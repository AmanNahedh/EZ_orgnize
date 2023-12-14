import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/screans/admin/add_event.dart';
import 'package:ez_orgnize/screans/admin/admins.dart';
import 'package:ez_orgnize/screans/admin/events.dart';
import 'package:ez_orgnize/screans/admin/meambres.dart';
import 'package:ez_orgnize/screans/admin/team_leader.dart';
import 'package:ez_orgnize/utils/onesignal_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
/*
 provides a navigation menu for the admin user with options to view and manage
  members, admins, team leaders, add events, and view existing events
 */
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
              return const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Text('Error occurred while fetching user data');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              // Handle the case when no data is available
              return const Text('No user data available');
            }

            final data = snapshot.data?.data() as Map<String, dynamic>?;

            if (data == null) {
              return const Text('No user data available');
            }

            final firstName = data['FirstName'] ?? '';
            final secondName = data['LastName'] ?? '';
            final image = data['url'];
            return Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
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
                const SizedBox(
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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: const Text('Members'),
              leading: const Icon(Icons.person),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Meambers(),
                ),
              ),
            ),
            ListTile(
              title: const Text('Admins'),
              leading: const Icon(Icons.admin_panel_settings),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Admins(),
                ),
              ),
            ),
            ListTile(
              title: const Text('Team leader'),
              leading: const Icon(Icons.manage_accounts_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TeamLeader(),
                ),
              ),
            ),
            ListTile(
              title: const Text('Add event'),
              leading: const Icon(Icons.event),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddEventPage(),
              )),
            ),
            ListTile(
              title: const Text('Events'),
              leading: const Icon(Icons.event_available_sharp),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Events(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
