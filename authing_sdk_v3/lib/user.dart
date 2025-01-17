import 'package:authing_sdk_v3/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  late String id;
  late String phone;
  late String email;
  late String token;
  String? idToken;
  String? mfaToken;
  String? firstTimeLoginToken;
  late String accessToken;
  String? refreshToken;

  late String username;
  late String nickname;
  late String company;
  late String photo;
  late String browser;
  late String device;
  late String name;
  late String givenName;
  late String familyName;
  late String middleName;
  late String profile;
  late String preferredUsername;
  late String website;
  late String gender;
  late String birthdate;
  late String zoneinfo;
  late String locale;
  late String address;
  late String streetAddress;
  late String locality;
  late String region;
  late String postalCode;
  late String city;
  late String province;
  late String country;

  late List customData;

  static User create(Map map, [String? accessToken]) {
    User user = User();
    user.id = map["userId"].toString();
    if (user.id.isEmpty) {
      user.id = map["sub"].toString();
    }
    user.phone = map["phone"].toString();
    user.email = map["email"].toString();

    if (map.containsKey("token")) {
      user.token = map["token"].toString();
    }
    if (map.containsKey("mfaToken")) {
      user.mfaToken = map["mfaToken"].toString();
    }
    if (map.containsKey("access_token")) {
      user.accessToken = map["access_token"].toString();
    } else if (accessToken != null) {
      user.accessToken = accessToken;
    } else {
      user.accessToken = "null";
    }
    if (map.containsKey("id_token")) {
      user.idToken = map["id_token"].toString();
    }
    if (map.containsKey("refresh_token")) {
      user.refreshToken = map["refresh_token"].toString();
    }

    user.username = map["username"].toString();
    user.nickname = map["nickname"].toString();
    user.company = map["company"].toString();
    user.photo = map["photo"].toString();
    user.browser = map["browser"].toString();
    user.device = map["device"].toString();
    user.name = map["name"].toString();
    user.givenName = map["givenName"].toString();
    user.familyName = map["familyName"].toString();
    user.middleName = map["middleName"].toString();
    user.profile = map["profile"].toString();
    user.preferredUsername = map["preferredUsername"].toString();
    user.website = map["website"].toString();
    user.gender = map["gender"].toString();
    user.birthdate = map["birthdate"].toString();
    user.zoneinfo = map["zoneinfo"].toString();
    user.locale = map["locale"].toString();
    user.address = map["address"].toString();
    user.streetAddress = map["streetAddress"].toString();
    user.locality = map["locality"].toString();
    user.region = map["region"].toString();
    user.postalCode = map["postalCode"].toString();
    user.city = map["city"].toString();
    user.province = map["province"].toString();
    user.country = map["country"].toString();
    return user;
  }

  static Future<User> update(User user, Map map) async {
    if (map.containsKey("access_token")) {
      user.accessToken = map["access_token"].toString();
    }
    if (map.containsKey("id_token")) {
      user.idToken = map["id_token"].toString();
    }
    if (map.containsKey("token")) {
      user.token = map["token"].toString();
    }
    if (map.containsKey("refresh_token")) {
      user.refreshToken = map["refresh_token"].toString();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthClient.keyToken, user.accessToken);

    return user;
  }

  setCustomData(List data) {
    customData = data;
  }
}
