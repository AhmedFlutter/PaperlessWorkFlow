part of 'feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();
}

class FeedbackInitial extends FeedbackState {
  @override
  List<Object> get props => [];
}

class FeedbackAdded extends FeedbackState {
  @override
  List<Object> get props => [];
}

class ShowFeedbacksState extends FeedbackState {
  final List<FeedbackModel> feedbacks;
  ShowFeedbacksState({this.feedbacks});
  @override
  List<Object> get props => [feedbacks];
}

class GetRequestPreloadState extends FeedbackState {
  final List<FeedbackModel> feedbacks;

  GetRequestPreloadState({this.feedbacks});

  @override
  List<Object> get props => throw UnimplementedError();

}

class UpdateFeedBackSolvedState extends FeedbackState {
  @override
  List<Object> get props => throw UnimplementedError();
}
