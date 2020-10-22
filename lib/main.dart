import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/form/bloc/form_bloc.dart';
import 'package:Paperless_Workflow/blocs/registeration/bloc/registration_bloc.dart';
import 'package:Paperless_Workflow/blocs/request/bloc/request_bloc.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/authority_screen.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/forms_screen.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/request_screen.dart';
import 'package:Paperless_Workflow/screens/login_screen.dart';
import 'package:Paperless_Workflow/screens/signup_screen.dart';
import 'package:Paperless_Workflow/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Paperless Workflow",
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.red,
        // primarySwatch: Colors.red
      ),
      routes: {
        '/login': (context) {
          return BlocProvider(
            create: (context) => AuthenticationBloc(),
            child: LoginScreen()
          );
        },
        '/signup': (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthenticationBloc(),
              ),
              BlocProvider(
                create: (context) => RegistrationBloc(),
              ),
            ],
            child: SignUpScreen(),
          );
        },
        '/requests': (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthenticationBloc()..add(GetAuthenticatedUser()),
              ),
              BlocProvider(
                create: (context) => RequestBloc(authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))..add(LoadAllRequestFormUser()),
              ),
              BlocProvider(
                create: (context) => FormBloc(authenticationBloc: AuthenticationBloc()..add(GetAuthenticatedUser()))..add(LoadAllFormsEvent())
              ),
              // (context) =>
            ],
            child: RequestScreen()
          );
        },
        '/authority_requests': (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthenticationBloc()..add(GetAuthenticatedUser()),
              ),
              BlocProvider(
                create: (context) => RequestBloc(authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))..add(LoadAuthorityRequests()),
              ),
              BlocProvider(
                create: (context) => FormBloc(authenticationBloc: AuthenticationBloc()..add(GetAuthenticatedUser()))..add(LoadAllFormsEvent())
              ),
              // (context) =>
            ],
            child: AuthorityScreen()
          );
        },
        '/forms': (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthenticationBloc()..add(GetAuthenticatedUser()),
              ),
              BlocProvider(
                create: (context) => FormBloc(authenticationBloc: AuthenticationBloc()..add(GetAuthenticatedUser()))..add(LoadAllFormsEvent())
              )
              // (context) =>
            ],
            child: FormsScreen()
          );
        },
        '/wrapper': (context) {
          return BlocProvider(
            create: (context) => AuthenticationBloc()..add(CheckAuthentication()),
            child: Wrapper()
          );
        },
      },
      initialRoute: '/wrapper',

    );
  }
}
