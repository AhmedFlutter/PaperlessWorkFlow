import 'package:flutter/material.dart';

class CustomWidgets {
  Widget errorOrSuccessMessage({@required String type, @required String msg}) {
    Color boxColor;
    Color textColor;

    if (type == 'error') {
      boxColor = Colors.red[100];
      textColor = Colors.red;
    } else {
      boxColor =Colors.green[100];
      textColor = Colors.green;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Text(msg, style: TextStyle(
        color: textColor,
        fontSize: 15
      ),),
    );
  }

  void showSnackBar(BuildContext context, String content, Duration duration)  {
    SnackBar snackbar = SnackBar(
      content: Text(content),
      duration: duration,
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  void offKeyboardFocus({@required BuildContext context}) {
      FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget loadInProgress() {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
