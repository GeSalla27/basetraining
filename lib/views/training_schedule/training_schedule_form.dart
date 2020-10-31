import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/enums/arrayModels.dart';
import 'package:basetraining/components/notifications.dart';
import 'package:basetraining/components/validators/validator_input.dart';
import 'package:basetraining/models/training.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/trainings.dart';
import 'package:basetraining/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TrainingScheduleForm extends StatefulWidget {
  @override
  _TrainingScheduleFormState createState() => _TrainingScheduleFormState();
}

class _TrainingScheduleFormState extends State<TrainingScheduleForm> {
  var actionModal;
  var trainingDate;
  var realizationDate;
  TrainingModal _training;
  final _formTraining = GlobalKey<FormState>();
  final _formFeedBack = GlobalKey<FormState>();
  final Map<String, String> _formTrainingaData = {};
  final Map<String, String> _formFeedBackData = {};
  bool _isLoading = false;
  List<UserModal> _student = [];

  UserModal _selectedstudent;
  String _selectedModality;
  String _selectedTrainingType;
  String _selectedIntensity;
  String _selectedRouteType;
  String _selectedDescriptionFeedback;
  List<String> _modalitys = ArrayModels().modalitys;
  List<String> _trainingTypes = ArrayModels().trainingTypes;
  List<String> _intensitys = ArrayModels().intensitys;
  List<String> _routeTypes = ArrayModels().routeTypes;
  List<String> _descriptionFeedbacks = ArrayModels().descriptionFeedback;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  void callDatePickerTraining() async {
    var selectDate = await getDate();
    setState(() {
      trainingDate = selectDate;
    });
  }

