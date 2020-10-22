part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
}

class AddFeedback extends FeedbackEvent {
  final FeedbackModel feedback;
  @override
  List<Object> get props => [feedback];

  AddFeedback({this.feedback});
}

class ShowFeedbacks extends FeedbackEvent {
  final String requestId;
  @override
  List<Object> get props => [requestId];

  ShowFeedbacks({this.requestId});
}

class PassFeedbacksToState extends FeedbackEvent {
  final List<FeedbackModel> feedbacks;
  @override
  List<Object> get props => [feedbacks];

  PassFeedbacksToState({this.feedbacks});
}

class GetRequestPreloadFeedback extends FeedbackEvent {
  final String documentID;
  GetRequestPreloadFeedback({this.documentID});

  @override
  List<Object> get props => [documentID];

}

class UpdateFeedBackSolved extends FeedbackEvent {
  final String documentID;
  UpdateFeedBackSolved({this.documentID});

  @override
  List<Object> get props => [documentID];

}
