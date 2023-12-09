import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTeamProfile extends StatefulWidget {
  const AdminTeamProfile({Key? key}) : super(key: key);

  @override
  State<AdminTeamProfile> createState() => _AdminTeamProfileState();
}

class _AdminTeamProfileState extends State<AdminTeamProfile> {
  final id = FirebaseAuth.instance.currentUser!.uid;
  var time = '';
  var rat = '';

  void fetchData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .get()
        .then((value) {
      setState(() {
        time = value.data()!['work time'].toString();
        rat = value.data()!['rating'].toString();
      });
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final email = FirebaseAuth.instance.currentUser!.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Users').doc(id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred while fetching user data'),
            );
          }

          final user = UserModel.fromSnapshot(
              snapshot.data!.data() as Map<String, dynamic>);
          final firstName = user.firstName ?? '';
          final lastName = user.lastName ?? '';
          final image = user.image ?? '';

          return Column(
            children: [
              const SizedBox(
                height: 1,
              ),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: image.isEmpty
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '$firstName $lastName',
                style: GoogleFonts.abhayaLibre().copyWith(fontSize: 50),
              ),
              Text(
                '$email',
                style: GoogleFonts.abhayaLibre().copyWith(fontSize: 25),
              ),
            ],
          );
        },
      ),
    );
  }
}
