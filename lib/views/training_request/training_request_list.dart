import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/tile/training_request_tile.dart';
import 'package:basetraining/models/training_request.dart';
import 'package:basetraining/provider/training_requests.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:basetraining/views/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingRequestList extends StatefulWidget {
  const TrainingRequestList({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _TrainingRequestListState createState() => _TrainingRequestListState();
}

class _TrainingRequestListState extends State<TrainingRequestList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<Users>(context, listen: false).setScaffoldKey(_scaffoldKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TrainingRequests trainingRequestProvider =
        Provider.of<TrainingRequests>(context);
    final userLogged = Provider.of<Users>(context, listen: false).userLogged;
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Solicitações de Treinos',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.work),
            color: AppThemes().secondaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.TRAINING_REQUEST_FORM);
            },
          )
        ],
      ),
      body: FutureBuilder<List<TrainingRequestModal>>(
        future: userLogged.role == 'adm'
            ? trainingRequestProvider.findQuery('idInstructor', userLogged.id)
            : trainingRequestProvider.findQuery('idStudent', userLogged.id),
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
                final List<TrainingRequestModal> trainingRequests =
                    snapshot.data;
                if (trainingRequests.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final TrainingRequestModal trainingRequest =
                          trainingRequests[index];
                      return TrainingRequestTile(trainingRequest);
                    },
                    itemCount: trainingRequests.length,
                  );
                }
              }
              return Center(
                  child: Text('Não foram encontradas solicitações de treino'));
              break;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      backgroundColor: AppThemes().secondaryColor),
                  Text('     Carregando...'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
