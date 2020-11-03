import 'package:basetraining/models/training.dart';
import 'package:basetraining/provider/trainings.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TrainingScheduleTile extends StatefulWidget {
  final TrainingModal training;
  const TrainingScheduleTile(this.training);

  @override
  _TrainingScheduleTileState createState() => _TrainingScheduleTileState();
}

class _TrainingScheduleTileState extends State<TrainingScheduleTile> {
  @override
  Widget build(BuildContext context) {
    final _userAdm = Provider.of<Users>(context, listen: false).userAdm;
    return Card(
      child: _userAdm && widget.training.status != 'Realizado'
          ? Slidable(
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Editar',
                  icon: Icons.edit,
                  color: Colors.amber,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        AppRoutes.TRAINING_SCHEDULE_FORM,
                        arguments: widget.training);
                  },
                ),
                IconSlideAction(
                  caption: 'Excluir',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Excluir Treino'),
                        content: Text('Tem certeza?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Sim'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                          FlatButton(
                            child: Text('Não'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ],
                      ),
                    ).then((confirmed) async {
                      if (confirmed) {
                        await Provider.of<Trainings>(context, listen: false)
                            .remove(widget.training);
                      }
                    });
                  },
                ),
              ],
              child: tileDetails(),
            )
          : tileDetails(),
    );
  }

  Container tileDetails() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey[300], blurRadius: 6, offset: Offset(0, -2))
      ]),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.fitness_center),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.TRAINING_SCHEDULE_DETAIL,
              arguments: widget.training);
        },
        title: Text('Aluno - ${widget.training.student.name}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Professor -  ${widget.training.instructor.name}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
              Text(
                'Status -  ${widget.training.status}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
              Text(
                '${widget.training.trainingDate}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
              Text(
                'Descrição -  ${widget.training.description}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
            ]),
      ),
    );
  }
}
