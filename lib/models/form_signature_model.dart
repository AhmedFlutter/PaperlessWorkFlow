import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class FormSignature extends Equatable {
  final String id;
  final String formId;
  final int onNumber;
  final String userRole;

  FormSignature({@required this.formId, @required this.onNumber, @required this.userRole, this.id});

  @override
  List<Object> get props => [formId, onNumber, userRole, id];


  static toMap(DocumentSnapshot snapshot) {
    Map<String,dynamic> data = snapshot.data;

    return FormSignature(formId: data['form_id'], onNumber: data['on_number'], userRole: data['user_role'], id: snapshot.documentID);
  }
}
