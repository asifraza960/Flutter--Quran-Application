import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constant/Constant.dart';
import '../../Controller/loginController.dart';
import '../../CustomWidget/Decoration.dart';
import '../Home_Screen/Main_Screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.3,
                    decoration: BoxDecoration(
                      color: Constants.kPrimary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(70),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 40,
                    right: 30,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),

              // Form
              Padding(
                padding: const EdgeInsets.only(top: 38, left: 8, right: 8),
                child: Column(
                  children: [
                    Form(
                      key: _loginController.formKey,
                      child: Column(
                        children: [
                          // EMAIL
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              controller: _loginController.emailController,
                              validator: (value) =>
                                  _loginController.validEmail(value!),
                              decoration: DecorationWidget(
                                context,
                                "Enter Email",
                                Icons.email,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // PASSWORD
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextFormField(
                              obscureText: true,
                              controller:
                              _loginController.passwordController,
                              validator: (value) =>
                                  _loginController.validPassword(value!),
                              decoration: DecorationWidget(
                                context,
                                "Enter Password",
                                Icons.vpn_key,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // FORGOT PASSWORD
                          Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            height: 40,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Constants.kPrimary,
                                ),
                              ),
                            ),
                          ),

                          // LOGIN BUTTON
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Constants.kPrimary,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Obx(
                                      () => _loginController.isLoading.value
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                onPressed: () {
                                  // _loginController.login();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Register Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.offNamed('/register');
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Constants.kPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
