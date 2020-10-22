import 'package:Paperless_Workflow/models/feedback_model.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DatabaseRepository{
  static DatabaseRepository _databaseRepository;
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final StreamController<List<RequestModel>> _requestsController =
    StreamController<List<RequestModel>>.broadcast();

  final StreamController<List<FeedbackModel>> _feedbackController =
  StreamController<List<FeedbackModel>>.broadcast();

  factory DatabaseRepository() {
    if (_databaseRepository == null) {
      _databaseRepository = DatabaseRepository._createInstance();
    }
    return _databaseRepository;
  }

  DatabaseRepository._createInstance();

  Stream<List<RequestModel>> listenToRealTimeRequests({@required String collectionName}){
    List<RequestModel> requestList = List();
    _firestore.collection(collectionName).snapshots().listen((requestSnapshot) async {
        var requests = requestSnapshot.documents.map(
          (snapshot) async {
            RequestModel request = await RequestModel.toMap(snapshot);
            return request;
          }
        ).toList();

        for (var i in requests) {
          RequestModel request = await i;
          requestList.add(request);
        }

        _requestsController.add(requestList);
     });

     return _requestsController.stream;
  }

  Stream<List<FeedbackModel>> listenToRealTimeFeedbacks({@required String collectionName}){
    _firestore.collection(collectionName).orderBy('date', descending: true).snapshots().listen((requestSnapshot) async {
        var feedbacks = requestSnapshot.documents.map(
          (snapshot) {
            FeedbackModel request = FeedbackModel.toMap(snapshot);
            return request;
          }
        ).toList();

        _feedbackController.add(feedbacks);
     });

     return _feedbackController.stream;
  }

  void updateData({String collectionName, String documentID, Map<String,dynamic> data}) {
    _firestore.collection(collectionName).document(documentID).updateData(data);
  }

  Future<DocumentSnapshot> getSingleRequest({String collectionName, String documentID}) async {
    DocumentSnapshot data = await _firestore.collection(collectionName).document(documentID).get();
    return data;
  }

  Future<List<DocumentSnapshot>> getRequestByFilter(DocumentReference user, DocumentReference form ) async {

    try {
      QuerySnapshot snapshot = await _firestore.collection("requests").where('user', isEqualTo: user).where('form',isEqualTo: form).where('canceled', isEqualTo: 0).getDocuments();

      return snapshot.documents;

    } catch (e) {
      print("Caught Exception ${e.toString()}");
      return null;
    }
  }



  Future<String> getFilePath() async {
    try {
      String filepath;

      filepath = await FilePicker.getFilePath(type:FileType.custom, allowedExtensions: ['pdf']);

      return filepath;
    }
      catch (e) {
        print("Caught Exception: " + e.toString());
        return null;
    }
  }

  DocumentReference getSingleDocument({@required String collectionName,@required String documentID}) {

    try {

      DocumentReference document = _firestore.collection(collectionName).document(documentID);

      if (document.documentID != null) {
        return document;
      }
      return null;

    } catch (e) {
      print(e.toString());
      return null;
    }

  }

    Future<bool> downloadFile(StorageReference ref, String filename) async {
      final String url = await ref.getDownloadURL();
      // final String uuid = Uuid().v1();
      await http.get(url);
      DateFormat dateFormat = DateFormat("yyyy-MM-dd-HH:mm");
      String datetime = dateFormat.format(DateTime.now());
      final Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
      final File file = File('${downloadsDirectory.path}/$filename-$datetime.pdf');
      await file.create();
      ref.writeToFile(file);

      return true;
  }

  Future<StorageReference> getStorageRef(String url ) async {
    return await _firebaseStorage.getReferenceFromUrl(url);
  }

  Future<DocumentReference> getSingleDocumentByFilter({@required String collectionName, @required dynamic condition, @required String filter}) async {
    try {
      var snapshots = await _firestore.collection(collectionName).where(
        condition,
        isEqualTo: filter
      ).getDocuments();

      if (snapshots.documents.length > 0) {

        return snapshots.documents[0].reference;

      }
      return null;

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> uploadFile(String filepath, String userId) async {

    // String extension = filepath.split('.').last;
    String filename = userId + '-' + DateTime.now().toString() + filepath.split('/').last;

    StorageReference reference = _firebaseStorage.ref().child(filename);

    StorageUploadTask task = reference.putData(File(filepath).readAsBytesSync());

    String url = await (await task.onComplete).ref.getDownloadURL();

    return url;

  }

  Future<List<DocumentSnapshot>> getAllDocuments(String collectionName) async {

    try {
      QuerySnapshot snapshot =  await _firestore.collection(collectionName).getDocuments();

      return snapshot.documents;

    } catch (e) {

      print('Caught Exception');
      print(e.toString());
      return null;

    }
  }

  CollectionReference getCollectionInstance(String collectionName) {
    return _firestore.collection(collectionName);
  }

  Future<List<DocumentSnapshot>> getAllDocumentsByFilter(String collectionName, {dynamic condition, dynamic filter}) async {

    try {
      QuerySnapshot snapshot =  await _firestore.collection(collectionName).where(
        condition,
        isEqualTo: filter
      ).getDocuments();

      return snapshot.documents;

    } catch (e) {

      print('Caught Exception');
      print(e.toString());
      return null;

    }
  }

  Future<bool> createNewDocument(String collectionName, Map<String, dynamic> data) async {
    DocumentReference document = await _firestore.collection(collectionName).add(data);

    if (document.documentID != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createNewDocumentAndGetID(String collectionName, Map<String, dynamic> data) async {
    DocumentReference document = await _firestore.collection(collectionName).add(data);

    return document.documentID;
  }
}
