# Bech32m_i
This is a fork of [gilnobrega/bech32m](https://github.com/gilnobrega/bech32m) to fix bug with convert.

An implementation of the [BIP350 spec] for Segwit Bech32m address format, adapted to work with the Chia Blockchain and other PoST blockchains.

## Exceptions

The specification defines a myriad of cases in which decoding and encoding 
should fail. Please make sure your code catches all the relevant exception 
defined in `lib/exceptions.dart`.

## Installing

Add it to your `pubspec.yaml`:

```
dependencies:
  bech32m_i: any
```

## Licence overview

All files in this repository fall under the license specified in 
[COPYING](COPYING). The project is licensed as [AGPL with a lesser clause](https://www.gnu.org/licenses/agpl-3.0.en.html). 
It may be used within a proprietary project, but the core library and any 
changes to it must be published online. Source code for this library must 
always remain free for everybody to access.

## Thanks

[BIP350 spec]: https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
[BOLT #11 spec]: https://github.com/lightningnetwork/lightning-rfc/blob/master/11-payment-encoding.md
