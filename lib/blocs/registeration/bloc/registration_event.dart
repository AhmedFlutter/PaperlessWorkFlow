part of 'registration_bloc.dart';

@immutable
abstract class RegistrationEvent extends Equatable{}


class RegisterUser extends RegistrationEvent {
  final User user;

  RegisterUser({this.user});

  @override
  List<Object> get props => [user];

}
