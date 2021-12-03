import 'package:buy_it/provider/modelHud.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/widgets/custom_logo.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../constanse.dart';

class SignupScreen extends StatelessWidget {
  static String id = 'SignupScreen';
  String? _email, _password;
  final Auth auth = Auth();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: KMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              CustomLogo(),
              SizedBox(
                height: height * .05,
              ),
              CustomTextField(
                onClick: (value) {},
                hint: 'Enter your name ',
                icon: Icons.person,
              ),
              SizedBox(
                height: height * .02,
              ),
              CustomTextField(
                onClick: (value) {
                  _email = value;
                },
                hint: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(
                height: height * .02,
              ),
              CustomTextField(
                onClick: (value) {
                  _password = value;
                },
                hint: 'Enter your Password',
                icon: Icons.lock,
              ),
              SizedBox(
                height: height * .05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (context) => FlatButton(
                    height: 45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () async {
                      final modelhud =
                          Provider.of<ModelHud>(context, listen: false);
                      modelhud.changeIsLoading(true);
                      if (_globalKey.currentState!.validate()) {
                        _globalKey.currentState?.save();
                        await auth.signUp(_email!.trim(), _password!.trim()).then((value) {
                          modelhud.changeIsLoading(false);
                        }).catchError((e) {
                          print(e.message.toString());
                          modelhud.changeIsLoading(false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                              "${e.message.toString()}",
                            )),
                          );
                        });
                      }
                      modelhud.changeIsLoading(false);
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do have an account ?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      //do somthing
                    },
                    child: Text(
                      ' Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
