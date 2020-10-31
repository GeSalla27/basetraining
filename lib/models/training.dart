import 'package:basetraining/models/feedback.dart';
import 'package:basetraining/models/user.dart';

class TrainingModal {
  final String id;
  final String idInstructor;
  final String idStudent;
  final String status;
  final String trainingDate;
  final UserModal student;
  final UserModal instructor;
  final String description;
  final String note;
  final String distance;
  final String time;
  final String warmingUp;
  final String pace;
  final String modality;
  final String trainingType;
  final String intensity;
  final String routeType;
  final FeedbackModal feedback;

  const TrainingModal({
    this.id,
    this.idInstructor,
    this.idStudent,
    this.status,
    this.trainingDate,
    this.student,
    this.instructor,
    this.description,
    this.note,
    this.distance,
    this.time,
    this.warmingUp,
    this.pace,
    this.modality,
    this.trainingType,
    this.intensity,
    this.routeType,
    this.feedback,
  });

  TrainingModal.fromMap(Map snapshot, String id)
      : id = snapshot['id'] ?? '',
        idInstructor = snapshot['idInstructor'] ?? '',
        idStudent = snapshot['idStudent'] ?? '',
        status = snapshot['status'] ?? '',
        trainingDate = snapshot['trainingDate'] ?? '',
        student =
            UserModal.fromMap(snapshot['student'], snapshot['student']['id']) ??
                '',
        instructor = UserModal.fromMap(
                snapshot['instructor'], snapshot['instructor']['id']) ??
            '',
        description = snapshot['description'] ?? '',
        note = snapshot['note'] ?? '',
        distance = snapshot['distance'] ?? '',
        time = snapshot['time'] ?? '',
        warmingUp = snapshot['warmingUp'] ?? '',
        pace = snapshot['pace'] ?? '',
        modality = snapshot['modality'] ?? '',
        trainingType = snapshot['trainingType'] ?? '',
        intensity = snapshot['intensity'] ?? '',
        routeType = snapshot['routeType'] ?? '',
        feedback = snapshot['feedback'] == null
            ? null
            : FeedbackModal.fromMap(snapshot['feedback']) ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'idInstructor': idInstructor,
        'idStudent': idStudent,
        'status': status,
        'trainingDate': trainingDate,
        'student': student.toJson(),
        'instructor': instructor.toJson(),
        'description': description,
        'note': note,
        'distance': distance,
        'time': time,
        'warmingUp': warmingUp,
        'pace': pace,
        'modality': modality,
        'trainingType': trainingType,
        'intensity': intensity,
        'routeType': routeType,
        'feedback': feedback == null ? null : feedback.toJson(),
      };

  @override
  String toString() {
    return super.toString();
  }
}
