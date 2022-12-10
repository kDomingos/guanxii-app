import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_code_sample/HomePage.dart';
import 'package:qr_code_sample/biodata.dart';
import 'package:qr_code_sample/constants.dart';
import 'package:qr_code_sample/login.dart';
import 'package:qr_code_sample/models/avatars.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.ava);
  String ava;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => ProfileScreen(widget.ava)),
              //     );
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width / 2,
              //     height: MediaQuery.of(context).size.height * 0.08,
              //     decoration: BoxDecoration(
              //       color: Colors.lightBlue,
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     child: Center(
              //         child: Text(
              //       'View Profile',
              //       style: TextStyle(color: Colors.white),
              //     )),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
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
                  //print(avatarimage);
                  // var doc = snapshot.data.docs;
                  // var avatardocId = doc[index].id;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          setState(() {
                            prefs.setString(avatarimageurlkey, avatarimage);
                            widget.ava = avatarimage;
                          });
                          print(widget.ava);
                          Navigator.of(context).pop(true);
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

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Guanxii'),
            content: const Text(
                'Do you want go back to home screen or close Guanxii ?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(widget.ava),
                  ),
                ),
                child: const Text(
                  'Home Screen',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Exit Guanxii',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
        )) ??
        false;
  }

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

  showbillingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "At the moment everything is free. Enjoy and let us know your thoughts by sharing your experience with the app.",
                textAlign: TextAlign.center,
              ),
            ),
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
    // getavaa();
    setState(() {});
    // getprofilepopup();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyHomePage(widget.ava),
                ),
              );
              //Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          //centerTitle: true,
          elevation: 0.0,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Color(0xFFB2E2FE),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    height: 130,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFF2254E0), width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10.0,
                      color: Color(0xFF2254E0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 45.0,
                            child: ClipOval(
                              //color: Colors.amber,
                              child: Image.asset(
                                widget.ava == ""
                                    ? '$avatarimageurl'
                                    : widget.ava,
                                cacheHeight:
                                    MediaQuery.of(context).size.height ~/
                                        1 *
                                        window.devicePixelRatio.ceil(),
                                cacheWidth: MediaQuery.of(context).size.width ~/
                                    1 *
                                    window.devicePixelRatio.ceil(),
                                gaplessPlayback: true,
                                fit: BoxFit.cover,
                                //style: TextStyle(fontSize: 18),
                              ),
                              //height: 50,
                              // ignore: sort_child_properties_last
                              // child: Center(
                              //   child:
                              // ),
                              //width: MediaQuery.of(context).size.width * 0.15,
                              // decoration: BoxDecoration(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(15)),
                              //     color: Color(0xFFE2EEF6)),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: ListTile(
                              title: Text(
                                '$userName',
                                style: TextStyle(color: Colors.white),
                                //style: mainTextStyle,
                              ),
                              subtitle: Text(
                                '$usermail',
                                style: TextStyle(color: Colors.white),
                                //style: mainTextStyle,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BioDataScreen(widget.ava),
                                  ));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10.0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  //width: MediaQuery.of(context).size.width / 1.5,
                                  // ignore: prefer_const_constructors
                                  child: ListTile(
                                    // ignore: prefer_const_constructors
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFFB2E2FE),
                                      radius: 25.0,
                                      // ignore: prefer_const_constructors
                                      child: ClipOval(
                                          //color: Colors.amber,
                                          // ignore: prefer_const_constructors
                                          child: Icon(Icons.person)
                                          //height: 50,
                                          // ignore: sort_child_properties_last
                                          // child: Center(
                                          //   child:
                                          // ),
                                          //width: MediaQuery.of(context).size.width * 0.15,
                                          // decoration: BoxDecoration(
                                          //     borderRadius:
                                          //         BorderRadius.all(Radius.circular(15)),
                                          //     color: Color(0xFFE2EEF6)),
                                          ),
                                    ),
                                    // ignore: prefer_const_constructors
                                    title: Text(
                                      'My Account',
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      //style: mainTextStyle,
                                    ),
                                    // ignore: prefer_const_constructors
                                    subtitle: Text(
                                      'Make changes to your account',
                                      style:
                                          // ignore: prefer_const_constructors
                                          TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                      //style: mainTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                              //Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              showaprofileDialog(context);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width / 1.5,
                                    // ignore: prefer_const_constructors
                                    child: ListTile(
                                      // ignore: prefer_const_constructors
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xFFB2E2FE),
                                        radius: 25.0,
                                        // ignore: prefer_const_constructors
                                        child: ClipOval(
                                            //color: Colors.amber,
                                            // ignore: prefer_const_constructors
                                            child: Icon(
                                                Icons.photo_size_select_actual)
                                            //height: 50,
                                            // ignore: sort_child_properties_last
                                            // child: Center(
                                            //   child:
                                            // ),
                                            //width: MediaQuery.of(context).size.width * 0.15,
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.all(Radius.circular(15)),
                                            //     color: Color(0xFFE2EEF6)),
                                            ),
                                      ),
                                      // ignore: prefer_const_constructors
                                      title: Text(
                                        'Choose Avatar',
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        //style: mainTextStyle,
                                      ),
                                      // ignore: prefer_const_constructors
                                      subtitle: Text(
                                        'Choose avatar acording to your personality',
                                        style:
                                            // ignore: prefer_const_constructors
                                            TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11),
                                        //style: mainTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                //Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  //width: MediaQuery.of(context).size.width / 1.5,
                                  // ignore: prefer_const_constructors
                                  child: ListTile(
                                    // ignore: prefer_const_constructors
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFFB2E2FE),
                                      radius: 25.0,
                                      // ignore: prefer_const_constructors
                                      child: ClipOval(
                                          //color: Colors.amber,
                                          // ignore: prefer_const_constructors
                                          child: Icon(Icons.person_add)
                                          //height: 50,
                                          // ignore: sort_child_properties_last
                                          // child: Center(
                                          //   child:
                                          // ),
                                          //width: MediaQuery.of(context).size.width * 0.15,
                                          // decoration: BoxDecoration(
                                          //     borderRadius:
                                          //         BorderRadius.all(Radius.circular(15)),
                                          //     color: Color(0xFFE2EEF6)),
                                          ),
                                    ),
                                    // ignore: prefer_const_constructors
                                    title: Text(
                                      'Invite a friend',
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      //style: mainTextStyle,
                                    ),
                                    // ignore: prefer_const_constructors
                                    subtitle: Text(
                                      'Invite your friends and family to our community',
                                      style:
                                          // ignore: prefer_const_constructors
                                          TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                      //style: mainTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                              //Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              showbillingDialog(context);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width / 1.5,
                                    // ignore: prefer_const_constructors
                                    child: ListTile(
                                      // ignore: prefer_const_constructors
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xFFB2E2FE),
                                        radius: 25.0,
                                        // ignore: prefer_const_constructors
                                        child: ClipOval(
                                            //color: Colors.amber,
                                            // ignore: prefer_const_constructors
                                            child: Icon(Icons.payment_outlined)
                                            //height: 50,
                                            // ignore: sort_child_properties_last
                                            // child: Center(
                                            //   child:
                                            // ),
                                            //width: MediaQuery.of(context).size.width * 0.15,
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.all(Radius.circular(15)),
                                            //     color: Color(0xFFE2EEF6)),
                                            ),
                                      ),
                                      // ignore: prefer_const_constructors
                                      title: Text(
                                        'Billing',
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        //style: mainTextStyle,
                                      ),
                                      // ignore: prefer_const_constructors
                                      subtitle: Text(
                                        'Access more features by inviting us to cofee',
                                        style:
                                            // ignore: prefer_const_constructors
                                            TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11),
                                        //style: mainTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                //Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  //width: MediaQuery.of(context).size.width / 1.3,
                                  // ignore: prefer_const_constructors
                                  child: ListTile(
                                    // ignore: prefer_const_constructors
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFFB2E2FE),
                                      radius: 25.0,
                                      // ignore: prefer_const_constructors
                                      child: ClipOval(
                                          //color: Colors.amber,
                                          // ignore: prefer_const_constructors
                                          child: Icon(Icons.logout)
                                          //height: 50,
                                          // ignore: sort_child_properties_last
                                          // child: Center(
                                          //   child:
                                          // ),
                                          //width: MediaQuery.of(context).size.width * 0.15,
                                          // decoration: BoxDecoration(
                                          //     borderRadius:
                                          //         BorderRadius.all(Radius.circular(15)),
                                          //     color: Color(0xFFE2EEF6)),
                                          ),
                                    ),
                                    // ignore: prefer_const_constructors
                                    title: Text(
                                      'Log out',
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      //style: mainTextStyle,
                                    ),
                                    // ignore: prefer_const_constructors
                                    subtitle: Text(
                                      'Further secure your account for safety',
                                      style:
                                          // ignore: prefer_const_constructors
                                          TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                      //style: mainTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                              //Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () async {
                                  // SharedPreferences prefs =
                                  //     await SharedPreferences.getInstance();
                                  // prefs.clear();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (route) => false);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'More',
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        //style: mainTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10.0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                // ignore: prefer_const_constructors
                                child: ListTile(
                                  // ignore: prefer_const_constructors
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFFB2E2FE),
                                    radius: 25.0,
                                    // ignore: prefer_const_constructors
                                    child: ClipOval(
                                        //color: Colors.amber,
                                        // ignore: prefer_const_constructors
                                        child:
                                            Icon(Icons.notification_important)
                                        //height: 50,

                                        ),
                                  ),
                                  // ignore: prefer_const_constructors
                                  title: Text(
                                    'Help & Support',
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    //style: mainTextStyle,
                                  ),
                                  // ignore: prefer_const_constructors
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                // ignore: prefer_const_constructors
                                child: ListTile(
                                  // ignore: prefer_const_constructors
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFFB2E2FE),
                                    radius: 25.0,
                                    // ignore: prefer_const_constructors
                                    child: ClipOval(
                                      //color: Colors.amber,
                                      // ignore: prefer_const_constructors
                                      child: Icon(
                                        Icons.favorite_outline_outlined,
                                      ),
                                    ),
                                  ),
                                  // ignore: prefer_const_constructors
                                  title: Text(
                                    'About App',
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    //style: mainTextStyle,
                                  ),
                                  // ignore: prefer_const_constructors
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
