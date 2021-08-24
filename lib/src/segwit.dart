import 'dart:convert';

import 'bech32m.dart';
import 'exceptions.dart';

/// An instance of the default implementation of the SegwitCodec
const SegwitCodec segwit = SegwitCodec();

/// A codec which converts a Segwit class to its String representation and vice versa.
class SegwitCodec extends Codec<Segwit, String> {
  const SegwitCodec();

  @override
  SegwitDecoder get decoder => SegwitDecoder();
  @override
  SegwitEncoder get encoder => SegwitEncoder();

  @override
  String encode(Segwit data) {
    return SegwitEncoder().convert(data);
  }

  @override
  Segwit decode(String data) {
    return SegwitDecoder().convert(data);
  }
}

/// This class converts a Segwit class instance to a String.
class SegwitEncoder extends Converter<Segwit, String> with SegwitValidations {
  @override
  String convert(Segwit input) {
    var program = input.program;

    if (isTooShortProgram(program)) {
      throw InvalidProgramLength('too short');
    }

    if (isTooLongProgram(program)) {
      throw InvalidProgramLength('too long');
    }

    var data = _convertBits(program, 8, 5, true);

    return bech32.encode(Bech32m(input.hrp, data));
  }
}

/// This class converts a String to a Segwit class instance.
class SegwitDecoder extends Converter<String, Segwit> with SegwitValidations {
  @override
  Segwit convert(String input) {
    var decoded = bech32.decode(input);

    if (isEmptyProgram(decoded.data)) {
      throw InvalidProgramLength('empty');
    }

    var program = _convertBits(decoded.data, 5, 8, false);

    if (isTooShortProgram(program)) {
      throw InvalidProgramLength('too short');
    }

    if (isTooLongProgram(program)) {
      throw InvalidProgramLength('too long');
    }

    return Segwit(decoded.hrp, program);
  }
}

/// Generic validations for a Segwit class.
class SegwitValidations {
  bool isEmptyProgram(List<int> data) {
    return data.isEmpty;
  }

  bool isTooLongProgram(List<int> program) {
    return program.length > 40;
  }

  bool isTooShortProgram(List<int> program) {
    return program.length < 2;
  }
}

/// A representation of a Segwit Bech32 address. This class can be used to obtain the `scriptPubKey`.
class Segwit {
  Segwit(this.hrp, this.program);

  final String hrp;
  final List<int> program;

  String get scriptPubKey {
    return program
        .map((c) => c.toRadixString(16).padLeft(0, '0'))
        .toList()
        .join('');
  }
}

List<int> _convertBits(List<int> data, int from, int to, bool pad) {
  var acc = 0;
  var bits = 0;
  var result = <int>[];
  var maxv = (1 << to) - 1;

  data.forEach((v) {
    if (v < 0 || (v >> from) != 0) {
      throw Exception();
    }
    acc = (acc << from) | v;
    bits += from;
    while (bits >= to) {
      bits -= to;
      result.add((acc >> bits) & maxv);
    }
  });

  if (pad) {
    if (bits > 0) {
      result.add((acc << (to - bits)) & maxv);
    }
  }
  return result;
}
