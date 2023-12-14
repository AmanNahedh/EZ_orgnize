import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*
 class is designed to handle user-related data
 and interactions with Firebase.
 It encapsulates methods for retrieving user
 information and fetching data for applied members
 */
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
//constructor
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
//method that converts the UserModel object to a Map<String, dynamic>
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
//method is used to create a UserModel object from a Map<String, dynamic>
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
//method retrieves the current user's information
// from Firebase based on the user's UID. It returns a UserModel object
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

//method takes a list of member IDs (appliedMembers)
// and a list of UserModel objects (appliedMembersData).
// It fetches user data for each member ID and populates the list
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
