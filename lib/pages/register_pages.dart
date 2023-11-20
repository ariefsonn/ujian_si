import 'package:flutter/material.dart';
import 'package:ujian_si/data/helper.dart';
import 'package:ujian_si/pages/login_pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final cMail = TextEditingController();
  final cName = TextEditingController();
  final cPassword = TextEditingController();

  Future<void> register() async {
    String mail = cMail.text;
    String username = cName.text;
    String password = cPassword.text;

    if (mail.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      await DatabaseHelper.instance.register(username, password, mail);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Register', style: TextStyle(
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
                  hintText: 'Enter your name',
                ),
                controller: cName,
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
                    register();
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
                    'Register',
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
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginPage()));
                },
                child: const Text("Want to login?", style: TextStyle(
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
