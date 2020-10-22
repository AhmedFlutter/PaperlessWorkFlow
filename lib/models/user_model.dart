import 'package:equatable/equatable.dart';

class User extends Equatable{
  @override
  List<Object> get props => [userId, name, email, password, designation, phoneNo, userRole];

  //Defining Properties

  final String userId;
  final String name;
  final String email;
  final String password;
  final String designation;
  final String phoneNo;
  final String userRole;


  User({this.userId, this.name, this.email, this.password, this.designation, this.phoneNo, this.userRole});


  // User toMap(Map<String, String> map) {

  // }
}
