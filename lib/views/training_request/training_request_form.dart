import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/notifications.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/models/training_request.dart';
import 'package:basetraining/provider/training_requests.dart';
import 'package:basetraining/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainingRequestForm extends StatefulWidget {
  @override
  _TrainingRequestFormState createState() => _TrainingRequestFormState();
}

class _TrainingRequestFormState extends State<TrainingRequestForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final Map<String, String> _formaData = {};
  List weekList = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];
  List<UserModal> _instructors = [];
  UserModal _selectedInstructor;
  List<String> activitiesList = ['', '', '', '', '', '', ''];
  Users userProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<Users>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitação de Treino',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            color: AppThemes().secondaryColor,
            onPressed: () async {
              final isValid = _form.currentState.validate();
              if (_selectedInstructor == null) {
                await showAlertDialog(context, 'Ops!',
                    'Por favor informar o professor responsável');
                return;
              }

              if (isValid) {
                _form.currentState.save();
                setState(() {
                  _isLoading = true;
                });

                UserModal student = userProvider.userLogged;
                UserModal instructor = _selectedInstructor;

                String message =
                    await Provider.of<TrainingRequests>(context, listen: false)
                        .put(
                            TrainingRequestModal(
                                id: _formaData['id'],
                                idInstructor: instructor.id,
                                idStudent: student.id,
                                student: student,
                                status: 'Solicitado',
                                instructor: instructor,
                                kmGoal: _formaData['kmGoal'],
                                paceGoal: _formaData['paceGoal'],
                                testGoal: _formaData['testGoal'],
                                note: _formaData['note'],
                                requestDate: DateTime.now(),
                                activities: activitiesList),
                            context);

                sendMessage(
                    'Nova solicitação de treino. ',
                    'Aluno ' +
                        student.name +
                        ' ${DateFormat("dd/MM/yyyy").format(DateTime.now())}',
                    instructor.fcmToken);

                setState(() {
                  _isLoading = false;
                });

                if (message != null && message.isNotEmpty) {
                  await showAlertDialog(context, 'Ops!', message);
                  return;
                }

                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: AppThemes().secondaryColor),
            )
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FutureBuilder<List<UserModal>>(
                                    future:
                                        userProvider.findQuery('role', 'adm'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<UserModal>>
                                            snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator(
                                            backgroundColor:
                                                AppThemes().secondaryColor);
                                      else if (snapshot.hasError) {
                                        print(
                                            'Error 404! Contate o suporte técnico.');
                                      } else if (snapshot.hasData) {
                                        _instructors = snapshot.data;
                                        return ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<UserModal>(
                                            hint: Text(
                                                '   Selecione o professor resposável  '),
                                            items: snapshot.data
                                                .map((UserModal user) {
                                              return DropdownMenuItem<
                                                  UserModal>(
                                                child: Text(user.name),
                                                value: user,
                                              );
                                            }).toList(),
                                            onChanged: (UserModal value) {
                                              setState(() {
                                                if (value != null) {
                                                  _selectedInstructor = value;
                                                }
                                              });
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            value: _selectedInstructor == null
                                                ? _selectedInstructor
                                                : _instructors
                                                    .where((i) =>
                                                        i.name ==
                                                        _selectedInstructor
                                                            .name)
                                                    .first,
                                          ),
                                        );
                                      }
                                      return Container();
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              buildDataTable(weekList, activitiesList),
                            ],
                          ),
                        )),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: _formaData['testGoal'],
                                  decoration: InputDecoration(
                                      labelText: 'Meta de Prova'),
                                  onSaved: (newValue) =>
                                      _formaData['testGoal'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['kmGoal'],
                                  decoration:
                                      InputDecoration(labelText: 'Meta de Km'),
                                  onSaved: (newValue) =>
                                      _formaData['kmGoal'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['paceGoal'],
                                  decoration: InputDecoration(
                                      labelText: 'Meta de Pace - Ritmo Médio'),
                                  onSaved: (newValue) =>
                                      _formaData['paceGoal'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['note'],
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    labelText: 'Observação para Professor',
                                  ),
                                  onSaved: (newValue) =>
                                      _formaData['note'] = newValue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  DataTable buildDataTable(List weekList, List<String> activitiesList) {
    return DataTable(
      dataRowHeight: 40,
      horizontalMargin: 10,
      columnSpacing: 30,
      headingRowHeight: 55,
      dividerThickness: 1,
      columns: [
        DataColumn(
          label: Text(
            "Dia da Semana",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          numeric: false,
        ),
        DataColumn(
          tooltip: 'Informe suas atividades semanais',
          label: Text(
            "Atividades",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          numeric: false,
        ),
      ],
      rows: weekList
          .map(
            (weekDay) => DataRow(cells: [
              DataCell(
                Text(
                  weekDay,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                Container(
                  width: 180,
                  child: TextField(
                    onChanged: (text) {
                      if (weekDay == 'Segunda') {
                        activitiesList.removeAt(0);
                        activitiesList.insert(0, text);
                      } else if (weekDay == 'Terça') {
                        activitiesList.removeAt(1);
                        activitiesList.insert(1, text);
                      } else if (weekDay == 'Quarta') {
                        activitiesList.removeAt(2);
                        activitiesList.insert(2, text);
                      } else if (weekDay == 'Quinta') {
                        activitiesList.removeAt(3);
                        activitiesList.insert(3, text);
                      } else if (weekDay == 'Sexta') {
                        activitiesList.removeAt(4);
                        activitiesList.insert(4, text);
                      } else if (weekDay == 'Sábado') {
                        activitiesList.removeAt(5);
                        activitiesList.insert(5, text);
                      } else if (weekDay == 'Domingo') {
                        activitiesList.removeAt(6);
                        activitiesList.insert(6, text);
                      }
                    },
                  ),
                ),
              ),
            ]),
          )
          .toList(),
    );
  }
}
