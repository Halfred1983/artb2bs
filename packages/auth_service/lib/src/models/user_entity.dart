import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
   const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
   required this.creationDate,
   required this.lastSignIn,
});

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final String creationDate;
  final String lastSignIn;


  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['id'] ?? "",
        firstName: json['firstName'] ?? "",
        lastName: json['lastName'] ?? "",
        email: json['email'] ?? "",
        imageUrl: json['imageUrl'] ?? "",
      creationDate: json['createionDate'] ?? "",
      lastSignIn:  json['lastSignIn'] ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'imageUrl': imageUrl,
        'lastSignIn': lastSignIn,
        'creationDate': creationDate,
      };
  factory UserEntity.empty() => const UserEntity(
        id: "",
        firstName: "",
        lastName: "",
        email: "",
        imageUrl: "",
        lastSignIn: "",
        creationDate: "",
      );
  @override
  List<Object?> get props => [id, firstName, lastName, email, imageUrl];


}
