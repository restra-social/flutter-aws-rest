part of flutter_aws_rest;

class S3BucketApi {
  final AwsClient _awsClient;
  final String _bucketName;
  final String _regionName;

  S3BucketApi(this._bucketName, this._regionName, this._awsClient);

  Future setCannedAcl(String objectKey, String cannedAcl) {
    final completer = new Completer();
    final uri = this._getUri(path: objectKey, queryParams: {'acl': ''});
    final request = new AwsRequest.noPayload(headers: {'x-amz-acl': cannedAcl});
    this._awsClient.put(uri, request).then((HttpClientResponse resp) {
      _readResponseAsString(resp).then((responseText) {
        completer.complete();
      });
    });
    return completer.future;
  }

  Future uploadObjectBytes(String objectKey, List<int> bytes,
      {Map<String, String> headers}) {
    final completer = new Completer();
    final request = new AwsRequest.fromBytes(bytes, headers: headers);
    final uri = this._getUri(path: objectKey);
    this._awsClient.put(uri, request).then((HttpClientResponse resp) {
      _readResponseAsString(resp).then((responseText) {
        completer.complete();
      });
    });
    return completer.future;
  }

  Future<ListBucketResult> listBucket() {
    final completer = new Completer<ListBucketResult>();
    final uri = this._getUri();
    this._awsClient.get(uri).then((HttpClientResponse resp) {
      _readResponseAsString(resp).then((String responseText) {
        final results = new ListBucketResult.fromXml(responseText);
        completer.complete(results);
      });
    });
    return completer.future;
  }

  Future<DeleteResults> deleteObjects(List<S3Object> objects) {
    if (objects == null || objects.length == 0) {
      _logger.warning('No objects were passed to deleteObjects, returning.');
      return new Future(() => new DeleteResults());
    }

    final completer = new Completer<DeleteResults>();
    final deleteReq = new _DeleteRequest(objects);
    final requestXml = deleteReq.toString();
    _logger.finest(requestXml);
    final uri = this._getUri(queryParams: {'delete': ''});
    final request = new AwsRequest.fromBytes(utf8.encode(requestXml), headers: {
      'content-type': 'text/xml; charset=utf-8',
      'content-encoding': 'gzip'
    });
    this._awsClient.post(uri, request).then((HttpClientResponse resp) {
      _readResponseAsString(resp).then((responseText) {
        _logger.finest(responseText);
        final results = new DeleteResults.fromXml(responseText);
        completer.complete(results);
      });
    });
    return completer.future;
  }

  Uri _getUri({String path, Map<String, String> queryParams}) => new Uri(
      scheme: 'https',
      host: 's3-$_regionName.amazonaws.com',
      path: path == null ? this._bucketName : '${this._bucketName}/$path',
      queryParameters: queryParams);

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
