import 'package:test/test.dart';
import 'package:flutter_aws_rest/flutter_aws_rest.dart';

void main() {
  final creds = new AwsCredentials("", "");
  final scope = new AwsScope("ap-south-1", 's3');
  final signer = new RequestSigner(creds, scope);
  final awsClient = new AwsClient(signer);
  final bucketApi = new S3BucketApi("restra", "ap-south-1", awsClient);
  bucketApi.listBucket().then((ListBucketResult results) {
    print('Objects in bucket:');
    results.contents.forEach((content) => print(content.key));
  });
}
