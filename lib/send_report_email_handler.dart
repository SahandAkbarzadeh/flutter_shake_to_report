import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';

class _Uuid {
  final Random _random = Random();

  /// Generate a version 4 (random) UUID. This is a UUID scheme that only uses
  /// random numbers as the source of the generated UUID.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/temp_image${_Uuid().generateV4()}.png');
}

Future<File> _writeImage(Uint8List image) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsBytes(image.toList());
}

Future sendEmail(Uint8List image, String description, String email) async {
  var attachment = await _writeImage(image);
  final MailOptions mailOptions = MailOptions(
    body: description,
    subject: 'new bug report',
    recipients: [email],
    isHTML: true,
    bccRecipients: [],
    ccRecipients: [],
    attachments: [attachment.path],
  );
  await FlutterMailer.send(mailOptions);
}