  void callDatePickerFeedBack() async {
    var selectDate = await getDate();
    setState(() {
      realizationDate = selectDate;
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

  void _loadFormData(TrainingModal training) {
    actionModal = "Novo";
    if (training != null) {
      actionModal = "Editar";
      _formTrainingaData['id'] = training.id;
      _formTrainingaData['idInstructor'] = training.idInstructor;
      _formTrainingaData['idStudent'] = training.idStudent;
      _formTrainingaData['status'] = training.status;
      trainingDate = DateFormat("dd/MM/yyyy HH:mm:ss")
          .parse(training.trainingDate + " 00:00:00");
      _selectedstudent = training.student;
      _formTrainingaData['description'] = training.description;
      _formTrainingaData['note'] = training.note;
      _formTrainingaData['distance'] = training.distance;
      _formTrainingaData['time'] = training.time;
      _formTrainingaData['warmingUp'] = training.warmingUp;
      _formTrainingaData['pace'] = training.pace;
      _selectedModality = training.modality;
      _selectedTrainingType = training.trainingType;
      _selectedIntensity = training.intensity;
      _selectedRouteType = training.routeType;

      if (training.feedback != null) {
        _formFeedBackData['status'] = training.feedback.status;
        realizationDate = training.feedback.realizationDate;
        _formFeedBackData['description'] = training.feedback.description;
        _formFeedBackData['distance'] = training.feedback.distance;
        _formFeedBackData['time'] = training.feedback.time;
        _formFeedBackData['pace'] = training.feedback.pace;
        _formFeedBackData['physicalEffort'] = training.feedback.physicalEffort;
        _formFeedBackData['externalLink'] = training.feedback.externalLink;
      } else
        _formFeedBackData['status'] = "Não Realizado";
      realizationDate = null;
      _formFeedBackData['description'] = "";
      _formFeedBackData['distance'] = "";
      _formFeedBackData['time'] = "";
      _formFeedBackData['pace'] = "";
      _formFeedBackData['physicalEffort'] = "";
      _formFeedBackData['externalLink'] = "";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _training = ModalRoute.of(context).settings.arguments;
    if (Provider.of<Users>(context, listen: false).userLogged != null) {}
    _loadFormData(_training);
  }

  @override
  Widget build(BuildContext context) {
    final Users _userProvider = Provider.of<Users>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.fitness_center),
                text: 'Treino',
                iconMargin: EdgeInsets.only(bottom: 8.0),
              ),
              Tab(
                icon: Icon(Icons.thumbs_up_down),
                text: 'Feedback',
                iconMargin: EdgeInsets.only(bottom: 8.0),
              ),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
          ),
          title: Text(actionModal + ' Treino',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              color: AppThemes().secondaryColor,
              onPressed: () async {
                final isValid = _formTraining.currentState.validate();
                if (_selectedstudent == null) {
                  await showAlertDialog(
                      context, 'Ops!', 'Por favor informar aluno!');
                  return;
                }

                if (trainingDate == null) {
                  await showAlertDialog(
                      context, 'Ops!', 'Por favor informar a data do treino!');
                  return;
                }

                if (!isValid) {
                  await showAlertDialog(context, 'Ops!',
                      'Campos obrigatórios não foram preenchidos!');
                  return;
                }

                if (isValid) {
                  _formTraining.currentState.save();
                  showLoading();

                  UserModal student = _selectedstudent;
                  UserModal instructor = _userProvider.userLogged;
                  String statusTraining;

                  if (_formTrainingaData['id'] != '' &&
                      _formTrainingaData['id'] != null) {
                    statusTraining = _formTrainingaData['status'];
                  } else {
                    statusTraining = 'Proposto';
                  }

                  String message =
                      await Provider.of<Trainings>(context, listen: false).put(
                          TrainingModal(
                              id: _formTrainingaData['id'],
                              idInstructor: instructor.id,
                              idStudent: student.id,
                              status: statusTraining,
                              trainingDate:
                                  DateFormat("dd/MM/yyyy").format(trainingDate),
                              student: student,
                              instructor: instructor,
                              description: _formTrainingaData['description'],
                              note: _formTrainingaData['note'],
                              distance: _formTrainingaData['distance'],
                              time: _formTrainingaData['time'],
                              warmingUp: _formTrainingaData['warmingUp'],
                              pace: _formTrainingaData['pace'],
                              modality: _formTrainingaData['modality'],
                              trainingType: _formTrainingaData['trainingType'],
                              intensity: _formTrainingaData['intensity'],
                              routeType: _formTrainingaData['routeType'],
                              feedback: null),
                          context);

                  hideLoading();

                  if (message != null && message.isNotEmpty) {
                    await showAlertDialog(context, 'Ops!', message);
                    return;
                  }

                  sendMessage(
                      'Você recebeu um novo treino. ',
                      'Professor ' +
                          instructor.name +
                          ' ${DateFormat("dd/MM/yyyy").format(trainingDate)}',
                      student.fcmToken);

                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
        body: TabBarView(
          children: [
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        backgroundColor: AppThemes().secondaryColor),
                  )
                : scheduleForm(_userProvider, _userProvider.userLogged),
            feedBackForm(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView scheduleForm(userProvider, userLogged) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Form(
            key: _formTraining,
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Aluno',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FutureBuilder<List<UserModal>>(
                                future: userProvider.findQuery(
                                    'instructor.id', userLogged.id),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<UserModal>> snapshot) {
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
                                        items:
                                            listStudents.map((UserModal user) {
                                          return DropdownMenuItem<UserModal>(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Data do Treino',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: callDatePickerTraining,
                              color: AppThemes().secondaryColor,
                            ),
                            Container(
                              child: trainingDate == null
                                  ? Text(
                                      "Selecione a data do Treino",
                                    )
                                  : Text(
                                      '${DateFormat("dd/MM/yyyy").format(trainingDate)}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: 'Modalidade',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          value: _selectedModality,
                          validator: FieldNotInformed.validate,
                          onSaved: (newValue) =>
                              _formTrainingaData['modality'] =
                                  _selectedModality,
                          items: _modalitys.map((modality) {
                            return DropdownMenuItem(
                              child: Text(modality),
                              value: modality,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedModality = newValue;
                            });
                          },
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: 'Tipo de Treino',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          value: _selectedTrainingType,
                          validator: FieldNotInformed.validate,
                          onSaved: (newValue) =>
                              _formTrainingaData['trainingType'] =
                                  _selectedTrainingType,
                          items: _trainingTypes.map((trainingType) {
                            return DropdownMenuItem(
                              child: Text(trainingType),
                              value: trainingType,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTrainingType = newValue;
                            });
                          },
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: 'Intensidade',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          value: _selectedIntensity,
                          validator: FieldNotInformed.validate,
                          onSaved: (newValue) =>
                              _formTrainingaData['intensity'] =
                                  _selectedIntensity,
                          items: _intensitys.map((intensity) {
                            return DropdownMenuItem(
                              child: Text(intensity),
                              value: intensity,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedIntensity = newValue;
                            });
                          },
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: 'Tipo de Percurso',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          value: _selectedRouteType,
                          validator: FieldNotInformed.validate,
                          onSaved: (newValue) =>
                              _formTrainingaData['routeType'] =
                                  _selectedRouteType,
                          items: _routeTypes.map((routeType) {
                            return DropdownMenuItem(
                              child: Text(routeType),
                              value: routeType,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRouteType = newValue;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: _formTrainingaData['description'],
                          validator: FieldNotInformed.validate,
                          decoration: InputDecoration(
                              labelText: 'Descrição',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formTrainingaData['description'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formTrainingaData['warmingUp'],
                          decoration: InputDecoration(
                              labelText: 'Aquecimento',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formTrainingaData['warmingUp'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formTrainingaData['distance'],
                          decoration: InputDecoration(
                              labelText: 'Distância',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formTrainingaData['distance'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formTrainingaData['time'],
                          decoration: InputDecoration(
                              labelText: 'Tempo',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formTrainingaData['time'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formTrainingaData['pace'],
                          decoration: InputDecoration(
                              labelText: 'Ritmo (pace)',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formTrainingaData['pace'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formTrainingaData['note'],
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Observação',
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          onSaved: (newValue) =>
                              _formTrainingaData['note'] = newValue,
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
    );
  }

  SingleChildScrollView feedBackForm() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Form(
            key: _formFeedBack,
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        _formFeedBackData['status'] == null
                            ? TextFormField(
                                enabled: false,
                                readOnly: true,
                                initialValue: 'Não realizado',
                                decoration: InputDecoration(
                                    labelText: 'Status',
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal)),
                              )
                            : TextFormField(
                                enabled: false,
                                readOnly: true,
                                initialValue: _formFeedBackData['status'],
                                decoration:
                                    InputDecoration(labelText: 'Status'),
                              ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Data de Realização',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: callDatePickerFeedBack,
                              color: Colors.blueAccent,
                            ),
                            Container(
                              child: realizationDate == null
                                  ? Text(
                                      "Selecione a data de realização do treino",
                                    )
                                  : Text(
                                      '${DateFormat("dd/MM/yyyy").format(realizationDate)}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: 'Como foi o treino',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          value: _selectedDescriptionFeedback,
                          validator: FieldNotInformed.validate,
                          onSaved: (newValue) =>
                              _formTrainingaData['description'] =
                                  _selectedDescriptionFeedback,
                          items: _descriptionFeedbacks.map((routeType) {
                            return DropdownMenuItem(
                              child: Text(routeType),
                              value: routeType,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDescriptionFeedback = newValue;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: _formFeedBackData['distance'],
                          decoration: InputDecoration(
                              labelText: 'Distância',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formFeedBackData['distance'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formFeedBackData['time'],
                          decoration: InputDecoration(
                              labelText: 'Tempo',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formFeedBackData['time'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formFeedBackData['pace'],
                          decoration: InputDecoration(
                              labelText: 'Ritmo',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formFeedBackData['pace'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formFeedBackData['physicalEffort'],
                          decoration: InputDecoration(
                              labelText: 'Esforço',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formFeedBackData['physicalEffort'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formFeedBackData['externalLink'],
                          decoration: InputDecoration(
                              labelText: 'Link Externo',
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                          onSaved: (newValue) =>
                              _formFeedBackData['externalLink'] = newValue,
                        ),
                        TextFormField(
                          initialValue: _formFeedBackData['note'],
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Observação para o professor',
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          onSaved: (newValue) =>
                              _formFeedBackData['note'] = newValue,
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
    );
  }
}
