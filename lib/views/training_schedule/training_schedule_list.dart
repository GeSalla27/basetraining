import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/tile/training_schedule_tile.dart';
import 'package:basetraining/models/training.dart';
import 'package:basetraining/provider/trainings.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:basetraining/views/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainingScheduleList extends StatefulWidget {
  const TrainingScheduleList({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  _TrainingScheduleListState createState() => _TrainingScheduleListState();
}

class _TrainingScheduleListState extends State<TrainingScheduleList> {
  var trainingDate;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<Users>(context, listen: false).setScaffoldKey(_scaffoldKey);
    super.initState();
  }

  void callDatePickerTraining() async {
    var selectDate = await getDate();
    setState(() {
      if (selectDate != null) {
        trainingDate = selectDate;
      }
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: trainingDate != null ? trainingDate : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (trainingDate == null) {
      DateTime now = DateTime.now();
      trainingDate = DateTime(now.year, now.month, now.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Trainings trainingProvider = Provider.of<Trainings>(context);
    final userLogged = Provider.of<Users>(context, listen: false).userLogged;
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppThemes().primaryColor,
        title: Text('Agenda de Treinos',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        actions: <Widget>[
          Provider.of<Users>(context, listen: false).getUserAdm
              ? IconButton(
                  icon: Icon(Icons.fitness_center),
                  color: AppThemes().secondaryColor,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.TRAINING_SCHEDULE_FORM);
                  },
                )
              : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      trainingDate = trainingDate.subtract(Duration(days: 1));
                      setState(() {
                        trainingDate = trainingDate;
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    icon: Icon(Icons.date_range),
                    onPressed: callDatePickerTraining,
                    color: AppThemes().secondaryColor,
                  ),
                  Text(
                    '${DateFormat.yMMMd('pt_BR').format(trainingDate).toString()}, ${DateFormat.EEEE('pt_BR').format(trainingDate).toString()}',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      trainingDate = trainingDate.add(Duration(days: 1));
                      setState(() {
                        trainingDate = trainingDate;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TrainingModal>>(
              future: userLogged.role == 'adm'
                  ? trainingProvider.findTraningsByDate(
                      'idInstructor',
                      userLogged.id,
                      DateFormat("dd/MM/yyyy").format(trainingDate))
                  : trainingProvider.findTraningsByDate(
                      'idStudent',
                      userLogged.id,
                      DateFormat("dd/MM/yyyy").format(trainingDate)),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    CircularProgressIndicator(
                        backgroundColor: AppThemes().secondaryColor);
                    break;
                  case ConnectionState.waiting:
                    CircularProgressIndicator(
                        backgroundColor: AppThemes().secondaryColor);
                    break;
                  case ConnectionState.active:
                    CircularProgressIndicator(
                        backgroundColor: AppThemes().secondaryColor);
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final List<TrainingModal> trainings = snapshot.data;
                      if (trainings.isNotEmpty) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final TrainingModal training = trainings[index];
                            return TrainingScheduleTile(training);
                          },
                          itemCount: trainings.length,
                        );
                      }
                    }
                    return Center(
                        child: Text('Nenhum treino para a data selecionada'));
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
                          backgroundColor: AppThemes().secondaryColor,
                        ),
                        Text('     Carregando...'),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
