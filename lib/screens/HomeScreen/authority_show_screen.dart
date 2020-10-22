import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/feedback/bloc/feedback_bloc.dart';
import 'package:Paperless_Workflow/blocs/request/bloc/request_bloc.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:Paperless_Workflow/shared/pdftron_document.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_screen.dart';


class AuthorityShowScreen extends StatefulWidget {
  final String title;
  final RequestModel requestModel;
  AuthorityShowScreen({Key key, @required this.title, @required this.requestModel}) : super(key: key);

  @override
  _AuthorityShowScreenState createState() => _AuthorityShowScreenState(title: title, requestModel: requestModel);
}

class _AuthorityShowScreenState extends State<AuthorityShowScreen> {
  final String title;
  final RequestModel requestModel;

  _AuthorityShowScreenState({@required this.title, @required this.requestModel});
  final CustomWidgets customWidgets = CustomWidgets();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = true;
    String formUrl;
    bool signedDocument = false;
    String signatureDocumentID;
    int onNumber;
    final _scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocConsumer<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestFormSelected) {
            isLoading = true;
            BlocProvider.of<RequestBloc>(context).add(AuthorityRequestFormUpload(
              requestID: widget.requestModel.id,
              filePath: state.filepath,
              signatureDocumentID: signatureDocumentID,
              onNumber: onNumber
            ));
          }
          if (state is AuthorityRequestFormUploadState) {
            Navigator.pop(context);
          }

          if (state is CancelRequestSuccessfullState) {
            Navigator.pop(context);
          }

          if (state is RequestFormSelectedFail) {
            BlocProvider.of<RequestBloc>(context).add(LoadRequestAuthority(requestModel));
          }
        },
        builder: (context, state) {
          if (state is AuthorityRequestSignatureState) {
            isLoading = false;
            formUrl = state.formUrl;
            signedDocument = state.signedDocument;
            signatureDocumentID = state.documentID;
            onNumber = state.onNumber;
          }
            if (isLoading) {
              return customWidgets.loadInProgress();
            } else {
              return ListView(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top:40.0)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Center(
                        child: Text(
                            requestModel.formName,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red
                            ),
                        ),
                      )
                    ),
                    Padding(padding: EdgeInsets.only(top:30.0)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red
                        ),
                        child: FlatButton(
                          onPressed: () {
                            openDocument(formUrl);
                          },
                          child: Text("Open Form", style: TextStyle(color:Colors.white),)
                        ),
                      ),
                    ),
                    // Padding(padding: EdgeInsets.only(top:30.0)),
                    signedDocument == false ? Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue
                        ),
                        child: FlatButton(
                          onPressed: () {
                            _scaffoldKey.currentState.showBottomSheet((context) {
                              return Container(
                                color: Colors.white,
                                height: 180,
                                child: Container(
                                  child: ListView(
                                    padding: EdgeInsets.only(top:20.0),
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: FlatButton(
                                          onPressed: () {
                                            BlocProvider.of<RequestBloc>(context)
                                                .add(SelectRequestForm());
                                            Navigator.pop(context);
                                          },
                                          child: Text('Choose File',
                                              style: TextStyle(
                                                color: Colors.red,
                                              )),
                                          padding: EdgeInsets.all(14.0),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.red,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius: BorderRadius.circular(20.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)
                                    )
                                  ),
                                ),
                              );
                            });
                          },
                          child: Text("Signature", style: TextStyle(color:Colors.white),)
                        ),
                      ),
                    ) : Container(),
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
                                    create: (context) => FeedbackBloc()..add(ShowFeedbacks(requestId: requestModel.id))
                                  ),
                                ],
                                child: FeedbackScreen(requestModel: requestModel, signDocument: signedDocument)
                              );
                            }));
                          },
                          child: Text("Show Feedbacks", style: TextStyle(color:Colors.white),)
                        ),
                      ),
                    ),
                    signedDocument == false ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red
                        ),
                        child: FlatButton(
                          onPressed: () {
                            BlocProvider.of<RequestBloc>(context).add(CancelRequest(requestModel.id));
                            setState(() {
                              isLoading = true;
                            });
                          },
                          child: Text("Cancel Request", style: TextStyle(color:Colors.white),)
                        ),
                      ),
                    ): Container(),

                  ],
                );
            }
          },
      ),

    );
  }
}
