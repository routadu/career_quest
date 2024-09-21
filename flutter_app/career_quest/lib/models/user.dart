import 'dart:convert';

class User {
  final String id;
  final String parentId;
  String name;
  int age;
  int phone;
  String email;
  String educationLevel;
  List<String> interests;

  User({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
    required this.educationLevel,
    required this.interests,
  });

  factory User.fromMap(String uid, Map<String, dynamic> data) {
    try {
      return User(
        id: uid,
        parentId: data['parentId'],
        name: data['name'],
        age: data['age'],
        phone: data['phone'],
        email: data['email'],
        educationLevel: data['educationLevel'],
        interests: List.from(data['interests']),
      );
    } catch (e) {
      return User.empty();
    }
  }

  factory User.empty() {
    return User(
      id: "empty",
      parentId: "empty",
      name: "empty",
      age: 0,
      phone: 0,
      email: "",
      educationLevel: "",
      interests: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "parentId": parentId,
      "name": name,
      "age": age,
      "phone": phone,
      "email": email,
      "educationLevel": educationLevel,
      "interests": interests,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

class ParentUser {
  final String id;
  final String childId;
  String name;
  int age;
  int phone;
  String email;

  ParentUser({
    required this.id,
    required this.childId,
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
  });

  factory ParentUser.fromMap(String uid, Map<String, dynamic> data) {
    try {
      return ParentUser(
        id: uid,
        childId: data['childId'],
        name: data['name'],
        age: data['age'],
        phone: data['phone'],
        email: data['email'],
      );
    } catch (e) {
      return ParentUser.empty();
    }
  }

  factory ParentUser.empty() {
    return ParentUser(
      id: "empty",
      childId: "empty",
      name: "empty",
      age: 0,
      phone: 0,
      email: "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "childId": childId,
      "name": name,
      "age": age,
      "phone": phone,
      "email": email,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
