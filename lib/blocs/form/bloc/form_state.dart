part of 'form_bloc.dart';

abstract class FormBlocState extends Equatable {
  const FormBlocState();
}

class FormInitial extends FormBlocState {
  @override
  List<Object> get props => [];
}


class FormLoadSuccess extends FormBlocState {
  @override
  List<Object> get props => [forms];

  final List<FormModel> forms;

  FormLoadSuccess({@required this.forms});

}
