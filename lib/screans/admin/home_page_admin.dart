import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/screans/admin/add_event.dart';
import 'package:ez_orgnize/screans/admin/admins.dart';
import 'package:ez_orgnize/screans/admin/events.dart';
import 'package:ez_orgnize/screans/admin/meambres.dart';
import 'package:ez_orgnize/screans/admin/team_leader.dart';
import 'package:ez_orgnize/utils/onesignal_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  Future<void> signOut() async {
    await OneSignalManager.clearNotification();
    await OneSignalManager.removeExternalUserId();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final id = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        leading: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('Users').doc(id).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

            if (!snapshot.hasData || snapshot.data == null) {
              // Handle the case when no data is available
              return Text('No user data available');
            }

            final data = snapshot.data?.data() as Map<String, dynamic>?;

            if (data == null) {
              return Text('No user data available');
            }

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
              title: Text('Admins'),
              leading: Icon(Icons.admin_panel_settings),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Admins(),
                ),
              ),
            ),
            ListTile(
              title: Text('Team leader'),
              leading: Icon(Icons.manage_accounts_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TeamLeader(),
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
            ListTile(
              title: Text('Events'),
              leading: Icon(Icons.event_available_sharp),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Events(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
