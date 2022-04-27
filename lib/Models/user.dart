class UserModel {
  late String id;
  late String name;
  late String email;
  UserModel(
      {required this.id, required this.name, required this.email});

  UserModel.fromJson(Map <String, dynamic> map)
  {
    if (map == null) {
      return;
    }
    else {
      id = map['id'];
      name = map['name'];
      email = map['email'];
    }
  }

  toJson()
  {
    return {
      'id':id,
      'name' : name,
      'email' : email,
    };
  }

}