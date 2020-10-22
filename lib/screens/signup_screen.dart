import 'package:Paperless_Workflow/blocs/registeration/bloc/registration_bloc.dart';
import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:Paperless_Workflow/shared/constants.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _formListController = ScrollController();

  final CustomWidgets _customWidgets = CustomWidgets();
  @override
  Widget build(BuildContext context) {
    RegistrationBloc registrationBloc = BlocProvider.of<RegistrationBloc>(context);

    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state is RegistrationLoadInProgress) {
          return _customWidgets.loadInProgress();
        } else {
          return Scaffold(
                  body: Container(
                  padding: EdgeInsets.only(left: 20.0,right: 20.0, top: 100.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                    controller: _formListController,
                    children: <Widget>[
                      Center(child: Text("Sign Up", style: TextStyle(fontSize: 28.0, color: Colors.red, fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.only(top:30.0)),
                      BlocBuilder<RegistrationBloc, RegistrationState>(
                        builder: (context, state) {
                          if (state is RegistrationFails) {
                            return _customWidgets.errorOrSuccessMessage(type: 'error', msg: state.msg);
                          } else if (state is RegistrationSuccess){
                            return _customWidgets.errorOrSuccessMessage(type: 'success', msg: state.msg);
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top:20.0)),
                      TextFormField(
                        validator: (String name) {
                          if(name.isEmpty) {
                            return "Please type Name";
                          }
                          return null;
                        },
                        controller: _nameController,

                        decoration: textInputDecoration.copyWith(hintText: "Enter Name"),
                      ),
                      Padding(padding: EdgeInsets.only(top:20.0)),
                      TextFormField(
                        validator: (String email) {
                          if(EmailValidator.validate(email)) {
                            return null;
                          } else if(email.isEmpty) {
                            return "Please type Email Address";
                          } else {
                            return "Please type correct Email Address";
                          }
                        },
                        controller: _emailController,

                        decoration: textInputDecoration.copyWith(hintText: "Enter Email Adress"),
                      ),
                      Padding(padding: EdgeInsets.only(top:20.0)),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (String password) {
                          if (password.isEmpty) {
                            return "Please enter Password";
                          } else if (password.length < 6) {
                            return "Password should have atleast 6 characters";
                          }
                          return null;
                        },
                        decoration: textInputDecoration.copyWith(hintText: "Enter Password"),
                      ),
                      Padding(padding: EdgeInsets.only(top:20.0)),

                      TextFormField(
                        validator: (String designation) {
                          if(designation.isEmpty) {
                            return "Please type Designation";
                          }
                          return null;
                        },
                        controller: _designationController,

                        decoration: textInputDecoration.copyWith(hintText: "Enter your Designation"),
                      ),
                      Padding(padding: EdgeInsets.only(top:20.0)),
                      TextFormField(
                        validator: (String number) {
                          if(number.isEmpty) {
                            return "Please type Number";
                          }
                          return null;
                        },
                        controller: _numberController,

                        decoration: textInputDecoration.copyWith(hintText: "Enter your Number"),
                      ),
                      Padding(padding: EdgeInsets.only(top:20.0)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: FlatButton(onPressed: () {
                            if (_formKey.currentState.validate()) {
                              registrationBloc.add(RegisterUser(user: User(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                designation: _designationController.text,
                                phoneNo: _numberController.text,
                                userRole: 'student'
                              )));

                              _formListController.jumpTo(0.0);
                              _customWidgets.offKeyboardFocus(context: context);
                              if (registrationBloc.state is RegistrationSuccess) {
                                registrationBloc.close();
                              }
                            } else {
                              _customWidgets.offKeyboardFocus(context: context);
                            }
                          },
                          child:Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18.0),),)
                      ),
                      FlatButton(onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text("Already have account? Login",
                      style: TextStyle(color: Colors.teal[100]),))
                    ],
                  )),

                ),
              );
        }
      },
    );

  }
}
