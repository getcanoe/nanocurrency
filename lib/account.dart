import 'dart:typed_data';

import 'package:nanocurrency/block.dart';
import 'package:ed25519_dart/ed25519_dart.dart' as ed25519;
import 'package:nanocurrency/block_chain.dart';
import 'package:nanocurrency/util.dart';

/// Represents an Account in a Wallet. Has an identifier which is also referred to as the
/// account name, or address. An Account has a chain of Blocks.
class Account {
  /// xrb_ or nano_ prefixed
  /// Account number/identifier: This is what you think of as someone's Nano
  /// address: it'a string that starts with "xrb_" (in the future this will become
  /// "nano_"), then has 52 characters which are the public key but encoded with a
  /// specific base32 encoding algorithm to prevent human transcription errors by
  /// limiting ambiguity between different characters (no O and 0 for example).
  /// Then the final 8 characters are a checksum of the public key to aid in
  /// discovering typos, also encoded with the same base32 scheme.
  String prefix;
  String identifier;

  Account(Uint8List key, {prefix = 'nano_'}) {
    this.prefix = prefix;
    setSecretKey(key);
  }

  /// Public Key: This is also a 32 byte value, usually represented as a 64
  /// character, upper case hexadecimal string (0-9A-F). It is derived from a
  /// private key by using the ed25519 curve using blake2b as the hash function
  /// instead of sha. Usually public keys will not be passed around in this form,
  /// however.
  Uint8List publicKey;

  /// Private Key: This is also a 32 byte value, usually represented as a 64
  /// character, uppercase hexadecimal string(0-9A-F). It can either be random (an
  /// ad-hoc key) or derived from a seed, as described above. This is what
  /// represents control of a specific account on the ledger. If you know or can
  /// know the private key of someone's account, you can transact as if you own
  /// that account.
  Uint8List secretKey;

  BigInt pendingBalance;
  BigInt balance;

  BlockChain chain = BlockChain();

  String representative;

  setSecretKey(Uint8List bytes) {
    if (bytes.length != 32) {
      throw 'Invalid Secret Key length. Should be 32 bytes';
    }
    secretKey = bytes;
    publicKey = ed25519.publicKey(bytes);
    identifier = accountFromPublicKey(publicKey, prefix: prefix);
  }
}
