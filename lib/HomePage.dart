// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qr_code_sample/ProfilePage.dart';
import 'package:qr_code_sample/constants.dart';
import 'package:qr_code_sample/login.dart';
import 'package:qr_code_sample/models/avatars.dart';
import 'package:qr_code_sample/models/profile.dart';
import 'package:qr_code_sample/profile.dart';
import 'package:qr_code_sample/utilities/firebase_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(this.ava);
  String ava;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String ava = "";
  String? avaa = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle mainTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 25,
  );
  showavatarDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: getavatars(),
          );
        });
  }

  showaprofileDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: getprofilepopup(),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getavatars();
    getavaa();
    setState(() {});
    // getprofilepopup();
  }

  void getavaa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    avaa = prefs.getString('ava');
    print(ava);
  }

  Widget getprofilepopup() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  showavatarDialog(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(
                    'Choose Avatar',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(widget.ava)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(
                    'View Profile',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getavatars() {
    String arrayObjsText =
        '{"tags": [{"id": 1,"image" : "assets/images/avatar_two.png"}, '
        '{"id": 2,"image" : "assets/images/avatar_three.png"}, '
        '{"id": 3,"image" : "assets/images/avatar_four.png"}, '
        '{"id": 4,"image" : "assets/images/avatar_five.png"}, '
        '{"id": 5,"image" : "assets/images/avatar_six.png"}]}';

    var tagObjsJson = jsonDecode(arrayObjsText)['tags'] as List;
    List<Tag> tagObjs =
        tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                  child: Text(
                "Choose an avatar.",
                style: TextStyle(color: Colors.black, fontSize: 25),
              )),
              SizedBox(
                height: 30,
              ),
              GridView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: tagObjs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 120),
                itemBuilder: (BuildContext context, int index) {
                  var avatarimage = tagObjs[index].image;
                  print(avatarimage);
                  // var doc = snapshot.data.docs;
                  // var avatardocId = doc[index].id;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(avatarimageurlkey, avatarimage);
                          setState(() {
                            widget.ava = avatarimage;
                          });
                          print(widget.ava);
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.green,
                          child: ClipOval(
                            child: Image.asset(
                              "${tagObjs[index].image}",
                              cacheWidth: 100 * window.devicePixelRatio.ceil(),
                              cacheHeight: 100 * window.devicePixelRatio.ceil(),
                              fit: BoxFit.fill,
                              gaplessPlayback: true,
                            ),
                          ),
                          //backgroundImage: Image.asset("name"),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // getava() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.getString('ava');
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFB2E2FE),
      // appBar: AppBar(EEFE
      //   title: Text(widgeFEt.title),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
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
                        child: const Center(
                          child: Text(
                            "LOGO",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFE2EEF6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          showaprofileDialog(context);
                          //showavatarDialog(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: ClipOval(
                            //height: 50,
                            // ignore: sort_child_properties_last
                            child: Center(
                              child: Image.asset(
                                widget.ava == ""
                                    ? '$avatarimageurl'
                                    : widget.ava,
                                cacheWidth: 50 * window.devicePixelRatio.ceil(),
                                cacheHeight:
                                    50 * window.devicePixelRatio.ceil(),
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
                        ),
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
              Text(
                'Hi $userName',
                style: mainTextStyle,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                height: height * 0.7,
                width: width * 0.9,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseUtils.getProfiles,
                    builder: (ctx, snapshot) {
                      //print('111111 conn state ${snapshot.connectionState}');
                      if (snapshot.hasData) {
                        //print('111111 has data ${snapshot.data}');
                        var profilesList = snapshot.data!.docs.map((e) {
                          return Profile.fromMap(e.data());
                        }).toList();
                        //print('111111 data ${profilesList}');
                        var listOfDocRef = snapshot.data!.docs;
                        return ListView.builder(
                            itemCount: profilesList.length,
                            itemBuilder: (context, index) {
                              return Builder(builder: (context) {
                                return Slidable(
                                  startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (ctx) {
                                            FirebaseUtils.deleteProfile(
                                              docRef:
                                                  listOfDocRef[index].reference,
                                            );
                                            setState(() {});
                                          },
                                          backgroundColor:
                                              const Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                        SlidableAction(
                                          onPressed: (ctx) {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                isUpdating: true,
                                                profile: profilesList[index],
                                                docRef: listOfDocRef[index]
                                                    .reference,
                                              ),
                                            ));
                                          },
                                          backgroundColor:
                                              const Color(0xFF21B7CA),
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: 'Edit',
                                        ),
                                      ]),
                                  child: GestureDetector(
                                    onTap: () async {
                                      String? imgPath =
                                          await FirebaseUtils.getProfileQr(
                                              (profilesList[index].email! +
                                                  profilesList[index]
                                                      .profileName! +
                                                  profilesList[index]
                                                      .website!));
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (ctx) {
                                            return Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(50),
                                                            topRight:
                                                                Radius.circular(
                                                                    50))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      width: width * 0.8,
                                                      height: height * 0.09,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        profilesList[index]
                                                                .profileName ??
                                                            'Personal Profile',
                                                        style: mainTextStyle,
                                                      )),
                                                    ),
                                                    Image.network(
                                                      imgPath ??
                                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png',
                                                      height: height * 0.3,
                                                      width: width * 0.7,
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ProfilePage(
                                                              isUpdating: true,
                                                              profile:
                                                                  profilesList[
                                                                      index],
                                                              docRef:
                                                                  listOfDocRef[
                                                                          index]
                                                                      .reference,
                                                            ),
                                                          ));
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .settings_outlined,
                                                          size: 35,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: width * 0.8,
                                      height: height * 0.09,
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                          child: Text(
                                        profilesList[index].profileName ??
                                            'Personal Profile',
                                        style: mainTextStyle,
                                      )),
                                    ),
                                  ),
                                );
                              });
                            });
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
        elevation: 50.0,
        color: Color(0xFFB2E2FE),
        child: Container(
          height: height * 0.21, //set your height here
          width: width,
          //set your width here
          decoration: BoxDecoration(
            color: Color(0xFFB2E2FE),
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
                child: IconButton(
                    onPressed: () {
                      // showModalBottomSheet(
                      //     context: context,
                      //     builder: (ctx) {
                      //       return Material(
                      //         color: Colors.transparent,
                      //         child: Container(
                      //           height: 150,
                      //           decoration: const BoxDecoration(
                      //               borderRadius: BorderRadius.only(
                      //                   topLeft: Radius.circular(50),
                      //                   topRight: Radius.circular(50))),
                      //           child: Column(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceEvenly,
                      //             children: [
                      //               GestureDetector(
                      //                 onTap: () {
                      //                   Navigator.of(context)
                      //                       .push(MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         const ProfilePage(
                      //                             isUpdating: false),
                      //                   ));
                      //                 },
                      //                 child: Container(
                      //                   width: width * 0.8,
                      //                   height: height * 0.07,
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.blue,
                      //                     borderRadius:
                      //                         BorderRadius.circular(15),
                      //                   ),
                      //                   child: const Center(
                      //                     child: Text(
                      //                       'Personal Profile',
                      //                       style:
                      //                           TextStyle(color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //               // Image.asset(
                      //               //   'assets/images/qr.png',
                      //               //   height: height * 0.3,
                      //               //   width: width * 0.7,
                      //               // ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 100,
                      color: Colors.black,
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
    );
  }
}
