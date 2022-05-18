import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/dialogbox.dart';
import 'package:todo/models/notification.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key, required this.taskRef}) : super(key: key);
  final DocumentReference taskRef;
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late int hours;
  late int minutes;
  late bool timeperiod;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: widget.taskRef.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text('No data'),
          );
        } else {
          final taskSnapshot = snapshot.data;
          TextEditingController titleController =
              TextEditingController(text: taskSnapshot!['title']);
          TextEditingController itemController = TextEditingController();
          return Scaffold(
            appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                ),
                actions: [
                  Button(
                      title: 'Delete Task',
                      content: 'Are you sure you want to delete this task?',
                      onPressed: () {
                        widget.taskRef.delete();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      size: 30),
                  IconButton(
                    onPressed: () => NotificationService().showNotification(
                        1,
                        taskSnapshot['title'],
                        'Task Reminder',
                        DateTime.now().add(const Duration(seconds: 5))),
                    icon: const Icon(Icons.alarm, color: Colors.black),
                  ),
                ],
                backgroundColor: Colors.white10),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                        hintText: 'Enter Title',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle()),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.taskRef.update({'title': value});
                        titleController.text = value;
                      } else {
                        titleController.text = taskSnapshot['title'];
                      }
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: itemController,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                        hintText: 'Enter Item',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    onSubmitted: (value) {
                      widget.taskRef
                          .collection('items')
                          .doc(DateTime.now().toString())
                          .set({
                        'item': value,
                        'timestamp': DateTime.now(),
                        'checkbox': false
                      });
                      itemController.clear();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: widget.taskRef.collection('items').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          final itemSnapshot = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: itemSnapshot[index]['checkbox']
                                      ? Colors.blue
                                      : Colors.black12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                      value: itemSnapshot[index]['checkbox'],
                                      onChanged: (value) {
                                        itemSnapshot[index].reference.update({
                                          'checkbox': value,
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        itemSnapshot[index]['item'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          decoration: itemSnapshot[index]
                                                  ['checkbox']
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DialogBox(
                                                title: 'Delete',
                                                onPressed: () {
                                                  itemSnapshot[index]
                                                      .reference
                                                      .delete();
                                                  Navigator.pop(context);
                                                },
                                              );
                                            });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
