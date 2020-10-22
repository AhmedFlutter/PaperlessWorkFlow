part of 'request_bloc.dart';

abstract class RequestState extends Equatable {
  const RequestState();
}

class RequestInitial extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestFormSelected extends RequestState {
  final String filepath;

  RequestFormSelected({@required this.filepath});

  @override
  List<Object> get props => [filepath];
}

class RequestFormSelectedFail extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestFormUploadSuccessfull extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestFormUploadInProgress extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestFormUploadFails extends RequestState {
  @override
  List<Object> get props => [];
}

class RequestFormLoadAllUserRequest extends RequestState {

  final List<RequestModel> requests;

  RequestFormLoadAllUserRequest({@required this.requests});

  @override
  List<Object> get props => [requests];

}

class RequestsNotAvailable extends RequestState {

  @override
  List<Object> get props => throw UnimplementedError();

}

class RequestFormShowState extends RequestState {

  @override
  List<Object> get props => throw UnimplementedError();

}


class RequestFormSingleState extends RequestState {

  final RequestModel request;
  final List<dynamic> signatures;

  RequestFormSingleState({this.request, this.signatures});

  @override
  List<Object> get props => [request, signatures];

}

class AuthorityRequestFormUploadState extends RequestState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class RequestDownloadState extends RequestState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class RequestAlreadyExists extends RequestState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class LoadAuthorityRequestsSuccessState extends RequestState {
  final List<RequestModel> requests;

  LoadAuthorityRequestsSuccessState(this.requests);

  @override
  List<Object> get props => [requests];
}

class LoadAuthorityRequestsFailsState extends RequestState {
  @override
  List<Object> get props => throw UnimplementedError();
}


class AuthorityRequestSignatureState extends RequestState {
  final String formUrl;
  final bool signedDocument;
  final String documentID;
  final int onNumber;
  AuthorityRequestSignatureState(this.formUrl,this.documentID, this.onNumber , {this.signedDocument});

  @override
  List<Object> get props => [formUrl];
}

class AuthorityRequestSignatureFailsState extends RequestState {
  @override
  List<Object> get props => [];
}

class CancelRequestSuccessfullState extends RequestState {
  @override
  List<Object> get props => [];
}

