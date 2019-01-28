import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:nanocurrency/account.dart';
import 'package:nanocurrency/blake.dart';

/// Represents a complete Wallet with Accounts.
class Wallet {
  /// Seed: This is a series of 32 random bytes of data, usually represented as
  /// a 64 character, uppercase hexadecimal string (0-9A-F). This value is used
  /// to derive private keys for accounts by combining it with an index and then
  /// putting that into a hash function (PrivK[i] = blake2b(outLen = 32, input =
  /// seed || i) where || means concatentaion and i is a 32bit unsigned
  /// integer). Private keys are derived deterministically from the seed, which
  /// means that as long as you put the same seed and index into the derivation
  /// function, you will get the same resulting private key every time.
  /// Therefore, knowing just the seed allows you to be able to access all the
  /// derived private keys from index 0 to 2^32 - 1 (because the index value is
  /// a unsigned 32 bit integer). Wallet implementations will commonly start
  /// from index 0 and increment it by 1 each time you create a new account so
  /// that recovering accounts is as easy as importing the seed and then
  /// repeating this account creation process.
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
