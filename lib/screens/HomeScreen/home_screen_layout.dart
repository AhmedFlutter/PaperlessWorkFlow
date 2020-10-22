import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:Paperless_Workflow/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// void main() => runApp(new MyApp());

class HomeScreenLayout {

  Widget layout({@required BuildContext context, @required String title, @required Function customWidget, Function onPressCallback}) {
    CustomWidgets customWidgets = CustomWidgets();
    AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (prevstate, currentState) {
        if (currentState is AuthenticationLoadInProgress || currentState is AuthenticateUserState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        print(state);
        if (state is AuthenticateUserState) {
          if (title == 'Requests') {

            return Scaffold(
              appBar: _getHomeScreenAppBar(title),
              drawer: _getHomeScreenAccountDrawer(context,title,authenticationBloc, state.user),
              body: customWidget(),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: onPressCallback
              ),
            );

          } else if (title == 'Requests For Signature') {
              return Scaffold(
                appBar: _getHomeScreenAppBar(title),
                drawer: _getHomeScreenAccountDrawer(context,title,authenticationBloc, state.user),
                body: customWidget(),
              );
          } else {
            return Scaffold(
              appBar: _getHomeScreenAppBar(title),
              drawer: _getHomeScreenAccountDrawer(context,title,authenticationBloc, state.user),
              body: customWidget(),
            );
          }
        } else {
          return customWidgets.loadInProgress();
        }
      },
    );
  }
  AppBar _getHomeScreenAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.red,
      title: new Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Drawer _getHomeScreenAccountDrawer(BuildContext context,String title, AuthenticationBloc authenticationBloc, User user) {

    return Drawer(
      child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              accountName: Text(
                user.name != null ? user.name : '',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
              ),
              accountEmail: Text(
                user.email != null ? user.email : '',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
              ),
              currentAccountPicture: Icon(
                Icons.account_circle,
                size: 50.0,
                color: Colors.white,
              ),
              margin: EdgeInsets.only(bottom: 0.0),
        ),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top:0.0),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: title == 'Requests' ? Colors.red[100] : null
                ),
                child: ListTile(
                  leading: Icon(Icons.inbox, color: title == "Requests" ? Colors.red : null,),
                  title: Text("Requests",
                    style: TextStyle(
                      color: title == "Requests" ? Colors.red : null
                    ),
                  ),
                  onTap: () {
                    print("Title:  $title");
                    if (title != "Requests") {
                      Navigator.pushNamed(context, '/requests');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              user.userRole != 'student' ? Container(
                decoration: BoxDecoration(
                  color: title == 'Requests For Signature' ? Colors.red[100] : null
                ),
                child: ListTile(
                  leading: Icon(Icons.inbox, color: title == "Requests For Signature" ? Colors.red : null,),
                  title: Text("Requests For Signature",
                    style: TextStyle(
                      color: title == "Requests For Signature" ? Colors.red : null
                    ),
                  ),
                  onTap: () {
                    print("Title:  $title");
                    if (title != "Requests For Signature") {
                      Navigator.pushNamed(context, '/authority_requests');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ): Container(),
              Container(
                  decoration: BoxDecoration(
                    color: title == "Forms" ? Colors.red[100] : null,
                  ),
                  child: ListTile(
                  leading: Icon(Icons.add, color: title == "Forms" ? Colors.red : null),
                  title: Text("Forms",
                      style: TextStyle(
                        color: title == "Forms" ? Colors.red : null
                      ),
                    ),
                  onTap: () {
                    if (title != "Forms") {
                      Navigator.pushNamed(context, '/forms');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                      print(state);
                      if (state is AuthenticationSignOutSuccessfull) {
                        authenticationBloc.close();
                        Navigator.pushNamed(context, '/wrapper');
                      }
                    },
                    child: ListTile(
                    leading: Icon(Icons.supervisor_account),
                    title: Text("Sign Out"),
                    onTap: () {
                      authenticationBloc.add(AuthenticationSignOut());
                    },
                  ),
              ),

            ],
          ),
        )
      ],
    ));
  }
}
