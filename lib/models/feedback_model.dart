import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FeedbackModel extends Equatable{
  @override
  List<Object> get props => [feedbackId,userRole,message, requestId, name];

  //Defining Properties
  final String feedbackId;
  final String userRole;
  final String message;
  final String requestId;
  final String name;
  final date;


  FeedbackModel({this.feedbackId, this.userRole, this.message, this.requestId, this.name, this.date});

  static FeedbackModel toMap(DocumentSnapshot snapshot) {
    Map<String,dynamic> data = snapshot.data;
    return FeedbackModel(
      feedbackId: snapshot.documentID,
      userRole: data['user_role'],
      requestId: data['request_id'],
      message: data['message'],
      name: data['name'],
      date : data['date'],
    );
  }
}
