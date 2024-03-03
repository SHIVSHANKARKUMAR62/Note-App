import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController taskController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String id = " ";
  var key = GlobalKey<FormState>();
  DateTime data = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    getId();
    super.initState();
  }

  getId() {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = firebaseAuth.currentUser!;
    setState(() {
      id = user.uid;
    });
  }

  void logOut() async {
    await firebaseAuth.signOut();
  }

  addTask() async{
    String id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("Task").doc(id).collection("List").doc().set({
      "Task" : taskController.text,
      "NameOfTask" : nameController.text,
      "Date" : dateController.text.trim(),
      "Time" : timeController.text.trim()
    });
  }


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var id = firebaseAuth.currentUser!.email.toString();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Task"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          },
              icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Form(
              key: key,
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    controller: nameController,
                    decoration: const InputDecoration(
                        label: Text("Write Your Task"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Enter Your Task";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: taskController,
                    decoration: const InputDecoration(
                        label: Text("Write Your Task Name"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )
                    ),
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Enter Your Task Name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: w*0.5,
                          child: TextFormField(
                            keyboardType: TextInputType.datetime,
                            controller: dateController,
                            decoration: const InputDecoration(
                                label: Text("Enter Date..."),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                )
                            ),
                            validator: (value) {
                              if(value!.isEmpty){
                                return "Please Enter Date...";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: w*0.1,
                        ),
                        SizedBox(
                          width: w*0.3,
                          child: TextFormField(
                            keyboardType: TextInputType.datetime,
                            controller: timeController,
                            decoration: const InputDecoration(
                                label: Text("Enter Time..."),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                )
                            ),
                            validator: (value) {
                              if(value!.isEmpty){
                                return "Please Enter Time...";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            ElevatedButton(onPressed: (){
              if(key.currentState!.validate()){
                addTask();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Task is added...")));
              }
            }, child: const Text("Add Task")),

          ],
        ),
      ),
    );
  }
}
