import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final UserModal user;
  const UserTile(this.user);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.USER_DETAIL, arguments: user);
        },
        title: Text('${user.name}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text('${user.email}',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.amber,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.USER_FORM, arguments: user);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Excluir Usuário'),
                      content: Text('Tem certeza?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Sim'),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        TextButton(
                          child: Text('Não'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ],
                    ),
                  ).then((confirmed) async {
                    if (confirmed) {
                      await Provider.of<Users>(context, listen: false)
                          .remove(user);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
