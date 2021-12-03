import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/notifications.dart';
import 'package:basetraining/models/training_request.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/training_requests.dart';
import 'package:basetraining/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainingRequestDetail extends StatefulWidget {
  @override
  _TrainingRequestDetailState createState() => _TrainingRequestDetailState();
}

class _TrainingRequestDetailState extends State<TrainingRequestDetail> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formaData = {};
  TrainingRequestModal trainingRequest;
  UserModal userLogged;
  bool _isLoading = false;

  Future<void> aproveStudent() async {
    try {
      showLoading();

      UserModal studentUpdate = UserModal(
          id: trainingRequest.student.id,
          idAuth: trainingRequest.student.idAuth,
          name: trainingRequest.student.name,
          email: trainingRequest.student.email,
          password: trainingRequest.student.password,
          phone: trainingRequest.student.phone,
          fcmToken: trainingRequest.student.fcmToken,
          instructor: userLogged);

      String message = await Provider.of<Users>(context, listen: false)
          .put(studentUpdate, context);

      if (message != null && message.isNotEmpty) {
        await showAlertDialog(context, 'Ops!', message);
        return;
      }

      message = await Provider.of<TrainingRequests>(context, listen: false).put(
          TrainingRequestModal(
              id: trainingRequest.id,
              idInstructor: userLogged.id,
              idStudent: studentUpdate.id,
              student: studentUpdate,
              status: 'Aprovado',
              instructor: userLogged,
              kmGoal: trainingRequest.kmGoal,
              paceGoal: trainingRequest.paceGoal,
              testGoal: trainingRequest.testGoal,
              note: trainingRequest.note,
              requestDate: trainingRequest.requestDate,
              activities: trainingRequest.activities),
          context);

      if (message != null && message.isNotEmpty) {
        await showAlertDialog(context, 'Ops!', message);
        return;
      }

      sendMessage(
          'Sua solicitação de treino foi aprovada. ',
          'Professor ' +
              trainingRequest.instructor.name +
              ' ${DateFormat("dd/MM/yyyy").format(DateTime.now())}',
          trainingRequest.student.fcmToken);

      hideLoading();
      Navigator.of(context).pop();
    } catch (e) {
      print(e.message);
      hideLoading();
    }
  }

  showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _loadFormData(TrainingRequestModal trainingRequest) {
    if (trainingRequest != null) {
      _formaData['id'] = trainingRequest.id;
      _formaData['idInstructor'] = trainingRequest.idInstructor;
      _formaData['idStudent'] = trainingRequest.idStudent;
      _formaData['testGoal'] = trainingRequest.testGoal;
      _formaData['kmGoal'] = trainingRequest.kmGoal;
      _formaData['paceGoal'] = trainingRequest.paceGoal;
      _formaData['note'] = trainingRequest.note;
      _formaData['student'] = trainingRequest.student.name;
      _formaData['instructor'] = trainingRequest.instructor.name;
      _formaData['status'] = trainingRequest.status;
      _formaData['segunda'] = trainingRequest.activities[0];
      _formaData['terça'] = trainingRequest.activities[1];
      _formaData['quarta'] = trainingRequest.activities[2];
      _formaData['quinta'] = trainingRequest.activities[3];
      _formaData['sexta'] = trainingRequest.activities[4];
      _formaData['sabado'] = trainingRequest.activities[5];
      _formaData['domingo'] = trainingRequest.activities[6];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trainingRequest = ModalRoute.of(context).settings.arguments;
    if (Provider.of<Users>(context, listen: false).userLogged != null) {
      userLogged = Provider.of<Users>(context, listen: false).userLogged;
    }
    _loadFormData(trainingRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes Solicitação de Treino',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        backgroundColor: AppThemes().primaryColor,
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
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['instructor'],
                                  decoration: InputDecoration(
                                      labelText: 'Professor Resposável',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['student'],
                                  decoration: InputDecoration(
                                      labelText: 'Aluno',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['status'],
                                  decoration: InputDecoration(
                                      labelText: 'Status',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['testGoal'],
                                  decoration: InputDecoration(
                                      labelText: 'Meta de Prova',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['kmGoal'],
                                  decoration: InputDecoration(
                                      labelText: 'Meta de Km',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['paceGoal'],
                                  decoration: InputDecoration(
                                      labelText: 'Meta de Pace - Ritmo Médio',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['note'],
                                  decoration: InputDecoration(
                                      labelText: 'Observação para Professor',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: 400,
                            color: Colors.white,
                            padding: EdgeInsets.all(16.0),
                            child: activitieTable(),
                          ),
                        ),
                        SizedBox(height: 8),
                        (userLogged.role == 'adm' &&
                                _formaData['status'] == 'Solicitado')
                            ? Container(
                                width: 180,
                                height: 48,
                                child: RaisedButton(
                                  onPressed: () {
                                    showLoading();
                                    aproveStudent();
                                  },
                                  color: AppThemes().signUpColor,
                                  child: Text(
                                    'Aprovar Solicitação',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  DataTable activitieTable() {
    return DataTable(
      dataRowHeight: 40,
      horizontalMargin: 10,
      columnSpacing: 30,
      headingRowHeight: 55,
      dividerThickness: 1,
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Dia da Semana',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Atividades',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Segunda',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(
              Container(
                width: 180,
                child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  initialValue: _formaData['segunda'],
                ),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Terça',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(
              Container(
                width: 180,
                child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  initialValue: _formaData['terça'],
                ),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Quarta',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(
              Container(
                width: 180,
                child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  initialValue: _formaData['quarta'],
                ),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Quinta',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(
              Container(
                width: 180,
                child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  initialValue: _formaData['quinta'],
                ),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Sexta',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(
              Container(
                width: 180,
                child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  initialValue: _formaData['sexta'],
                ),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Sábado',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(
              Container(
                width: 180,
                child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  initialValue: _formaData['sabado'],
                ),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              'Domingo',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataCell(
              Container(
                width: 180,
                child: TextFormField(
                  enabled: false,
                  readOnly: true,
                  initialValue: _formaData['domingo'],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
