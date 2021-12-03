import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/validators/validator_input.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  UserModal _user;
  bool _isLoading = false;
  final Map<String, String> _formaData = {};

  void _loadFormData(UserModal user) {
    if (user != null) {
      _formaData['id'] = user.id;
      _formaData['idAuth'] = user.idAuth;
      _formaData['name'] = user.name;
      _formaData['email'] = user.email;
      _formaData['password'] = user.password;
      _formaData['phone'] = user.phone;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = ModalRoute.of(context).settings.arguments;
    _loadFormData(_user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes().primaryColor,
        title: Text('Formulário de Usuário',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            color: AppThemes().secondaryColor,
            onPressed: () async {
              final isValid = _form.currentState.validate();
              if (isValid) {
                _form.currentState.save();
                setState(() {
                  _isLoading = true;
                });

                String message =
                    await Provider.of<Users>(context, listen: false).put(
                        UserModal(
                            id: _formaData['id'],
                            idAuth: _formaData['idAuth'],
                            instructor: _user.instructor != null
                                ? _user.instructor
                                : null,
                            name: _formaData['name'],
                            email: _formaData['email'],
                            password: _formaData['password'],
                            phone: _formaData['phone'],
                            fcmToken: _user.fcmToken,
                            role: _user.role),
                        context);

                setState(() {
                  _isLoading = false;
                });

                if (message != null && message.isNotEmpty) {
                  await showAlertDialog(context, 'Ops!', message);
                  return;
                }

                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: AppThemes().secondaryColor),
            )
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Form(
                    key: _form,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: _formaData['name'],
                              decoration: InputDecoration(labelText: 'Nome'),
                              validator: NameFieldValidator.validate,
                              onSaved: (newValue) =>
                                  _formaData['name'] = newValue,
                            ),
                            TextFormField(
                              initialValue: _formaData['email'],
                              decoration: InputDecoration(labelText: 'E-mail'),
                              validator: EmailFieldValidator.validate,
                              onSaved: (newValue) =>
                                  _formaData['email'] = newValue,
                            ),
                            TextFormField(
                              initialValue: _formaData['password'],
                              validator: PasswordFieldValidatorSiginUp.validate,
                              onSaved: (newValue) =>
                                  _formaData['password'] = newValue,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(labelText: "Senha"),
                            ),
                            TextFormField(
                              initialValue: _formaData['phone'],
                              decoration: InputDecoration(labelText: 'Phone'),
                              onSaved: (newValue) =>
                                  _formaData['phone'] = newValue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
