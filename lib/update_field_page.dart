import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateFieldPage extends StatefulWidget {
  String uid = '';
  String s = '';
  late IconData icon;

  var userData;

  UpdateFieldPage(IconData icon, String s, String uid, userData, {Key? key})
      : super(key: key) {
    this.uid = uid;
    this.s = s;
    this.icon = icon;
    this.userData = userData;
  }

  @override
  State<StatefulWidget> createState() =>
      _UpdateFieldPage(icon: icon, s: s, uid: uid, userData: userData);
}

class _UpdateFieldPage extends State<UpdateFieldPage> {
  final updateField = TextEditingController();

  var icon;
  var s;
  var uid;
  var userData;

  _UpdateFieldPage(
      {required this.icon,
      required this.s,
      required this.uid,
      required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: [
          const SizedBox(
            height: 300,
          ),
          TextFormField(
            maxLines: 1,
            controller: updateField,
            decoration: InputDecoration(
              hintText: 'Update your ${s}',
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              var collection = FirebaseFirestore.instance.collection('users');
              collection
                  .doc(uid)
                  .update({this.s: updateField.text}) // <-- Updated data
                  .then((_) => print('Success'))
                  .catchError((error) => print('Failed: $error'));

              Navigator.pop(context);

              setState(() {
                userData[s] = updateField.text;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
            ),
            child: const Text(
              'Update',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
