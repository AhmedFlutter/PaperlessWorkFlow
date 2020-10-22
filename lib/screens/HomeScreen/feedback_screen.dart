import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/blocs/feedback/bloc/feedback_bloc.dart';
import 'package:Paperless_Workflow/models/feedback_model.dart';
import 'package:Paperless_Workflow/models/request_model.dart';
import 'package:Paperless_Workflow/screens/HomeScreen/feedback_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  final RequestModel requestModel;
  final bool signDocument;

  FeedbackScreen({Key key, this.requestModel, this.signDocument}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Screen"),
      ),
      floatingActionButton: widget.signDocument ? null: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<AuthenticationBloc>(context),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<FeedbackBloc>(context),
                )
              ],
              child: FeedbackAddScreen(requestModel: widget.requestModel,)
            );
          }));
          BlocProvider.of<FeedbackBloc>(context).add(ShowFeedbacks(requestId: widget.requestModel.id));
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (context, state) {
          if (state is ShowFeedbacksState) {
            List<FeedbackModel> feedbacks = state.feedbacks;
            if (feedbacks.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                reverse: true,

                itemCount: feedbacks.length,
                itemBuilder: (context, count) {
                  FeedbackModel feedback = feedbacks[count];
                  DateFormat formatter = DateFormat("yyyy-MM-dd");
                  String formatted = formatter.format(feedback.date.toDate());
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                    child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(feedback.name[0])
                          ),
                          title: Text(feedback.message),
                          subtitle: Text(formatted),
                          trailing: Text(feedback.userRole),
                          isThreeLine: true,
                        ),
                      ),
                  );
                },
              );
            } else {
              return Container(child: Center(child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('No feedbacks are available Click on (+) button to add feedback', style: TextStyle(fontSize: 15.0),),
              ),),);
            }

          } else {
            return Container();
          }
        }
      ),
    );
  }
}
