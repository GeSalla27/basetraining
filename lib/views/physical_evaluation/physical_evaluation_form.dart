import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/notifications.dart';
import 'package:basetraining/models/physical_evaluation.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/physical_evaluations.dart';
import 'package:basetraining/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PhysicalEvaluationForm extends StatefulWidget {
  @override
  _PhysicalEvaluationFormState createState() => _PhysicalEvaluationFormState();
}

class _PhysicalEvaluationFormState extends State<PhysicalEvaluationForm> {
  final _form = GlobalKey<FormState>();
  var evaluationDate;
  PhysicalEvaluationModal _physicalEvaluation;
  bool _isLoading = false;
  final Map<String, String> _formaData = {};
  List<UserModal> _student = [];
  UserModal _selectedstudent;
  Users userProvider;

  @override
  void initState() {
    super.initState();
  }

  void callDatePickerEvaluationDate() async {
    var selectDate = await getDate();
    setState(() {
      evaluationDate = selectDate;
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  void _loadFormData(PhysicalEvaluationModal physicalEvaluation) {
    if (physicalEvaluation != null) {
      _formaData['id'] = physicalEvaluation.id;
      _formaData['idInstructor'] = physicalEvaluation.idInstructor;
      _formaData['idStudent'] = physicalEvaluation.idStudent;
      _selectedstudent = physicalEvaluation.student;
      evaluationDate = physicalEvaluation.evaluationDate;
      _formaData['height'] = physicalEvaluation.height;
      _formaData['weight'] = physicalEvaluation.weight;
      _formaData['chest'] = physicalEvaluation.chest;
      _formaData['waist'] = physicalEvaluation.waist;
      _formaData['abdomen'] = physicalEvaluation.abdomen;
      _formaData['hip'] = physicalEvaluation.hip;
      _formaData['forearmRight'] = physicalEvaluation.forearmRight;
      _formaData['forearmLeft'] = physicalEvaluation.forearmLeft;
      _formaData['armRight'] = physicalEvaluation.armRight;
      _formaData['armLeft'] = physicalEvaluation.armLeft;
      _formaData['thighRight'] = physicalEvaluation.thighRight;
      _formaData['thighLeft'] = physicalEvaluation.thighLeft;
      _formaData['calfRight'] = physicalEvaluation.calfRight;
      _formaData['calfLeft'] = physicalEvaluation.calfLeft;
      _formaData['currentFat'] = physicalEvaluation.currentFat;
      _formaData['weightFat'] = physicalEvaluation.weightFat;
      _formaData['weightThin'] = physicalEvaluation.weightThin;
      _formaData['note'] = physicalEvaluation.note;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _physicalEvaluation = ModalRoute.of(context).settings.arguments;
    _loadFormData(_physicalEvaluation);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<Users>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação Física',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400)),
        backgroundColor: AppThemes().primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            color: AppThemes().secondaryColor,
            onPressed: () async {
              final isValid = _form.currentState.validate();
              if (_selectedstudent == null) {
                await showAlertDialog(context, 'Ops!',
                    'Por favor informar o aluno a ser avaliado');
                return;
              }

              if (evaluationDate == null) {
                await showAlertDialog(context, 'Ops!',
                    'Por favor informar a data da avaliação física!');
                return;
              }

              if (isValid) {
                _form.currentState.save();
                setState(() {
                  _isLoading = true;
                });

                UserModal student = _selectedstudent;
                UserModal instructor = userProvider.userLogged;

                String message = await Provider.of<PhysicalEvaluations>(context,
                        listen: false)
                    .put(
                        PhysicalEvaluationModal(
                          id: _formaData['id'],
                          idInstructor: instructor.id,
                          idStudent: student.id,
                          instructor: instructor,
                          student: student,
                          evaluationDate: evaluationDate,
                          height: _formaData['height'],
                          weight: _formaData['weight'],
                          chest: _formaData['chest'],
                          waist: _formaData['waist'],
                          abdomen: _formaData['abdomen'],
                          hip: _formaData['hip'],
                          forearmRight: _formaData['forearmRight'],
                          forearmLeft: _formaData['forearmLeft'],
                          armRight: _formaData['armRight'],
                          armLeft: _formaData['armLeft'],
                          thighRight: _formaData['thighRight'],
                          thighLeft: _formaData['thighLeft'],
                          calfRight: _formaData['calfRight'],
                          calfLeft: _formaData['calfLeft'],
                          currentFat: _formaData['currentFat'],
                          weightFat: _formaData['weightFat'],
                          weightThin: _formaData['weightThin'],
                          note: _formaData['note'],
                        ),
                        context);

                sendMessage(
                    'Você tem numa nova avaliação física. ',
                    'Professor ' +
                        instructor.name +
                        ' ${DateFormat("dd/MM/yyyy").format(DateTime.now())}',
                    student.fcmToken);

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
                                    future: userProvider.findQuery(
                                        'instructor.id',
                                        userProvider.userLogged.id),
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
                                        _student = snapshot.data;
                                        List<UserModal> listStudents =
                                            snapshot.data.toList();
                                        listStudents.sort((a, b) {
                                          return a.name
                                              .toLowerCase()
                                              .compareTo(b.name.toLowerCase());
                                        });
                                        return ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<UserModal>(
                                            icon: Icon(Icons.perm_identity),
                                            hint: Text(
                                                '      Selecione o aluno     '),
                                            items: listStudents
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
                                                  _selectedstudent = value;
                                                }
                                              });
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                            value: _selectedstudent == null
                                                ? _selectedstudent
                                                : _student
                                                    .where((i) =>
                                                        i.name ==
                                                        _selectedstudent.name)
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
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text('Data da Avaliação Física',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.date_range),
                                      onPressed: callDatePickerEvaluationDate,
                                      color: Colors.blueAccent,
                                    ),
                                    Container(
                                      child: evaluationDate == null
                                          ? Text(
                                              "Selecione a data de realização da avaliação",
                                            )
                                          : Text(
                                              '${DateFormat("dd/MM/yyyy").format(evaluationDate)}',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  initialValue: _formaData['height'],
                                  decoration:
                                      InputDecoration(labelText: 'Altura'),
                                  onSaved: (newValue) =>
                                      _formaData['height'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['weight'],
                                  decoration:
                                      InputDecoration(labelText: 'Peso'),
                                  onSaved: (newValue) =>
                                      _formaData['weight'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['chest'],
                                  decoration:
                                      InputDecoration(labelText: 'Tórax'),
                                  onSaved: (newValue) =>
                                      _formaData['chest'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['waist'],
                                  decoration:
                                      InputDecoration(labelText: 'Cintura'),
                                  onSaved: (newValue) =>
                                      _formaData['waist'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['abdomen'],
                                  decoration:
                                      InputDecoration(labelText: 'Abdômen'),
                                  onSaved: (newValue) =>
                                      _formaData['abdomen'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['hip'],
                                  decoration:
                                      InputDecoration(labelText: 'Quadril'),
                                  onSaved: (newValue) =>
                                      _formaData['hip'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['forearmRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Antebraço Direito'),
                                  onSaved: (newValue) =>
                                      _formaData['forearmRight'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['forearmLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Antebraço Esquerdo'),
                                  onSaved: (newValue) =>
                                      _formaData['forearmLeft'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['armRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Braço Direito'),
                                  onSaved: (newValue) =>
                                      _formaData['armRight'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['armLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Braço Esquerdo'),
                                  onSaved: (newValue) =>
                                      _formaData['armLeft'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['thighRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Coxa Direita'),
                                  onSaved: (newValue) =>
                                      _formaData['thighRight'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['thighLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Coxa Esquerda'),
                                  onSaved: (newValue) =>
                                      _formaData['thighLeft'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['calfRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Panturrilha Direita'),
                                  onSaved: (newValue) =>
                                      _formaData['calfRight'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['calfLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Panturrilha Esquerda'),
                                  onSaved: (newValue) =>
                                      _formaData['calfLeft'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['currentFat'],
                                  decoration: InputDecoration(
                                      labelText: 'Gordura Atual %'),
                                  onSaved: (newValue) =>
                                      _formaData['currentFat'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['weightFat'],
                                  decoration:
                                      InputDecoration(labelText: 'Peso Gordo'),
                                  onSaved: (newValue) =>
                                      _formaData['weightFat'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['weightThin'],
                                  decoration:
                                      InputDecoration(labelText: 'Peso Magro'),
                                  onSaved: (newValue) =>
                                      _formaData['weightThin'] = newValue,
                                ),
                                TextFormField(
                                  initialValue: _formaData['note'],
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    labelText: 'Observação',
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
}
