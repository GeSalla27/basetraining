import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/models/physical_evaluation.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhysicalEvaluationDetail extends StatefulWidget {
  @override
  _PhysicalEvaluationDetailState createState() =>
      _PhysicalEvaluationDetailState();
}

class _PhysicalEvaluationDetailState extends State<PhysicalEvaluationDetail> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formaData = {};
  PhysicalEvaluationModal trainingRequest;
  UserModal userLogged;
  bool _isLoading = false;

  Future<void> aproveStudent() async {
    try {
      showLoading();

      /*UserModal studentUpdate = UserModal(
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

      message = await Provider.of<PhysicalEvaluations>(context, listen: false).put(
          PhysicalEvaluationModal(
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
          trainingRequest.student.fcmToken);*/

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

  void _loadFormData(PhysicalEvaluationModal trainingRequest) {
    /*if (trainingRequest != null) {
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
    }*/
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
        title: Text('Detalhes Avaliação Física',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
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
                                      labelText: 'Professor Resposável'),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['student'],
                                  decoration:
                                      InputDecoration(labelText: 'Aluno'),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['status'],
                                  decoration:
                                      InputDecoration(labelText: 'Status'),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['testGoal'],
                                  decoration: InputDecoration(
                                      labelText: 'Meta de Prova'),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['kmGoal'],
                                  decoration:
                                      InputDecoration(labelText: 'Meta de Km'),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['paceGoal'],
                                  decoration: InputDecoration(
                                      labelText: 'Meta de Pace - Ritmo Médio'),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['note'],
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    labelText: 'Observação para Professor',
                                  ),
                                ),
                              ],
                            ),
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
                                  color: Colors.lightGreenAccent[700],
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
}
