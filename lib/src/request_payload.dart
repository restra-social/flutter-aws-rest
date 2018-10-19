part of flutter_aws_rest;

class AwsRequest {
  static final _emptySha256 = _sha256Payload(new List<int>());
  static final _emptyMd5 = _md5Payload(new List<int>());
  final List<int> bytes;
  final String payloadSha256;
  final String payloadMd5;
  final Map<String, String> headers;

  bool get isEmpty => this.bytes == null;

  AwsRequest(this.bytes, this.payloadSha256, this.payloadMd5, this.headers);

  factory AwsRequest.fromBytes(List<int> bytes,
      {Map<String, String> headers: const {}}) {
    return new AwsRequest(
        bytes, _sha256Payload(bytes), _md5Payload(bytes), headers);
  }

  factory AwsRequest.noPayload({Map<String, String> headers: const {}}) {
    return new AwsRequest(null, _emptySha256, _emptyMd5, headers);
  }

  static String _md5Payload(List<int> payload) {
    return CryptoUtils.bytesToBase64(md5.convert(payload).bytes);
  }

  static String _sha256Payload(List<int> payload) {
    return CryptoUtils.bytesToHex(sha256.convert(payload).bytes);
  }
}
