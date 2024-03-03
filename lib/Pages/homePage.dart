import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/Pages/first.dart';
import 'package:noteapp/Widget/container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id = " ";

  // MenuButtonWidget menuButtonWidget = MenuButtonWidget();

  @override
  void initState() {
    // TODO: implement initState
    getId();
    super.initState();
  }

  getId() {
    setState(() {
      id = FirebaseAuth.instance.currentUser!.uid;
    });
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    //var id = firebaseAuth.currentUser!.email.toString();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [

          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuButton(),));
          }, icon: const Icon(Icons.menu)),
          // IconButton(
          //     onPressed: () {
          //       logOut();
          //       // Navigator.popUntil(context, (route) => route.isFirst);
          //       // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
          //       // Navigator.pushAndRemoveUntil(
          //       //     context,
          //       //     MaterialPageRoute(
          //       //       builder: (context) => const LoginPage(),
          //       //     ),
          //       //     (route) => route.isCurrent);
          //       Navigator.popUntil(context, (route) => route.isFirst);
          //       Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const LoginPageSecond(),
          //           ));
          //     },
          //     icon: const Icon(Icons.logout)),
        ],
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: w * 0.008, top: h * 0.04),
              child: Container(
                height: h * 0.3,
                width: w * 0.7,
                decoration: const BoxDecoration(color: Colors.red,
                ),
              )),
          SizedBox(
            height: h * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(("Note List"), style: TextStyle(fontSize: w * 0.06)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FirstScreen(),
                          ));
                    },
                    icon: const Icon(Icons.add),
                    style: ButtonStyle(
                        iconSize: MaterialStatePropertyAll(w * 0.1))),
              ],
            ),
          ),
          SizedBox(
            height: h * 0.01,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Task")
                .doc(id)
                .collection("List")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 8.0,left: 8.0),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Task"),
                                Text(snapshot.data!.docs[index]["NameOfTask"]),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Divider(
                                      height: h * 0.05,
                                    ),
                                    const Text("Name of Task"),
                                    Text(snapshot.data!.docs[index]["Task"]),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Divider(
                                      height: h * 0.05,
                                    ),
                                    const Text("Date"),
                                    Text(snapshot.data!.docs[index]["Date"]),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Divider(
                                      height: h * 0.05,
                                    ),
                                    const Text("Time"),
                                    Text(snapshot.data!.docs[index]["Time"]),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                var deleteIndex = snapshot.data!.docs[index].id;
                                FirebaseFirestore.instance
                                    .collection("User")
                                    .doc(id)
                                    .collection("UserValue")
                                    .doc()
                                    .collection("List")
                                    .doc(deleteIndex)
                                    .delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Task is Deleted...")));
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

