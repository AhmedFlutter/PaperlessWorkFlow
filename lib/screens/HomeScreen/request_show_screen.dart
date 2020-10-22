// import 'dart:async';
import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/feedback/bloc/feedback_bloc.dart';
import 'package:Paperless_Workflow/blocs/request/bloc/request_bloc.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/feedback_screen.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:basic_utils/basic_utils.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';


class RequestShowScreen extends StatefulWidget {

  final String documentID;

  const RequestShowScreen({Key key, this.documentID}) : super(key: key);

  @override
  _RequestShowScreenState createState() => _RequestShowScreenState();

}

class _RequestShowScreenState extends State<RequestShowScreen> {
  @override
  void initState() {
    super.initState();
  }
  int currentStep = 0;
  List<Step> steps = [];
  bool signDocument = false;
  RequestModel request;
  CustomWidgets customWidgets = CustomWidgets();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Screen"),
      ),
      body: BlocConsumer<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestDownloadState) {
            BlocProvider.of<RequestBloc>(context).add(GetSingleRequest(documentID: request.id));
            customWidgets.showSnackBar(context, "Your request has been downloaded successfully", Duration(seconds: 3));
          }
        },
        builder: (context, state) {
          if (state is RequestFormSingleState) {
            request = state.request;
            return ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top:15.0),
                  child: Stepper(
                    steps: getSteps(state),
                    controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) => Container(),
                    currentStep: currentStep,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue
                    ),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<AuthenticationBloc>(context),
                              ),
                              BlocProvider(
                                create: (context) => FeedbackBloc()..add(ShowFeedbacks(requestId: request.id))
                              ),
                            ],
                            child: FeedbackScreen(requestModel: request, signDocument: signDocument)
                          );
                        }));
                      },
                      child: Text("Show Feedbacks", style: TextStyle(color:Colors.white),)
                    ),
                  ),
                )


              ],
            );
          } else {
            return customWidgets.loadInProgress();
          }
        },
      ),
    );
  }
  List<Step> getSteps(RequestFormSingleState state) {
    List<Step> steps = [];
    RequestModel request = state.request;
    List<dynamic> signatures = state.signatures;
    // signatures.sort();
    steps.add(Step(
      title: Text("Submitted"),
      content: Text("Request has been submitted and send to Authority"),
      state: StepState.complete,
      isActive: true,
    ));

    for (var signature in signatures) {
      String signatureUserRole = '';

      if (signature.userRole.contains('_')) {
        var splitString = signature.userRole.split('_');
        for (var string in splitString) {
          signatureUserRole = signatureUserRole + StringUtils.capitalize(string) + " ";
        }
      } else {
        signatureUserRole = StringUtils.capitalize(signature.userRole);
      }

      if (signature.document != null) {
        currentStep = signature.onNumber + 1;
      }
      steps.add(Step(
        title: Text("Signed By $signatureUserRole"),
        content: Text("Your document has been signed by $signatureUserRole successfully"),
        state : signature.document == null ? StepState.indexed : StepState.complete,
        isActive: signature.document == null ? false : true
      ));

    }

    if (request.allDone != null) {
      signDocument = true;
      currentStep = currentStep + 1;
    }

    steps.add(Step(
        title: Text("All Done"),
        content: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: Center(
            child: FlatButton(
              onPressed: () {
                if (state is RequestFormSingleState) {
                  BlocProvider.of<RequestBloc>(context).add(RequestDownload(request.allDone,request.formName));
                }
              },
              child: Text("Download", style: TextStyle(fontSize: 20.0, color: Colors.white),),
            ),
          ),
        ),
      state: request.allDone != null ? StepState.complete : StepState.indexed,
      isActive: request.allDone != null ? true : false
      ));

    return steps;
  }
//   void setPreloadFormValues(List<FeedbackModel> feedbacks, RequestModel request) {
//     List<FeedbackModel> reverseFeedbacks = List.from(feedbacks.reversed);
//     for (FeedbackModel feedback in reverseFeedbacks) {
//       if (feedback.userRole == 'teacher') {

//         if (request.signedByTeacherDocument == null || request.signedByTeacherDocument == '') {
//           problemFeedbackID = feedback.feedbackId;
//           problemUserRole = 'teacher';
//           problemFormUrl = request.formUrl;
//           problemMessage = feedback.message;
//           setState(() {
//             teacherStep = StepState.error;
//             stepTeacher = true;
//             stepActive = StepActive.SignedByTeacher;
//           });
//           break;
//         }

//       } else if (feedback.userRole == 'chairman') {
//         if (request.signedByChairmanDocument == null || request.signedByChairmanDocument == '') {
//           problemFeedbackID = feedback.feedbackId;
//           problemUserRole = 'chairman';
//           problemFormUrl = request.signedByTeacherDocument;
//           problemMessage = feedback.message;

//           setState(() {
//             chairmanStep = StepState.error;
//             stepActive = StepActive.SignedByChairman;
//             stepChairman = true;
//             stepTeacher = true;
//             // print(stepActive);
//           });
//           break;
//         }

//       }
//     }
//   }

