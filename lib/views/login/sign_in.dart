import 'package:basetraining/auth/auth.dart';
import 'package:basetraining/auth/auth_provider.dart';
import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/validators/validator_input.dart';
import 'package:basetraining/components/validators/validator_login.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/users.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onSignedIn;
  const SignIn(this.onSignedIn);

  @override
  _SignInState createState() => _SignInState(onSignedIn);
}

class _SignInState extends State<SignIn> {
  final VoidCallback onSignedIn;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool isLoading = false;
  _SignInState(this.onSignedIn);
  String _email, _password;

  double displayHeight() => MediaQuery.of(context).size.height;
  double displayWidth() => MediaQuery.of(context).size.width;

  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        final Users userProvider = Provider.of<Users>(context, listen: false);
        UserModal userLogged;
        final String userId =
            await auth.signInWithEmailAndPassword(_email, _password);

        List<UserModal> result = await userProvider.findQuery('idAuth', userId);
        if (result[0] != null) {
          Provider.of<Users>(context, listen: false).setUserLogged(result[0]);

          userLogged = userProvider.userLogged;

          // register fcm token
          String fcmToken = await _firebaseMessaging.getToken();

          await Provider.of<Users>(context, listen: false).put(
              UserModal(
                  id: userLogged.id,
                  idAuth: userLogged.idAuth,
                  name: userLogged.name,
                  email: userLogged.email,
                  password: userLogged.password,
                  phone: userLogged.phone,
                  role: userLogged.role,
                  instructor: userLogged.instructor,
                  fcmToken: fcmToken),
              context);
        }

        hideLoading();
        widget.onSignedIn();
      } catch (e) {
        hideLoading();
        String message = ValidatorLogin.validate(e.code);
        await showAlertDialog(context, 'Ops!', message);
      }
    } else
      hideLoading();
  }

  showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          color: AppThemes().signInColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: displayHeight() / 4,
                    right: displayWidth() / 20,
                    left: displayWidth() / 20),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          spreadRadius: 2),
                    ]),
                child: TextFormField(
                  validator: EmailFieldValidator.validate,
                  onSaved: (value) => _email = value.trim(),
                  keyboardType: TextInputType.text,
                  cursorColor: AppThemes().secondaryColor,
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: AppThemes().secondaryColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  right: displayWidth() / 20,
                  left: displayWidth() / 20,
                ),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          spreadRadius: 2),
                    ]),
                child: TextFormField(
                  validator: PasswordFieldValidator.validate,
                  onSaved: (value) => _password = value.trim(),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  cursorColor: AppThemes().secondaryColor,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: AppThemes().secondaryColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              !isLoading
                  ? Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                        horizontal: displayWidth() / 20,
                        vertical: 25,
                      ),
                      child: RaisedButton(
                        onPressed: () {
                          showLoading();
                          validateAndSubmit();
                        },
                        color: Colors.white,
                        child: Text(
                          'Entrar',
                          style: TextStyle(color: AppThemes().secondaryColor),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: Colors.black12,
                              width: 2,
                            )),
                      ),
                    )
                  : Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                        horizontal: displayWidth() / 20,
                        vertical: 25,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                            backgroundColor: AppThemes().secondaryColor),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
