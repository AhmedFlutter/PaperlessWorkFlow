import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final String id;
  final String userId;
  final String userEmail;
  final String userDesignation;
  final String userName;
  final String phoneNo;
  final String userRole;
  final String formName;
  final String formUrl;
  final int oneTimeOnly;
  final String feedbackTeacher;
  final String feedbackChairman;
  final int canceled;
  final String allDone;

  RequestModel({this.id, this.userId, this.userEmail, this.userDesignation, this.userName, this.phoneNo, this.userRole, this.formName, this.formUrl,this.oneTimeOnly, this.feedbackChairman, this.feedbackTeacher, this.canceled, this.allDone});


  static Future<RequestModel> toMap(DocumentSnapshot snapshot) async {
    var data = snapshot.data;
    DocumentSnapshot form = await data['form'].get();
    DocumentSnapshot user = await data['user'].get();


    return RequestModel(
      id: snapshot.documentID,
      userId: user.data['user_id'],
      userEmail: user.data['email'],
      userDesignation: user.data['designation'],
      userName: user.data['name'],
      userRole: user.data['user_role'],
      phoneNo: user.data['phone_no'],
      formName: form.data['name'],
      oneTimeOnly: form.data['oneTimeOnly'],
      formUrl: data['form_url'],
      canceled: data['canceled'],
      allDone: data['all_done']
    );

  }



  @override
  String toString() {
    return "Request Model: id:$id, userId:$userId, userEmail:$userEmail, userDesignation:$userDesignation, userName:$userName, phoneNo:$phoneNo, formName:$formName, formUrl:$formUrl, canceled:$canceled, allDone$allDone";
  }


  @override
  List<Object> get props => [
    id, userId, userEmail, userDesignation, userName, phoneNo, userRole, formName, canceled, allDone
  ];

}
