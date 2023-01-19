// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_sample/ProfilePage.dart';
import 'package:qr_code_sample/constants.dart';
import 'package:qr_code_sample/edit_profiles/edit_personal_profile.dart';
import 'package:qr_code_sample/login.dart';
import 'package:qr_code_sample/models/avatars.dart';
import 'package:qr_code_sample/models/profile.dart';
import 'package:qr_code_sample/profile.dart';
import 'package:qr_code_sample/profiles/anti_profile.dart';
import 'package:qr_code_sample/profiles/link_profile.dart';
import 'package:qr_code_sample/profiles/personal_profile.dart';
import 'package:qr_code_sample/profiles/prof_profile.dart';
import 'package:qr_code_sample/utilities/firebase_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(this.ava);
  String ava;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class SettingsModal {
  final String avatarimage;

  SettingsModal({
    required this.avatarimage,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  currentUser() {
    final User user = _firebaseAuth.currentUser!;
    final uid = user.uid.toString();
    return uid;
  }

  bool isedit = true;

  String usingprofile = "";
  String ava = "";
  String perp_docid = "";
  String perp_name = "";

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle mainTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 25,
  );
  @override
  void initState() {
    //refresh the page here
    super.initState();
    getSettings();
  }

  // void getavaa() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   avatarimage = prefs.getString(avatarimageurlkey) ?? '';
  //   setState(() {
  //     ava = avatarimage;
  //   });
  // }

  static Future<SettingsModal> getSettings() async {
    final preferences = await SharedPreferences.getInstance();

    final _avatarimage = preferences.getString(avatarimageurlkey) ?? '';
    print(_avatarimage);
    return SettingsModal(
      avatarimage: _avatarimage,
    );
  }

  deleteAlertDialog(BuildContext context, String name, String id) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Text(
        'Cancel',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(primary: Colors.blue),
    );
    Widget continueButton = ElevatedButton(
      onPressed: () async {
        FirebaseFirestore.instance
            .collection("users_profile")
            .doc(currentUser())
            .collection("personal_qr_code")
            .doc(id)
            .delete()
            .whenComplete(() async {
          Navigator.pop(context);
        });
      },
      child: const Text(
        'Delete',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(primary: Colors.red),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete profile " + name,
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "Deleteing this profile will remove all data",
        textAlign: TextAlign.center,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextEditingController profilenameController = TextEditingController();
  TextEditingController editprofilenameController = TextEditingController();
  final _profilenameformKey = GlobalKey<FormState>();
  showprofilenameDialog(BuildContext context, String docid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color(0xFFE2EEF6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: getprofilepopup(docid),
          );
        });
  }

  Widget getprofilepopup(String docid) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _profilenameformKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Please name your Profile',
                  // ignore: unnecessary_const
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  //style: mainTextStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onTap: () async {},
                      //readOnly: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter profile name.';
                        }
                        return null;
                      },
                      controller: profilenameController,
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          //suffixIcon: Icon(Icons.date_range_sharp),
                          // suffixIcon: Icon(
                          //   Icons.person,
                          //   color: Colors.blue,
                          // ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          hintText: 'Name',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          errorStyle: const TextStyle(color: Colors.red)),
                      //,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_profilenameformKey.currentState!.validate()) {
                      //if (usingprofile == "personl") {
                      Navigator.of(context)
                          .pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => PersonalProfileScreen(
                                  profilenameController.text.toString(),
                                  isedit,
                                  docid,
                                  usingprofile),
                            ),
                          )
                          .whenComplete(() => profilenameController.clear());
                      //   } else if (usingprofile == "link") {
                      //     Navigator.of(context)
                      //         .pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (context) => LinkProfileScreen(
                      //                 profilenameController.text.toString()),
                      //           ),
                      //         )
                      //         .whenComplete(() => profilenameController.clear());
                      //   } else if (usingprofile == "prof") {
                      //     Navigator.of(context)
                      //         .pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (context) => ProfProfileScreen(
                      //                 profilenameController.text.toString()),
                      //           ),
                      //         )
                      //         .whenComplete(() => profilenameController.clear());
                      //   } else if (usingprofile == "anti") {
                      //     Navigator.of(context)
                      //         .pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (context) => AntiProfileScreen(
                      //                 profilenameController.text.toString()),
                      //           ),
                      //         )
                      //         .whenComplete(() => profilenameController.clear());
                      //}
                    }
                    // Navigator.of(context).pop();
                    //showprofilenameDialog(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      color: const Color(0xFF62AEFB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                        child: Text(
                      'Create Profile',
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _editprofilenameformKey = GlobalKey<FormState>();
  editshowprofilenameDialog(BuildContext context, String docid,
      String profilename, String usingprofile) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color(0xFFE2EEF6),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: editgetprofilepopup(docid, profilename, usingprofile),
          );
        });
  }

  Widget editgetprofilepopup(
      String docid, String profilename, String usingprofile) {
    editprofilenameController.text = profilename;
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _profilenameformKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Please name your Profile',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  //style: mainTextStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onTap: () async {},
                      //readOnly: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter profile name.';
                        }
                        return null;
                      },
                      controller: editprofilenameController,
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          //suffixIcon: Icon(Icons.date_range_sharp),
                          // suffixIcon: Icon(
                          //   Icons.person,
                          //   color: Colors.blue,
                          // ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          hintText: 'Name',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          errorStyle: const TextStyle(color: Colors.red)),
                      //,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_profilenameformKey.currentState!.validate()) {
                      // if (usingprofile == "personl") {
                      Navigator.of(context)
                          .pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => EditPersonalProfileScreen(
                                  editprofilenameController.text.toString(),
                                  isedit,
                                  docid,
                                  usingprofile),
                            ),
                          )
                          .whenComplete(
                              () => editprofilenameController.clear());
                      //   } else if (usingprofile == "link") {
                      //     Navigator.of(context)
                      //         .pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (context) => LinkProfileScreen(
                      //                 profilenameController.text.toString()),
                      //           ),
                      //         )
                      //         .whenComplete(() => profilenameController.clear());
                      //   } else if (usingprofile == "prof") {
                      //     Navigator.of(context)
                      //         .pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (context) => ProfProfileScreen(
                      //                 profilenameController.text.toString()),
                      //           ),
                      //         )
                      //         .whenComplete(() => profilenameController.clear());
                      //   } else if (usingprofile == "anti") {
                      //     Navigator.of(context)
                      //         .pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (context) => AntiProfileScreen(
                      //                 profilenameController.text.toString()),
                      //           ),
                      //         )
                      //         .whenComplete(() => profilenameController.clear());
                      // }
                    }
                    // Navigator.of(context).pop();
                    //showprofilenameDialog(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      color: const Color(0xFF62AEFB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                        child: Text(
                      'Update Profile',
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Guanxii'),
            content: const Text('Do you want to close Guanxii ?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent, // Color(0xFF62AEFB),
        // appBar: AppBar(EEFE
        //   title: Text(widgeFEt.title),
        // ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFFE2EEF6),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //       colors: [Color(0xFF029FE2), Color(0xFF29ABE2)],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter),
          // ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          height: 50,
                          // ignore: sort_child_properties_last
                          child: Image.asset(
                            "assets/images/guanxii.png",
                            cacheWidth: 50 * window.devicePixelRatio.ceil(),
                            cacheHeight: 50 * window.devicePixelRatio.ceil(),
                            gaplessPlayback: true,
                            //style: TextStyle(fontSize: 18),
                          ),
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xFFe2eef6)),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => const QRScan(),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     height: 50,
                      //     // ignore: sort_child_properties_last
                      //     child: const Icon(Icons.qr_code),
                      //     width: MediaQuery.of(context).size.width * 0.15,
                      //     decoration: const BoxDecoration(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(15)),
                      //         color: Color(0xFFE2EEF6)),
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(widget.ava),
                                ),
                              );
                              //showaprofileDialog(context);
                              //showavatarDialog(context);
                            },
                            child: FutureBuilder<SettingsModal>(
                              future: getSettings(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  return CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: ClipOval(
                                      //height: 50,
                                      // ignore: sort_child_properties_last
                                      child: Center(
                                        child: Image.asset(
                                          widget.ava == ""
                                              ? '$avatarimageurl'
                                              : snapshot.data!.avatarimage,
                                          cacheWidth: 50 *
                                              window.devicePixelRatio.ceil(),
                                          cacheHeight: 50 *
                                              window.devicePixelRatio.ceil(),
                                          gaplessPlayback: true,
                                          //style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      //width: MediaQuery.of(context).size.width * 0.15,
                                      // decoration: BoxDecoration(
                                      //     borderRadius:
                                      //         BorderRadius.all(Radius.circular(15)),
                                      //     color: Color(0xFFE2EEF6)),
                                    ),
                                  );
                                  // Text(
                                  //   snapshot.data!.avatarimage,
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 20.0,
                                  //   ),
                                  // );
                                }

                                /// better to handle other cases, included on answer
                                return const CircularProgressIndicator();
                              },
                            )
                            // CircleAvatar(
                            //   backgroundColor: Colors.white,
                            //   radius: 30,
                            //   child: ClipOval(
                            //     //height: 50,
                            //     // ignore: sort_child_properties_last
                            //     child: Center(
                            //       child: Image.asset(
                            //         widget.ava == ""
                            //             ? '$avatarimageurl'
                            //             : widget.ava,
                            //         cacheWidth: 50 * window.devicePixelRatio.ceil(),
                            //         cacheHeight:
                            //             50 * window.devicePixelRatio.ceil(),
                            //         gaplessPlayback: true,
                            //         //style: TextStyle(fontSize: 18),
                            //       ),
                            //     ),
                            //     //width: MediaQuery.of(context).size.width * 0.15,
                            //     // decoration: BoxDecoration(
                            //     //     borderRadius:
                            //     //         BorderRadius.all(Radius.circular(15)),
                            //     //     color: Color(0xFFE2EEF6)),
                            //   ),
                            // ),
                            ),
                      ),

                      // IconButton(
                      //     onPressed: () async {
                      //       SharedPreferences prefs =
                      //           await SharedPreferences.getInstance();
                      //       prefs.clear();
                      //       Navigator.of(context).pushAndRemoveUntil(
                      //           MaterialPageRoute(
                      //             builder: (context) => const LoginPage(),
                      //           ),
                      //           (route) => false);
                      //     },
                      //     icon: const Icon(
                      //       Icons.logout,
                      //       color: Colors.white,
                      //     )),
                    ],
                  ),
                ),
                Text('Hi $userName',
                    style: const TextStyle(
                        color: Color(0xFF3F4D4E), fontSize: 28)),
                SizedBox(
                  height: height * 0.03,
                ),
                SizedBox(
                  height: height * 0.7,
                  width: width * 0.9,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users_profile")
                          .doc(currentUser())
                          .collection("personal_qr_code")
                          .snapshots(),
                      builder: (ctx, snapshot) {
                        //print('111111 conn state ${snapshot.connectionState}');
                        if (snapshot.hasData) {
                          //print('111111 has data ${snapshot.data}');
                          // var profilesList = snapshot.data!.docs.map((e) {
                          //   return Profile.fromMap(e.data());
                          // }).toList();
                          //print('111111 data ${profilesList}');
                          var listOfDocRef = snapshot.data!.docs;

                          return Container(
                            padding: const EdgeInsets.only(bottom: 120),
                            height: height * 0.50,
                            child: ListView.builder(
                                primary: true,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: listOfDocRef.length,
                                itemBuilder: (context, index) {
                                  print(
                                      listOfDocRef[index].get("profilestatus"));
                                  return Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Slidable(
                                          closeOnScroll: false,
                                          // Specify a key if the Slidable is dismissible.
                                          key: const ValueKey(0),

                                          // The start action pane is the one at the left or the top side.
                                          // startActionPane: ActionPane(
                                          //   // A motion is a widget used to control how the pane animates.
                                          //   motion: const ScrollMotion(),

                                          //   // A pane can dismiss the Slidable.
                                          //   dismissible:
                                          //       DismissiblePane(onDismissed: () {}),

                                          //   // All actions are defined in the children parameter.
                                          //   children: [
                                          //     // A SlidableAction can have an icon and/or a label.
                                          //     SlidableAction(
                                          //       onPressed: (ctx) {
                                          //         setState(() {});
                                          //       },
                                          //       backgroundColor: Color(0xFFFBCD32),
                                          //       foregroundColor: Colors.white,
                                          //       icon: Icons.delete,
                                          //       label: 'Edit',
                                          //     ),
                                          //     SlidableAction(
                                          //       onPressed: (ctx) {
                                          //         setState(() {});
                                          //       },
                                          //       backgroundColor: Color(0xFFd71d1d),
                                          //       foregroundColor: Colors.white,
                                          //       icon: Icons.share,
                                          //       label: 'Delete',
                                          //     ),
                                          //   ],
                                          // ),

                                          // The end action pane is the one at the right or the bottom side.
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (ctx) {
                                                  editshowprofilenameDialog(
                                                      context,
                                                      listOfDocRef[index].id,
                                                      listOfDocRef[index]
                                                          .get("profile_name"),
                                                      listOfDocRef[index].get(
                                                          "profilestatus"));
                                                  // setState(() {});
                                                },
                                                backgroundColor:
                                                    const Color(0xFFFBCD32),
                                                foregroundColor: Colors.white,
                                                //icon: Icons.delete,
                                                label: 'Edit',
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SlidableAction(
                                                onPressed: (ctx) {
                                                  deleteAlertDialog(
                                                    context,
                                                    listOfDocRef[index]
                                                        .get('profile_name'),
                                                    listOfDocRef[index].id,
                                                  );
                                                  // Navigator.of(context).push(
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         EditPersonalProfileScreen(
                                                  //             listOfDocRef[index]
                                                  //                 .get('profile_name'),
                                                  //             listOfDocRef[index]
                                                  //                 .get('name'),
                                                  //             listOfDocRef[index]
                                                  //                 .get('dateOfBirth'),
                                                  //             listOfDocRef[index]
                                                  //                 .get('email'),
                                                  //             listOfDocRef[index]
                                                  //                 .get('phone'),
                                                  //             listOfDocRef[index]
                                                  //                 .get('image'),
                                                  //             listOfDocRef[index]
                                                  //                 .get('website')),
                                                  //   ),
                                                  // );
                                                  // setState(() {});
                                                },
                                                backgroundColor:
                                                    const Color(0xFFd71d1d),
                                                foregroundColor: Colors.white,
                                                //icon: Icons.share,
                                                label: 'Delete',
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              // SlidableAction(
                                              //   // An action can be bigger than the others.
                                              //   flex: 2,
                                              //   onPressed: (ctx) {
                                              //     setState(() {});
                                              //   },
                                              //   backgroundColor: Color(0xFF7BC043),
                                              //   foregroundColor: Colors.white,
                                              //   icon: Icons.archive,
                                              //   label: 'Archive',
                                              // ),
                                              // SlidableAction(
                                              //   onPressed: (ctx) {
                                              //     setState(() {});
                                              //   },
                                              //   backgroundColor: Color(0xFF0392CF),
                                              //   foregroundColor: Colors.white,
                                              //   icon: Icons.save,
                                              //   label: 'Save',
                                              // ),
                                            ],
                                          ),

                                          // The child of the Slidable is what the user sees when the
                                          // component is not dragged.
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30.0),
                                                    topRight:
                                                        Radius.circular(30.0),
                                                  )),
                                                  backgroundColor:
                                                      const Color(0xFFE2EEF6),
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (ctx) {
                                                    return Container(
                                                      height: height * 0.75,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          50),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          50))),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        120.0),
                                                            child: Divider(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.01,
                                                              thickness: 5.0,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                            width: width * 0.8,
                                                            height:
                                                                height * 0.08,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF62AEFB),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                              listOfDocRef[
                                                                          index]
                                                                      .get(
                                                                          'profile_name') ??
                                                                  'Personal Profile',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 25),
                                                            )),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          CachedNetworkImage(
                                                            imageUrl: listOfDocRef[
                                                                    index]
                                                                .get(
                                                                    'qr_image'),
                                                            progressIndicatorBuilder: (context,
                                                                    url,
                                                                    downloadProgress) =>
                                                                CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                          // Image.network(
                                                          //   listOfDocRef[index]
                                                          //       .get('qr_image'),
                                                          //   height: height * 0.4,
                                                          //   width: width * 0.8,
                                                          // ),
                                                          IconButton(
                                                              onPressed: () {
                                                                print(listOfDocRef[
                                                                        index]
                                                                    .get(
                                                                        "profilestatus"));
                                                                editshowprofilenameDialog(
                                                                    context,
                                                                    listOfDocRef[
                                                                            index]
                                                                        .id,
                                                                    listOfDocRef[
                                                                            index]
                                                                        .get(
                                                                            "profile_name"),
                                                                    listOfDocRef[
                                                                            index]
                                                                        .get(
                                                                            "profilestatus"));
                                                                // Navigator.of(context)
                                                                //     .push(
                                                                //         MaterialPageRoute(
                                                                //   builder: (context) =>
                                                                //       ProfilePage(
                                                                //     isUpdating: true,
                                                                //     profile:
                                                                //         profilesList[
                                                                //             index],
                                                                //     docRef:
                                                                //         listOfDocRef[
                                                                //                 index]
                                                                //             .reference,
                                                                //   ),
                                                                // ));
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .settings_outlined,
                                                                size: 35,
                                                              )),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              width: width * 0.8,
                                              height: height * 0.10,
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF62AEFB),
                                                // .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 5,
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                              child: Center(
                                                  child: Text(
                                                listOfDocRef[index]
                                                    .get('profile_name')
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          );
                        } else {
                          return const Center(
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()),
                          );
                        }
                      }),
                ),
                // SizedBox(
                //   height: height * 0.07,
                //   child:  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0.0,
          color: Colors.transparent, //Color(0xFF62AEFB),
          child: Container(
            height: height * 0.21, //set your height here
            width: width,
            //set your width here
            decoration: const BoxDecoration(
              color: Color(0xFFE2EEF6),
            ),
            //borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: height * 0.2, //set your height here
                  width: width / 0.05,
                  //color: Colors.black,
                  child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Material(
                                color: const Color(0xFFE2EEF6),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50))),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 120.0),
                                        child: Divider(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          thickness: 5.0,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            usingprofile = "personl";
                                            print(usingprofile);
                                            isedit = false;
                                          });
                                          Navigator.pop(context);
                                          showprofilenameDialog(
                                              context, 'Empty');
                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //   builder: (context) =>
                                          //       const ProfilePage(
                                          //           isUpdating: false),
                                          // ));
                                        },
                                        child: Container(
                                          width: width * 0.8,
                                          height: height * 0.08,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF62AEFB),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Create Personal Profile',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            usingprofile = "prof";
                                            print(usingprofile);
                                          });
                                          Navigator.pop(context);
                                          showprofilenameDialog(
                                              context, 'Empty');
                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //   builder: (context) =>
                                          //       const ProfilePage(
                                          //           isUpdating: false),
                                          // ));
                                        },
                                        child: Container(
                                          width: width * 0.8,
                                          height: height * 0.08,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF62AEFB),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Create Professional Profile',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       usingprofile = "link";
                                      //       print(usingprofile);
                                      //     });
                                      //     Navigator.pop(context);
                                      //     showprofilenameDialog(
                                      //         context, 'Empty');
                                      //     // Navigator.of(context)
                                      //     //     .push(MaterialPageRoute(
                                      //     //   builder: (context) =>
                                      //     //       const ProfilePage(
                                      //     //           isUpdating: false),
                                      //     // ));
                                      //   },
                                      //   child: Container(
                                      //     width: width * 0.8,
                                      //     height: height * 0.08,
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.lightBlue,
                                      //       borderRadius:
                                      //           BorderRadius.circular(10),
                                      //     ),
                                      //     child: const Center(
                                      //       child: Text(
                                      //         'Create Link Profile',
                                      //         style: TextStyle(
                                      //             color: Colors.white),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            usingprofile = "anti";

                                            print(usingprofile);
                                          });
                                          Navigator.pop(context);
                                          showprofilenameDialog(
                                              context, 'Empty');
                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //   builder: (context) =>
                                          //       const ProfilePage(
                                          //           isUpdating: false),
                                          // ));
                                        },
                                        child: Container(
                                          width: width * 0.8,
                                          height: height * 0.08,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF62AEFB),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Creaate Anti-Creep Profile',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Image.asset(
                        "assets/images/plus.png",
                        color: const Color(0xFF3F4D4E),
                        gaplessPlayback: true,
                      )),
                ),

                //add as many tabs as you want here
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
