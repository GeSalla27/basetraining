import 'package:basetraining/views/login/sign_in.dart';
import 'package:basetraining/views/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:basetraining/components/app_themes.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedIn;
  const LoginPage({this.onSignedIn});

  @override
  State<StatefulWidget> createState() => _LoginPageState(onSignedIn);
}

class _LoginPageState extends State<LoginPage> {
  final pageController = PageController(initialPage: 1);
  final VoidCallback onSignedIn;

  _LoginPageState(this.onSignedIn);

  double displayHeight() => MediaQuery.of(context).size.height;
  double displayWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (value) =>
          FocusScope.of(context).requestFocus(FocusNode()),
      controller: pageController,
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: SignIn(onSignedIn),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.purple[700], Colors.blue[700]])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: displayHeight() / 1.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.purple[700], Colors.blue[700]])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Basetraining",
                              style: TextStyle(
                                fontSize: 46,
                                fontWeight: FontWeight.w300,
                                color: AppThemes().secondaryVariantColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: displayHeight() / 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: displayWidth() / 10,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      pageController.previousPage(
                        duration: Duration(seconds: 1),
                        curve: Curves.ease,
                      );
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        color: AppThemes().secondaryColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Colors.black12,
                          width: 2,
                        )),
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: displayWidth() / 10,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      pageController.nextPage(
                        duration: Duration(seconds: 1),
                        curve: Curves.ease,
                      );
                    },
                    child: Text(
                      'Cadastrar-se',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Colors.black12,
                          width: 2,
                        )),
                    color: AppThemes().secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: SignUp(onSignedIn),
        ),
      ],
    );
  }
}
