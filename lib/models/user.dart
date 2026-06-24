/// The signed-in user, as returned by `POST /auth/login`.
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.roles = const <String>[],
  });

  final String id;
  final String name;
  final String email;
  final List<String> roles;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      roles: (json['roles'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'roles': roles,
  };
}
