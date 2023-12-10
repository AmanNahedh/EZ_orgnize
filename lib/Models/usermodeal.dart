import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? gender;
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
    this.gender,
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
      "gender": gender,
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
      gender: snapshot['gender'],
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

//
  Future<List<UserModel>> fetchAppliedMembersData(
      List<String> appliedMembers, List<UserModel> appliedMembersData) async {
    try {
      final CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('Users');

      for (final memberId in appliedMembers) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await usersCollection.doc(memberId).get();

        if (snapshot.exists) {
          final Map<String, dynamic> userData = snapshot.data()!;
          final UserModel user = UserModel.fromSnapshot(userData);
          appliedMembersData.add(user);
        }
      }

      return appliedMembersData;
    } catch (e) {
      print('Error fetching applied members data: $e');
      return [];
    }
  }
}
