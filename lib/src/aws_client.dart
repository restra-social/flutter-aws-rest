part of flutter_aws_rest;

class AwsClient {
  final RequestSigner _signer;
  final HttpClient _httpClient;

  AwsClient(this._signer) : this._httpClient = new HttpClient();

  Future<HttpClientResponse> put(Uri uri, AwsRequest payload) =>
      this.sendRequest('put', uri, payload);

  Future<HttpClientResponse> get(Uri uri) =>
      this.sendRequest('get', uri, new AwsRequest.noPayload());

  Future<HttpClientResponse> post(Uri uri, AwsRequest payload) =>
      this.sendRequest('post', uri, payload);

  Future<HttpClientResponse> delete(Uri uri, String path) =>
      this.sendRequest('delete', uri, new AwsRequest.noPayload());

  Future<HttpClientResponse> sendRequest(
      String method, Uri uri, AwsRequest payload) {
    final completer = new Completer<HttpClientResponse>();
    _logger.finest('Making ${method.toUpperCase()} request to $uri');
    this._httpClient.openUrl(method, uri).then((HttpClientRequest req) {
      this._signer.signRequest(req, payload);
      if (!payload.isEmpty) {
        req.add(payload.bytes);
      }
      req.close().then((HttpClientResponse resp) {
        _logger.finest('Received response: ${resp.reasonPhrase}');
        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          completer.complete(resp);
        } else {
          _readResponseAsString(resp).then((respText) {
            _logger.finest(respText);
            completer.completeError(new ErrorResponse.fromXml(respText));
          });
        }
      });
    });

    return completer.future;
  }

  static Future<String> _readResponseAsString(HttpClientResponse resp) {
    final completer = new Completer<String>();
    final buffer = new StringBuffer();
    resp
        .transform(utf8.decoder)
        .listen((String contents) => buffer.write(contents))
        .onDone(() => completer.complete(buffer.toString()));
    return completer.future;
  }
}
