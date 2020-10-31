import 'package:basetraining/components/validators/validator_login.dart';
import 'package:basetraining/models/training.dart';
import 'package:basetraining/services/api_trainings.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';

class Trainings with ChangeNotifier {
  ApiTrainings _api = locator<ApiTrainings>();

  List<TrainingModal> trainings;

  Future<List<TrainingModal>> findAll() async {
    var result = await _api.getDataCollection();
    trainings = result.docs
        .map((doc) => TrainingModal.fromMap(doc.data(), doc.id))
        .toList();
    return trainings;
  }

  Future<List<TrainingModal>> findQuery(dynamic array, dynamic value) async {
    var result = await _api.getQueryCollection(array, value);
    trainings = result.docs
        .map((doc) => TrainingModal.fromMap(doc.data(), doc.id))
        .toList();
    return trainings;
  }

  Future<List<TrainingModal>> findTraningsByDate(
      dynamic array, dynamic value, dynamic date) async {
    var result = await _api.getTrainingsByDate(array, value, date);
    trainings = result.docs
        .map((doc) => TrainingModal.fromMap(doc.data(), doc.id))
        .toList();
    return trainings;
  }

  int get count {
    return trainings.length;
  }

  Future<String> put(TrainingModal training, context) async {
    String message;
    if (training == null) {
      message = 'Erro inconsistencia nos dados';
    }

    if (training.id != null) {
      await _api.updateDocument(training.toJson(), training.id);
    } else {
      try {
        await _api.addDocument(training.toJson()).then((value) {
          TrainingModal objIdCreated = TrainingModal(
            id: value.id.toString(),
            idInstructor: training.idInstructor,
            idStudent: training.idStudent,
            status: training.status,
            trainingDate: training.trainingDate,
            student: training.student,
            instructor: training.instructor,
            description: training.description,
            note: training.note,
            distance: training.distance,
            time: training.time,
            warmingUp: training.warmingUp,
            pace: training.pace,
            modality: training.modality,
            trainingType: training.trainingType,
            intensity: training.intensity,
            routeType: training.routeType,
            feedback: training.feedback,
          );
          _api.updateDocument(objIdCreated.toJson(), value.id);
        });
      } catch (e) {
        message = ValidatorLogin.validate(e.code);
      }
    }

    notifyListeners();
    return message;
  }

  Future remove(TrainingModal training) async {
    if (training != null && training.id != null) {
      await _api.removeDocument(training.id);
      notifyListeners();
      return;
    }
  }
}
