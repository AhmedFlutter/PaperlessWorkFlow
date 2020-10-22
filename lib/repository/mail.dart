import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

sendMailFromGmail(String recieverEmail, String subject, String messageHtml) async {
  String userName = "fizzajaved30@gmail.com";
  String password = "Gamer0340";
  final smtpServer = gmail(userName, password);
  final message = Message()
  ..from = Address(userName, 'PaperlessWorkflow')
  ..recipients.add(recieverEmail)
  ..subject = subject
  ..html = messageHtml;

  try {
    await send(message, smtpServer);
    // print('Message sent: ' + sendReport.toString());
  } on MailerException {
    print('Message not sent.');
  }
}
