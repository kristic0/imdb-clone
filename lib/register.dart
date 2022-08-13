import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imdb_clone/profile_page.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  //final FirebaseAuth _firebaseAuth;
  var rememberValue = false;

  final emailCtrlr = TextEditingController();
  final pwdCtrlr = TextEditingController();
  final pwdRepeatCtrlr = TextEditingController();
  final nameCtrlr = TextEditingController();
  final birthdayCtrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Register',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 1,
                    controller: emailCtrlr,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: pwdCtrlr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: pwdRepeatCtrlr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Repeat your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 1,
                    controller: nameCtrlr,
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      prefixIcon: const Icon(Icons.account_circle),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 1,
                    controller: birthdayCtrlr,
                    decoration: InputDecoration(
                      hintText: 'Your birthday',
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      var dateTime = DateTime.parse(date.toString());

                      birthdayCtrlr.text =
                          "${dateTime.day}.${dateTime.month}.${dateTime.year}.";
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var dataValid = false;

                      if (emailCtrlr.text.isEmpty ||
                          pwdCtrlr.text.isEmpty ||
                          pwdRepeatCtrlr.text.isEmpty ||
                          nameCtrlr.text.isEmpty ||
                          birthdayCtrlr.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: const Text('All fields must be filled'),
                              content: TextButton(
                                onPressed: () {
                                  Navigator.pop(_);
                                },
                                child: const Text("OK"),
                              )),
                        );
                      } else {
                        if (pwdCtrlr.text != pwdRepeatCtrlr.text) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                title: const Text('Passwords don\'t match'),
                                content: TextButton(
                                  onPressed: () {
                                    Navigator.pop(_);
                                  },
                                  child: const Text("OK"),
                                )),
                          );
                        } else {
                          dataValid = true;
                        }
                      }

                      if (dataValid) {
                        UserCredential result = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailCtrlr.text,
                                password: pwdCtrlr.text);

                        User? user = result.user;

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .set({
                          'name': nameCtrlr.text,
                          'birthday': birthdayCtrlr.text
                        });

                        var userData;
                        FirebaseFirestore.instance
                            .collection('users')
                            .where('uid', isEqualTo: user.uid)
                            .get()
                            .then((value) {
                          userData = value;
                        });

                        Navigator.of(context, rootNavigator: true)
                            .pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(user: user, userData: userData)),
                        );
                      }
                      // var user = await AccountService.login(
                      //     email: emailCtrlr.text, password: pwdCtrlr.text);

                      // if (user != null) {
                      //   Navigator.of(context, rootNavigator: false)
                      //       .pushReplacement(
                      //     MaterialPageRoute(
                      //         builder: (context) => ProfilePage(
                      //               user: user,
                      //             )),
                      //   );
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
