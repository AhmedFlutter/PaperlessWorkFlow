import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/form/bloc/form_bloc.dart';
import 'package:Paperless_Workflow/blocs/request/bloc/request_bloc.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/authority_show_screen.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_layout.dart';

class AuthorityScreen extends StatefulWidget {
  AuthorityScreen({Key key}) : super(key: key);

  @override
  _AuthorityScreenState createState() => _AuthorityScreenState();
}

class _AuthorityScreenState extends State<AuthorityScreen> {
  // RequestScreen({Key key}) : super(key: key);
  final HomeScreenLayout _homeScreenLayout = HomeScreenLayout();
  final String title = "Requests For Signature";
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
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state is LoadAuthorityRequestsSuccessState) {

          List<RequestModel> requests = state.requests;

          if (requests.length > 0) {
            return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, position) {
                      RequestModel request = requests[position];

                      return Card(
                        child: ListTile(
                          title: Text(request.formName),
                          subtitle: Text(request.userEmail),
                          onTap: () async  {
                            String title = request.formName + ' - ' + request.userName;

                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(value: authenticationBloc),
                                    // BlocProvider.value(value: requestBloc),
                                    BlocProvider(create: (context) => RequestBloc(authenticationBloc: authenticationBloc)..add(LoadRequestAuthority(request)))
                                  ],
                                  child: AuthorityShowScreen(title: title, requestModel: request)
                                );
                              }
                            ));

                            requestBloc.add(LoadAuthorityRequests());

                          },
                        ),
                        elevation: 2.0,
                      );
                    }
              );
          } else {
            return Center(child: Text("Requests Not Available Right Now"));
          }

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
        onPressCallback: null
      );
  }
  @override
  void dispose() {
    authenticationBloc.close();
    requestBloc.close();
    formbloc.close();
    super.dispose();
  }

}
