import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_text_from_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/pages/header.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final double _height = 120;

  //register metthod
  void register() {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "PassworMismatched",
          ),
        ),
      );
    } else {
      try {
        authServices.createUserWithEmailAndPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: _height, child: HeaderWidget(_height)),
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 40, // Ubah radius sesuai dengan kebutuhan
                child: Icon(
                  Icons.message,
                  size: 50, // Ubah ukuran ikon sesuai dengan kebutuhan
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
              ),

              //Welcome back message
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Selamat Datang! buat akun baru anda",
                style: TextStyle(fontSize: 16),
              ),
              //Email text field
              const SizedBox(
                height: 30,
              ),
              MyTextFormField(
                hintText: "Email",
                isObsecureText: false,
                controller: emailController,
              ),
              MyTextFormField(
                hintText: "Password",
                isObsecureText: true,
                controller: passwordController,
              ),
              MyTextFormField(
                hintText: "Confirm Password",
                isObsecureText: true,
                controller: confirmPasswordController,
              ),
              //signing button
              const SizedBox(
                height: 30,
              ),
              MyButton(
                title: "Register",
                onTap: register,
                buttonColor: Colors.blue,
              ),
              //not a member

              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah menjadi member?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
