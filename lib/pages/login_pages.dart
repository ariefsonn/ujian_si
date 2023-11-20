import 'package:flutter/material.dart';
import 'package:ujian_si/data/helper.dart';
import 'package:ujian_si/pages/home_page.dart';
import 'package:ujian_si/pages/register_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cMail = TextEditingController();
  final cPassword = TextEditingController();

  Future<void> login() async {
    String email = cMail.text;
    String password = cPassword.text;

    bool loggedIn = await DatabaseHelper.instance.login(email, password);

    if (loggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 200),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Sign In', style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 27,
                  fontStyle: FontStyle.normal
              )),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                controller: cMail,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                controller: cPassword,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF5258D4)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(49))),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Euclid Circular B',
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterPage()));
                },
                child: const Text("Want to register?", style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
