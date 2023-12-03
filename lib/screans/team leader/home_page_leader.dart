import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/screans/team%20leader/events_leader.dart';
import 'package:ez_orgnize/utils/onesignal_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageLeader extends StatelessWidget {
  const HomePageLeader({Key? key}) : super(key: key);

  Future<void> signOut() async{
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
              title: const Text('Events'),
              leading: const Icon(Icons.event_available_sharp),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EventsLeader(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
