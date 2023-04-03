import 'package:flutter/material.dart';
import 'package:guanxii_app/login.dart';
import 'package:guanxii_app/utilities/firebase_utilities.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextStyle mainTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
  TextEditingController _email = TextEditingController();

  // final FocusNode _emailFocus = FocusNode();
  final _forgetpassformKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFF6AC4FE),
        appBar: AppBar(
          //backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          title: const Text("Forget Password"),
        ),
        body: isLoading == false
            ? SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _forgetpassformKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: width / 1.2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: _email,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.blue,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  hintText: 'Enter Your Email',
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  errorStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          // style: ElevatedButton.styleFrom(
                          //     primary: AppColor.primaryColor),
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (_forgetpassformKey.currentState!.validate()) {
                              FirebaseUtils()
                                  .resetPassword(
                                email: _email.text.trim(),
                              )
                                  .then((value) {
                                if (value == "Email sent") {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Recovery password email has been sent check your mail.')));
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)));
                                }
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Container(
                            width: width / 2,
                            height: height * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(
                              'Submit',
                              style: mainTextStyle,
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
              )
            : const Center(child: const CircularProgressIndicator()));
  }
}
