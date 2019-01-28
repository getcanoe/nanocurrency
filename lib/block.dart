import 'dart:typed_data';

import 'package:nanocurrency/blake.dart';
import 'package:nanocurrency/util.dart';

// final RAI_TO_RAW = '000000000000000000000000';
// final MAIN_NET_WORK_THRESHOLD = 'ffffffc000000000';

final STATE_BLOCK_PREAMBLE = hexToBytes(
    '0000000000000000000000000000000000000000000000000000000000000006');
final STATE_BLOCK_ZERO = hexToBytes(
    '0000000000000000000000000000000000000000000000000000000000000000');

enum BlockType { send, receive, open, change }

/// This is a Block for the block chain. We maintain fields in JSON friendly formats, typically
/// hex in Strings for binary data.
class Block {
  Block(this.state);

  /// Is this a state block?
  bool state;

  /// Indicates type of block
  BlockType type;

  /// The hash of the block
  Uint8List hash;

  Uint8List signature;

  Uint8List work;

  Uint8List account; // open

  /// The hash of the previous Block
  Uint8List previous; // send, receive and change

  Uint8List representative; // open and change

  BigInt balance; // send

  Uint8List destination; // open and change

  Uint8List source; // open and change

/*
  var send // if this is a send state block
  var blockAmount = bigInt(0)// amount transferred
  var blockAccount // account owner of this block
  var blockMessage // Additional information about this block
  var origin // account sending money in case of receive or open block
  var immutable = false // if true means block has already been confirmed and cannot be changed, some checks are ignored
  var timestamp // the UTC timestamp in milliseconds since 1970, 1 jan
*/

  /// Calculates the hash
  Uint8List calculateHash() {
    var blake = Blake();
    if (state) {
      blake
        ..updateBytes(STATE_BLOCK_PREAMBLE)
        ..updateBytes(account)
        ..updateBytes(previous)
        ..updateBytes(representative)
        ..updateBytes(bigIntToBytes(balance));

      switch (type) {
        case BlockType.send:
          blake.updateBytes(destination);
          break;
        case BlockType.receive:
          blake.updateBytes(source);
          break;
        case BlockType.open:
          blake.updateBytes(source);
          break;
        case BlockType.change:
          blake.updateBytes(STATE_BLOCK_ZERO);
          break;
        default:
          throw 'Unrecognized type of block';
      }
    } else {
      switch (type) {
        case BlockType.send:
          blake
            ..updateBytes(previous)
            ..updateBytes(destination)
            ..updateBytes(bigIntToBytes(balance));
          break;
        case BlockType.receive:
          blake..updateBytes(previous)..updateBytes(source);
          break;
        case BlockType.open:
          blake
            ..updateBytes(source)
            ..updateBytes(representative)
            ..updateBytes(account);
          break;
        case BlockType.change:
          blake..updateBytes(previous)..updateBytes(representative);
          break;
        default:
          throw 'Unrecognized type of block';
      }
    }
    return blake.finalBytes();
  }
}
