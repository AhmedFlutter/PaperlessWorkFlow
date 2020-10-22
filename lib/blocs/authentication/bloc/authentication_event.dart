part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable{}


class AuthenticateUser extends AuthenticationEvent{

  final User user;

  AuthenticateUser({@required this.user});
  @override
  List<Object> get props => [user];

}

class CheckAuthentication extends AuthenticationEvent{
  @override
  List<Object> get props => throw UnimplementedError();

}

class AuthenticationSignOut extends AuthenticationEvent {
  @override
  List<Object> get props => throw UnimplementedError();

}


class GetAuthenticatedUser extends AuthenticationEvent {
  @override
  List<Object> get props => throw UnimplementedError();

}

