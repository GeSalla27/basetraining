import 'package:basetraining/provider/physical_evaluations.dart';
import 'package:basetraining/provider/training_requests.dart';
import 'package:basetraining/provider/trainings.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/services/api_physical_evaluation.dart';
import 'package:basetraining/services/api_training_requests.dart';
import 'package:basetraining/services/api_trainings.dart';
import 'package:basetraining/services/api_users.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiUsers('users'));
  locator.registerLazySingleton(() => Users());
  locator.registerLazySingleton(() => ApiTrainingRequests('trainingRequests'));
  locator.registerLazySingleton(() => TrainingRequests());
  locator.registerLazySingleton(() => ApiTrainings('trainings'));
  locator.registerLazySingleton(() => Trainings());
  locator.registerLazySingleton(() => PhysicalEvaluations());
  locator.registerLazySingleton(
      () => ApiPhysicalEvaluations('physicalEvaluations'));
}
