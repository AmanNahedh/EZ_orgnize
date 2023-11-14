import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:ez_orgnize/screans/admin/member_profile.dart';
import 'package:flutter/material.dart';

class ApplayedMemebers extends StatefulWidget {
  const ApplayedMemebers({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  _ApplayedMemebersState createState() => _ApplayedMemebersState();
}

class _ApplayedMemebersState extends State<ApplayedMemebers> {
  late List<UserModel> allMembers = [];
  late List<UserModel> displayedMembers = [];
  late List<String> appliedMembers = [];

  @override
  void initState() {
    super.initState();
    fetchAppliedMembers();
  }

  Future<void> fetchAppliedMembers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc('male female')
        .collection('Apllaying')
        .doc('Apllaying')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        final List<dynamic>? membersList = data['male'];
        if (membersList != null && membersList is List<dynamic>) {
          appliedMembers = membersList.cast<String>();
        }
      }
    }
    print(appliedMembers.length);
    var a = UserModel();
    await a.fetchAppliedMembersData(appliedMembers, allMembers);
    setState(() {
      displayedMembers = allMembers;
    });
    print(allMembers.length);
  }

  void searchMembers(String query) {
    setState(() {
      displayedMembers = allMembers.where((member) {
        final fullName = '${member.firstName} ${member.lastName}'.toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchMembers,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: displayedMembers.isEmpty
                ? Center(
                    child: Text('No members found'),
                  )
                : ListView.builder(
                    itemCount: displayedMembers.length,
                    itemBuilder: (context, index) {
                      final member = displayedMembers[index];
                      return ListTile(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MemberProfile(
                              id: member.id,
                            ),
                          ),
                        ),
                        title: Text('${member.firstName} ${member.lastName}'),
                        subtitle: Text(member.phoneNumber ?? ''),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            print('done');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
