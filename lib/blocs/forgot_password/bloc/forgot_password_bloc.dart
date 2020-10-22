import 'dart:async';

import 'package:Paperless_Workflow/repository/database.dart';
import 'package:Paperless_Workflow/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  UserRepository _userRepository = UserRepository();
  DatabaseRepository _databaseRepository = DatabaseRepository();

  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ForgotPassword) {
      yield* _mapForgotPasswordEventToState(event);
    }
  }
  Stream<ForgotPasswordState> _mapForgotPasswordEventToState(ForgotPassword event) async*{

    try {
      QuerySnapshot query = await _databaseRepository.getCollectionInstance('/users').where('email', isEqualTo: event.email).getDocuments();
      List<DocumentSnapshot> documents = query.documents;

      if (documents.length > 0) {
        bool resetPassword = await _userRepository.resetPassword(event.email);

        if (resetPassword) {
          yield ForgotPasswordSuccess();
        }

      } else {
        yield ForgotPasswordFails();
      }

    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }

  }

}



