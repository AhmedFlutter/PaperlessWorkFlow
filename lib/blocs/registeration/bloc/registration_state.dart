part of 'registration_bloc.dart';

@immutable
abstract class RegistrationState extends Equatable {}

class RegistrationInitial extends RegistrationState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class RegistrationLoadInProgress extends RegistrationState {
  @override
  List<Object> get props => throw UnimplementedError();

}


class RegistrationSuccess extends RegistrationState {

  final String msg;

  RegistrationSuccess({this.msg});

  @override
  List<Object> get props => [msg];
}

class RegistrationFails extends RegistrationState {

  final String msg;

  RegistrationFails({this.msg});

  @override
  List<Object> get props => [msg];
}
