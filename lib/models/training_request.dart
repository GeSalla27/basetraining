import 'package:basetraining/models/user.dart';

class TrainingRequestModal {
  final String id;
  final String status;
  final String idInstructor;
  final String idStudent;
  final UserModal student;
  final UserModal instructor;
  final String kmGoal;
  final String paceGoal;
  final String testGoal;
  final String note;
  final DateTime requestDate;
  final List<dynamic> activities;

  const TrainingRequestModal({
    this.id,
    this.idInstructor,
    this.idStudent,
    this.status,
    this.student,
    this.instructor,
    this.kmGoal,
    this.paceGoal,
    this.testGoal,
    this.note,
    this.requestDate,
    this.activities,
  });

  TrainingRequestModal.fromMap(Map snapshot, String id)
      : id = snapshot['id'] ?? '',
        idInstructor = snapshot['idInstructor'] ?? '',
        idStudent = snapshot['idStudent'] ?? '',
        status = snapshot['status'] ?? '',
        student =
            UserModal.fromMap(snapshot['student'], snapshot['student']['id']) ??
                '',
        instructor = UserModal.fromMap(
                snapshot['instructor'], snapshot['instructor']['id']) ??
            '',
        kmGoal = snapshot['kmGoal'] ?? '',
        paceGoal = snapshot['paceGoal'] ?? '',
        testGoal = snapshot['testGoal'] ?? '',
        note = snapshot['note'] ?? '',
        requestDate = snapshot['requestDate'].toDate() ?? '',
        activities = List<String>.from(snapshot['activities']) ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'idInstructor': idInstructor,
        'idStudent': idStudent,
        'status': status,
        'student': student.toJson(),
        'instructor': instructor.toJson(),
        'kmGoal': kmGoal,
        'paceGoal': paceGoal,
        'testGoal': testGoal,
        'note': note,
        'requestDate': requestDate,
        'activities': activities,
      };

  @override
  String toString() {
    return super.toString();
  }
}
