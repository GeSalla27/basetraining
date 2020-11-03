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
  final String forearmRight; // Antebraço
  final String forearmLeft; // Antebraço
  final String armRight; // braço
  final String armLeft; // braço
  final String thighRight; // coxa
  final String thighLeft; // coxa
  final String calfRight; // panturrilha
  final String calfLeft; // panturrilha
  final String currentFat; // gordura atual
  final String weightFat; // peso gordo
  final String weightThin; // peso magro
  final String note;

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
    this.forearmRight,
    this.forearmLeft,
    this.armRight,
    this.armLeft,
    this.thighRight,
    this.thighLeft,
    this.calfRight,
    this.calfLeft,
    this.currentFat,
    this.weightFat,
    this.weightThin,
    this.note,
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
        hip = snapshot['hip'] ?? '',
        forearmRight = snapshot['forearmRight'] ?? '',
        forearmLeft = snapshot['forearmLeft'] ?? '',
        armRight = snapshot['armRight'] ?? '',
        armLeft = snapshot['armLeft'] ?? '',
        thighRight = snapshot['thighRight'] ?? '',
        thighLeft = snapshot['thighLeft'] ?? '',
        calfRight = snapshot['calfRight'] ?? '',
        calfLeft = snapshot['calfLeft'] ?? '',
        currentFat = snapshot['currentFat'] ?? '',
        weightFat = snapshot['weightFat'] ?? '',
        weightThin = snapshot['weightThin'] ?? '',
        note = snapshot['note'] ?? '';

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
        'forearmRight': forearmRight,
        'forearmLeft': forearmLeft,
        'armRight': armRight,
        'armLeft': armLeft,
        'thighRight': thighRight,
        'thighLeft': thighLeft,
        'calfRight': calfRight,
        'calfLeft': calfLeft,
        'currentFat': currentFat,
        'weightFat': weightFat,
        'weightThin': weightThin,
        'note': note,
      };

  @override
  String toString() {
    return super.toString();
  }
}
