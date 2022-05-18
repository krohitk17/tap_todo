import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/dialogbox.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/components/logo.dart';
import 'package:todo/routes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  late String uid;
  bool loading = false;

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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ModalProgressHUD(
        inAsyncCall: loading,
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 40,
                    )),
              ),
              const AppName(
                size: 30,
                iconsize: 10,
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  _auth.currentUser?.email ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.blue,
                    size: 30,
                  ),
                  title: const Text('Logout', style: TextStyle(fontSize: 25)),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return DialogBox(
                        title: 'Logout',
                        content: 'Are you sure you want to logout?',
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          Navigator.of(context).pop();
                          await _auth.signOut();
                          setState(() {
                            loading = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  title: const Text('Delete Account',
                      style: TextStyle(fontSize: 25)),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return DialogBox(
                        title: 'Delete Account',
                        content:
                            'Are you sure you want to delete your account?',
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          Navigator.of(context).pop();
                          await FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(uid)
                              .delete();
                          await _auth.currentUser?.delete();
                          setState(() {
                            loading = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Tap ToDo', style: TextStyle(fontSize: 25)),
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      splashColor: Colors.blue,
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
                                  child: Text(
                                      DateFormat('hh:mm a    dd-MM-yyyy')
                                          .format((docs[index]['timestamp']
                                                  as Timestamp)
                                              .toDate())),
                                ),
                              ],
                            ),
                            Button(
                              onPressed: () {
                                docs[index].reference.delete();
                                Navigator.pop(context);
                              },
                              title: 'Delete Task',
                              content:
                                  'Are you sure you want to delete this task?',
                              size: 35,
                            ),
                          ],
                        ),
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
              if (snapshot['title'] == '') {
                task.delete();
              }
            });
          }),
    );
  }
}
