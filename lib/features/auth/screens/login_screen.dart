import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../routes/route_names.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthController controller = AuthController();

  bool hidePassword = true;

  void login() async {

    bool success = await controller.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if(success){
      Navigator.pushReplacementNamed(context, RouteNames.dashboard);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed")),
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            CustomTextField(
              hint: "Email",
              controller: emailController,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              hint: "Password",
              controller: passwordController,
              obscure: hidePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  hidePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: (){
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),
            ),

            // 👇 YEH NAYA ADD HUA HAI (Forgot Password)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){
                  Navigator.pushNamed(
                    context,
                    RouteNames.forgotPassword,
                  );
                },
                child: const Text("Forgot Password?"),
              ),
            ),

            const SizedBox(height: 10),

            CustomButton(
              text: "Login",
              onPressed: login,
            ),

            TextButton(
              onPressed: (){
                Navigator.pushNamed(context, RouteNames.signup);
              },
              child: const Text("Create Account"),
            )

          ],

        ),
      ),
    );
  }
}