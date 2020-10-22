import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FormModel extends Equatable {
  @override
  List<Object> get props => [id, name, url, oneTimeOnly];


  final String id;
  final String name;
  final String url;
  final int oneTimeOnly;

  FormModel({this.id, this.name, this.url, this.oneTimeOnly});


  static FormModel toMap(DocumentSnapshot document) {
    Map<String, dynamic> formData = document.data;

    return FormModel(
      id: document.documentID,
      name: formData['name'],
      url: formData['url'],
      oneTimeOnly: formData['oneTimeOnly']
    );
  }
}
