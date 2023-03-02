import 'package:flutter/material.dart';

const String baseURL = 'http://coldt.remaat.com';
// const String auth =
//     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiZTIxMjc4MWIxZjBiZTBhZWVjYjI2ZTc1ZDY0MDg2ZmExM2U4NDExNmJlOTcxYTUwOGU3NzY2ZWQyNjU5ZWNkZWM3MmZmN2ZlNjE2MzNiMzUiLCJpYXQiOjE2NDg0OTAwMTAuOTU2MDM4LCJuYmYiOjE2NDg0OTAwMTAuOTU2MDQxLCJleHAiOjE2ODAwMjYwMTAuOTUyNDQzLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.L9s1aYp3ogxsFtBdeUkL7cJDte1qz2HuavVQLtcOPkE1FiHVWm2THRjvkD9zvGlbxFF8oFKJnSxqpWr6rgw49yKPGL9CGFBSC0U34MWKAmfCaNGTp9joih0dluHeykV_8HSiRbGfsLdnBy63yf90LvXuqBnTyFcdDLAwqK0Jpa50aBOWU_WC4QiZEUFpW0e_axCdiGGhrtx6jFSg3C2IF-wFW53BqAWVx-DHgqvHCEGw2lt1TrROgiEeo13gxQd0s9FZ16fU7U1Jw3nFjxe-J9mxQpSxDCdDr-V3DUdrbg7ojQLOHIG-0f8_LACqo52DGe9UE04GS1jOPZ746pPKCICUaTBpM3tXS51EdbAJ5gSZYcAyeNVdNlalddra2YeShD6Lu1bmSLcqjlTApDoN_h7w4RWyaLz_lxlX60IsVvVsM1OogvAWuRcasIYJhaI7eUQriAs6jz0VF3u8oJhg1f49HhWo4mGCJT9yug_9mkb4j85nVCUfh31ztUbeiDLkNW_lHRI77RIuAjQ5O6FXhJe2AVdT6kI9glMQOXpw0xBPXyQXpkxeI_9DvsX1oQWaPtsyNTuJXH2Cgn5w9tP-td4kHIgJHKfTz-6Ljf5a4cKBl9cs1hebEVqXbrSatKudi0bSyMIEoYezJnwBe8qPhvrCWAF0TflA1xY5xovS1Fs';

const Map<String, String> requestHeaders = {
  'Accept': 'application/json',
  'Content-type': 'application/json',
  // 'Authorization': 'Bearer $auth'
};

errorSnaokBar(BuildContext context, String str, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(str),
    duration: const Duration(seconds: 3),
    backgroundColor: color,
  ));
}
