import 'package:basetraining/models/user.dart';

class PhysicalEvaluationModal {
  final String id;
  final String idInstructor;
  final String idStudent;
  final UserModal student;
  final UserModal instructor;
  final DateTime evaluationDate;
  final String height; // Altura
  final String weight; // Peso
  final String chest; // Torax
  final String waist; // Cintura
  final String abdomen; // Abdomen
  final String hip; // Quadril
  final String forearm; // Ante braço
  final String arm; // braço
  final String thigh; // coxa
  final String calf; // panturrilha
  final String currentFat; // gordura atual
  final String weightFat; // peso gordo
  final String weightThin; // peso magro

  const PhysicalEvaluationModal({
    this.id,
    this.idInstructor,
    this.idStudent,
    this.student,
    this.instructor,
    this.evaluationDate,
    this.height,
    this.weight,
    this.chest,
    this.waist,
    this.abdomen,
    this.hip,
    this.forearm,
    this.arm,
    this.thigh,
    this.calf,
    this.currentFat,
    this.weightFat,
    this.weightThin,
  });

  PhysicalEvaluationModal.fromMap(Map snapshot, String id)
      : id = snapshot['id'] ?? '',
        idInstructor = snapshot['idInstructor'] ?? '',
        idStudent = snapshot['idStudent'] ?? '',
        student =
            UserModal.fromMap(snapshot['student'], snapshot['student']['id']) ??
                '',
        instructor = UserModal.fromMap(
                snapshot['instructor'], snapshot['instructor']['id']) ??
            '',
        evaluationDate = snapshot['evaluationDate'].toDate() ?? '',
        height = snapshot['height'] ?? '',
        weight = snapshot['weight'] ?? '',
        chest = snapshot['chest'] ?? '',
        waist = snapshot['waist'] ?? '',
        abdomen = snapshot['abdomen'] ?? '',
        hip = snapshot['abdomen'] ?? '',
        forearm = snapshot['forearm'] ?? '',
        arm = snapshot['arm'] ?? '',
        thigh = snapshot['thigh'] ?? '',
        calf = snapshot['calf'] ?? '',
        currentFat = snapshot['currentFat'] ?? '',
        weightFat = snapshot['weightFat'] ?? '',
        weightThin = snapshot['weightThin'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'idInstructor': idInstructor,
        'idStudent': idStudent,
        'student': student.toJson(),
        'instructor': instructor.toJson(),
        'evaluationDate': evaluationDate,
        'height': height,
        'weight': weight,
        'chest': chest,
        'waist': waist,
        'abdomen': abdomen,
        'hip': hip,
        'forearm': forearm,
        'arm': arm,
        'thigh': thigh,
        'calf': calf,
        'currentFat': currentFat,
        'weightFat': weightFat,
        'weightThin': weightThin,
      };

  @override
  String toString() {
    return super.toString();
  }
}
