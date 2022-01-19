import 'authing.dart';
import 'util.dart';
import 'user.dart';
import 'result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthClient {

  static User? currentUser;

  static Future<AuthResult> registerByEmail(
      String email, String password) async {
    var body = jsonEncode({'email': email, 'password': Util.encrypt(password)});
    final Result result = await post('/api/v2/register/email', body);
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = User.create(result.data);
    }
    return authResult;
  }

  static Future<AuthResult> registerByUserName(
      String username, String password) async {
    var body = jsonEncode({'username': username, 'password': Util.encrypt(password)});
    final Result result = await post('/api/v2/register/username', body);
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = User.create(result.data);
    }
    return authResult;
  }

  static Future<AuthResult> registerByPhoneCode(
      String phone, String code, String password) async {
    var body = jsonEncode({'phone': phone, 'code': code, 'password': Util.encrypt(password)});
    final Result result = await post('/api/v2/register/phone-code', body);
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = User.create(result.data);
    }
    return authResult;
  }

  static Future<AuthResult> loginByAccount(
      String account, String password) async {
    var body = jsonEncode({'account': account, 'password': Util.encrypt(password)});
    final Result result = await post('/api/v2/login/account', body);
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = createUser(result);
    }
    return authResult;
  }

  static Future<AuthResult> loginByPhoneCode(
      String phone, String code) async {
    var body = jsonEncode({'phone': phone, 'code': code});
    final Result result = await post('/api/v2/login/phone-code', body);
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = createUser(result);
    }
    return authResult;
  }

  static Future<AuthResult> loginByLDAP(
      String username, String password) async {
    var body = jsonEncode({'username': username, 'password': Util.encrypt(password)});
    final Result result = await post('/api/v2/login/ldap', body);
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = createUser(result);
    }
    return authResult;
  }

  static Future<AuthResult> loginByAD(
      String username, String password) async {
    var body = jsonEncode({'username': username, 'password': Util.encrypt(password)});
    final Result result = await post('/api/v2/login/ad', body);
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = createUser(result);
    }
    return authResult;
  }

  static Future<AuthResult> getCurrentUser() async {
    final Result result = await get('/api/v2/users/me');
    AuthResult authResult = AuthResult(result);
    if (result.code == 200) {
      authResult.user = User.create(result.data);
    }
    return authResult;
  }

  static Future<AuthResult> logout() async {
    final Result result = await get('/api/v2/logout?app_id=' + Authing.sAppId);
    currentUser = null;
    return AuthResult(result);
  }

  static Future<AuthResult> sendSms(String phone) async {
    final Result result = await post('/api/v2/sms/send', jsonEncode({'phone': phone}));
    return AuthResult(result);
  }

  static Future<AuthResult> sendEmail(String email, String scene) async {
    var body = jsonEncode({'email': email, 'scene': scene});
    final Result result = await post('/api/v2/email/send', body);
    return AuthResult(result);
  }

  static User createUser(Result result) {
    currentUser = User.create(result.data);
    return currentUser!;
  }

  static Future<Result> get(String endpoint) {
    return request("get", endpoint, null);
  }

  static Future<Result> post(String endpoint, String body) {
    return request("post", endpoint, body);
  }

  static Future<Result> request(
      String method, String endpoint, String? body) async {
    var url = Uri.parse('https://' + Authing.sHost + endpoint);
    Map<String, String> headers = {
      "x-authing-userpool-id": Authing.sUserPoolId,
      "x-authing-app-id": Authing.sAppId,
      "x-authing-request-from": "SDK@Flutter@" + Authing.VERSION,
      "content-type": "application/json"
    };
    if (currentUser != null) {
      headers.putIfAbsent("Authorization", () => "Bearer " + currentUser!.token);
    }
    var response = method.toLowerCase() == "get" ? await http.get(url, headers: headers) : await http.post(url, headers: headers, body: body);
    Result result = Result();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map parsed = jsonDecode(response.body);
      if (parsed.containsKey("code")) {
        result.code = parsed["code"] as int;
      } else {
        result.code = 200;
      }
      if (parsed.containsKey("message")) {
        result.message = parsed["message"] as String;
      }
      if (parsed.containsKey("data")) {
        result.data = parsed["data"];
      } else {
        result.data = parsed;
      }
    } else {
      result.code = response.statusCode;
      result.message = "network error";
    }
    return result;
  }
}