import 'dart:async';
import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:Paperless_Workflow/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:Paperless_Workflow/config/config.dart';


part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {

  UserRepository _userRepository = UserRepository();

  RegistrationBloc() : super(RegistrationInitial());

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {

    if (event is RegisterUser) {
      yield* _mapRegiterUserToState(event.user);
    }

  }
  Stream<RegistrationState> _mapRegiterUserToState(User user) async*{
      try {
        yield RegistrationLoadInProgress();
        bool registeredUser = await _userRepository.signUp(user);

        if (registeredUser) {
          yield RegistrationSuccess(msg: emailSuccessMsg);

          // yield RegistrationInitial();
        } else {
          yield RegistrationFails(msg: emailVerifyError);

          // yield RegistrationInitial();

        }

      } catch(e) {
        // yield RegistrationFails(msg: emailVerifyError);
        print("Catch Exception");

        // yield RegistrationInitial();
    }
}
}
