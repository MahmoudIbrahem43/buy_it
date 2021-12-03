import 'package:buy_it/constanse.dart';
import 'package:buy_it/provider/adminMood.dart';
import 'package:buy_it/provider/modelHud.dart';
import 'package:buy_it/screens/signup_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/widgets/custom_logo.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/admin_home.dart';
import 'user/home_page.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String? _email, _password;

  final Auth auth = Auth();

  final adminPassword = 'admin1234';

  bool keepUserLoggedIn = false;

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
                  height: height * .1,
                ),
                CustomTextField(
                  onClick: (value) {
                    _email = value!;
                  },
                  hint: 'Enter your email',
                  icon: Icons.email,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          shape: CircleBorder(),
                          checkColor: KSecondColor,
                          activeColor: KMainColor,
                          value: keepUserLoggedIn,
                          onChanged: (value) {
                            setState(() {
                              keepUserLoggedIn = value!;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  onClick: (value) {
                    _password = value!;
                  },
                  hint: 'Enter your Password',
                  icon: Icons.lock,
                ),
                SizedBox(
                  height: height * .06,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: FlatButton(
                    // child: Container(),
                    height: 45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onPressed: () {
                      if (keepUserLoggedIn = true) {
                        keepUserLoggedin();
                      }
                      _validate(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: height * .03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account ?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignupScreen.id);
                      },
                      child: Text(
                        ' sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<AdminMood>(context, listen: false)
                                .changeIsAdmine(true);
                          },
                          child: Text(
                            'i\'m an admin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Provider.of<AdminMood>(context).isAdmin
                                    ? KMainColor
                                    : Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<AdminMood>(context, listen: false)
                                .changeIsAdmine(false);
                          },
                          child: Text(
                            'i\'m a user',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Provider.of<AdminMood>(context,
                                            listen: true)
                                        .isAdmin
                                    ? Colors.white
                                    : KMainColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _validate(BuildContext context) async {
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeIsLoading(true);
    if (_globalKey.currentState!.validate()) {
      _globalKey.currentState!.save();
      if (Provider.of<AdminMood>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          await auth.signIn(_email!.trim(), _password!.trim()).then((value) {
            modelhud.changeIsLoading(false);
            Navigator.pushNamed(context, AdminHome.id);
          }).catchError((e) {
            modelhud.changeIsLoading(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                "${e.message.toString()}",
              )),
            );
          });
        } else {
          modelhud.changeIsLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong !'),
          ));
        }
      } else {
        await auth.signIn(_email!, _password!).then((value) {
          modelhud.changeIsLoading(false);
          Navigator.pushNamed(context, HomePage.id);
        }).catchError((e) {
          modelhud.changeIsLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              "${e.message.toString()}",
            )),
          );
        });
      }
    }
    modelhud.changeIsLoading(false);
  }

  void keepUserLoggedin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(KKeepUserLoggedIN, keepUserLoggedIn);
  }
}
