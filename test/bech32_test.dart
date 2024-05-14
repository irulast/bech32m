import 'package:bech32m_i/bech32m_i.dart';
import 'package:test/test.dart';

// tests cribbed from https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki#test-vectors-for-bech32m
void main() {
  group('bech32m with', () {
    group('valid test vectors from specification', () {
      [
        'A1LQFN3A',
        'a1lqfn3a',
        'an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11sg7hg6',
        'abcdef1l7aum6echk45nj3s0wdvt2fg8x9yrzpqzd3ryx',
        '11llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllludsr8',
        'split1checkupstagehandshakeupstreamerranterredcaperredlc445v',
        '?1v759aa',
      ]
        ..forEach((vec) {
          test('decode static vector: $vec', () {
            expect(bech32.decode(vec), isNotNull);
          });
        })
        ..forEach((vec) {
          test('decode then encode static vector: $vec', () {
            expect(bech32.encode(bech32.decode(vec)), vec.toLowerCase());
          });
        });
    });

    group('invalid test vectors from specification having', () {
      test('hrp character out of range (space char)', () {
        expect(() => bech32.decode('\x20' '1nwldj5'),
            throwsA(TypeMatcher<OutOfRangeHrpCharacters>()));
      });

      test('hrp character out of range (delete char)', () {
        expect(() => bech32.decode('\x7F' '1axkwrx'),
            throwsA(TypeMatcher<OutOfRangeHrpCharacters>()));
      });

      test('hrp character out of range (control char)', () {
        expect(() => bech32.decode('\x80' '1eym55h'),
            throwsA(TypeMatcher<OutOfRangeHrpCharacters>()));
      });

      test('too long overall', () {
        expect(
            () => bech32.decode(
                'an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4'),
            throwsA(TypeMatcher<TooLong>()));
      });

      test('no separator', () {
        expect(() => bech32.decode('qyrz8wqd2c9m'),
            throwsA(TypeMatcher<InvalidSeparator>()));
      });

      test('empty hpr', () {
        expect(() => bech32.decode('1qyrz8wqd2c9m'),
            throwsA(TypeMatcher<TooShortHrp>()));
      });

      test('invalid data character, case one', () {
        expect(() => bech32.decode('y1b0jsk6g'),
            throwsA(TypeMatcher<OutOfBoundChars>()));
      });

      test('invalid data character, case two', () {
        expect(() => bech32.decode('lt1igcx5c0'),
            throwsA(TypeMatcher<OutOfBoundChars>()));
      });

      test('too short checksum', () {
        expect(() => bech32.decode('in1muywd'),
            throwsA(TypeMatcher<TooShortChecksum>()));
      });

      test('invalid checksum character, case one', () {
        expect(() => bech32.decode('mm1crxm3i' '\xFF'),
            throwsA(TypeMatcher<OutOfBoundChars>()));
      });

      test('invalid checksum character, case two', () {
        expect(() => bech32.decode('au1s5cgom' '\xFF'),
            throwsA(TypeMatcher<OutOfBoundChars>()));
      });

      test('checksum calculated from upper case hpr', () {
        expect(() => bech32.decode('M1VUXWEZ'),
            throwsA(TypeMatcher<InvalidChecksum>()));
      });

      test('empty hpr, case one', () {
        expect(() => bech32.decode('16plkw9'),
            throwsA(TypeMatcher<TooShortHrp>()));
      });

      test('empty hpr, case two', () {
        expect(() => bech32.decode('1p2gdwpf'),
            throwsA(TypeMatcher<TooShortHrp>()));
      });
    });

    group('length override', () {
      test('valid maxLength parameter', () {
        var str =
            'lnbc1pvjluezpp5qqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqypqdpl2pkx2ctnv5sxxmmwwd5kgetjypeh2ursdae8g6twvus8g6rfwvs8qun0dfjkxaq8rkx3yf5tcsyz3d73gafnh3cax9rn449d9p5uxz9ezhhypd0elx87sjle52x86fux2ypatgddc6k63n7erqz25le42c4u4ecky03ylcqca784w';
        expect(() => bech32.decode(str, str.length + 5), isNotNull);
      });

      test('invalid maxLength parameter', () {
        var str =
            'lnbc1pvjluezpp5qqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqypqdpl2pkx2ctnv5sxxmmwwd5kgetjypeh2ursdae8g6twvus8g6rfwvs8qun0dfjkxaq8rkx3yf5tcsyz3d73gafnh3cax9rn449d9p5uxz9ezhhypd0elx87sjle52x86fux2ypatgddc6k63n7erqz25le42c4u4ecky03ylcqca784w';
        expect(() => bech32.decode(str, str.length - 5),
            throwsA(TypeMatcher<TooLong>()));
      });
    });
  });
}
