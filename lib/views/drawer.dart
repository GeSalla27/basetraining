import 'package:basetraining/auth/auth.dart';
import 'package:basetraining/auth/auth_provider.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/main.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserModal userLogged;

  @override
  void didChangeDependencies() {
    if (Provider.of<Users>(context, listen: false).userLogged != null) {
      userLogged = Provider.of<Users>(context, listen: false).userLogged;
    }
    super.didChangeDependencies();
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
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            _createDrawerItem(
                icon: Icons.home,
                colorIcon: Colors.blueGrey,
                text: 'Home',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.HOME)),
            _createDrawerItem(
                icon: Icons.calendar_today,
                text: 'Agenda de Treinos',
                colorIcon: Colors.yellowAccent[700],
                onTap: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.TRAINING_SCHEDULE_LIST)),
            _createDrawerItem(
                icon: Icons.assignment,
                text: 'Solicitação de Treinos',
                colorIcon: Colors.lightBlueAccent[400],
                onTap: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.TRAINING_REQUEST_LIST)),
            _createDrawerItem(
                icon: Icons.favorite_border,
                text: 'Avaliação Física',
                colorIcon: Colors.greenAccent[400],
                onTap: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.PHYSICAL_EVALUATION_LIST)),
            Provider.of<Users>(context, listen: false).userAdm
                ? _createDrawerItem(
                    icon: Icons.account_box,
                    text: 'Cadastro de Usuários',
                    colorIcon: Colors.orangeAccent,
                    onTap: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.USER_LIST))
                : Container(width: 0.0, height: 0.0),
            _createDrawerItem(
                icon: Icons.exit_to_app,
                text: 'Sair',
                colorIcon: Colors.red,
                onTap: () => _signOut(context)),
          ],
        ),
      ),
    );
  }

  Widget _createHeader() {
    return Container(
        color: AppThemes().primaryColor,
        height: 92.0,
        child: Container(
          child: DrawerHeader(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(0.0),
            child: Stack(
              children: <Widget>[
                Positioned(
                    bottom: 8.0,
                    left: 8.0,
                    top: 4,
                    child: Text("  Menu  ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ),
        padding: EdgeInsets.all(8.0));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap, Color colorIcon}) {
    return ListTile(
      visualDensity: VisualDensity.comfortable,
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: colorIcon,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  letterSpacing: 0.5,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
