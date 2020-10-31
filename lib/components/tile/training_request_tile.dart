import 'package:basetraining/models/training_request.dart';
import 'package:basetraining/provider/training_requests.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainingRequestTile extends StatelessWidget {
  final TrainingRequestModal trainingRequest;
  const TrainingRequestTile(this.trainingRequest);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.assignment),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.TRAINING_REQUEST_DETAIL,
              arguments: trainingRequest);
        },
        title: Text('Aluno - ${trainingRequest.student.name}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Professor -  ${trainingRequest.instructor.name}',
                  style:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
              Text('Status -  ${trainingRequest.status}',
                  style:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
              Text(
                  '${DateFormat("dd/MM/yyyy").format(trainingRequest.requestDate)}',
                  style:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
            ]),
        trailing: Container(
          width: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: trainingRequest.status != 'Aprovado'
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Excluir Solicitação de Treino'),
                              content: Text('Tem certeza?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Sim'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                                FlatButton(
                                  child: Text('Não'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                              ],
                            ),
                          ).then((confirmed) async {
                            if (confirmed) {
                              await Provider.of<TrainingRequests>(context,
                                      listen: false)
                                  .remove(trainingRequest);
                            }
                          });
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
