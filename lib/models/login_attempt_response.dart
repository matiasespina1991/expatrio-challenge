class LoginAttemptResponseModel {
  final bool successful;
  final String message;
  final int statusCode;
  final String? errorCode;

  LoginAttemptResponseModel(
      {required this.successful,
      required this.message,
      required this.statusCode,
      this.errorCode});
}
