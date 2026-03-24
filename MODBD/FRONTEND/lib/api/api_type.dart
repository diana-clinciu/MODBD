const _devBaseUrl = "http://localhost:8000";

enum ApiType {
  dev(_devBaseUrl);

  const ApiType(this.baseUrl);

  final String baseUrl;
}

const ApiType selectedApiType = ApiType.dev;
