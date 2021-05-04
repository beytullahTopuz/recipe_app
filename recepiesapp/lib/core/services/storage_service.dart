import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServisi {
  Reference _storage = FirebaseStorage.instance.ref();
  final DateTime zaman = DateTime.now();
  String resimId;

  Future<String> userimgUpload(File resimDosyasi, String id) async {
    UploadTask yuklemeYoneticisi =
        _storage.child("images/userpictures/$id.jpg").putFile(resimDosyasi);

    TaskSnapshot snapshot = await yuklemeYoneticisi;

    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }

  Future<String> foodImageUpload(File resimDosyasi, String id) async {
    var v = getRandomString(10);

    UploadTask yuklemeYoneticisi =
        _storage.child("images/foodImages/$v$id.jpg").putFile(resimDosyasi);

    TaskSnapshot snapshot = await yuklemeYoneticisi;

    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
