import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? tallCont;
  final String? weightCont;
  final String? nationality;
  final String? phoneNumber;
  final String? validity;
  final String? image;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.tallCont,
    this.weightCont,
    this.nationality,
    this.phoneNumber,
    this.validity,
    this.image,
  });

  Map<String, dynamic> toJson([DocumentSnapshot<Map<String, dynamic>>? user]) {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "tallCont": tallCont,
      "weightCont": weightCont,
      "nationality": nationality,
      "phoneNumber": phoneNumber,
      "validity": validity,
      "image": image,
      "id" : id,
    };
  }

  factory UserModel.fromSnapshot(Map<String, dynamic> snapshot) {
    return UserModel(
      firstName: snapshot['FirstName'],
      lastName: snapshot['LastName'],
      tallCont: snapshot['allCont'],
      weightCont: snapshot['weightCont'],
      nationality: snapshot['Nationality'],
      phoneNumber: snapshot['PhoneNumber'],
      validity: snapshot['validity'],
      image: snapshot['url'],
      id: snapshot['id'],
    );
  }
}