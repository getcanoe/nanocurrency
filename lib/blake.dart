import 'dart:convert';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:pointycastle/digests/blake2b.dart';

/// Convenience wrapper for Blake2bDigest.
class Blake {
  Blake2bDigest digest;

  Blake({digestSize = 32, key = null}) {
    digest = Blake2bDigest(digestSize: digestSize, key: key);
  }

  updateHex(String data) {
    updateBytes(HEX.decode(data));
  }

  updateString(String data) {
    updateBytes(utf8.encode(data));
  }

  updateBytes(Uint8List bytes) {
    digest.update(bytes, 0, bytes.length);
  }

  String finalHex() {
    return HEX.encode(finalBytes());
  }

  Uint8List finalBytes() {
    var out = new Uint8List(digest.digestSize);
    var len = digest.doFinal(out, 0);
    return out.sublist(0, len);
  }
}
