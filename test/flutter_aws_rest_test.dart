

import 'dart:typed_data';

import 'package:flutter_aws_rest/flutter_aws_rest.dart';

import 'settings.dart';

void main() {

  Future saveDataToServer(
      List<ByteData> images, String name, String type, String id) async {
    final creds = AwsCredentials(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);
    final scope = AwsScope("ap-south-1", 's3');
    final signer = RequestSigner(creds, scope);
    final awsClient = AwsClient(signer);
    final bucketApi = S3BucketApi("restra/restaurant/$id", AWS_REGION, awsClient);

    for (var i = 0; i < images.length; i++) {
      // Upload to S3
      var filteredName =
          name.trim().toLowerCase().replaceAll(" ", "_") + '_${type}_$i.jpg';
      bucketApi.uploadObjectBytes(
          '$filteredName', images[i].buffer.asUint8List(),
          headers: {'content-type': 'image/jpeg'}).then((_) {
        // Set Permission to Public Read
        bucketApi.setCannedAcl('$filteredName', 'public-read').then((_) {
          print(type + ' ' + i.toString() + ' set acl complete!');

          // Add to List
/*          setState(() {
            if (placeInfo.images == null) {
              placeInfo.images = new List<String>();
              placeInfo.images.add(
                  'https://restra.s3.amazonaws.com/restaurant/$filteredName');
            } else {
              placeInfo.images.add(
                  'https://restra.s3.amazonaws.com/restaurant/$filteredName');
            }
          });*/

        });
      });
    }
  }

  Future getImageFromServer(String id) async {
    final creds = AwsCredentials(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);
    final scope = AwsScope("ap-south-1", 's3');
    final signer = RequestSigner(creds, scope);
    final awsClient = AwsClient(signer);
    final bucketApi = S3BucketApi("restra/restaurant", "ap-south-1", awsClient);

    bucketApi.listBucket().then((ListBucketResult results) {
      results.contents.forEach((content) => print(content.key));
    });
  }
}