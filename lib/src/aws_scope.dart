part of flutter_aws_rest;

class AwsScope {
  final String _region;
  final String _service;

  AwsScope(this._region, this._service);

  String generateScopeString(HttpClientRequest req) {
    return '${_scopeDateFormatter.format(req.headers.date)}/$_region/$_service/aws4_request';
  }
}
