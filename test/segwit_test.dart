import 'package:bech32m_i/bech32m_i.dart';
import 'package:test/test.dart';

// tests cribbed from https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki#test-vectors-for-v0-v16-native-segregated-witness-addresses
void main() {
  // group('segwit with', () {
  //   group('valid test vectors from specification', () {
  //     [
  //       [
  //         'BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4',
  //         '0014751e76e8199196d454941c45d1b3a323f1433bd6'
  //       ],
  //       [
  //         'tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7',
  //         '00201863143c14c5166804bd19203356da136c985678cd4d27a1b8c6329604903262'
  //       ],
  //       [
  //         'bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y',
  //         '5128751e76e8199196d454941c45d1b3a323f1433bd6751e76e8199196d454941c45d1b3a323f1433bd6'
  //       ],
  //       ['BC1SW50QGDZ25J', '6002751e'],
  //       [
  //         'bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs',
  //         '5210751e76e8199196d454941c45d1b3a323'
  //       ],
  //       [
  //         'tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy',
  //         '0020000000c4a5cad46221b2a187905e5266362b99d5e91c6ce24d165dab93e86433'
  //       ],
  //       [
  //         'tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c',
  //         '5120000000c4a5cad46221b2a187905e5266362b99d5e91c6ce24d165dab93e86433'
  //       ],
  //       [
  //         'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0',
  //         '512079be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798'
  //       ],
  //     ]
  //       ..forEach((tuple) {
  //         test('convert to correct scriptPubkey: ${tuple[0]}', () {
  //           // print(segwit.decode(tuple[0]).scriptPubKey);
  //           expect(segwit.decode(tuple[0]).scriptPubKey, tuple[1]);
  //         });
  //       })
  //       ..forEach((tuple) {
  //         test('decode then encode static vector: $tuple', () {
  //           expect(
  //               segwit.encode(segwit.decode(tuple[0])), tuple[0].toLowerCase());
  //         });
  //       });
  //   });
  // });

  group('invalid test vectors from specification having', () {
    // test('invalid human-readable part', () {
    //   expect(
    //       () => segwit.decode(
    //           'tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut'),
    //       throwsA(TypeMatcher<InvalidHrp>()));
    // });

    group('invalid checksum', () {
      var addresses = [
        'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd',
        'tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf',
        'BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL',
      ];

      // ignore: cascade_invocations
      addresses.forEach((address) {
        test('bech32 instead of bech32m for $address', () {
          expect(() => segwit.decode(address),
              throwsA(TypeMatcher<InvalidChecksum>()));
        });
      });
    });

    // test('invalid witness version', () {
    //   expect(
    //       () => segwit.decode(
    //           'BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R'),
    //       throwsA(TypeMatcher<InvalidWitnessVersion>()));
    // });

    test('invalid program length (too short)', () {
      expect(() => segwit.decode('bc1pw5dgrnzv'),
          throwsA(TypeMatcher<InvalidProgramLength>()));
    });

    test('invalid program length (too long)', () {
      expect(
          () => segwit.decode(
              'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav'),
          throwsA(TypeMatcher<InvalidProgramLength>()));
    });

    // test('invalid program length (for witness version 0)', () {
    //   expect(() => segwit.decode('BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P'),
    //       throwsA(TypeMatcher<InvalidProgramLength>()));
    // });

    test('mixed case', () {
      expect(
          () => segwit.decode(
              'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq'),
          throwsA(TypeMatcher<MixedCase>()));
    });

    // test('zero padding of more than 4 bytes', () {
    //   expect(() => segwit.decode('bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf'),
    //       throwsA(TypeMatcher<InvalidPadding>()));
    // });

    // test('non zero padding in 8-to-5 conversion', () {
    //   expect(() => segwit.decode('tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j'),
    //       throwsA(TypeMatcher<InvalidPadding>()));
    // });

    //   test('empty data', () {
    //     expect(() => segwit.decode('bc1gmk9yu'),
    //         throwsA(TypeMatcher<InvalidProgramLength>()));
    //   });
    });
}
