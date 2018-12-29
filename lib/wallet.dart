import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:nanocurrency/account.dart';
import 'package:nanocurrency/blake.dart';

/// Represents a complete Wallet with Accounts.
class Wallet {
  Uint8List seed;
  String defaultPrefix = 'nano_';
  var accounts = List<Account>();

  Wallet(this.seed);

  Wallet.fromHexSeed(String hex) {
    seed = HEX.decode(hex);
  }

  Account newAccount() {
    final account = Account(nextKey(), prefix: defaultPrefix);
    accounts.add(account);
    return account;
  }

  Uint8List nextKey() {
    if (seed.length != 32) {
      throw 'Seed should be set first.';
    }
    var indexBytes = Uint8List(4);
    ByteData.view(indexBytes.buffer).setUint32(0, accounts.length);
    // index = hex_uint8(dec2hex(index, 4));

    return (Blake()..updateBytes(seed)..updateBytes(indexBytes)).finalBytes();

//   api.addSecretKey(uint8_hex(newKey))
//    return accountFromHexKey(uint8_hex(nacl.sign.keyPair.fromSecretKey(newKey).publicKey))
  }
}
