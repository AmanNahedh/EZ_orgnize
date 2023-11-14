import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "tallCont": tallCont,
      "weightCont": weightCont,
      "nationality": nationality,
      "phoneNumber": phoneNumber,
      "validity": validity,
      "image": image,
      "id": id,
    };
  }

  factory UserModel.fromSnapshot(Map<String, dynamic> snapshot) {
    return UserModel(
      firstName: snapshot['FirstName'],
      lastName: snapshot['LastName'],
      tallCont: snapshot['tallCont'],
      weightCont: snapshot['weightCont'],
      nationality: snapshot['Nationality'],
      phoneNumber: snapshot['PhoneNumber'],
      validity: snapshot['Validity'],
      image: snapshot['url'],
      id: snapshot['id'],
    );
  }

  Future<UserModel?> getCurrentUserInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        UserModel currentUser = UserModel.fromSnapshot(userData);
        print('Inside getCurrentUserInfo');
        print(currentUser.firstName);
        return currentUser;
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      print('Error retrieving current user info: $e');
      return null;
    }
  }
}
