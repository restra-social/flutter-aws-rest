library flutter_aws_rest;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:xml/xml.dart' as xml;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';

part 'src/cryptoutil.dart';
part 'src/request_payload.dart';
part 'src/request_signer.dart';
part 'src/aws_scope.dart';
part 'src/aws_credentials.dart';
part 'src/aws_client.dart';
part 'src/s3_bucket_api.dart';
part 'src/models/list_bucket_result.dart';
part 'src/models/content.dart';
part 'src/models/user.dart';
part 'src/models/delete_request.dart';
part 'src/models/delete_result.dart';
part 'src/models/s3object.dart';
part 'src/models/error_response.dart';

final _scopeDateFormatter = new DateFormat('yyyyMMdd');
final _httpDateFormatter = new DateFormat("EEE, dd MMM y HH:mm:ss 'GMT'");
final _logger = new Logger('flutter_aws_rest');
