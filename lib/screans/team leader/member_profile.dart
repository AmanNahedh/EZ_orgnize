import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberProfile extends StatefulWidget {
  MemberProfile({Key? key, required this.id}) : super(key: key);
  var id;

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('Users').doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
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
              SizedBox(
                height: 1,
              ),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: image.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$firstName $lastName',
                style: GoogleFonts.abhayaLibre().copyWith(fontSize: 50),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.teal),
                        top: BorderSide(color: Colors.teal),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('5'),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('5'), Text('rating')],
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.teal),
                        top: BorderSide(color: Colors.teal),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('5'),
                          Text('events'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
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
