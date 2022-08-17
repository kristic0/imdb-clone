import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileImage extends StatefulWidget {
  final ValueChanged<String> update;
  User user;

  UpdateProfileImage({required this.update, Key? key, required User this.user})
      : super(key: key);

  @override
  State<UpdateProfileImage> createState() =>
      _UpdateProfileImageState(update, user);
}

class _UpdateProfileImageState extends State<UpdateProfileImage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  late ValueChanged<String> update;
  late User user;

  _UpdateProfileImageState(ValueChanged<String> update, User user) {
    this.update = update;
    this.user = user;
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'profile-pics/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    update(urlDownload);

    var collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(user.uid)
        .update({'profileImage': urlDownload}) // <-- Updated data
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            if (pickedFile != null)
              Expanded(
                child: Image.file(File(pickedFile!.path!),
                    width: double.infinity, fit: BoxFit.cover),
              ),
            ElevatedButton(onPressed: selectFile, child: Text("select file")),
            ElevatedButton(onPressed: uploadFile, child: Text("upload file"))
          ],
        ),
      ),
    );
  }
}
