import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


class RequestSignature extends Equatable {
  final String id;
  final String document;
  final int onNumber;
  final String requestID;
  final String userRole;


  RequestSignature({this.id, @required this.document, @required this.onNumber, @required this.requestID, @required this.userRole});

  @override
  List<Object> get props => [id, document, onNumber, requestID, userRole];

  static toMap(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data;

    return RequestSignature(id: snapshot.documentID, document: data['document'], onNumber: data['on_number'], requestID: data['request_id'], userRole: data['user_role']);
  }

}
