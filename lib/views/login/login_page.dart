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
          body: Container(
            color: AppThemes().primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: displayHeight() / 2.5,
                  decoration: BoxDecoration(
                      color: AppThemes().primaryVariantColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center, //colocar aqui imagem
                        color: AppThemes().secondaryColor,
                        size: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Basetraining",
                              style: TextStyle(
                                fontSize: 36,
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
