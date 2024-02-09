String errorCodesToMessage(errorCode) {
  String message;

  switch (errorCode) {
    case 'INVALID_LOGIN_OR_PASSWORD':
      message =
          'Invalid login or password. Please enter a correct username and/or password.';
      break;
    case 'INVALID_CREDENTIALS':
      message = 'Invalid credentials.';
      break;
    case 'UNKNOWN_ERROR':
      message =
          'Unknown error. Please try again later or contact administrators.';
      break;
    default:
      message = 'Please try again later.';
  }

  return message;
}
