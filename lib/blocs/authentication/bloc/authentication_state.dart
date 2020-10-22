part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AuthenticationLoadInProgress extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AuthenticationSuccess extends AuthenticationState {
  final bool verifiedLogin;

  AuthenticationSuccess({this.verifiedLogin});

  @override
  List<Object> get props => [verifiedLogin];
}

class AuthenticationFails extends AuthenticationState {
  final String msg;
  AuthenticationFails({this.msg});

  @override
  List<Object> get props => [msg];
}

class AuthenticationSignOutSuccessfull extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();

}

class AuthenticateUserState extends AuthenticationState {

  final User user;

  AuthenticateUserState({@required this.user});

  @override
  List<Object> get props => [];

}
