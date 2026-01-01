import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../common/common.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Validators
  String? validEmail(String value) {
    if (!GetUtils.isEmail(value.trim())) {
      return "Please provide a valid email";
    }
    return null;
  }

  String? validPassword(String value) {
    if (value.trim().length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // Login function
  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    isLoading.value = true;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // Sign in with Firebase
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? user = _auth.currentUser;
      await user?.reload();
      user = _auth.currentUser;

      if (user == null) {
        snackMessage("User not found, please register");
        isLoading.value = false;
        return;
      }

      // Email verification check
      if (!user.emailVerified) {
        snackMessage("Please verify your email first");
        isLoading.value = false;
        return;
      }

      // Navigate to main screen
      Get.offAllNamed('/main');

    } on FirebaseAuthException catch (e) {
      // Friendly messages based on Firebase error codes
      if (e.code == 'user-not-found') {
        snackMessage("Please register this email first");
      } else if (e.code == 'wrong-password') {
        snackMessage("Incorrect password");
      } else if (e.code == 'invalid-email') {
        snackMessage("Invalid email format");
      } else {
        // For Web: override default Firebase message
        String message = e.message ?? "Login failed, please check your credentials";
        snackMessage(message);
      }
    }
    catch (e) {
      snackMessage("Something went wrong");
      print(e);
    }

    isLoading.value = false;
  }
}
