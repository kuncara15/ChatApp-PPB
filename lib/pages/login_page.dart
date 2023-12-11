import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_text_from_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/pages/header.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final double _height = 150;

  void signIn() {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    try {
      authServices.signInWithEmailndPassword(
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
                "Selamat Datang! Login akun anda",
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
              //signing button
              const SizedBox(
                height: 30,
              ),
              MyButton(
                title: "Sign In",
                onTap: signIn,
                buttonColor: Colors.blue,
              ),
              //not a member
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bukan member?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Registrasi",
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
