
import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:Paperless_Workflow/screens/forgot_password_screen.dart';
import 'package:Paperless_Workflow/shared/constants.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _formListController = ScrollController();

  final CustomWidgets _customWidgets = CustomWidgets();

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationLoadInProgress) {
          return _customWidgets.loadInProgress();
        } else if (state is AuthenticationSuccess) {
          authenticationBloc.close();
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
                  Center(child: Text("Sign In", style: TextStyle(fontSize: 28.0, color: Colors.red, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.only(top:30.0)),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is AuthenticationFails) {
                        return _customWidgets.errorOrSuccessMessage(type: "error", msg: state.msg);
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

                    decoration: textInputDecoration.copyWith(hintText: "Enter Email Address"),
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: FlatButton(onPressed: () {
                        if (_formKey.currentState.validate()) {
                          authenticationBloc.add(AuthenticateUser(user: User(
                            email: _emailController.text,
                            password: _passwordController.text
                          )));
                          _formListController.jumpTo(0.0);
                        }
                      },
                      child:Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18.0),),)
                  ),
                  FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return BlocProvider<ForgotPasswordBloc>(
                        create: (context) => ForgotPasswordBloc(),
                        child: ForgotPasswordScreen(),
                      );
                    }));
                  },
                  child: Text("Forgot Password ?", style: TextStyle(color: Colors.teal[100]),)),
                  FlatButton(onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text("Don't have account? Create One",
                  style: TextStyle(color: Colors.teal[100]),))
                ],
              )),

            ),
          );

        }
      }
    );

    }
}
