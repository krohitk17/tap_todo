import 'package:flutter/material.dart';
import 'package:todo/components/deleteicon.dart';
import 'package:todo/components/dialogbox.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/routes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  late String uid;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          uid = user.uid;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return DialogBox(
                      title: 'Logout',
                      onPressed: () {
                        _auth.signOut();
                        Navigator.pop(context);
                      },
                    );
                  });
            }),
        title: const Text('Tap ToDo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('tasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.taskscreen,
                          arguments: docs[index].reference);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(
                                  docs[index]['title'],
                                  style: const TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(DateFormat('hh:mm a    dd-MM-yyyy')
                                    .format(
                                        (docs[index]['timestamp'] as Timestamp)
                                            .toDate())),
                              ),
                            ],
                          ),
                          DeleteIcon(
                            onPressed: () {
                              docs[index].reference.delete();
                              Navigator.pop(context);
                            },
                            title: 'Delete Task',
                            size: 35,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            var task = FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('tasks')
                .doc(DateTime.now().toString());
            await task.set({'title': '', 'timestamp': DateTime.now()});
            Navigator.pushNamed(context, RouteNames.taskscreen, arguments: task)
                .then((value) async {
              final snapshot = await task.get();
              print(snapshot.data());
              if (snapshot['title'] == '') {
                task.delete();
                print('deleted');
              }
            });
          }),
    );
  }
}
