import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/models/physical_evaluation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhysicalEvaluationDetail extends StatefulWidget {
  @override
  _PhysicalEvaluationDetailState createState() =>
      _PhysicalEvaluationDetailState();
}

class _PhysicalEvaluationDetailState extends State<PhysicalEvaluationDetail> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formaData = {};
  PhysicalEvaluationModal _physicalEvaluation;
  bool _isLoading = false;

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

  void _loadFormData(PhysicalEvaluationModal physicalEvaluation) {
    if (physicalEvaluation != null) {
      _formaData['id'] = physicalEvaluation.id;
      _formaData['idInstructor'] = physicalEvaluation.idInstructor;
      _formaData['idStudent'] = physicalEvaluation.idStudent;
      _formaData['instructor'] = physicalEvaluation.instructor.name;
      _formaData['student'] = physicalEvaluation.student.name;
      _formaData['evaluationDate'] =
          DateFormat("dd/MM/yyyy").format(physicalEvaluation.evaluationDate);
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _physicalEvaluation = ModalRoute.of(context).settings.arguments;
    _loadFormData(_physicalEvaluation);
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
                                  initialValue: _formaData['evaluationDate'],
                                  decoration: InputDecoration(
                                      labelText: 'Data da Avaliação',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['height'],
                                  decoration: InputDecoration(
                                      labelText: 'Altura',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['weight'],
                                  decoration: InputDecoration(
                                      labelText: 'Peso',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['chest'],
                                  decoration: InputDecoration(
                                      labelText: 'Tórax',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['waist'],
                                  decoration: InputDecoration(
                                      labelText: 'Cintura',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['abdomen'],
                                  decoration: InputDecoration(
                                      labelText: 'Abdômen',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['hip'],
                                  decoration: InputDecoration(
                                      labelText: 'Quadril',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['forearmRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Antebraço Direito',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['forearmLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Antebraço Esquerdo',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['armRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Braço Direito',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['armLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Braço Esquerdo',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['thighRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Coxa Direita',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['thighLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Coxa Esquerda',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['calfRight'],
                                  decoration: InputDecoration(
                                      labelText: 'Panturrilha Direita',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['calfLeft'],
                                  decoration: InputDecoration(
                                      labelText: 'Panturrilha Esquerda',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['currentFat'],
                                  decoration: InputDecoration(
                                      labelText: 'Gordura Atual %',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['weightFat'],
                                  decoration: InputDecoration(
                                      labelText: 'Peso Gordo',
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal)),
                                ),
                                TextFormField(
                                  enabled: false,
                                  readOnly: true,
                                  initialValue: _formaData['weightThin'],
                                  decoration: InputDecoration(
                                      labelText: 'Peso Magro',
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
