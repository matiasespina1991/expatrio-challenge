class UserAuthDataModel {
  final String accessToken;
  final DateTime accessTokenExpiresAt;
  final int maxAgeSeconds;
  final UserAuthInfo userInfo;
  final String userId;
  final String userRole;
  final bool xpm;

  UserAuthDataModel({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.maxAgeSeconds,
    required this.userInfo,
    required this.userId,
    required this.userRole,
    required this.xpm,
  });

  factory UserAuthDataModel.fromJson(Map<String, dynamic> json) {
    return UserAuthDataModel(
      accessToken: json['accessToken'],
      accessTokenExpiresAt: DateTime.parse(json['accessTokenExpiresAt']),
      maxAgeSeconds: json['maxAgeSeconds'],
      userInfo: UserAuthInfo.fromJson(
          json['userInfo'] ?? json['subject']), // Adaptado para compatibilidad
      userId: json['userId'].toString(),
      userRole: json['userRole'],
      xpm: json['xpm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'accessTokenExpiresAt': accessTokenExpiresAt.toIso8601String(),
      'maxAgeSeconds': maxAgeSeconds,
      'userInfo': userInfo.toJson(),
      'userId': userId,
      'userRole': userRole,
      'xpm': xpm,
    };
  }
}

class UserAuthInfo {
  final List<String> consoleRoles;
  final bool isAdmin;
  final String role;
  final String userId;
  final String userUuid;
  final String email;
  final String firstName;
  final String fullName;
  final String lastName;

  UserAuthInfo({
    required this.consoleRoles,
    required this.isAdmin,
    required this.role,
    required this.userId,
    required this.userUuid,
    required this.email,
    required this.firstName,
    required this.fullName,
    required this.lastName,
  });

  factory UserAuthInfo.fromJson(Map<String, dynamic> json) {
    return UserAuthInfo(
      consoleRoles: List<String>.from(json['consoleRoles']),
      isAdmin: json['isAdmin'],
      role: json['role'],
      userId: json['userId'].toString(),
      userUuid: json['userUuid'],
      email: json['email'],
      firstName: json['firstName'],
      fullName: json['fullName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consoleRoles': consoleRoles,
      'isAdmin': isAdmin,
      'role': role,
      'userId': userId,
      'userUuid': userUuid,
      'email': email,
      'firstName': firstName,
      'fullName': fullName,
      'lastName': lastName,
    };
  }
}
