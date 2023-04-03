// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanxii_app/constants.dart';
import 'package:guanxii_app/login.dart';
import 'package:guanxii_app/models/profile.dart';
import 'package:guanxii_app/utilities/firebase_utilities.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key, required this.isUpdating, this.profile, this.docRef})
      : super(key: key);
  final bool isUpdating;
  final Profile? profile;
  final docRef;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController profileNameController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdating) {
      nameController.text = widget.profile!.name ?? '';
      dayController.text = widget.profile!.dayOfBirth ?? '';
      phoneController.text = widget.profile!.phoneNo ?? '';
      websiteController.text = widget.profile!.website ?? '';
      addressController.text = widget.profile!.address ?? '';
      emailController.text = widget.profile!.email ?? '';
      profileNameController.text = widget.profile!.profileName ?? '';
    }
  }

  File? image;
  bool isLoading = false;

  TextStyle mainTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_sharp)),
                      IconButton(
                          onPressed: () async {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                          },
                          icon: const Icon(Icons.logout)),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                GestureDetector(
                  onTap: () async {
                    XFile? img =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (img != null) {
                      image = File(img.path);
                      setState(() {
                        print(image!.path);
                      });
                    }
                  },
                  child: Container(
                      width: width * 0.8,
                      height: height * 0.16,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: image != null
                                  ? Image.file(
                                      image!,
                                      fit: BoxFit.contain,
                                    ).image
                                  : !widget.isUpdating
                                      ? Image.network(
                                              'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png')
                                          .image
                                      : Image.network(
                                          widget.profile!.imgURL ??
                                              'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png',
                                          fit: BoxFit.contain,
                                        ).image),
                          shape: BoxShape.circle),
                      child: SizedBox()),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: profileNameController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text('Profile Name'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text('Name'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: dayController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text('Day of Birth'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text('Phone Number'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text('Enter Your Email'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: websiteController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text('Website'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text('Address'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                InkWell(
                  onTap: () async {
                    if (nameController.text.isNotEmpty) {
                      isLoading = true;
                      setState(() {});
                      String imgPath = '';
                      if (image != null) {
                        imgPath = await FirebaseUtils.uploadItemImage(image!);
                      } else if (widget.isUpdating) {
                        imgPath = widget.profile!.imgURL ?? '';
                      }
                      Profile profile = Profile(
                          profileName: profileNameController.text,
                          userMail: usermail,
                          address: addressController.text,
                          imgURL: imgPath,
                          name: nameController.text,
                          dayOfBirth: dayController.text,
                          phoneNo: phoneController.text,
                          email: emailController.text,
                          website: websiteController.text);
                      if (widget.isUpdating) {
                        FirebaseUtils.updateProfile(
                            profile: profile, docRef: widget.docRef);
                      } else {
                        FirebaseUtils.addProfile(profile);
                      }
                      isLoading = false;
                      var vCard = VCard();
                      vCard.firstName = profile.name!;
                      // vCard.middleName = 'MiddleName';
                      // vCard.lastName = 'LastName';
                      vCard.organization = profile.website;
                      vCard.photo.attachFromUrl('imgPath', 'PNG');
                      vCard.workPhone = profile.phoneNo;
                      //vCard.birthday = DateTime.now();
                      vCard.jobTitle = profile.profileName;
                      //vCard.url = 'https://github.com/valerycolong';
                      vCard.email = profile.email;
                      setState(() {});
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            GlobalKey screenShotKey = GlobalKey();
                            return Scaffold(
                              backgroundColor: Colors.transparent,
                              body: Center(
                                child: Container(
                                  color: Colors.white,
                                  height: 600,
                                  width: width * 0.9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                              Icons.cancel_outlined)),
                                      RepaintBoundary(
                                        key: screenShotKey,
                                        child: QrImage(
                                          data: vCard.getFormattedString(),
                                          size: 320,
                                          gapless: false,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MaterialButton(
                                              color: Colors.blue,
                                              child: Text('Save to Firebase'),
                                              onPressed: () async {
                                                RenderRepaintBoundary?
                                                    boundary = screenShotKey
                                                            .currentContext
                                                            ?.findRenderObject()
                                                        as RenderRepaintBoundary?;
                                                var image =
                                                    await boundary!.toImage();
                                                ByteData? byteData =
                                                    await image.toByteData(
                                                        format: ImageByteFormat
                                                            .png);
                                                Uint8List? pngBytes = byteData
                                                    ?.buffer
                                                    .asUint8List();
                                                print(
                                                    '11111111 bytes $pngBytes');
                                                final tempDir =
                                                    await getExternalStorageDirectory();
                                                final file = await File(
                                                        '${tempDir?.path}/${DateTime.now().toString()}qrimage.png')
                                                    .create();
                                                print(
                                                    '11111111 file created $file');
                                                await file
                                                    .writeAsBytes(pngBytes!);
                                                String qrPath =
                                                    await FirebaseUtils
                                                        .uploadItemImage(file);
                                                FirebaseUtils.addQR(
                                                    profile.email! +
                                                        profile.profileName! +
                                                        profile.website!,
                                                    qrPath);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'QR Code Saved Successfuly')));
                                              }),
                                          MaterialButton(
                                              color: Colors.blue,
                                              onPressed: () async {
                                                try {
                                                  RenderRepaintBoundary?
                                                      boundary = screenShotKey
                                                              .currentContext
                                                              ?.findRenderObject()
                                                          as RenderRepaintBoundary?;
                                                  var image =
                                                      await boundary!.toImage();
                                                  ByteData? byteData =
                                                      await image.toByteData(
                                                          format:
                                                              ImageByteFormat
                                                                  .png);
                                                  Uint8List? pngBytes = byteData
                                                      ?.buffer
                                                      .asUint8List();
                                                  print(
                                                      '11111111 bytes $pngBytes');
                                                  final tempDir =
                                                      await getExternalStorageDirectory();
                                                  final file = await File(
                                                          '${tempDir?.path}/${DateTime.now().toString()}qrimage.png')
                                                      .create();
                                                  print(
                                                      '11111111 file created $file');
                                                  await file
                                                      .writeAsBytes(pngBytes!);
                                                  bool res = await GallerySaver
                                                          .saveImage(
                                                              file.path) ??
                                                      false;
                                                  if (res) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'QR Code Saved Successfuly')));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Failed! QR Code Not Saved')));
                                                  }
                                                } catch (e) {
                                                  print(e);
                                                }
                                              },
                                              child: const Text(
                                                  'Save To Gallery')),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter User Name')));
                    }
                  },
                  child: Container(
                    width: width * 0.8,
                    height: height * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: !isLoading
                            ? Text(
                                'Create Profile',
                                style: mainTextStyle,
                              )
                            : CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
