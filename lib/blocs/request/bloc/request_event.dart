part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();
}


class SelectRequestForm extends RequestEvent {
  @override
  List<Object> get props => throw UnimplementedError();

}

class GetSingleRequest extends RequestEvent {

  final String documentID;

  GetSingleRequest({this.documentID});

  @override
  List<Object> get props => throw UnimplementedError();

}

class ShowRequestForm extends RequestEvent {
  @override
  List<Object> get props => throw UnimplementedError();

}

class UploadRequestForm extends RequestEvent {
  final String filePath;
  final String formDocument;

  UploadRequestForm({this.filePath, this.formDocument});

  @override
  List<Object> get props => [filePath, formDocument];

}

class LoadAllRequestFormUser extends RequestEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class LoadRequestAuthority extends RequestEvent {
  final RequestModel request;

  LoadRequestAuthority(this.request);
  @override
  List<Object> get props => [request];
}


class PassRequestsToState extends RequestEvent {
  final List<RequestModel> requests;

  PassRequestsToState({@required this.requests});

  @override
  List<Object> get props => [requests];

}


class AuthorityRequestFormUpload extends RequestEvent {
  final String requestID;
  final String filePath;
  final String signatureDocumentID;
  final int onNumber;

  AuthorityRequestFormUpload({this.requestID, this.filePath, this.signatureDocumentID, this.onNumber});

  @override
  List<Object> get props => throw UnimplementedError();

}

class RequestDownload extends RequestEvent {
  final String url;
  final String fileName;
  RequestDownload(this.url, this.fileName);
  @override
  List<Object> get props => [url, fileName];

}

class LoadAuthorityRequests extends RequestEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PassAuthorityRequestsToState extends RequestEvent {
  final List<RequestModel> requests;

  PassAuthorityRequestsToState({this.requests});
  @override
  List<Object> get props => [requests];
}


class PassRequestAuthorityToState extends RequestEvent{
  final String formUrl;
  final bool signedDocument;
  final String documentID;
  final int onNumber;

  PassRequestAuthorityToState(this.formUrl,this.documentID,this.onNumber, {this.signedDocument});
  @override
  List<Object> get props => [];

}

class PassRequestFailSignatureAuthorityToState extends RequestEvent{
  @override
  List<Object> get props => [];
}

class CancelRequest extends RequestEvent {
  final String documentID;

  CancelRequest(this.documentID);

  @override
  List<Object> get props => [documentID];

}
