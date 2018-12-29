import 'dart:typed_data';

import 'package:nanocurrency/blake.dart';

const alphabet = '13456789abcdefghijkmnopqrstuwxyz'; // No 0, 2 and no l, v

/// Encode provided Uint8List using the Nano-specific Base-32 implementeation.
String encodeNanoBase32(List<int> bytes) {
  final length = bytes.length;
  final leftover = (length * 8) % 5;
  final offset = leftover == 0 ? 0 : 5 - leftover;

  var value = 0;
  var output = '';
  var bits = 0;

  for (var i = 0; i < length; i++) {
    value = (value << 8) | bytes[i];
    bits += 8;

    while (bits >= 5) {
      output += alphabet[(value >> (bits + offset - 5)) & 31];
      bits -= 5;
    }
  }

  if (bits > 0) {
    output += alphabet[(value << (5 - (bits + offset))) & 31];
  }

  return output;
}

_readChar(String char) {
  final idx = alphabet.indexOf(char);
  if (idx == -1) {
    throw 'Invalid character found: ' + char;
  }
  return idx;
}

/// Decodes a Nano-implementation Base32 encoded string into a Uint8List
Uint8List decodeNanoBase32(String input) {
  final length = input.length;
  final leftover = (length * 5) % 8;
  final offset = leftover == 0 ? 0 : 8 - leftover;

  var bits = 0;
  var value = 0;

  var index = 0;
  var output = Uint8List((length * 5 / 8).ceil());

  for (var i = 0; i < length; i++) {
    value = (value << 5) | _readChar(input[i]);
    bits += 5;

    if (bits >= 8) {
      output[index++] = (value >> (bits + offset - 8)) & 255;
      bits -= 8;
    }
  }
  if (bits > 0) {
    output[index++] = (value << (bits + offset - 8)) & 255;
  }

  if (leftover != 0) {
    output.removeAt(0);
  }
  return output;
}

accountFromPublicKey(Uint8List key, {String prefix = 'nano_'}) {
  final encodedPublicKey = encodeNanoBase32(key);
  final checksum = (Blake(digestSize: 5)..updateBytes(key)).finalBytes();
  final encodedChecksum = encodeNanoBase32(checksum.reversed.toList());
  return prefix + encodedPublicKey + encodedChecksum;
}

/*
Uint8List publicKeyFromAccount (account) {
  if ((account.startsWith('xrb_1') || account.startsWith('xrb_3')) && (account.length == 64)) {
    account = account.substring(4, 64);
    var isValid = /^[13456789abcdefghijkmnopqrstuwxyz]+$/.test(account);
    if (isValid) {
      var key_uint4 = array_crop(uint5_uint4(string_uint5(account.substring(0, 52))));
      var hash_uint4 = uint5_uint4(string_uint5(account.substring(52, 60)));
      var key_array = uint4_uint8(key_uint4);
      var blake_hash = blake2b(key_array, null, 5).reverse();
      if (equal_arrays(hash_uint4, uint8_uint4(blake_hash))) {
        var key = uint4_hex(key_uint4);
        return key;
      } else {
        throw 'Checksum incorrect.';
      }
    }	else {
      throw 'Invalid XRB account.';
    }
  }
  throw 'Invalid XRB account.';
}*/
