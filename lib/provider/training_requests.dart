import 'package:basetraining/components/validators/validator_login.dart';
import 'package:basetraining/models/training_request.dart';
import 'package:basetraining/services/api_training_requests.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';

class TrainingRequests with ChangeNotifier {
  ApiTrainingRequests _api = locator<ApiTrainingRequests>();

  List<TrainingRequestModal> trainingRequests;

  Future<List<TrainingRequestModal>> findAll() async {
    var result = await _api.getDataCollection();
    trainingRequests = result.docs
        .map((doc) => TrainingRequestModal.fromMap(doc.data(), doc.id))
        .toList();
    return trainingRequests;
  }

  Future<List<TrainingRequestModal>> findQuery(
      dynamic array, dynamic value) async {
    var result = await _api.getQueryCollection(array, value);
    trainingRequests = result.docs
        .map((doc) => TrainingRequestModal.fromMap(doc.data(), doc.id))
        .toList();
    return trainingRequests;
  }

  int get count {
    return trainingRequests.length;
  }

  Future<String> put(TrainingRequestModal trainingRequest, context) async {
    String message;
    if (trainingRequest == null) {
      message = 'Erro inconsistencia nos dados';
    }

    if (trainingRequest.id != null) {
      await _api.updateDocument(trainingRequest.toJson(), trainingRequest.id);
    } else {
      try {
        await _api.addDocument(trainingRequest.toJson()).then((value) {
          TrainingRequestModal objIdCreated = TrainingRequestModal(
            id: value.id.toString(),
            idInstructor: trainingRequest.idInstructor,
            idStudent: trainingRequest.idStudent,
            status: trainingRequest.status,
            activities: trainingRequest.activities,
            student: trainingRequest.student,
            instructor: trainingRequest.instructor,
            kmGoal: trainingRequest.kmGoal,
            note: trainingRequest.note,
            paceGoal: trainingRequest.paceGoal,
            requestDate: trainingRequest.requestDate,
            testGoal: trainingRequest.testGoal,
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

  Future remove(TrainingRequestModal trainingRequest) async {
    if (trainingRequest != null && trainingRequest.id != null) {
      await _api.removeDocument(trainingRequest.id);
      notifyListeners();
      return;
    }
  }
}
