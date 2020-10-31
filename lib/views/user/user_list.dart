import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/tile/user_tile.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:basetraining/views/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  const UserList({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    final Users userProvider = Provider.of<Users>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Usuários',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.group_add),
            color: AppThemes().secondaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.USER_FORM);
            },
          )
        ],
      ),
      body: FutureBuilder<List<UserModal>>(
        future: userProvider.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              CircularProgressIndicator(
                  backgroundColor: AppThemes().secondaryColor);
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final List<UserModal> users = snapshot.data;
                if (users.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final UserModal user = users[index];
                      return UserTile(user);
                    },
                    itemCount: users.length,
                  );
                }
              }
              return Center(child: Text('Não foram encotrados dados'));
              break;
          }
          return Container();
        },
      ),
    );
  }
}
