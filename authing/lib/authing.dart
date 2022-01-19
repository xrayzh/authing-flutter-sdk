library authing;

import 'package:http/http.dart' as http;

class Authing {
  static const String VERSION = "0.0.1";

  static String sUserPoolId = "";
  static String sAppId = "";

  static String sHost = "core.authing.cn";
  static String sPublicKey =
      "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4xKeUgQ+Aoz7TLfAfs9+paePb5KIofVthEopwrXFkp8OCeocaTHt9ICjTT2QeJh6cZaDaArfZ873GPUn00eOIZ7Ae+TiA2BKHbCvloW3w5Lnqm70iSsUi5Fmu9/2+68GZRH9L7Mlh8cFksCicW2Y2W2uMGKl64GDcIq3au+aqJQIDAQAB";

  static void init(String userPoolId, String appId) {
    sUserPoolId = userPoolId;
    sAppId = appId;
    http.get(Uri.parse(
        "https://developer-beta.authing.cn/stats/sdk-trace/?appid=" +
            appId +
            "&sdk=flutters&version=" +
            VERSION +
            "&ip=flutter"));
  }

  static void setOnPremiseInfo(String host, String publicKey) {
    sHost = host;
    sPublicKey = publicKey;
  }
}