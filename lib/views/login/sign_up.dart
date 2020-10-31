import 'package:basetraining/auth/auth.dart';
import 'package:basetraining/auth/auth_provider.dart';
import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/validators/validator_input.dart';
import 'package:basetraining/components/validators/validator_login.dart';
import 'package:basetraining/locator.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/services/api_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basetraining/models/user.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onSignedIn;
  const SignUp(this.onSignedIn);

  @override
  _SignUpState createState() => _SignUpState(onSignedIn);
}

class _SignUpState extends State<SignUp> {
  final VoidCallback onSignedIn;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiUsers _api = locator<ApiUsers>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool isLoading = false;
  _SignUpState(this.onSignedIn);
  String _name, _phoneNumber, _email, _password;

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
        final String userId =
            await auth.createUserWithEmailAndPassword(_email, _password);
        print('Signed in: $userId');
        UserModal userFinal = UserModal(
          idAuth: userId,
          name: _name,
          email: _email,
          password: _password,
          phone: _phoneNumber,
          role: '',
        );
        DocumentReference doc = await _api.addDocument(userFinal.toJson());
        if (doc != null) {
          // register fcm token
          String fcmToken = await _firebaseMessaging.getToken();
          UserModal user = UserModal(
              id: doc.id,
              idAuth: userFinal.idAuth,
              name: userFinal.name,
              email: userFinal.email,
              password: userFinal.password,
              phone: userFinal.phone,
              role: userFinal.role,
              fcmToken: fcmToken);
          await _api.updateDocument(user.toJson(), doc.id);
          Provider.of<Users>(context, listen: false).setUserLogged(user);
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
          color: AppThemes().signUpColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: displayHeight() / 8,
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
                  validator: NameFieldValidator.validate,
                  onSaved: (value) => _name = value,
                  keyboardType: TextInputType.text,
                  cursorColor: AppThemes().secondaryColor,
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.account_circle,
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
                    left: displayWidth() / 20),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                      ),
                    ]),
                child: TextFormField(
                  validator: NameFieldValidator.validate,
                  onSaved: (value) => _phoneNumber = value,
                  keyboardType: TextInputType.number,
                  cursorColor: AppThemes().secondaryColor,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    hintText: 'Número',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.phone_iphone,
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
                    left: displayWidth() / 20),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                      ),
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
                      ),
                    ]),
                child: TextFormField(
                  validator: PasswordFieldValidatorSiginUp.validate,
                  onSaved: (value) => _password = value.trim(),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  cursorColor: AppThemes().secondaryColor,
                  decoration: InputDecoration(
                    hintText: "Senha",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
                    prefixIcon: Icon(
                      Icons.vpn_key,
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
                          'Cadastrar-se',
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
