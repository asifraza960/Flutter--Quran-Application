import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../common/common.dart';
class RegisterController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var name = '';
  var email = '';
  var password = '';

  var isImgAvailable = false.obs;
  final _picker = ImagePicker();
  var selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;
  var isLoading = false.obs;

  CollectionReference userDatBaseReference = FirebaseFirestore.instance
      .collection("user");
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void getImage(ImageSource imageSource) async {
    final pickedFile = await _picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      selectedImageSize.value =
          "${((File(selectedImagePath.value)).lengthSync() / 1024 / 1024)
              .toStringAsFixed(2)} Mb";
      isImgAvailable.value = true;
    } else {
      isImgAvailable.value = false;
      snackMessage("No image selected");
    }
  }

  String? validName(String value) {
    if (value.length < 3) {
      return "Name must be 3 characters";
    }
    return null;
  }

  String? validEmail(String value) {
    if (!GetUtils.isEmail(value.trim())) {
      return "Please Provide Valid Email";
    }
    return null;
  }

  String? validPassword(String value) {
    if (value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }

  Future<void> registration() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    isLoading.value = true;

    formKey.currentState!.save();

    userRegister(email.trim(), password.toString().trim()).then((credentials) {
      if (credentials != null) {
      } else {
        snackMessage("User already exist");
      }
      isLoading.value = false;
    });

  }

  Future<UserCredential?> userRegister(String email, String password) async {
    try {
      // Create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = FirebaseAuth.instance.currentUser;

      // Send verification email only ONCE
      await user!.sendEmailVerification();
      snackMessage("Verification email sent! Check your inbox.");

      // Save user info to firestore
      await saveDataToDb();

      // Redirect to login page
      Get.offAllNamed('/login');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        snackMessage("This email is already registered.");
      } else if (e.code == "invalid-email") {
        snackMessage("Invalid email.");
      } else if (e.code == "weak-password") {
        snackMessage("Password is too weak.");
      } else {
        snackMessage(e.message ?? "Unknown error");
      }
      return null;
    }
  }


  Future<String?> uploadFile(filePath) async {
    File file = File(filePath);
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String randomStr = String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );

    try {
      await _storage.ref('uploads/user/${randomStr}').putFile(file);
    } on FirebaseException catch (e) {
      snackMessage(e.code.toString());
    }
    String downloadURL = await _storage
        .ref('uploads/user/${randomStr}')
        .getDownloadURL();

    return downloadURL;
  }

  Future<void> saveDataToDb() async {
    User? user = FirebaseAuth.instance.currentUser;
    await userDatBaseReference.doc(user!.uid).set({
      'uid': user.uid,
      'name': name,
      'email': email,
      'url': '',
    });
    return;
  }

  void updateProfile(String argUrl) {
    User? user = FirebaseAuth.instance.currentUser;

    if (isImgAvailable == true) {
      uploadFile(selectedImagePath.value).then((url) {
        if (url != null) {
          userDatBaseReference.doc(user!.uid).update({
            'uid': user.uid,
            'name': nameController.text,
            'email': emailController.text,
            'url': url,
          });
        } else {
          snackMessage("Image not Uploaded");
        }
      });
    } else {
      userDatBaseReference.doc(user!.uid).update({
        'uid': user.uid,
        'name': nameController.text,
        'email': emailController.text,
        'url': argUrl == "" ? '' : argUrl,
      });

    }
  }
}
