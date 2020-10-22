import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/feedback/bloc/feedback_bloc.dart';
import 'package:Paperless_Workflow/models/feedback_model.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Paperless_Workflow/repository/mail.dart';

class FeedbackAddScreen extends StatefulWidget {
  final RequestModel requestModel;

  FeedbackAddScreen({Key key, this.requestModel}) : super(key: key);

  @override
  _FeedbackAddScreenState createState() => _FeedbackAddScreenState();
}

class _FeedbackAddScreenState extends State<FeedbackAddScreen> {

  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User user = (BlocProvider.of<AuthenticationBloc>(context).state as AuthenticateUserState).user;
    String userRole = user.userRole;
    String name = user.name;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Feedback")
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: TextField(
              controller: feedbackController,
              maxLines: 2,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.grey
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0
                  )
                ),
                hintText: "Feedback"
              )
            ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey
            ),
            child: FlatButton(
              onPressed: () {
                Timestamp date = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);

                BlocProvider.of<FeedbackBloc>(context).add(AddFeedback(
                  feedback: FeedbackModel(
                    requestId: widget.requestModel.id,
                    userRole: userRole,
                    message: feedbackController.text,
                    name: name,
                    date: date,
                  )
                ));
                feedbackController.clear();
                sendMailFromGmail(widget.requestModel.userEmail, "PaperlessWorkflow Feedback Added", "Feedback was added on your request by ${capitalize(userRole)}");
                Navigator.pop(context);
              },
              child: Text("Post Feedback", style: TextStyle(color:Colors.white),)
            ),
          ),
        ),
        ],
      ),
    );
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}
