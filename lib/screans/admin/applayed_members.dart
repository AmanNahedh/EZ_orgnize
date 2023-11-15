import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_orgnize/modeals/event_model.dart';
import 'package:ez_orgnize/modeals/usermodeal.dart';
import 'package:ez_orgnize/screans/admin/member_profile.dart';
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
  late List<dynamic> accepted = [];
  var counter = 0;

  @override
  void initState() {
    super.initState();
    fetchAppliedMembers();
  }

  Future<void> fetchAppliedMembers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        final List<dynamic>? membersList =
            data['maleAccept'] + data['femaleAccept'];
        if (membersList != null && membersList is List<dynamic>) {
          appliedMembers = membersList.cast<String>();
        }
      }
    }

    var a = UserModel();
    await a.fetchAppliedMembersData(appliedMembers, allMembers);
    setState(() {
      displayedMembers = allMembers;
    });
  }

  void searchMembers(String query) {
    setState(() {
      displayedMembers = allMembers.where((member) {
        final fullName = '${member.firstName} ${member.lastName}'.toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  void getCounterAndAccept() async {
    var doc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .get();
    var data = doc.data();
    counter = await data!['counter'];
    accepted = await data!['maleAccept'];
    print('$counter counter');
    print('${accepted.length} length');
  }

  void accept() async {
    getCounterAndAccept();
    accepted.add(id);
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.eventName)
        .update({'maleAccept': accepted}).then((value) {
      print('updated');
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
                          onPressed: () => accept(),
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
