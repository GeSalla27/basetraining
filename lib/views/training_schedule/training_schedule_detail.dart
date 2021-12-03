import 'package:basetraining/components/alert.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/components/enums/arrayModels.dart';
import 'package:basetraining/components/notifications.dart';
import 'package:basetraining/components/validators/validator_input.dart';
import 'package:basetraining/models/feedback.dart';
import 'package:basetraining/models/training.dart';
import 'package:basetraining/models/user.dart';
import 'package:basetraining/provider/trainings.dart';
import 'package:basetraining/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TrainingScheduleDetail extends StatefulWidget {
  @override
  _TrainingScheduleDetailState createState() => _TrainingScheduleDetailState();
}

class _TrainingScheduleDetailState extends State<TrainingScheduleDetail> {
  var realizationDate;
  UserModal _userLogged;
  TrainingModal _training;
  String _selectedDescriptionFeedback;
  final _formTraining = GlobalKey<FormState>();
  final _formFeedBack = GlobalKey<FormState>();
  final Map<String, String> _formTrainingaData = {};
  final Map<String, String> _formFeedBackData = {};
  List<String> _descriptionFeedbacks = ArrayModels().descriptionFeedback;
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> registerFeedback(TrainingModal trainingObj) async {
    try {
      final isValid = _formFeedBack.currentState.validate();

      if (realizationDate == null) {
        await showAlertDialog(context, 'Ops!',
            'Por favor informar a data de realização do treino!');
        return;
      }

      if (_selectedDescriptionFeedback == null) {
        await showAlertDialog(
            context, 'Ops!', 'Por favor informar como foi o treino!');
        return;
      }

      if (!isValid) {
        await showAlertDialog(
            context, 'Ops!', 'Campos obrigatórios não foram preenchidos!');
        return;
      }

      if (isValid) {
        _formFeedBack.currentState.save();
        showLoading();
      }

      FeedbackModal feedbackObj = FeedbackModal(
          status: "Realizado",
          realizationDate: realizationDate,
          description: _formFeedBackData['description'],
          distance: _formFeedBackData['distance'],
          time: _formFeedBackData['time'],
          pace: _formFeedBackData['pace'],
          physicalEffort: _formFeedBackData['physicalEffort'],
          externalLink: _formFeedBackData['externalLink'],
          note: _formFeedBackData['note']);

      String message = await Provider.of<Trainings>(context, listen: false).put(
          TrainingModal(
              id: trainingObj.id,
              idInstructor: trainingObj.idInstructor,
              idStudent: trainingObj.idStudent,
              status: "Realizado",
              trainingDate: trainingObj.trainingDate,
              student: trainingObj.student,
              instructor: trainingObj.instructor,
              description: trainingObj.description,
              note: trainingObj.note,
              distance: trainingObj.distance,
              time: trainingObj.time,
              warmingUp: trainingObj.warmingUp,
              pace: trainingObj.pace,
              modality: trainingObj.modality,
              trainingType: trainingObj.trainingType,
              intensity: trainingObj.intensity,
              routeType: trainingObj.routeType,
              feedback: feedbackObj),
          context);

      hideLoading();

      if (message != null && message.isNotEmpty) {
        await showAlertDialog(context, 'Ops!', message);
        return;
      }

      sendMessage(
          'Você recebeu um novo feedback. ',
          'Aluno ' +
              trainingObj.student.name +
              ': Treino ' +
              trainingObj.description +
              ' ' +
              trainingObj.trainingDate,
          trainingObj.instructor.fcmToken);

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

  void _loadFormData(TrainingModal training) {
    if (training != null) {
      _formTrainingaData['id'] = training.id;
      _formTrainingaData['idInstructor'] = training.idInstructor;
      _formTrainingaData['idStudent'] = training.idStudent;
      _formTrainingaData['status'] = training.status;
      _formTrainingaData['trainingDate'] = training.trainingDate;
      _formTrainingaData['studentName'] = training.student.name;
      _formTrainingaData['instructorName'] = training.instructor.name;
      _formTrainingaData['description'] = training.description;
      _formTrainingaData['note'] = training.note;
      _formTrainingaData['distance'] = training.distance;
      _formTrainingaData['time'] = training.time;
      _formTrainingaData['warmingUp'] = training.warmingUp;
      _formTrainingaData['pace'] = training.pace;
      _formTrainingaData['modality'] = training.modality;
      _formTrainingaData['trainingType'] = training.trainingType;
      _formTrainingaData['intensity'] = training.intensity;
      _formTrainingaData['routeType'] = training.routeType;

      if (training.feedback != null) {
        _formFeedBackData['status'] = training.feedback.status;
        _formFeedBackData['realizationDate'] =
            DateFormat("dd/MM/yyyy").format(training.feedback.realizationDate);
        _selectedDescriptionFeedback = training.feedback.description;
        _formFeedBackData['description'] = training.feedback.description;
        _formFeedBackData['distance'] = training.feedback.distance;
        _formFeedBackData['time'] = training.feedback.time;
        _formFeedBackData['pace'] = training.feedback.pace;
        _formFeedBackData['physicalEffort'] = training.feedback.physicalEffort;
        _formFeedBackData['externalLink'] = training.feedback.externalLink;
      } else {
        _formFeedBackData['status'] = "Não Realizado";
        _formFeedBackData['realizationDate'] = "";
        _formFeedBackData['description'] = "";
        _formFeedBackData['distance'] = "";
        _formFeedBackData['time'] = "";
        _formFeedBackData['pace'] = "";
        _formFeedBackData['physicalEffort'] = "";
        _formFeedBackData['externalLink'] = "";
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _training = ModalRoute.of(context).settings.arguments;
    if (Provider.of<Users>(context, listen: false).userLogged != null) {
      _userLogged = Provider.of<Users>(context, listen: false).userLogged;
    }
    _loadFormData(_training);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes().primaryColor,
          bottom: TabBar(
            onTap: (value) => FocusScope.of(context).unfocus(),
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
          title: Text('Detalhes Treino',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400)),
        ),
        body: TabBarView(
          children: [
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        backgroundColor: AppThemes().secondaryColor),
                  )
                : scheduleForm(),
            _formFeedBackData['status'] != "Realizado" && _userLogged.role == ''
                ? feedBackForm()
                : feedBackDetail(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView scheduleForm() {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _formTraining,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['status'],
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
                          initialValue: _formTrainingaData['trainingDate'],
                          decoration: InputDecoration(
                              labelText: 'Data do Treino',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['studentName'],
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
                          initialValue: _formTrainingaData['instructorName'],
                          decoration: InputDecoration(
                              labelText: 'Professor',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['description'],
                          decoration: InputDecoration(
                              labelText: 'Descrição do Treino',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['modality'],
                          decoration: InputDecoration(
                              labelText: 'Modalidade',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['trainingType'],
                          decoration: InputDecoration(
                              labelText: 'Tipo de Treino',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['intensity'],
                          decoration: InputDecoration(
                              labelText: 'Intensidade',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['routeType'],
                          decoration: InputDecoration(
                              labelText: 'Tipo de Percurso',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['warmingUp'],
                          decoration: InputDecoration(
                              labelText: 'Aquecimento',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['distance'],
                          decoration: InputDecoration(
                              labelText: 'Distância',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['time'],
                          decoration: InputDecoration(
                              labelText: 'Tempo',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['pace'],
                          decoration: InputDecoration(
                              labelText: 'Ritmo (pace)',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formTrainingaData['note'],
                          decoration: InputDecoration(
                              labelText: 'Observação',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                              _formFeedBackData['description'] =
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
                        SizedBox(height: 8),
                        (_userLogged.role == '' &&
                                _training.status != "Realizado")
                            ? Container(
                                width: 180,
                                height: 48,
                                child: RaisedButton(
                                  onPressed: () {
                                    showLoading();
                                    registerFeedback(_training);
                                  },
                                  color: AppThemes().signUpColor,
                                  child: Text(
                                    'Registar Feedback',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView feedBackDetail() {
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
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['status'],
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
                          initialValue: _formFeedBackData['realizationDate'],
                          decoration: InputDecoration(
                              labelText: 'Data de realização',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['description'],
                          decoration: InputDecoration(
                              labelText: 'Como foi o treino',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['distance'],
                          decoration: InputDecoration(
                              labelText: 'Distância',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['time'],
                          decoration: InputDecoration(
                              labelText: 'Tempo',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['time'],
                          decoration: InputDecoration(
                              labelText: 'Tempo',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['pace'],
                          decoration: InputDecoration(
                              labelText: 'Ritmo',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['physicalEffort'],
                          decoration: InputDecoration(
                              labelText: 'Esforço',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['externalLink'],
                          decoration: InputDecoration(
                              labelText: 'Link Externo',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
                        ),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          initialValue: _formFeedBackData['note'],
                          decoration: InputDecoration(
                              labelText: 'Observação para o professor',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal)),
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
