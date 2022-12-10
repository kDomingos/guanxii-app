import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:qr_code_sample/models/personalmodel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

class QRScreen extends StatefulWidget {
  QRScreen(
      this.birthday,
      this.email,
      this.name,
      this.number,
      this.profilename,
      this.website,
      this.isedit,
      this.docid,
      this.countryCode,
      this.usingprofile,
      this.surname,
      this.business,
      this.positon,
      this.workphone,
      this.address);
  String name;
  String number;
  String email;
  String birthday;
  String website;
  String profilename;
  bool isedit;
  String docid;
  String countryCode;
  String usingprofile;
  String surname;
  String business;
  String positon;
  String workphone;
  String address;
  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  currentUser() {
    final User user = _firebaseAuth.currentUser!;
    final uid = user.uid.toString();
    return uid;
  }

  Widget progressBar() {
    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 13.0,
      animation: true,
      percent: 0.8,
      animationDuration: 1500,
      center: new Text(
        "90.0%",
        style: new TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: new Text(
          "Please wait we are saving the qr.",
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
    );
  }

  GlobalKey globalKey = new GlobalKey();
  var vCard = VCard();
  String? _name;
  String? _number;
  String? _email;
  String? _birthday;
  String? _website;
  String? _image;
  String? _profilename;
  String _dataString = "";
  Payload? payload;
  @override
  void initState() {
    super.initState();
    qrdataforpersonalprofile();
  }

  // ignore: non_constant_identifier_names
  String img_URL = '';
  File? _imageFile;
  bool saveimage = false;
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile!.path.split('/').last;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('QR_Codes/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        setState(() {
          img_URL = value;
          // print("Done: $value");
        });
      },
    );
  }

  Future<void> qrdataforpersonalprofile() async {
    if (widget.usingprofile == "personl") {
      vCard.firstName = widget.name;
      // vCard.middleName = 'MiddleName';
      // vCard.lastName = 'LastName';
      //vCard.organization = widget.website;
      // vCard.photo.embedFromFile(widget.image);
      //vCard.photo.embedFromString(widget.image, dynamic);
      vCard.workPhone = widget.countryCode + widget.number;
      vCard.birthday = DateTime.parse(widget.birthday);
      //vCard.jobTitle = widget.profilename;
      vCard.url = widget.website != "" ? 'https://${widget.website}' : "";
      // widget.website != "" ? vCard.url = 'https://${widget.website}' : "";
      vCard.email = widget.email;
    } else if (widget.usingprofile == "prof") {
      vCard.firstName = widget.name;
      // vCard.middleName = 'MiddleName';
      vCard.lastName = widget.surname;
      vCard.organization = widget.business;
      //Card.photo.embedFromFile(widget.image);
      vCard.cellPhone = widget.countryCode + widget.number;
      vCard.workPhone = widget.workphone;
      vCard.workAddress.street = widget.address;
      //vCard.birthday = DateTime.tryParse(widget.birthday);
      vCard.jobTitle = widget.positon;
      vCard.url = widget.website != "" ? 'https://${widget.website}' : "";
      vCard.email = widget.email;
    } else if (widget.usingprofile == "anti") {}

    // _profilename = widget.name;
    // _number = widget.number;
    // _name = widget.name;
    // _birthday = widget.birthday;
    // _image = widget.image;
    // _website = widget.email;
    // _email = widget.email;
    //   _dataString = '''
    // {
    // "profilename": ${widget.profilename};
    // "number": ${widget.number};
    // "name": ${widget.name};
    // "birthday": ${widget.birthday};
    // "image": ${widget.image};
    // "website": ${widget.website};
    // "email": ${widget.email};
    // }
    // ''';
  }

  // Future<String> createQrPicture(String qr) async {
  //   return path;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFFFFFFF),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                child: Row(
                  //mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        try {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.blueGrey[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                content: progressBar(),
                              );
                            },
                          );
                          RenderRepaintBoundary? boundary =
                              globalKey.currentContext?.findRenderObject()
                                  as RenderRepaintBoundary?;
                          var image = await boundary!.toImage();
                          ByteData? byteData = await image.toByteData(
                              format: ImageByteFormat.png);
                          Uint8List? pngBytes = byteData?.buffer.asUint8List();
                          // print('11111111 bytes $pngBytes');
                          final tempDir = await getExternalStorageDirectory();
                          final file = await File(
                                  '${tempDir?.path}/${DateTime.now().toString()}qrimage.png')
                              .create();
                          // print('11111111 file created $file');
                          await file.writeAsBytes(pngBytes!);
                          // bool res =
                          await GallerySaver.saveImage(file.path) ?? false;
                          setState(() {
                            _imageFile = file;
                          });
                          await uploadImageToFirebase(context)
                              .whenComplete(() async {
                            await Future.delayed(Duration(seconds: 7))
                                .whenComplete(() async {
                              Navigator.of(context).pop();
                              final FirebaseFirestore _db =
                                  FirebaseFirestore.instance;
                              final collection = 'users_profile';
                              final personal_qr_code = 'personal_qr_code';

                              final documentId = currentUser();
                              final snapShot = await _db
                                  .collection(collection)
                                  .doc(documentId)
                                  .collection(personal_qr_code)
                                  .doc(widget.docid)
                                  .get();

                              if (snapShot.exists) {
                                _db
                                    .collection(collection)
                                    .doc(documentId)
                                    .collection(personal_qr_code)
                                    .doc(widget.docid)
                                    .update({
                                  "name": widget.name,
                                  "email": widget.email,
                                  "website": widget.website,
                                  "phone": widget.number,
                                  "dateOfBirth": widget.birthday,
                                  "profile_name": widget.profilename,
                                  "qr_image": img_URL,
                                  "countryCode": widget.countryCode,
                                  "surname": widget.surname,
                                  "business": widget.business,
                                  "position": widget.positon,
                                  "profilestatus": widget.usingprofile,
                                  "address": widget.address,
                                  "workphone": widget.workphone
                                }).whenComplete(() {
                                  // print(dobController.text.toString());
                                  // print(emailController.text.toString());
                                  // print(img_URL);
                                  // print(firstnameController.text.toString());
                                  // print(number);
                                  // print(widget.name);
                                  // print(websiteController.text.toString());
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => QRScreen(
                                  //         dobController.text.toString(),
                                  //         emailController.text.toString(),
                                  //         img_URL,
                                  //         firstnameController.text.toString(),
                                  //         number,
                                  //         widget.name,
                                  //         websiteController.text.toString()),
                                  //   ),
                                  // );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("QR Saved and Updated"),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        bottom: 20, right: 20, left: 20),
                                  ));

                                  Navigator.of(context).pop();
                                });
                              } else if (widget.docid == "Empty") {
                                _db
                                    .collection(collection)
                                    .doc(documentId)
                                    .collection(personal_qr_code)
                                    //.doc(documentId)
                                    .add({
                                  "name": widget.name,
                                  "email": widget.email,
                                  "website": widget.website,
                                  "phone": widget.number,
                                  "dateOfBirth": widget.birthday,
                                  "profile_name": widget.profilename,
                                  "qr_image": img_URL,
                                  "countryCode": widget.countryCode,
                                  "surname": widget.surname,
                                  "business": widget.business,
                                  "position": widget.positon,
                                  "profilestatus": widget.usingprofile,
                                  "address": widget.address,
                                  "workphone": widget.workphone
                                }).whenComplete(() {
                                  // print(dobController.text.toString());
                                  // print(emailController.text.toString());
                                  // print(img_URL);
                                  // print(firstnameController.text.toString());
                                  // print(number);
                                  // print(widget.name);
                                  // print(websiteController.text.toString());
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => QRScreen(
                                  //         dobController.text.toString(),
                                  //         emailController.text.toString(),
                                  //         img_URL,
                                  //         firstnameController.text.toString(),
                                  //         number,
                                  //         widget.name,
                                  //         websiteController.text.toString()),
                                  //   ),
                                  // );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("QR Saved Successfully"),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        bottom: 20, right: 20, left: 20),
                                  ));

                                  Navigator.of(context).pop();
                                });
                              }
                              // if (snapShot.exists) {

                              // .onError((error, stackTrace) {
                              //   ScaffoldMessenger.of(context)
                              //       .showSnackBar(SnackBar(
                              //     content: Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: Text("stackTrace"),
                              //     ),
                              //     behavior: SnackBarBehavior.floating,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     //padding: EdgeInsets.all(10),
                              //     margin: EdgeInsets.only(
                              //         bottom: 20, right: 20, left: 20),
                              //   ));
                              //   //print(stackTrace);
                              // });
                              // }
                              // else {
                              //   _db
                              //       .collection(collection)
                              //       .doc(documentId)
                              //       .collection(personal_qr_code)
                              //       .doc(documentId)
                              //       .set({
                              //     "profile_name": widget.name,
                              //     "name": widget.name,
                              //     "image": img_URL,
                              //   }).whenComplete(() async {
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(SnackBar(
                              //       content: const Padding(
                              //         padding: EdgeInsets.all(8.0),
                              //         child: Text("QR Saved Successfully"),
                              //       ),
                              //       behavior: SnackBarBehavior.floating,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10),
                              //       ),
                              //       //padding: EdgeInsets.all(10),
                              //       margin: EdgeInsets.only(
                              //           bottom: 20, right: 20, left: 20),
                              //     ));

                              //     Navigator.of(context).pop();
                              //     // if (res) {
                              //     //   ScaffoldMessenger.of(context)
                              //     //       .showSnackBar(SnackBar(
                              //     //     content: const Padding(
                              //     //       padding: EdgeInsets.all(8.0),
                              //     //       child:
                              //     //           Text('QR Code Saved Successfuly'),
                              //     //     ),
                              //     //     behavior: SnackBarBehavior.floating,
                              //     //     shape: RoundedRectangleBorder(
                              //     //       borderRadius: BorderRadius.circular(10),
                              //     //     ),
                              //     //     //padding: EdgeInsets.all(10),
                              //     //     margin: EdgeInsets.only(
                              //     //         bottom: 20, right: 20, left: 20),
                              //     //   ));
                              //     // } else {
                              //     //   ScaffoldMessenger.of(context)
                              //     //       .showSnackBar(SnackBar(
                              //     //     content: const Padding(
                              //     //       padding: EdgeInsets.all(8.0),
                              //     //       child:
                              //     //           Text('Failed! QR Code Not Saved'),
                              //     //     ),
                              //     //     behavior: SnackBarBehavior.floating,
                              //     //     shape: RoundedRectangleBorder(
                              //     //       borderRadius: BorderRadius.circular(10),
                              //     //     ),
                              //     //     //padding: EdgeInsets.all(10),
                              //     //     margin: EdgeInsets.only(
                              //     //         bottom: 20, right: 20, left: 20),
                              //     //   ));
                              //     // }
                              //   });
                              // }
                            }).catchError((onError) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(onError),
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

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text(onError)));
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2254E0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                            child: Text(
                          "Save QR Code",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: RepaintBoundary(
                        key: globalKey,
                        child: Container(
                          color: Colors.white,
                          child: (QrImage(
                            data: vCard.getFormattedString(),
                            // data:abid,  uid,  txnid,
                            version: QrVersions.auto,
                            size: 320,
                            gapless: false,
                            // embeddedImage: AssetImage('assets/images/imgicon.png'),
                            // embeddedImageStyle: QrEmbeddedImageStyle(
                            //   size: Size(80, 80),
                            // ),
                          )),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
