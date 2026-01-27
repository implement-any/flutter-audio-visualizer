enum AppEnvironment { dev, prod }

class CommonUrl {
  static const dev = "http://10.0.2.2:8080";
  static const prod = "https://port-0-ffmpeg-spectrum-mkcr19bk78d45000.sel3.cloudtype.app";
}

class Environment {
  static const bool _isProd = bool.fromEnvironment('dart.vm.product');

  static const String baseUrl = _isProd
      ? CommonUrl.prod
      : CommonUrl.dev;
}
