import 'dart:async';
import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/models/form_model.dart';
import 'package:Paperless_Workflow/repository/database.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormBlocState> {
  DatabaseRepository _databaseRepository = DatabaseRepository();
  AuthenticationBloc authenticationBloc;
  FormBloc({this.authenticationBloc}) : super(FormInitial());

  @override
  Stream<FormBlocState> mapEventToState(
    FormEvent event,
  ) async* {
    if (event is LoadAllFormsEvent) {
      yield* _mapLoadAllFormEventToState();
    } else if (event is PassFormsToState) {
      yield FormLoadSuccess(forms: event.forms);
    }
  }

  Stream<FormBlocState> _mapLoadAllFormEventToState() async* {
    authenticationBloc.listen((state) async {
      if (state is AuthenticateUserState) {
        String userRole = state.user.userRole;
        QuerySnapshot query = await _databaseRepository.getCollectionInstance("forms").where('user_role', isEqualTo: userRole).getDocuments();

        List<DocumentSnapshot> documents =  query.documents;

        List<FormModel> forms = documents.map((document) => FormModel.toMap(document)).toList();

        add(PassFormsToState(forms));
      }

    // yield FormLoadSuccess(forms: forms);

    });

  // }
  }

  @override
  Future<void> close() {
    return super.close();
  }

}
