import 'package:Paperless_Workflow/blocs/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:Paperless_Workflow/shared/constants.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final _customWidgets = CustomWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
         alignment: Alignment.center,
         child: Stack(
           alignment: Alignment.center,
           children: <Widget>[
             Form(
               key: _formKey,
               child: ListView(
                 padding: EdgeInsets.symmetric(horizontal: 20.0),
                 shrinkWrap: true,
                 children: <Widget>[
                  Center(child: Container(child: Text("Forgot Password", style: TextStyle(fontSize: 28.0, color: Colors.red, fontWeight: FontWeight.bold)))),
                  Padding(padding: EdgeInsets.only(top:30.0)),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                      if (state is ForgotPasswordSuccess) {
                        return Container(
                          margin: EdgeInsets.only(top:20.0),
                          child: _customWidgets.errorOrSuccessMessage(type: 'success', msg: "We have send you an email with the reset password link"),
                        );
                      } else if (state is ForgotPasswordFails) {
                        return Container(
                          margin: EdgeInsets.only(top:20.0),
                          child: _customWidgets.errorOrSuccessMessage(type: 'error', msg: "Account with this email does not exist"),
                        );
                      } else {
                        return Container();
                      }
                    },
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
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: FlatButton(onPressed: () {
                        if (_formKey.currentState.validate()) {
                          BlocProvider.of<ForgotPasswordBloc>(context).add(ForgotPassword(_emailController.text));
                        }
                      },
                      child:Text("Send Email", style: TextStyle(color: Colors.white, fontSize: 18.0),),)
                  ),
                 ],
               )
             )
           ],
         ),
       )
    );
  }
}
