import 'package:Paperless_Workflow/blocs/form/bloc/form_bloc.dart';
import 'package:Paperless_Workflow/blocs/request/bloc/request_bloc.dart';
import 'package:Paperless_Workflow/models/form_model.dart';
import 'package:Paperless_Workflow/shared/constants.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_layout.dart';

class RequestFormScreen extends StatefulWidget {
  RequestFormScreen({Key key}) : super(key: key);
  @override
  _RequestFormScreenState createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final HomeScreenLayout _homeScreenLayout = HomeScreenLayout();
  final _formKey = GlobalKey<FormState>();
  final String title = "Request Form";
  String filepath;
  String selectDocumentText;
  // bool fileSelected = false;
  final CustomWidgets _customWidgets = CustomWidgets();
  String dropdownItemSelected = "chooseFile";
  Widget content() {
    return BlocBuilder<FormBloc, FormBlocState>(
      builder: (context, state) {
        // RequestBloc requestBloc = BlocProvider.of<RequestBloc>(context);
        if (state is FormLoadSuccess) {
          List<FormModel> forms = state.forms;
          List<FormModel> formsModified = [FormModel(id: "chooseFile", name: "Choose Form", oneTimeOnly: 0, url: null)];

          for (var form in forms) {
            formsModified.add(form);
          }
          // print(forms[0].name);
          return BlocConsumer<RequestBloc, RequestState>(
            listener: (context, state) {
              if (state is RequestFormUploadSuccessfull) {
                Navigator.pop(context);
                // requestBloc.close();
              } else if (state is RequestFormSelectedFail) {
                BlocProvider.of<RequestBloc>(context).add(ShowRequestForm());
              }
            },
            builder: (context, state) {
              if (state is RequestFormShowState ||
                  state is RequestFormSelected || state is RequestAlreadyExists) {
                return Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(top:120.0),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        children: <Widget>[
                          Center(
                              child: Text("Request Form",
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          BlocBuilder<RequestBloc, RequestState>(
                            builder: (context, state) {
                              if (state is RequestAlreadyExists) {
                                return CustomWidgets().errorOrSuccessMessage(type: 'error', msg: 'You have already sent this type of request you cant send another one');
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          DropdownButtonFormField<String>(
                              value: dropdownItemSelected,
                              decoration: textInputDecoration,
                              validator: (String value) {
                                if (value.isEmpty || value == null || value == "chooseFile") {
                                  return 'Select Form First';
                                }
                                return null;
                              },
                              items: formsModified
                                  .map((form) => DropdownMenuItem<String>(
                                      value: form.id, child: Text(form.name)))
                                  .toList(),
                              onChanged: (String value) {
                                setState(() {
                                  dropdownItemSelected = value;
                                });
                              }),
                          Padding(padding: EdgeInsets.only(top: 40.0)),
                          FlatButton(
                            onPressed: () {
                              print("button presed");
                              BlocProvider.of<RequestBloc>(context)
                                  .add(SelectRequestForm());
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
                          BlocBuilder<RequestBloc, RequestState>(
                            buildWhen: (prevState, currentState) {
                              if (currentState is RequestFormSelected) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              if (state is RequestFormSelected) {
                                filepath = state.filepath;
                                selectDocumentText = "Document Selected";

                                return Container(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Center(
                                    child: Text(
                                      selectDocumentText,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Center(
                                    child: Text(
                                      selectDocumentText == null
                                          ? "Please Select Document"
                                          : selectDocumentText,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          Padding(padding: EdgeInsets.only(top: 30.0)),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: FlatButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    BlocProvider.of<RequestBloc>(context).add(
                                        UploadRequestForm(
                                          filePath: filepath,
                                          formDocument: dropdownItemSelected
                                        ));
                                  }
                                },
                                child: Text(
                                  "Submit Form",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              )),
                        ],
                      )),
                );
              } else {
                return _customWidgets.loadInProgress();
              }
            },
          );
        } else {
          return _customWidgets.loadInProgress();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(BlocProvider.of<AuthenticationBloc>(context));
    return _homeScreenLayout.layout(
        context: context, title: title, customWidget: content);
  }
}
