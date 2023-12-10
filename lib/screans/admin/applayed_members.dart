import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/Models/event_model.dart';
import 'package:ez_orgnize/Models/usermodeal.dart';
import 'package:ez_orgnize/screans/admin/member_profile.dart';
import 'package:ez_orgnize/utils/onesignal_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplayedMemebers extends StatefulWidget {
  const ApplayedMemebers({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  _ApplayedMemebersState createState() => _ApplayedMemebersState();
}

class _ApplayedMemebersState extends State<ApplayedMemebers> {
  var id = FirebaseAuth.instance.currentUser!.uid;
  late List<UserModel> allMembers = [];
  late List<UserModel> displayedMembers = [];
  late List<String> appliedMembers = [];
  late List<String> accepted = [];
  var counter = 0;

  Future<List<UserModel>> fetchAppliedMembers() async {
    allMembers.clear();
    await fetchAcceptedMembers();
    print(accepted);
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        final List<dynamic>? membersList =
            data['maleAccept'] + data['femaleAccept'];
        if (membersList != null) {
          appliedMembers = membersList.cast<String>();
        }
      }
    }
    if (allMembers.isEmpty) {
      var a = UserModel();
      await a.fetchAppliedMembersData(appliedMembers, allMembers);
      allMembers = allMembers.toSet().toList(); // Remove duplicates
      displayedMembers = allMembers;
    }

    return allMembers;
  }

  void searchMembers(String query) {
    setState(() {
      displayedMembers = allMembers.where((member) {
        final fullName = '${member.firstName} ${member.lastName}'.toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  fetchAcceptedMembers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        final List<dynamic>? membersList = data['Accepted Members'];
        if (membersList != null) {
          accepted = membersList.cast<String>();
        }
      }
    }
  }

  void accept(user) async {
    await fetchAcceptedMembers();
    accepted.add(user);
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .update({'Accepted Members': accepted}).then((value) {
      setState(() {});
      print('updated');
      print(accepted);
    });
    //notfi2a
    List<String> notfi = [];
    notfi.add(user);
    OneSignalManager.sendNotificationToUsers(
        title: "Accept in event",
        content: "you have been chosen in the event",
        targets: notfi);
  }

  void remove(user) async {
    await fetchAcceptedMembers();
    accepted.remove(user);
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .update({'Accepted Members': accepted}).then((value) {
      setState(() {});
      print('updated');
      print(accepted);
    });
  }

  @override
  void initState() {
    fetchAppliedMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Members'),
            Text('${widget.event.eventName} event'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchMembers,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: fetchAppliedMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No members found'),
                  );
                } else {
                  final filteredMembers = displayedMembers;
                  final acceptedMembers = filteredMembers
                      .where(
                          (member) => accepted.contains(member.id.toString()))
                      .toList();
                  final pendingMembers = filteredMembers
                      .where(
                          (member) => !accepted.contains(member.id.toString()))
                      .toList();

                  return ListView.builder(
                    itemCount: acceptedMembers.length + pendingMembers.length,
                    itemBuilder: (context, index) {
                      if (index < acceptedMembers.length) {
                        final member = acceptedMembers[index];
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green[400],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MemberProfile(
                                  id: member.id,
                                ),
                              ),
                            ),
                            title:
                                Text('${member.firstName} ${member.lastName}'),
                            subtitle: Text(member.phoneNumber ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => remove(member.id),
                            ),
                          ),
                        );
                      } else {
                        final member =
                            pendingMembers[index - acceptedMembers.length];
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MemberProfile(
                                  id: member.id,
                                ),
                              ),
                            ),
                            title:
                                Text('${member.firstName} ${member.lastName}'),
                            subtitle: Text(member.phoneNumber ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => accept(member.id),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
