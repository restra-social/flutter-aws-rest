part of flutter_aws_rest;

class ErrorResponse {
  final String code;
  final String message;
  final String requestId;

  ErrorResponse(this.code, this.message, this.requestId);

  factory ErrorResponse.fromXml(String xmlText) {
    final parsed = xml.parse(xmlText);
    final errorElem = parsed.findElements('Error').first;
    final codeElem = errorElem.findElements('Code').first;
    final messageElem = errorElem.findElements('Message').first;
    final requestIdElem = errorElem.findElements('RequestId').first;
    return new ErrorResponse(
        codeElem.text, messageElem.text, requestIdElem.text);
  }

  String toString() => 'CODE: $code\nMESSAGE: $message\nREQUEST ID: $requestId';
}
