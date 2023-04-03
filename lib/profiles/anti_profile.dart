import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:guanxii_app/constants.dart';

class AntiProfileScreen extends StatefulWidget {
  AntiProfileScreen(this.name);
  String name;

  @override
  State<AntiProfileScreen> createState() => _AntiProfileScreenState();
}

class _AntiProfileScreenState extends State<AntiProfileScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  currentUser() {
    final User user = _firebaseAuth.currentUser!;
    final uid = user.uid.toString();
    return uid;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   print(currentUser());
  // }

  final _biodataformKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String number = "";
  TextEditingController dobController = TextEditingController();
  List<String> typeNeg = [
    "Male",
    "Female",
    "Other",
  ];
  Widget progressBar() {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: 0.7,
      animationDuration: 2000,
      center: new Text(
        "80.0%",
        style: new TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: new Text(
          "we are creating your profile",
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
    );
  }

  String dropdownValue = "Male";
  @override
  Widget build(BuildContext context) {
    print(currentUser());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
          "bio - date",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Color(0xFFB2E2FE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _biodataformKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 45.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF62AEFB),
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                            offset: Offset(0, -10),
                          )
                        ],
                      ),
                      child: ClipOval(
                        //color: Colors.amber,
                        child: Image.asset(
                          '$avatarimageurl',
                          //widget.ava == "" ? '$avatarimageurl' : widget.ava,
                          cacheHeight: MediaQuery.of(context).size.height ~/
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '$userName',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    //style: mainTextStyle,
                  ),
                  Text(
                    '$usermail',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                    //style: mainTextStyle,
                  ),
                  SizedBox(
                    height: 40,
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
                            return 'Please enter your first name.';
                          }
                          return null;
                        },
                        controller: firstnameController,
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
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            hintText: 'What is your first name?',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            errorStyle: TextStyle(color: Colors.white)),
                        //,
                      ),
                    ),
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
                            return 'Please enter your last name.';
                          }
                          return null;
                        },
                        controller: lastnameController,
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
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            hintText: 'And your last name?',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            errorStyle: TextStyle(color: Colors.white)),
                        //,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: IntlPhoneField(
                          controller: phoneController,
                          flagsButtonPadding: EdgeInsets.only(left: 15.0),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              //counter: Offstage(),
                              // suffixIcon: Icon(
                              //   Icons.person,
                              //   color: Colors.blue,
                              // ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(fontWeight: FontWeight.bold),
                              errorStyle: TextStyle(color: Colors.white)),
                          // decoration: const InputDecoration(
                          //   counter: Offstage(),
                          //   labelText: 'Mobile Number',
                          //   border: OutlineInputBorder(
                          //     borderSide: BorderSide(),
                          //   ),
                          // ),
                          initialCountryCode: 'ES',
                          showDropdownIcon: true,
                          dropdownIconPosition: IconPosition.trailing,
                          onChanged: (phone) {
                            setState(() {
                              number = phone.completeNumber.toString();
                              print(number);
                            });
                            print(phone.completeNumber);
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            // suffixIcon: Icon(
                            //   Icons.person,
                            //   color: Colors.blue,
                            // ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            hintText: 'Select your gender',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            errorStyle: TextStyle(color: Colors.white)),
                        value: dropdownValue,
                        hint: Text("Select your gender"),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please select your gender';
                          }
                        },
                        items: typeNeg
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        // onSaved: (val) =>
                        //     setState(() => typeNeg = val as List<String>),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime(2025),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              dobController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          });
                        },
                        readOnly: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your date of birth.';
                          }
                          return null;
                        },
                        controller: dobController,
                        //autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.date_range_sharp),
                            // suffixIcon: Icon(
                            //   Icons.person,
                            //   color: Colors.blue,
                            // ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            hintText: 'What is your date of birth?',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            errorStyle: TextStyle(color: Colors.white)),
                        //,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      // CollectionReference ref =
                      //     FirebaseFirestore.instance.collection('users');

                      // ref.doc(ref.doc().id).set({
                      //   "firstName": firstnameController.text.toString(),
                      //   // "lastName": lastnameController.text.toString(),
                      //   // "phoneNumber": number,
                      //   // "gender": dropdownValue,
                      //   // "dateOfBirth": dobController.text.toString()
                      // });

                      if (_biodataformKey.currentState!.validate()) {
                        progressBar();
                        final FirebaseFirestore _db =
                            FirebaseFirestore.instance;
                        final collection = 'users_bio_data';
                        final documentId = currentUser();
                        final snapShot = await _db
                            .collection(collection)
                            .doc(documentId)
                            .get();
                        if (snapShot.exists) {
                          _db.collection(collection).doc(documentId).update({
                            "firstName": firstnameController.text.toString(),
                            "lastName": lastnameController.text.toString(),
                            "phoneNumber": number,
                            "gender": dropdownValue,
                            "dateOfBirth": dobController.text.toString()
                          }).whenComplete(() {
                            firstnameController.clear();
                            lastnameController.clear();
                            phoneController.clear();
                            dobController.clear();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Successfully Updated"),
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  bottom: 20, right: 20, left: 20),
                            ));
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("stackTrace"),
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  bottom: 20, right: 20, left: 20),
                            ));
                            //print(stackTrace);
                          });
                        } else {
                          _db.collection(collection).doc(documentId).set({
                            "firstName": firstnameController.text.toString(),
                            "lastName": lastnameController.text.toString(),
                            "phoneNumber": number,
                            "gender": dropdownValue,
                            "dateOfBirth": dobController.text.toString()
                          }).whenComplete(() {
                            firstnameController.clear();
                            lastnameController.clear();
                            phoneController.clear();
                            dobController.clear();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Successfully Added"),
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  bottom: 20, right: 20, left: 20),
                            ));
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("stackTrace"),
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  bottom: 20, right: 20, left: 20),
                            ));
                            //print(stackTrace);
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Kindly fill out all feilds correctly"),
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.only(bottom: 20, right: 20, left: 20),
                        ));
                      }
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
                        "Update Profile",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
