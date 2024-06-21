mixin EndPoints {
  static const String host = 'https://todo.iraqsapp.com/';
  static const String refreshToken = "auth/refresh-token";
  static const String tasks = "todos/";
  static const String login = "auth/login/";
  static const String register = "auth/register/";
  static const String logout = "auth/logout/";
  static const String profile = "auth/profile/";
  static const String uploadImage = "upload/image";
  static const String images = "images/";
}

// constant for page limit & timeout
mixin AppLimit {
  static const int requestTimeOut = 30000;
}

const String appVersion = '0.0.1';
const String environment = 'Dev'; //Production