import 'dart:async';
import 'package:Paperless_Workflow/models/form_model.dart';
import 'package:Paperless_Workflow/models/form_signature_model.dart';
import 'package:Paperless_Workflow/models/request_signature_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:Paperless_Workflow/repository/database.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  DatabaseRepository _databaseRepository = DatabaseRepository();
  AuthenticationBloc authenticationBloc;

  RequestBloc({this.authenticationBloc})  : super(RequestInitial());

  @override
  Stream<RequestState> mapEventToState(
    RequestEvent event,
  ) async* {
    if (event is SelectRequestForm) {
      yield* _mapSelectRequestFormEventToState();
    } else if (event is UploadRequestForm) {
      yield* _mapUploadRequestFormEventTOState(event);
    } else if (event is LoadAllRequestFormUser) {
      yield* _mapLoadAllRequestFormUserToState();
    } else if (event is PassRequestsToState) {
      yield* _mapPassRequestsToState(event);
    } else if (event is ShowRequestForm) {
      yield* _mapShowRequestFormToState();
    } else if (event is GetSingleRequest) {
      yield* _mapGetSingleRequestToState(event);
    } else if (event is LoadRequestAuthority) {
      yield* _mapLoadRequestAuthorityToState(event);
    } else if (event is AuthorityRequestFormUpload) {
      yield* _mapAuthorityRequestFormUploadToState(event);
    } else if (event is RequestDownload) {
      yield* _mapRequestDownloadToState(event);
    } else if (event is LoadAuthorityRequests) {
      yield* _mapLoadAuthorityRequestsToState();
    } else if (event is PassAuthorityRequestsToState) {
      yield LoadAuthorityRequestsSuccessState(event.requests);
    } else if (event is PassRequestAuthorityToState) {
      yield AuthorityRequestSignatureState(event.formUrl,event.documentID,event.onNumber, signedDocument: event.signedDocument);
    } else if (event is PassRequestFailSignatureAuthorityToState) {
      yield AuthorityRequestSignatureFailsState();
    } else if (event is CancelRequest) {
      yield* _mapCancelRequestToState(event);
    }
  }

  Stream<RequestState> _mapCancelRequestToState(CancelRequest event) async* {
    try {
      _databaseRepository.updateData(
        collectionName: "requests",
        documentID: event.documentID,
        data: {
          "canceled": 1
        }
      );

      yield CancelRequestSuccessfullState();

    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }
  }

  Stream<RequestState> _mapLoadAuthorityRequestsToState() async*{
    try {
      authenticationBloc.listen((state) {

        if (state is AuthenticateUserState) {
          String userRole = state.user.userRole;

          _databaseRepository.listenToRealTimeRequests(
              collectionName: 'requests'
            ).listen((requestModelList) async {
              List<RequestModel> authorityRequests = [];
              List<RequestModel> requests = requestModelList.where((request) {
                if (request.allDone == null && request.canceled == 0) {
                  return true;
                } else {
                  return false;
                }
              }).toList();

              for (RequestModel request in requests) {
                bool checkAuthority = await checkRequestAuthority(request, userRole);

                if(checkAuthority) {
                  authorityRequests.add(request);
                }
              }

              add(PassAuthorityRequestsToState(requests: authorityRequests));

          });

        }

      });


    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }
  }

  Future<bool> checkRequestAuthority(RequestModel requestModel, String userRole) async{
    try {
      QuerySnapshot requestSignature = await _databaseRepository.getCollectionInstance('request_signatures').where('request_id', isEqualTo: requestModel.id).where('user_role', isEqualTo: userRole).where('document', isNull: true).getDocuments();

      List<DocumentSnapshot> documents = requestSignature.documents;

      if (documents.length > 0) {

        for (DocumentSnapshot document in documents ){
          int onNumber = document.data['on_number'] - 1;
          QuerySnapshot checkPerviousValue = await _databaseRepository.getCollectionInstance('request_signatures').where('on_number', isEqualTo: onNumber).where('request_id',isEqualTo:requestModel.id).getDocuments();

          if (checkPerviousValue.documents.length > 0) {
            Map<String, dynamic> data = checkPerviousValue.documents[0].data;

            if (data['document'] != null && data['document'] != '') {
              return true;
            } else {
              return false;
            }
          } else {
            return true;
          }

        }

      } else {
        return false;
      }

    } catch (e) {
      print("Caught Exception ${e.toString()}");
      return false;
    }

  }

  Stream<RequestState> _mapRequestDownloadToState(RequestDownload event) async*{
    try {
      yield RequestFormUploadInProgress();
      StorageReference ref = await _databaseRepository.getStorageRef(event.url);
      bool downloadFile = await _databaseRepository.downloadFile(ref, event.fileName);

      if (downloadFile) {
        yield RequestDownloadState();
      }

    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }
  }

  Stream<RequestState> _mapAuthorityRequestFormUploadToState(AuthorityRequestFormUpload event) async*{
    try {

      if (authenticationBloc.state is AuthenticateUserState) {
        User user = (authenticationBloc.state as AuthenticateUserState).user;
        String fileUrl = await _databaseRepository.uploadFile(event.filePath, user.userId);

        _databaseRepository.updateData(
          collectionName: "request_signatures",
          documentID: event.signatureDocumentID,
          data: {
            "document": fileUrl
        });

        QuerySnapshot querySnapshot = await _databaseRepository.getCollectionInstance('request_signatures').where('request_id', isEqualTo: event.requestID).where('on_number', isEqualTo: event.onNumber + 1).getDocuments();

        var requestSignatureList = querySnapshot.documents.map((snapshot) => RequestSignature.toMap(snapshot)).toList();

        if (requestSignatureList.length == 0) {
          _databaseRepository.updateData(
            collectionName: "requests",
            documentID: event.requestID,
            data: {
              "all_done": fileUrl
            }
          );
          yield AuthorityRequestFormUploadState();

        } else {
          yield AuthorityRequestFormUploadState();
        }
      }

    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }
  }

  Stream<RequestState> _mapShowRequestFormToState() async*{
    yield RequestFormShowState();
  }

  Stream<RequestState> _mapSelectRequestFormEventToState() async* {
    try {
      String filePath = await _databaseRepository.getFilePath();
      if (filePath != null && filePath != '') {
        yield RequestFormSelected(filepath: filePath);
      } else {
        yield RequestFormSelectedFail();
      }
    } catch (e) {
      print("Caught Exception: " + e.toString());
      yield RequestFormSelectedFail();
    }
  }

  Stream<RequestState> _mapUploadRequestFormEventTOState(UploadRequestForm event) async* {
    try {
      if (authenticationBloc.state is AuthenticateUserState) {

        yield RequestFormUploadInProgress();

        var state = (authenticationBloc.state as AuthenticateUserState);

        DocumentReference formDocument = _databaseRepository.getSingleDocument(collectionName: 'forms', documentID: event.formDocument);

        DocumentReference userDocument = await _databaseRepository.getSingleDocumentByFilter(collectionName: 'users', condition: 'user_id', filter: state.user.userId);

        DocumentSnapshot formSnapshot = await formDocument.get();

        FormModel formModel = FormModel.toMap(formSnapshot);
        QuerySnapshot formSingatures = await _databaseRepository.getCollectionInstance('forms_signatures').where('form_id', isEqualTo: event.formDocument).getDocuments();

        List<dynamic> formSignaturesList = formSingatures.documents.map((snapshot) => FormSignature.toMap(snapshot)).toList();

        if (formModel.oneTimeOnly == 1) {
          //Then We need to get filter Request if it exists then we need to throw error you have already submitted this request you cant submit another one
          List<DocumentSnapshot> snapshots = await _databaseRepository.getRequestByFilter(userDocument, formDocument);

          if (snapshots.length == 0) {
              String requestID = await uploadRequest(userDocument, formDocument, event, state.user.userId);
              if (requestID != '' || requestID != null) {
                bool requestSignaturesCreated = await createRequestSignatures(formSignaturesList, requestID);

                if (requestSignaturesCreated) {
                  yield RequestFormUploadSuccessfull();
                }

              } else {
                yield RequestFormUploadFails();
              }
          } else {
            yield RequestAlreadyExists();
          }

        } else {
          String requestID = await uploadRequest(userDocument, formDocument, event, state.user.userId);
          if (requestID != '' || requestID != null) {
            bool requestSignaturesCreated = await createRequestSignatures(formSignaturesList, requestID);

            if (requestSignaturesCreated) {
              yield RequestFormUploadSuccessfull();
            }

          } else {
            yield RequestFormUploadFails();
          }
        }

      }
    }
     catch (e) {
        print("Caught Exception ${e.toString()}");
        yield RequestFormUploadFails();
    }
  }

  Future<bool> createRequestSignatures(List<dynamic> formSingatureList, String documentID) async{
    try {
      for (dynamic form in formSingatureList) {
        await _databaseRepository.createNewDocument('request_signatures', {
          "request_id": documentID,
          "on_number": form.onNumber,
          "user_role": form.userRole,
          "document": null
        });
      }
      return true;

    } catch (e) {
      print("Caught Exception ${e.toString()}");
      return false;
    }

  }

  Future<String>  uploadRequest(DocumentReference user, DocumentReference form, UploadRequestForm event, String userID) async {
    String uploadFile = await _databaseRepository.uploadFile(event.filePath, userID);

    if (uploadFile != null && uploadFile.length > 0 ) {

      String request = await _databaseRepository.createNewDocumentAndGetID('requests',
        {
          'user': user,
          'form': form,
          'form_url': uploadFile,
          'canceled': 0,
          "all_done": null
        }
      );

      return request;
    } else {
      return null;
    }

  }

  Stream<RequestState> _mapLoadAllRequestFormUserToState() async* {
    try {
      authenticationBloc.listen((state) async {

        if (state is AuthenticateUserState) {
          _databaseRepository.listenToRealTimeRequests(
            collectionName: 'requests'
          ).listen((requestModelList) async {

            List<RequestModel> requests = requestModelList.where((request) => request.userId == state.user.userId).toList();
            add(PassRequestsToState(requests: requests));

          });
        }

      });
    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }


  }

  Stream<RequestState> _mapPassRequestsToState(PassRequestsToState event) async* {
    yield RequestFormUploadInProgress();

    if (event.requests.length > 0) {
      yield RequestFormLoadAllUserRequest(requests: event.requests);
    } else {
      yield RequestsNotAvailable();
    }

  }

  Stream<RequestState> _mapGetSingleRequestToState(GetSingleRequest event) async*{
    try {
      DocumentSnapshot document = await _databaseRepository.getSingleRequest(collectionName: 'requests', documentID: event.documentID);

      RequestModel request = await RequestModel.toMap(document);

      QuerySnapshot querySnapshot = await _databaseRepository.getCollectionInstance('request_signatures').orderBy("on_number").where('request_id', isEqualTo: event.documentID).getDocuments();

      List<dynamic> requestSignatures = querySnapshot.documents.map((snapshot) => RequestSignature.toMap(snapshot)).toList();

      yield RequestFormSingleState(request: request, signatures: requestSignatures);

    } catch (e) {
      print("Caught Exception: ${e.toString()}");
    }
  }

  Stream<RequestState> _mapLoadRequestAuthorityToState(LoadRequestAuthority event) async* {
    try {
      authenticationBloc.listen((state) async {

        if (state is AuthenticateUserState) {
          String userRole = state.user.userRole;
          QuerySnapshot querySnapshot = await _databaseRepository.getCollectionInstance('request_signatures').where('request_id', isEqualTo: event.request.id).where('document', isNull: true).where('user_role', isEqualTo: userRole).getDocuments();

          List<dynamic> requestSignatures = querySnapshot.documents.map((snapshot) => RequestSignature.toMap(snapshot)).toList();

          if (requestSignatures.length > 0) {
            var requestSignature = requestSignatures[0];
            QuerySnapshot querySnapshot = await _databaseRepository.getCollectionInstance('request_signatures').where('request_id', isEqualTo: event.request.id).where('on_number', isEqualTo: requestSignature.onNumber - 1).getDocuments();

            List<dynamic> requestExistSigntatures = querySnapshot.documents.map((snapshot) => RequestSignature.toMap(snapshot)).toList();
            // print(requestExistSigntatures);

            if (requestExistSigntatures.length > 0) {
              add(PassRequestAuthorityToState(requestExistSigntatures[0].document, requestSignature.id,requestSignature.onNumber, signedDocument: false));
            }
            else {
              add(PassRequestAuthorityToState(event.request.formUrl, requestSignature.id,requestSignature.onNumber, signedDocument: false));
            }

          } else {
            QuerySnapshot querySnapshot = await _databaseRepository.getCollectionInstance('request_signatures').where('request_id', isEqualTo: event.request.id).where('user_role', isEqualTo: userRole).getDocuments();

            List<dynamic> requestSignatures = querySnapshot.documents.map((snapshot) => RequestSignature.toMap(snapshot)).toList();

            if (requestSignatures.length > 0) {
              if (requestSignatures[0].document != null && requestSignatures[0].document != '') {
                add(PassRequestAuthorityToState(requestSignatures[0].document,requestSignatures[0].id,requestSignatures[0].onNumber, signedDocument: true));
              }
            } else {
              add(PassRequestFailSignatureAuthorityToState());
            }
          }

        }

      });

    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }
  }

  @override
  Future<void> close() {
    // authenticationBloc.close();
    return super.close();
  }
}
