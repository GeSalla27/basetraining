import 'package:basetraining/models/user.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final _form = GlobalKey<FormState>();
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
    final UserModal user = ModalRoute.of(context).settings.arguments;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes Usuário',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
      ),
      body: SingleChildScrollView(
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
                        enabled: false,
                        readOnly: true,
                        initialValue: _formaData['name'],
                        decoration: InputDecoration(labelText: 'Nome'),
                      ),
                      TextFormField(
                        enabled: false,
                        readOnly: true,
                        initialValue: _formaData['email'],
                        decoration: InputDecoration(labelText: 'E-mail'),
                      ),
                      TextFormField(
                        enabled: false,
                        readOnly: true,
                        initialValue: _formaData['password'],
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Senha"),
                      ),
                      TextFormField(
                        enabled: false,
                        readOnly: true,
                        initialValue: _formaData['phone'],
                        decoration: InputDecoration(labelText: 'Phone'),
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
