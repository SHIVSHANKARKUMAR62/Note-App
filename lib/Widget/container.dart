import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/Pages/first.dart';
import 'package:noteapp/Pages/homePage.dart';
import 'package:noteapp/Pages/loginPage.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  String id = " ";
  String firstCharacter = " ";
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
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.backspace_sharp)),
        ],
        title: const Text("Profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("User").doc(id).collection("UserValue")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.008, top: h * 0.04),
                              child: CircleAvatar(
                                minRadius: w*0.1,
                                maxRadius: w*0.15,
                                child: Text(snapshot.data!.docs[index]["Name"].toString().substring(0,1),style: TextStyle(fontSize: w*0.2)),
                              ),),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(w*0.009),
                                  child: Text("Name: ${snapshot.data!.docs[index]["Name"]}",style: TextStyle(fontSize: w*0.05)),
                                ),
                                Divider(
                                  height: h*0.03,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(w*0.009),
                                  child: Text("Email: ${snapshot.data!.docs[index]["Email"]}",style: TextStyle(fontSize: w*0.05)),
                                ),
                                Divider(
                                  height: h*0.03,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(w*0.009),
                                  child: Text("Password: ${snapshot.data!.docs[index]["Password"]}",style: TextStyle(fontSize: w*0.05)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: h*0.002),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                      },
                    ),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                        },
                        child: Text("Home",style: TextStyle(fontSize: w*0.05)))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h*0.002),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.task),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstScreen(),));
                      },
                    ),
                    GestureDetector(
                        onTap: (){
                          // Navigator.popUntil(context, (route) => route.isFirst);
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FirstScreen(),));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstScreen(),));
                        },
                        child: Text("New Task",style: TextStyle(fontSize: w*0.05)))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: h*0.2),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: (){
                        logOut();
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPageSecond(),));
                      },
                    ),
                    GestureDetector(
                        onTap: (){
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPageSecond(),));
                        },
                        child: Text("Log Out",style: TextStyle(fontSize: w*0.05)))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
