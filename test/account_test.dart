import 'package:nanocurrency/wallet.dart';
import "package:test/test.dart";
import "package:hex/hex.dart";

void main() {
  test("Account with keys from seed generated correctly", () {
    /*"seed": "BBA067329F44D8011BD6E15F43366A81307FBD8A4801A6997B354AD302F4BC72",
    "index": 0,
    "secretKey": "19622D20FBC8AAA9E45CF016FAC7EF7D85908EE898A670B4D6A2C8AA272828D0",
    "publicKey": "9795E63D9242D8C6E00FA5D95587B2E5262B1E15001A24D2F6D803DE577A0574",
    "account": "xrb_37wowrys6iprrui1zbgscp5u7sb87eh3c11t6mbhfp15usdqn3dn3sfp714g"*/

    var wallet = Wallet.fromHexSeed(
        'BBA067329F44D8011BD6E15F43366A81307FBD8A4801A6997B354AD302F4BC72');
    wallet.defaultPrefix = 'xrb_';
    var account = wallet.newAccount();
    expect(
        HEX.encode(account.secretKey).toUpperCase(),
        equals(
            '19622D20FBC8AAA9E45CF016FAC7EF7D85908EE898A670B4D6A2C8AA272828D0'));
    expect(
        HEX.encode(account.publicKey).toUpperCase(),
        equals(
            '9795E63D9242D8C6E00FA5D95587B2E5262B1E15001A24D2F6D803DE577A0574'));
    expect(
        account.identifier,
        equals(
            "xrb_37wowrys6iprrui1zbgscp5u7sb87eh3c11t6mbhfp15usdqn3dn3sfp714g"));
  });
}
