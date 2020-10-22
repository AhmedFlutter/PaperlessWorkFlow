import 'package:Paperless_Workflow/blocs/form/bloc/form_bloc.dart';
import 'package:Paperless_Workflow/models/form_model.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:Paperless_Workflow/shared/pdftron_document.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_layout.dart';

class FormsScreen extends StatefulWidget {
  FormsScreen({Key key}) : super(key: key);
  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final HomeScreenLayout _homeScreenLayout = HomeScreenLayout();
  final String title = "Forms";
  final CustomWidgets _customWidgets = CustomWidgets();
  // final List<Color> color = [Colors.red, Colors.blue, Colors.green, Colors.indigo];


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Widget content() {
    return BlocBuilder<FormBloc, FormBlocState>(
      builder: (context, state) {
        if (state is FormLoadSuccess) {
          List<FormModel> forms = state.forms;
          if (forms.length > 0) {
          return Container(
                        alignment: Alignment.center,
                        child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Center(child: Text("Forms", style: TextStyle(fontSize: 28.0, color: Colors.red, fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.only(top:30.0)),
                          Container(
                          alignment: Alignment.center,
                          child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          itemCount: forms.length,
                          itemBuilder: (_, index) {

                            if(index.isOdd) {

                              return Padding(
                                padding: EdgeInsets.only(top:20.0),
                                  child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: FlatButton(
                                    child: Text(forms[index].name, style: TextStyle(color: Colors.white, fontSize: 18.0),),
                                    onPressed: () {
                                      openDocument(forms[index].url);
                                    },
                                  ),
                                ),
                              );

                            } else {
                                return Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: FlatButton(
                                  child: Text(forms[index].name, style: TextStyle(color: Colors.white, fontSize: 18.0),),
                                  onPressed: () {
                                    openDocument(forms[index].url);
                                  },
                                ),
                              );
                            }

                          },
                        ),
                      )
                        ],

                      ),
                    );
          } else {
            return Center(child: Text("No Forms Available"));
          }
        } else {
          return _customWidgets.loadInProgress();
        }
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return _homeScreenLayout.layout(context: context, title: title, customWidget: content);
  }
}
