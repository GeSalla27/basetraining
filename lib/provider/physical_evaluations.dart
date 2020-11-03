import 'package:basetraining/components/validators/validator_login.dart';
import 'package:basetraining/models/physical_evaluation.dart';
import 'package:basetraining/services/api_physical_evaluation.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';

class PhysicalEvaluations with ChangeNotifier {
  ApiPhysicalEvaluations _api = locator<ApiPhysicalEvaluations>();

  List<PhysicalEvaluationModal> physicalEvaluations;

  Future<List<PhysicalEvaluationModal>> findAll() async {
    var result = await _api.getDataCollection();
    physicalEvaluations = result.docs
        .map((doc) => PhysicalEvaluationModal.fromMap(doc.data(), doc.id))
        .toList();
    return physicalEvaluations;
  }

  Future<List<PhysicalEvaluationModal>> findQuery(
      dynamic array, dynamic value) async {
    var result = await _api.getQueryCollection(array, value);
    physicalEvaluations = result.docs
        .map((doc) => PhysicalEvaluationModal.fromMap(doc.data(), doc.id))
        .toList();
    return physicalEvaluations;
  }

  int get count {
    return physicalEvaluations.length;
  }

  Future<String> put(
      PhysicalEvaluationModal physicalEvaluation, context) async {
    String message;
    if (physicalEvaluation == null) {
      message = 'Erro inconsistencia nos dados';
    }

    if (physicalEvaluation.id != null) {
      await _api.updateDocument(
          physicalEvaluation.toJson(), physicalEvaluation.id);
    } else {
      try {
        await _api.addDocument(physicalEvaluation.toJson()).then((value) {
          PhysicalEvaluationModal objIdCreated = PhysicalEvaluationModal(
            id: value.id.toString(),
            idInstructor: physicalEvaluation.idInstructor,
            idStudent: physicalEvaluation.idStudent,
            student: physicalEvaluation.student,
            instructor: physicalEvaluation.instructor,
            evaluationDate: physicalEvaluation.evaluationDate,
            height: physicalEvaluation.height,
            weight: physicalEvaluation.weight,
            chest: physicalEvaluation.chest,
            waist: physicalEvaluation.waist,
            abdomen: physicalEvaluation.abdomen,
            hip: physicalEvaluation.hip,
            forearmRight: physicalEvaluation.forearmRight,
            forearmLeft: physicalEvaluation.forearmLeft,
            armRight: physicalEvaluation.armRight,
            armLeft: physicalEvaluation.armLeft,
            thighRight: physicalEvaluation.thighRight,
            thighLeft: physicalEvaluation.thighLeft,
            calfRight: physicalEvaluation.calfRight,
            calfLeft: physicalEvaluation.calfLeft,
            currentFat: physicalEvaluation.currentFat,
            weightFat: physicalEvaluation.weightFat,
            weightThin: physicalEvaluation.weightThin,
            note: physicalEvaluation.note,
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

  Future remove(PhysicalEvaluationModal physicalEvaluation) async {
    if (physicalEvaluation != null && physicalEvaluation.id != null) {
      await _api.removeDocument(physicalEvaluation.id);
      notifyListeners();
      return;
    }
  }
}