//   void evaluateConditions(RequestModel request) {
//     steps.add(Step(
//       title: Text("Submitted"),
//       content: Text("Request has been submitted and send to Authority"),
//       state: StepState.complete,
//       isActive: true,
//     ));

//     if (request.signedByTeacherForm == 1) {
//       if (request.signedByTeacherDocument != null && problemUserRole != 'chairman') {
//         stepActive = StepActive.SignedByTeacher;
//         teacherStep = StepState.complete;
//         stepTeacher = true;
//       }

//       steps.add(Step(
//         title: Text("Signed By Teacher"),
//         content: problemUserRole == 'teacher' ? problemContent() : Text("Your document has been signed by teacher successfully"),
//         state: teacherStep,
//         isActive: stepTeacher
//       ));
//     }
//     if (request.signedByChairmanForm == 1) {
//       if (request.signedByChairmanDocument != null) {
//         stepActive = StepActive.SignedByChairman;
//         chairmanStep = StepState.complete;
//         stepChairman = true;
//       }
//       // print(stepActive);

//       steps.add(Step(
//         title: Text("Signed By Chairman"),
//         content: problemUserRole == 'chairman'? problemContent() : Text("Your document has been signed by Chairman successfully"),
//         state : chairmanStep,
//         isActive: stepChairman
//       ));
//     }
//     String formUrl;
//     if (request.signedByTeacherForm == 1 && request.signedByChairmanForm == 0) {
//       if (request.signedByTeacherDocument != null && request.signedByChairmanDocument == null) {
//         allDoneStep = StepState.complete;
//         stepActive = StepActive.AllDone;
//         stepAllDone = true;
//         signedDocument = true;
//         stepTeacher = true;
//         formUrl = request.signedByTeacherDocument;
//       }
//     }  else if (request.signedByTeacherForm == 0 && request.signedByChairmanForm == 1) {
//       if (request.signedByTeacherDocument == null && request.signedByChairmanDocument != null) {
//         allDoneStep = StepState.complete;
//         stepAllDone = true;
//         stepActive = StepActive.AllDone;
//         stepChairman = true;
//         formUrl = request.signedByChairmanDocument;
//       }
//     } else if (request.signedByTeacherForm == 1 && request.signedByChairmanForm == 1) {
//       if (request.signedByChairmanDocument != null && request.signedByTeacherDocument != null) {
//         allDoneStep = StepState.complete;
//         stepActive = StepActive.AllDone;
//         signedDocument = true;
//         stepAllDone = true;
//         stepTeacher = true;
//         stepChairman = true;
//         formUrl = request.signedByChairmanDocument;
//       }
//     }
//     steps.add(Step(
//       title: Text("All Done"),
//       content: Container(
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(20.0)
//         ),
//         child: Center(
//           child: FlatButton(
//             onPressed: () {
//               BlocProvider.of<RequestBloc>(context).add(RequestDownload(formUrl,fileName));
//             },
//             child: Text("Download", style: TextStyle(fontSize: 20.0, color: Colors.white),),
//           ),
//         ),
//       ),
//      state: allDoneStep,
//      isActive: stepAllDone
//     ));

//   }

//   Widget problemContent() {
//     return ListView(
//       shrinkWrap: true,
//       children: <Widget>[
//         Text(problemMessage, style: TextStyle(
//           color: Colors.red
//         )),

//         Container(
//           margin: EdgeInsets.only(top:15.0),
//           decoration: BoxDecoration(
//             color: Colors.red,
//             borderRadius: BorderRadius.circular(20.0)
//           ),
//           child: Center(
//             child: FlatButton(
//               onPressed: () {
//                 openDocument(problemFormUrl);
//               },
//               child: Text("Open Form", style: TextStyle(fontSize: 16.0, color: Colors.white),),
//             ),
//           ),
//         ),

//         Container(
//           margin: EdgeInsets.only(top:15.0),
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.circular(20.0)
//           ),
//           child: Center(
//             child: FlatButton(
//               onPressed: () {
//                 BlocProvider.of<RequestBloc>(context).add(SelectRequestForm());
//               },
//               child: Text("Choose File", style: TextStyle(fontSize: 16.0, color: Colors.white),),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget builder() {
//     return Container(
//       margin: EdgeInsets.only(top: 10),
//       // color: Colors.red,
//       child: Stepper(
//         steps: steps,
//         currentStep: setCurrentStep(),
//         controlsBuilder: (BuildContext context,
//                 {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
//             Container(),
//       ),
//     );
//   }

//   int setCurrentStep() {
//     if (steps.length == 3) {
//       if (stepActive == StepActive.Submitted) {
//         return 0;
//       }
//       else if (stepActive == StepActive.SignedByTeacher || stepActive == StepActive.SignedByChairman) {
//         return 1;
//       } else {
//         return 2;
//       }

//     } else {

//       if (stepActive == StepActive.Submitted) {
//         return 0;
//       }
//       else if (stepActive == StepActive.SignedByTeacher) {
//         print("Hello");

//         return 1;
//       } else if (stepActive == StepActive.SignedByChairman) {
//         // print("Hello");
//         return 2;
//       } else {
//         return 3;
//       }
//     }
//   }
// }
}
