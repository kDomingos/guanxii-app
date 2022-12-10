import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_sample/edit_qrScreen.dart';
import 'package:qr_code_sample/models/personalmodel.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qr_code_sample/constants.dart';
import 'package:qr_code_sample/qrscreen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EditPersonalProfileScreen extends StatefulWidget {
  EditPersonalProfileScreen(
      this.name, this.isedit, this.docid, this.usingprofile);
  String name, docid, usingprofile;
  bool isedit;

  @override
  State<EditPersonalProfileScreen> createState() =>
      _EditPersonalProfileScreenState();
}

class _EditPersonalProfileScreenState extends State<EditPersonalProfileScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var name;
  var vcnumber;
  var countrycode;
  var email;
  var birthday; // <-- The value you want to retrieve.
  var website;
  var surname;
  var business;
  var position;
  var currentprofile;
  var workphone;
  var address;

  currentUser() {
    final User user = _firebaseAuth.currentUser!;
    final uid = user.uid.toString();
    return uid;
  }

  String profileimg = "";
  String usingprofile = "";

  getuserdata() async {
    var collection = FirebaseFirestore.instance.collection('users_profile');
    var docSnapshot = await collection
        .doc(currentUser())
        .collection("personal_qr_code")
        .doc(widget.docid)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      name = data?['name'];
      vcnumber = data?['phone'];
      email = data?['email'];
      birthday = data?['dateOfBirth']; // <-- The value you want to retrieve.
      website = data?['website'];
      countrycode = data?['countryCode'];
      surname = data?['surname'];
      business = data?['business'];
      position = data?['position'];
      currentprofile = data?['profilestatus'];
      workphone = data?['workphone'];
      address = data?['address'];

      setState(() {
        widget.usingprofile = currentprofile;
        firstnameController.text = name;
        websiteController.text = website;
        emailController.text = email;
        dobController.text = birthday;
        phoneController.text = vcnumber;
        surnameController.text = surname;
        businessController.text = business;
        positionController.text = position;
        countryCode = countrycode;
        addressController.text = address;
        workphoneController.text = workphone;
      });

      print("hi");
      print(widget.docid);
      print(widget.usingprofile);
      print(name);
      print(number);
      print(email);
      print(birthday);
      print(website);
      // Call setState if needed.
    }
  }

  // ignore: non_constant_identifier_names
  String img_URL = '';
  bool saveimage = false;
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile!.path.split('/').last;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profileimages/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        setState(() {
          img_URL = value;
          print("Done: $value");
        });
      },
    );
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   print(currentUser());
  // }

  final _biodataformKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController workphoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  String number = "";
  String countryCode = "";
  TextEditingController dobController = TextEditingController();
  List<String> typeNeg = [
    "Male",
    "Female",
    "Other",
  ];
  Widget progressBar() {
    return CircularPercentIndicator(
      radius: 100.0,
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
          "we are updating your profile",
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
    );
  }

  File? _imageFile;
  final picker = ImagePicker();
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  void _uploadpictureModalBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )),
        backgroundColor: const Color(0xFFE2EEF6),
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Center(
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120.0),
                    child: Divider(
                      height: MediaQuery.of(context).size.height * 0.01,
                      thickness: 5.0,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pickImageFromGallery();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text(
                        "Upload from Device",
                        style: TextStyle(color: Colors.white),
                        //style: mainTextStyle,
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text(
                        'Take a photo',
                        style: TextStyle(color: Colors.white),
                        //style: s,
                      )),
                    ),
                  ),
                ]),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  String dropdownValue = "Male";
  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // title: const Text(
            //     ''),
            content: const Text(
              'Are you sure you want to leave the profile in the middle ?',
              textAlign: TextAlign.center,
            ),
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
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.isedit == true) {
    //   getuserdata();
    // }

    print(currentUser());
    print(widget.isedit);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          //centerTitle: true,
          elevation: 0.0,
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: const Color(0xFFE2EEF6),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                  key: _biodataformKey,
                  child: widget.usingprofile == "personl"
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 120,
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
                                      return 'Please enter your name.';
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
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                      hintText: 'Name',
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      errorStyle:
                                          const TextStyle(color: Colors.white)),
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
                                    disableLengthCheck: true,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    controller: phoneController,
                                    flagsButtonPadding:
                                        const EdgeInsets.only(left: 15.0),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        //counter: Offstage(),
                                        // suffixIcon: Icon(
                                        //   Icons.person,
                                        //   color: Colors.blue,
                                        // ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2.0),
                                        ),
                                        hintText: 'Phone Number',
                                        hintStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        errorStyle: const TextStyle(
                                            color: Colors.white)),
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
                                        countryCode =
                                            phone.countryCode.toString();
                                        number = phone.number.toString();
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
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  // validator: (value) {
                                  //   if (value!.isEmpty || !value.contains('@')) {
                                  //     return 'Please enter a valid email.';
                                  //   }
                                  //   return null;
                                  // },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.blue,
                                      ),
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
                                      hintText: 'Email',
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      errorStyle:
                                          const TextStyle(color: Colors.white)),
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
                                            DateFormat("yyyy-MM-dd")
                                                .format(selectedDate);
                                      }
                                    });
                                  },
                                  readOnly: true,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return 'Please enter your date of birth.';
                                  //   }
                                  //   return null;
                                  // },
                                  controller: dobController,
                                  //autofocus: true,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon:
                                          const Icon(Icons.date_range_sharp),
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
                                      hintText: 'Birthday',
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      errorStyle:
                                          const TextStyle(color: Colors.white)),
                                  //,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return 'Please enter website.';
                                  //   }
                                  //   return null;
                                  // },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: websiteController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: const Icon(
                                        Icons.web,
                                        color: Colors.blue,
                                      ),
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
                                      hintText: 'Website',
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      errorStyle:
                                          const TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                print(
                                  firstnameController.text.toString(),
                                );
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
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.blueGrey[900],
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        content: progressBar(),
                                      );
                                    },
                                  );
                                  await Future.delayed(
                                          const Duration(seconds: 5))
                                      .whenComplete(
                                          () => Navigator.pop(context));

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => EditQRScreen(
                                          dobController.text.toString(),
                                          emailController.text.toString(),
                                          firstnameController.text.toString(),
                                          number == "" ? vcnumber : number,
                                          widget.name,
                                          websiteController.text.toString(),
                                          widget.isedit,
                                          widget.docid,
                                          countryCode,
                                          widget.usingprofile,
                                          "",
                                          "",
                                          "",
                                          "",
                                          ""),
                                    ),
                                  );
                                  // final FirebaseFirestore _db =
                                  //     FirebaseFirestore.instance;
                                  // final collection = 'users_profile';
                                  // final personal = 'personal';
                                  // final documentId = currentUser();
                                  // final snapShot = await _db
                                  //     .collection(collection)
                                  //     .doc(documentId)
                                  //     .collection(personal)
                                  //     .doc(documentId)
                                  //     .get();

                                  // if (snapShot.exists) {
                                  //   _db
                                  //       .collection(collection)
                                  //       .doc(documentId)
                                  //       .collection(personal)
                                  //       .doc(documentId)
                                  //       .update({
                                  //     "profile_name": widget.name,
                                  //     "name": firstnameController.text.toString(),
                                  //     "email": emailController.text.toString(),
                                  //     "website": websiteController.text.toString(),
                                  //     "phone": number,
                                  //     "image": img_URL,
                                  //     "dateOfBirth": dobController.text.toString()
                                  //   }).whenComplete(() {
                                  //     // print(dobController.text.toString());
                                  //     // print(emailController.text.toString());
                                  //     // print(img_URL);
                                  //     // print(firstnameController.text.toString());
                                  //     // print(number);
                                  //     // print(widget.name);
                                  //     // print(websiteController.text.toString());
                                  //     Navigator.of(context).pushReplacement(
                                  //       MaterialPageRoute(
                                  //         builder: (context) => QRScreen(
                                  //             dobController.text.toString(),
                                  //             emailController.text.toString(),
                                  //             img_URL,
                                  //             firstnameController.text.toString(),
                                  //             number,
                                  //             widget.name,
                                  //             websiteController.text.toString()),
                                  //       ),
                                  //     );

                                  //     //Navigator.of(context).pop();
                                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  //       content: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text("Successfully Updated"),
                                  //       ),
                                  //       behavior: SnackBarBehavior.floating,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       ),
                                  //       //padding: EdgeInsets.all(10),
                                  //       margin: EdgeInsets.only(
                                  //           bottom: 20, right: 20, left: 20),
                                  //     ));
                                  //   }).onError((error, stackTrace) {
                                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  //       content: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text("stackTrace"),
                                  //       ),
                                  //       behavior: SnackBarBehavior.floating,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       ),
                                  //       //padding: EdgeInsets.all(10),
                                  //       margin: EdgeInsets.only(
                                  //           bottom: 20, right: 20, left: 20),
                                  //     ));
                                  //     //print(stackTrace);
                                  //   });
                                  // } else {
                                  //   _db
                                  //       .collection(collection)
                                  //       .doc(documentId)
                                  //       .collection(personal)
                                  //       .doc(documentId)
                                  //       .set({
                                  //     "profile_name": widget.name,
                                  //     "name": firstnameController.text.toString(),
                                  //     "email": emailController.text.toString(),
                                  //     "website": websiteController.text.toString(),
                                  //     "image": img_URL,
                                  //     "phone": number,
                                  //     "dateOfBirth": dobController.text.toString()
                                  //   }).whenComplete(() {
                                  //     // print(dobController.text.toString());
                                  //     // print(emailController.text.toString());
                                  //     // print(img_URL);
                                  //     // print(firstnameController.text.toString());
                                  //     // print(number);
                                  //     // print(widget.name);
                                  //     // print(websiteController.text.toString());
                                  //     Navigator.of(context).pushReplacement(
                                  //       MaterialPageRoute(
                                  //         builder: (context) => QRScreen(
                                  //             dobController.text.toString(),
                                  //             emailController.text.toString(),
                                  //             img_URL,
                                  //             firstnameController.text.toString(),
                                  //             number,
                                  //             widget.name,
                                  //             websiteController.text.toString()),
                                  //       ),
                                  //     );
                                  //     //Navigator.of(context).pop();

                                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  //       content: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text("Successfully Added"),
                                  //       ),
                                  //       behavior: SnackBarBehavior.floating,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       ),
                                  //       //padding: EdgeInsets.all(10),
                                  //       margin: EdgeInsets.only(
                                  //           bottom: 20, right: 20, left: 20),
                                  //     ));
                                  //   }).onError((error, stackTrace) {
                                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  //       content: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text("stackTrace"),
                                  //       ),
                                  //       behavior: SnackBarBehavior.floating,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       ),
                                  //       //padding: EdgeInsets.all(10),
                                  //       margin: EdgeInsets.only(
                                  //           bottom: 20, right: 20, left: 20),
                                  //     ));
                                  //     //print(stackTrace);
                                  //   });
                                  // }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          "Kindly fill out all feilds correctly"),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //padding: EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        bottom: 20, right: 20, left: 20),
                                  ));
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2254E0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                    child: Text(
                                  "Update Profile",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        )
                      : widget.usingprofile == "prof"
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 120,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: TextFormField(
                                            onTap: () async {},
                                            //readOnly: true,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter your name.';
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                ),
                                                hintText: 'Name',
                                                hintStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                errorStyle: const TextStyle(
                                                    color: Colors.white)),
                                            //,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: TextFormField(
                                            onTap: () async {},
                                            //readOnly: true,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter surname.';
                                              }
                                              return null;
                                            },
                                            controller: surnameController,
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                ),
                                                hintText: 'Surname',
                                                hintStyle: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                errorStyle: const TextStyle(
                                                    color: Colors.white)),
                                            //,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: TextFormField(
                                              onTap: () async {},
                                              //readOnly: true,
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
                                              //     return 'Enter business.';
                                              //   }
                                              //   return null;
                                              // },
                                              controller: businessController,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0),
                                                  ),
                                                  hintText: 'Business',
                                                  hintStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  errorStyle: const TextStyle(
                                                      color: Colors.white)),
                                              //,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: TextFormField(
                                              onTap: () async {},
                                              //readOnly: true,
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
                                              //     return 'Please enter your positon.';
                                              //   }
                                              //   return null;
                                              // },
                                              controller: positionController,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0),
                                                  ),
                                                  hintText: 'Position',
                                                  hintStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  errorStyle: const TextStyle(
                                                      color: Colors.white)),
                                              //,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: IntlPhoneField(
                                        disableLengthCheck: true,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        controller: phoneController,
                                        flagsButtonPadding:
                                            const EdgeInsets.only(left: 15.0),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            //counter: Offstage(),
                                            // suffixIcon: Icon(
                                            //   Icons.person,
                                            //   color: Colors.blue,
                                            // ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0),
                                            ),
                                            hintText: 'Phone Number',
                                            hintStyle: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            errorStyle: const TextStyle(
                                                color: Colors.white)),
                                        // decoration: const InputDecoration(
                                        //   counter: Offstage(),
                                        //   labelText: 'Mobile Number',
                                        //   border: OutlineInputBorder(
                                        //     borderSide: BorderSide(),
                                        //   ),
                                        // ),
                                        initialCountryCode: 'ES',
                                        showDropdownIcon: true,
                                        dropdownIconPosition:
                                            IconPosition.trailing,
                                        onChanged: (phone) {
                                          setState(() {
                                            countryCode =
                                                phone.countryCode.toString();
                                            number = phone.number.toString();
                                            print(number);
                                          });
                                          print(phone.completeNumber);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      // validator: (value) {
                                      //   if (value!.isEmpty || !value.contains('@')) {
                                      //     return 'Please enter a valid email.';
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.phone,
                                      controller: workphoneController,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          // suffixIcon: Icon(
                                          //   Icons.email_outlined,
                                          //   color: Colors.blue,
                                          // ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          hintText: 'Work Phone Number',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          errorStyle: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      // validator: (value) {
                                      //   if (value!.isEmpty || !value.contains('@')) {
                                      //     return 'Please enter a valid email.';
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          suffixIcon: const Icon(
                                            Icons.email_outlined,
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          hintText: 'Email',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          errorStyle: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      // validator: (value) {
                                      //   if (value!.isEmpty || !value.contains('@')) {
                                      //     return 'Please enter a valid email.';
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.streetAddress,
                                      controller: addressController,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          // suffixIcon: Icon(
                                          //   Icons.email_outlined,
                                          //   color: Colors.blue,
                                          // ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          hintText: 'Address',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          errorStyle: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width:
                                //       MediaQuery.of(context).size.width / 1.2,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: TextFormField(
                                //       onTap: () async {
                                //         await showDatePicker(
                                //           context: context,
                                //           initialDate: DateTime.now(),
                                //           firstDate: DateTime(1980),
                                //           lastDate: DateTime(2025),
                                //         ).then((selectedDate) {
                                //           if (selectedDate != null) {
                                //             dobController.text =
                                //                 DateFormat('dd-MM-yyyy')
                                //                     .format(selectedDate);
                                //           }
                                //         });
                                //       },
                                //       readOnly: true,
                                //       // validator: (value) {
                                //       //   if (value!.isEmpty) {
                                //       //     return 'Please enter your date of birth.';
                                //       //   }
                                //       //   return null;
                                //       // },
                                //       controller: dobController,
                                //       //autofocus: true,
                                //       keyboardType: TextInputType.text,
                                //       decoration: InputDecoration(
                                //           filled: true,
                                //           fillColor: Colors.white,
                                //           suffixIcon:
                                //               Icon(Icons.date_range_sharp),
                                //           // suffixIcon: Icon(
                                //           //   Icons.person,
                                //           //   color: Colors.blue,
                                //           // ),
                                //           border: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(15),
                                //           ),
                                //           focusedBorder: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(15),
                                //             borderSide: BorderSide(
                                //                 color: Colors.white,
                                //                 width: 2.0),
                                //           ),
                                //           enabledBorder: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(15),
                                //             borderSide: BorderSide(
                                //                 color: Colors.white,
                                //                 width: 2.0),
                                //           ),
                                //           hintText: 'Birthday',
                                //           hintStyle: TextStyle(
                                //               fontWeight: FontWeight.bold),
                                //           errorStyle:
                                //               TextStyle(color: Colors.white)),
                                //       //,
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return 'Please enter website.';
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.emailAddress,
                                      controller: websiteController,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          suffixIcon: const Icon(
                                            Icons.web,
                                            color: Colors.blue,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                          hintText: 'Website',
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          errorStyle: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
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

                                    if (_biodataformKey.currentState!
                                        .validate()) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                Colors.blueGrey[900],
                                            // ignore: prefer_const_constructors
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10.0))),
                                            content: progressBar(),
                                          );
                                        },
                                      );
                                      await Future.delayed(
                                              const Duration(seconds: 10))
                                          .whenComplete(
                                              () => Navigator.pop(context));

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => EditQRScreen(
                                            "",
                                            emailController.text.toString(),
                                            firstnameController.text.toString(),
                                            number == "" ? vcnumber : number,
                                            widget.name,
                                            websiteController.text.toString(),
                                            widget.isedit,
                                            widget.docid,
                                            countryCode,
                                            widget.usingprofile,
                                            surnameController.text.toString(),
                                            businessController.text.toString(),
                                            positionController.text.toString(),
                                            workphoneController.text.toString(),
                                            addressController.text.toString(),
                                          ),
                                        ),
                                      );
                                      // final FirebaseFirestore _db =
                                      //     FirebaseFirestore.instance;
                                      // final collection = 'users_profile';
                                      // final personal = 'personal';
                                      // final documentId = currentUser();
                                      // final snapShot = await _db
                                      //     .collection(collection)
                                      //     .doc(documentId)
                                      //     .collection(personal)
                                      //     .doc(documentId)
                                      //     .get();

                                      // if (snapShot.exists) {
                                      //   _db
                                      //       .collection(collection)
                                      //       .doc(documentId)
                                      //       .collection(personal)
                                      //       .doc(documentId)
                                      //       .update({
                                      //     "profile_name": widget.name,
                                      //     "name": firstnameController.text.toString(),
                                      //     "email": emailController.text.toString(),
                                      //     "website": websiteController.text.toString(),
                                      //     "phone": number,
                                      //     "image": img_URL,
                                      //     "dateOfBirth": dobController.text.toString()
                                      //   }).whenComplete(() {
                                      //     // print(dobController.text.toString());
                                      //     // print(emailController.text.toString());
                                      //     // print(img_URL);
                                      //     // print(firstnameController.text.toString());
                                      //     // print(number);
                                      //     // print(widget.name);
                                      //     // print(websiteController.text.toString());
                                      //     Navigator.of(context).pushReplacement(
                                      //       MaterialPageRoute(
                                      //         builder: (context) => QRScreen(
                                      //             dobController.text.toString(),
                                      //             emailController.text.toString(),
                                      //             img_URL,
                                      //             firstnameController.text.toString(),
                                      //             number,
                                      //             widget.name,
                                      //             websiteController.text.toString()),
                                      //       ),
                                      //     );

                                      //     //Navigator.of(context).pop();
                                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //       content: Padding(
                                      //         padding: const EdgeInsets.all(8.0),
                                      //         child: Text("Successfully Updated"),
                                      //       ),
                                      //       behavior: SnackBarBehavior.floating,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(10),
                                      //       ),
                                      //       //padding: EdgeInsets.all(10),
                                      //       margin: EdgeInsets.only(
                                      //           bottom: 20, right: 20, left: 20),
                                      //     ));
                                      //   }).onError((error, stackTrace) {
                                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //       content: Padding(
                                      //         padding: const EdgeInsets.all(8.0),
                                      //         child: Text("stackTrace"),
                                      //       ),
                                      //       behavior: SnackBarBehavior.floating,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(10),
                                      //       ),
                                      //       //padding: EdgeInsets.all(10),
                                      //       margin: EdgeInsets.only(
                                      //           bottom: 20, right: 20, left: 20),
                                      //     ));
                                      //     //print(stackTrace);
                                      //   });
                                      // } else {
                                      //   _db
                                      //       .collection(collection)
                                      //       .doc(documentId)
                                      //       .collection(personal)
                                      //       .doc(documentId)
                                      //       .set({
                                      //     "profile_name": widget.name,
                                      //     "name": firstnameController.text.toString(),
                                      //     "email": emailController.text.toString(),
                                      //     "website": websiteController.text.toString(),
                                      //     "image": img_URL,
                                      //     "phone": number,
                                      //     "dateOfBirth": dobController.text.toString()
                                      //   }).whenComplete(() {
                                      //     // print(dobController.text.toString());
                                      //     // print(emailController.text.toString());
                                      //     // print(img_URL);
                                      //     // print(firstnameController.text.toString());
                                      //     // print(number);
                                      //     // print(widget.name);
                                      //     // print(websiteController.text.toString());
                                      //     Navigator.of(context).pushReplacement(
                                      //       MaterialPageRoute(
                                      //         builder: (context) => QRScreen(
                                      //             dobController.text.toString(),
                                      //             emailController.text.toString(),
                                      //             img_URL,
                                      //             firstnameController.text.toString(),
                                      //             number,
                                      //             widget.name,
                                      //             websiteController.text.toString()),
                                      //       ),
                                      //     );
                                      //     //Navigator.of(context).pop();

                                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //       content: Padding(
                                      //         padding: const EdgeInsets.all(8.0),
                                      //         child: Text("Successfully Added"),
                                      //       ),
                                      //       behavior: SnackBarBehavior.floating,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(10),
                                      //       ),
                                      //       //padding: EdgeInsets.all(10),
                                      //       margin: EdgeInsets.only(
                                      //           bottom: 20, right: 20, left: 20),
                                      //     ));
                                      //   }).onError((error, stackTrace) {
                                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //       content: Padding(
                                      //         padding: const EdgeInsets.all(8.0),
                                      //         child: Text("stackTrace"),
                                      //       ),
                                      //       behavior: SnackBarBehavior.floating,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(10),
                                      //       ),
                                      //       //padding: EdgeInsets.all(10),
                                      //       margin: EdgeInsets.only(
                                      //           bottom: 20, right: 20, left: 20),
                                      //     ));
                                      //     //print(stackTrace);
                                      //   });
                                      // }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              "Kindly fill out all feilds correctly"),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        //padding: EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(
                                            bottom: 20, right: 20, left: 20),
                                      ));
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2254E0),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                        child: Text(
                                      "Update Profile",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            )
                          : Container()),
            ),
          ),
        ),
      ),
    );
  }
}
