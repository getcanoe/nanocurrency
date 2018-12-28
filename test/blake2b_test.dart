import "dart:convert";
import "package:test/test.dart";
import "package:hex/hex.dart";
import 'package:pointycastle/digests/blake2b.dart';

void main() {
  test("Blake2b 64 byte hash", () {
    var input = "abc";
    var blake = Blake2bDigest(digestSize: 64);
    var data = utf8.encode(input);
    expect(
        HEX.encode(blake.process(data)),
        equals(
            "ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d17d87c5392aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923"));
  });

  test("Blake2b 32 byte hash", () {
    var input = "abc";
    var blake = Blake2bDigest(digestSize: 32);
    var data = utf8.encode(input);
    expect(
        HEX.encode(blake.process(data)),
        equals(
            "bddd813c634239723171ef3fee98579b94964e3bb1cb3e427262c8c068d52319"));
  });
}
