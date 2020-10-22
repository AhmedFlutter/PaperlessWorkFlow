import 'dart:async';

import 'package:Paperless_Workflow/models/feedback_model.dart';
import 'package:Paperless_Workflow/repository/database.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  DatabaseRepository _databaseRepository = DatabaseRepository();
  FeedbackBloc() : super(FeedbackInitial());

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    if (event is AddFeedback) {
      yield* _mapAddFeedbacktoState(event);
    } else if (event is ShowFeedbacks) {
      yield* _mapShowFeedbacksToState(event);
    } else if (event is PassFeedbacksToState) {
      yield ShowFeedbacksState(feedbacks: event.feedbacks);
    }

  }

  // Stream<FeedbackState> _mapRequestPreloadFeedbackToState(GetRequestPreloadFeedback feedback) async* {
  //   try {
  //     List<DocumentSnapshot> documents = await _databaseRepository.getAllDocumentsByFilter("feedback", condition: 'request_id', filter: feedback.documentID);

  //     List<FeedbackModel> feedbacks = documents.map(
  //       (snapshot) => FeedbackModel.toMap(snapshot)
  //     ).toList();

  //     List<FeedbackModel> requestPreLoadFeedbacks = feedbacks.where((feedback) {
  //       if (feedback.requestReUplod == 1 && feedback.solved == 0) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }).toList();

  //     yield GetRequestPreloadState(feedbacks: requestPreLoadFeedbacks);

  //   } catch (e) {
  //     print("Caught Exception ${e.toString()}");
  //   }
  // }

  Stream<FeedbackState> _mapAddFeedbacktoState(AddFeedback event) async* {
    try {
      FeedbackModel feedback = event.feedback;
      await _databaseRepository.createNewDocument('feedback', {
        'request_id': feedback.requestId,
        'message': feedback.message,
        'user_role': feedback.userRole,
        'name': feedback.name,
        'date': feedback.date,
      });
    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }
  }

  Stream<FeedbackState> _mapShowFeedbacksToState(ShowFeedbacks event) async*{
    try {
      _databaseRepository.listenToRealTimeFeedbacks(collectionName: 'feedback').listen((feedbackList) {
        List<FeedbackModel> feedbacks = feedbackList.where((feedback) => feedback.requestId == event.requestId).toList();
        add(PassFeedbacksToState(feedbacks: feedbacks));
      });

    } catch (e) {
      print("Caught Exception ${e.toString()}");
    }

  }

}


