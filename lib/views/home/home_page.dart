import 'package:basetraining/auth/auth.dart';
import 'package:basetraining/auth/auth_provider.dart';
import 'package:basetraining/main.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/views/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState(onSignedOut);
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final VoidCallback onSignedOut;
  _HomePageState(this.onSignedOut);
  UserModal userLogged;

  @override
  void initState() {
    Provider.of<Users>(context, listen: false).setScaffoldKey(_scaffoldKey);
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      auth.signOut().then((res) {
        Provider.of<Users>(context, listen: false).userLogged = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    if (Provider.of<Users>(context, listen: false).userLogged != null) {
      userLogged = Provider.of<Users>(context, listen: false).userLogged;
    } else {
      _signOut(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('BaseTraining',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child: Text('Bem Vindo', style: TextStyle(fontSize: 32.0))),
            Center(
                child: userLogged != null
                    ? Text(userLogged.name, style: TextStyle(fontSize: 22.0))
                    : Text('', style: TextStyle(fontSize: 22.0))),
          ],
        ),
      ),
    );
  }
}
