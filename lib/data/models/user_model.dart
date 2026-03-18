
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.phone,
    required super.website,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:       json['id'] as int,
    name:     json['name'] as String,
    username: json['username'] as String,
    email:    json['email'] as String,
    phone:    json['phone'] as String,
    website:  json['website'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id':       id,
    'name':     name,
    'username': username,
    'email':    email,
    'phone':    phone,
    'website':  website,
  };
}