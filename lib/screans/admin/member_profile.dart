import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/Models/usermodeal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberProfile extends StatefulWidget {
  MemberProfile({Key? key, required this.id}) : super(key: key);
  var id;

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  var time = '';
  var rat = '';

  void fetchData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.id)
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('Users').doc(widget.id).get(),
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$time'),
                          Text(
                            'work hour',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(rat), Text('rating')],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
                endIndent: 40,
                indent: 40,
                color: Colors.teal[100],
              ),
            ],
          );
        },
      ),
    );
  }
}
