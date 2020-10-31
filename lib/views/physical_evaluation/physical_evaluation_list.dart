import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/tile/physical_evaluation_tile.dart';
import 'package:basetraining/models/physical_evaluation.dart';
import 'package:basetraining/provider/physical_evaluations.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:basetraining/views/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhysicalEvaluationList extends StatefulWidget {
  const PhysicalEvaluationList({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _PhysicalEvaluationListState createState() => _PhysicalEvaluationListState();
}

class _PhysicalEvaluationListState extends State<PhysicalEvaluationList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<Users>(context, listen: false).setScaffoldKey(_scaffoldKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PhysicalEvaluations trainingRequestProvider =
        Provider.of<PhysicalEvaluations>(context);
    final userLogged = Provider.of<Users>(context, listen: false).userLogged;
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Avaliações Físicas',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            color: AppThemes().secondaryColor,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.PHYSICAL_EVALUATION_FORM);
            },
          )
        ],
      ),
      body: FutureBuilder<List<PhysicalEvaluationModal>>(
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
                final List<PhysicalEvaluationModal> physicalEvaluations =
                    snapshot.data;
                if (physicalEvaluations.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final PhysicalEvaluationModal trainingRequest =
                          physicalEvaluations[index];
                      return PhysicalEvaluationTile(trainingRequest);
                    },
                    itemCount: physicalEvaluations.length,
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
