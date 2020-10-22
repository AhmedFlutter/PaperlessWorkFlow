part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();
}


class LoadAllFormsEvent extends FormEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PassFormsToState extends FormEvent{
  final List<FormModel> forms;

  PassFormsToState(this.forms);
  @override
  List<Object> get props => [forms];

}
