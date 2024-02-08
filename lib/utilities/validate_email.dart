bool isEmailValid(String email) {
  final emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );
  return emailRegExp.hasMatch(email);
}
