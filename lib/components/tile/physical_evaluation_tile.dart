import 'package:basetraining/models/physical_evaluation.dart';
import 'package:basetraining/provider/physical_evaluations.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PhysicalEvaluationTile extends StatefulWidget {
  final PhysicalEvaluationModal physicalEvaluation;
  const PhysicalEvaluationTile(this.physicalEvaluation);

  @override
  _PhysicalEvaluationTileState createState() => _PhysicalEvaluationTileState();
}

class _PhysicalEvaluationTileState extends State<PhysicalEvaluationTile> {
  @override
  Widget build(BuildContext context) {
    final _userAdm = Provider.of<Users>(context, listen: false).userAdm;
    return Card(
      child: _userAdm
          ? Slidable(
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Editar',
                  icon: Icons.edit,
                  color: Colors.amber,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        AppRoutes.PHYSICAL_EVALUATION_FORM,
                        arguments: widget.physicalEvaluation);
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
                        title: Text('Excluir Avaliação Física'),
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
                        await Provider.of<PhysicalEvaluations>(context,
                                listen: false)
                            .remove(widget.physicalEvaluation);
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
          child: Icon(Icons.favorite_border),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.PHYSICAL_EVALUATION_DETAIL,
              arguments: widget.physicalEvaluation);
        },
        title: Text('Aluno - ${widget.physicalEvaluation.student.name}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Professor -  ${widget.physicalEvaluation.instructor.name}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
              Text(
                '${DateFormat("dd/MM/yyyy").format(widget.physicalEvaluation.evaluationDate)}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
            ]),
      ),
    );
  }
}
