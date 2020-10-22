import 'dart:async';

import 'package:Paperless_Workflow/config/config.dart';
import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:Paperless_Workflow/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository _userRepository = UserRepository();

  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticateUser) {
      yield* _mapAuthenticateUserEventToState(event.user);
    } else if (event is CheckAuthentication) {
      yield* _mapCheckAuthenticateEventToState();
    } else if (event is AuthenticationSignOut) {
      yield* _mapSignOutEventToState();
    } else if (event is GetAuthenticatedUser) {
      yield* _mapGetAuthenticateUserToState();
    }

  }

  Stream<AuthenticationState> _mapAuthenticateUserEventToState(User user) async*{
    try {
      yield AuthenticationLoadInProgress();
      bool signInResult = await _userRepository.signInWithCredentials(email: user.email, password: user.password);

      if (signInResult) {

        bool checkEmailVerification = await _userRepository.checkEmailVerification();

        if (checkEmailVerification) {
          yield AuthenticationSuccess(verifiedLogin: true);

        } else {
          yield AuthenticationFails(msg: authenticationEmailVerifyError);
        }

      } else {
        yield AuthenticationFails(msg: authenticationEmailOrPasswordIncorrect);
      }

    } catch (e) {
      print(e.toString());
    }
  }

  Stream<AuthenticationState> _mapCheckAuthenticateEventToState() async* {
    try {
      bool onEmailAddressVerified = await _userRepository.onEmalAddressVerified();
      if (onEmailAddressVerified) {
          yield AuthenticationSuccess(verifiedLogin: onEmailAddressVerified);
      } else {
          yield AuthenticationFails();
      }

    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }
  }

  Stream<AuthenticationState> _mapSignOutEventToState() async*{
    try {
    print('hello');
    await _userRepository.signOut();
    yield AuthenticationSignOutSuccessfull();

    } catch (e) {

      print("Exception ${e.toString()}");
    }
 }

 Stream<AuthenticationState> _mapGetAuthenticateUserToState() async* {
  try {
    yield AuthenticationLoadInProgress();
    String userId = await _userRepository.getCurrentUserId();

    User user = await _userRepository.getUserData(userId);
    yield AuthenticateUserState(user: user);

  } catch (e) {
    print("Exception");
    e.toString();
  }
 }
}
