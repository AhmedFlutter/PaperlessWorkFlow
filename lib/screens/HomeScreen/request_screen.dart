import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/feedback/bloc/feedback_bloc.dart';
import 'package:Paperless_Workflow/blocs/form/bloc/form_bloc.dart';
import 'package:Paperless_Workflow/blocs/request/bloc/request_bloc.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/request_form_screen.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/request_show_screen.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_layout.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({Key key}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final HomeScreenLayout _homeScreenLayout = HomeScreenLayout();
  final String title = "Requests";
  final CustomWidgets _customWidgets = CustomWidgets();
  AuthenticationBloc authenticationBloc;
  FormBloc formbloc;
  RequestBloc requestBloc;

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    formbloc = BlocProvider.of<FormBloc>(context);
    requestBloc = BlocProvider.of<RequestBloc>(context);
  }

  Widget content() {
    return BlocConsumer<RequestBloc, RequestState>(
      listener: (context, state) {
        // print(state);
        if (state is RequestFormUploadSuccessfull) {
          _customWidgets.showSnackBar(
            context,
            "Request Added Successfully",
            Duration(
            seconds: 2)
            );
        }
      },
      builder: (context, state) {
        if (state is RequestFormLoadAllUserRequest) {

          List<RequestModel> requests = state.requests;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, position) {
              RequestModel request = requests[position];
              Widget traling;

              if (request.allDone != null) {
                traling = Text("Done", style:TextStyle(color: Colors.green, fontSize: 18.0));
              } else if (request.canceled == 1) {
                traling = Text("Canceled", style:TextStyle(color: Colors.red, fontSize: 18.0));
              } else {
                traling = Text("InProgress", style:TextStyle(color: Colors.orange, fontSize: 18.0));
              }

              return Card(
                child: ListTile(
                  title: Text(request.formName),
                  subtitle: Text(request.userEmail),
                  trailing: traling,
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (context) => RequestBloc(authenticationBloc: authenticationBloc)..add(GetSingleRequest(documentID: request.id)),),
                          BlocProvider.value(
                            value: authenticationBloc,
                          ),
                          BlocProvider(
                            create: (context) => FeedbackBloc()
                          )
                        ],
                        child: RequestShowScreen(documentID: request.id)
                      );
                    }));
                    requestBloc.add(LoadAllRequestFormUser());
                  },
                ),
                elevation: 2.0,
              );
            }
          );

        } else if (state is RequestsNotAvailable) {

          return Center(child: Text("Requests Not Available RightNow"));

        } else {

          return _customWidgets.loadInProgress();

        }

      },
    );
  }

  @override
  Widget build(BuildContext context) {
      return _homeScreenLayout.layout(
        context: context,
        title: title,
        customWidget: content,
        onPressCallback: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: authenticationBloc
                  ),
                  BlocProvider.value(
                    value: formbloc,
                  ),
                  BlocProvider(create: (context) => RequestBloc(authenticationBloc: authenticationBloc)..add(ShowRequestForm()))
                ],
                child: RequestFormScreen()
              );

            })
          );

          requestBloc.add(LoadAllRequestFormUser());
    });
  }

  @override
  void dispose() {
    authenticationBloc.close();
    requestBloc.close();
    formbloc.close();
    super.dispose();
  }
}
