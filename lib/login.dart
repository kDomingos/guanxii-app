// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_sample/HomePage.dart';
import 'package:qr_code_sample/constants.dart';
import 'package:qr_code_sample/forgetpassword.dart';
import 'package:qr_code_sample/utilities/firebase_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  String titleText = 'Sign In';
  String loginText = 'Sign Up Now';
  final _signinformKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isSignUp = false;
  bool isSignIn = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextStyle mainTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF6AC4FE),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _signinformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 100,
                        // ignore: sort_child_properties_last
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Image.asset(
                            "assets/images/guanxii.png",
                            cacheWidth: 50 * window.devicePixelRatio.ceil(),
                            cacheHeight: 50 * window.devicePixelRatio.ceil(),
                            gaplessPlayback: true,
                            //style: TextStyle(fontSize: 18),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color(0xFFE2EEF6)),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: isSignIn ? 1.5 : 0.0,
                                    color: isSignIn
                                        ? Colors.white
                                        : Colors.transparent),
                              ),
                            ),
                            child: ElevatedButton(
                                // ignore: sort_child_properties_last
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    "Sign In",
                                    style: isSignIn
                                        ? const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            letterSpacing: 1.0)
                                        : TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            fontSize: 20,
                                            letterSpacing: 1.0),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0.0, backgroundColor: Colors.transparent),
                                onPressed: () {
                                  loginText = 'Login Instead';
                                  titleText = 'Sign In';
                                  //isLogin = !isLogin;
                                  nameController.clear();
                                  emailController.clear();
                                  passwordController.clear();
                                  //passwordVisible = true;
                                  setState(() {
                                    isSignIn = true;
                                    isSignUp = false;
                                    passwordVisible = !passwordVisible;
                                  });
                                  // loginText = 'Login Instead';
                                  // titleText = 'Sign Up';

                                  //isSignUp = true;
                                  // nameController.clear();
                                  // emailController.clear();
                                  // passwordController.clear();
                                  // passwordVisible = true;
                                }),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: isSignUp ? 1.5 : 0.0,
                                    color: isSignUp
                                        ? Colors.white
                                        : Colors.transparent),
                              ),
                            ),
                            child: ElevatedButton(
                                // ignore: sort_child_properties_last
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    "Sign Up",
                                    style: isSignUp
                                        ? const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            letterSpacing: 1.0)
                                        : TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            fontSize: 20,
                                            letterSpacing: 1.0),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0.0, backgroundColor: Colors.transparent),
                                onPressed: () {
                                  loginText = 'Sign Up Now';
                                  titleText = 'Sign Up';
                                  // isLogin = !isLogin;
                                  nameController.clear();
                                  emailController.clear();
                                  passwordController.clear();
                                  //passwordVisible = true;
                                  setState(() {
                                    isSignIn = false;
                                    isSignUp = true;
                                    passwordVisible = !passwordVisible;
                                  });

                                  //isSignUp = false;
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const SignupScreen()),
                                  //     (route) => false);
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    isSignIn
                        ? const SizedBox()
                        : SizedBox(
                            width: width / 1.2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your name.';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                controller: nameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: const Icon(
                                      Icons.person,
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
                                    hintText: 'Enter Your Name',
                                    hintStyle:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                    errorStyle: const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                    // Container(
                    //   width: width * 0.8,
                    //   height: height * 0.07,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: TextFormField(
                    //       keyboardType: TextInputType.emailAddress,
                    //       controller: nameController,
                    //       decoration: const InputDecoration(
                    //           floatingLabelBehavior: FloatingLabelBehavior.never,
                    //           label: Text('Enter Your Name'),
                    //           border: InputBorder.none),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    SizedBox(
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
                                borderSide:
                                    const BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText: 'Enter Your Email',
                              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                              errorStyle: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    SizedBox(
                      width: width / 1.2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: passwordVisible,
                          controller: passwordController,
                          validator: (value) {
                            if (value!.length < 8) {
                              return 'Password must be 8 characters.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white, width: 2.0),
                              ),
                              hintText: 'Enter Password',
                              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                              errorStyle: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: width * 0.8,
                    //   height: height * 0.07,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: TextFormField(
                    //       obscureText: !passwordVisible,
                    //       controller: passwordController,
                    //       decoration: InputDecoration(
                    //           suffixIcon: IconButton(
                    //             icon: Icon(
                    //               // Based on passwordVisible state choose the icon
                    //               passwordVisible
                    //                   ? Icons.visibility_off
                    //                   : Icons.visibility,
                    //               color: Colors.blue,
                    //             ),
                    //             onPressed: () {
                    //               // Update the state i.e. toogle the state of passwordVisible variable
                    //               setState(() {
                    //                 passwordVisible = !passwordVisible;
                    //               });
                    //             },
                    //           ),
                    //           floatingLabelBehavior: FloatingLabelBehavior.never,
                    //           label: const Text('password'),
                    //           border: InputBorder.none),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: height * 0.01,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 45.0),
                    //       child: InkWell(
                    //         onTap: () {
                    //           if (isLogin) {
                    //             loginText = 'Login Instead';
                    //             titleText = 'Sign Up';
                    //             isLogin = !isLogin;
                    //             nameController.clear();
                    //             emailController.clear();
                    //             passwordController.clear();
                    //             passwordVisible = true;
                    //           } else {
                    //             loginText = 'Sign Up Now';
                    //             titleText = 'Login';
                    //             isLogin = !isLogin;
                    //             nameController.clear();
                    //             emailController.clear();
                    //             passwordController.clear();
                    //             passwordVisible = true;
                    //           }
                    //           setState(() {});
                    //         },
                    //         child: Text(
                    //           loginText,
                    //           style: const TextStyle(
                    //               fontSize: 18,
                    //               color: Colors.white,
                    //               decoration: TextDecoration.underline),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    SizedBox(
                      height: height * 0.03,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_signinformKey.currentState!.validate()) {
                          if (!isSignIn) {
                            String res = await FirebaseUtils.signup(
                                emailController.text, passwordController.text);
                            if (res == 'Success') {
                              loginText = 'Sign Up Now';
                              titleText = 'Sign In';
                              //isLogin = !isLogin;
                              FirebaseUtils.addUser(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text);
                              userName = nameController.text;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(userNamekey, usermail);

                              nameController.clear();
                              emailController.clear();
                              passwordController.clear();
                              setState(() {
                                isSignIn = true;
                                isSignUp = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                //padding: EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                    bottom: 20, right: 20, left: 20),
                                content: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Text('Signed Up Successfully, Login Now'),
                                ),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(res),
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
                          } else {
                            String res = await FirebaseUtils.login(
                                emailController.text, passwordController.text);
                            if (res == 'Success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Login Successfully'),
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                //padding: EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                    bottom: 20, right: 20, left: 20),
                              ));
                              usermail = emailController.text;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(userMailKey, usermail);
                              prefs.setBool(isLoginKey, true);

                              avatarimage =
                                  prefs.getString(avatarimageurlkey) ?? '';

                              //print('111 user mail' + usermail);
                              await FirebaseUtils.loadAdminData();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(avatarimage),
                                  ),
                                  ((route) => false));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(res),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  //padding: EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                      bottom: 20, right: 20, left: 20),
                                ),
                              );
                            }
                          }
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
                          titleText,
                          style: mainTextStyle,
                        )),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
                        );
                      },
                      child: const Text("Forgot Password ?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 0.5)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
