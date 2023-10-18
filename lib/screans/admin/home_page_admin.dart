import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/screans/admin/add_event.dart';
import 'package:ez_orgnize/screans/admin/meambres.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final id = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        leading: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('Users').doc(id).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Text('Error occurred while fetching user data');
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final firstName = data['FirstName'] ?? '';
            final secondName = data['LastName'] ?? '';
            final image = data['url'];

            return Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
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
                SizedBox(
                  width: 10,
                ),
                Text('$firstName $secondName'),
              ],
            );
          },
        ),
        leadingWidth: MediaQuery.of(context).size.width / 2,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: Text('Members'),
              leading: Icon(Icons.person),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Meambers(),
                ),
              ),
            ),
            ListTile(
              title: Text('Add event'),
              leading: Icon(Icons.event),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddEventPage(),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
