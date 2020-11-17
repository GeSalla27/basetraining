import 'dart:io';

import 'package:basetraining/auth/auth.dart';
import 'package:basetraining/auth/auth_provider.dart';
import 'package:basetraining/components/app_themes.dart';
import 'package:basetraining/locator.dart';
import 'package:basetraining/provider/physical_evaluations.dart';
import 'package:basetraining/provider/training_requests.dart';
import 'package:basetraining/provider/trainings.dart';
import 'package:basetraining/provider/users.dart';
import 'package:basetraining/root/root_page.dart';
import 'package:basetraining/routes/app_routes.dart';
import 'package:basetraining/views/home/home_page.dart';
import 'package:basetraining/views/physical_evaluation/physical_evaluation_detail.dart';
import 'package:basetraining/views/physical_evaluation/physical_evaluation_form.dart';
import 'package:basetraining/views/physical_evaluation/physical_evaluation_list.dart';
import 'package:basetraining/views/training_request/training_request_detail.dart';
import 'package:basetraining/views/training_request/training_request_form.dart';
import 'package:basetraining/views/training_request/training_request_list.dart';
import 'package:basetraining/views/training_schedule/training_schedule_detail.dart';
import 'package:basetraining/views/training_schedule/training_schedule_form.dart';
import 'package:basetraining/views/training_schedule/training_schedule_list.dart';
import 'package:basetraining/views/user/user_detail.dart';
import 'package:basetraining/views/user/user_form.dart';
import 'package:basetraining/views/user/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Users(),
        ),
        ChangeNotifierProvider(
          create: (context) => TrainingRequests(),
        ),
        ChangeNotifierProvider(
          create: (context) => Trainings(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhysicalEvaluations(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

final pageController = PageController(initialPage: 1);

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        home: RootPage(),
        debugShowCheckedModeBanner: false,
        title: 'Base Training',
        theme: ThemeData(
          primaryColor: AppThemes().primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('pt', 'BR')],
        routes: {
          AppRoutes.HOME: (_) => HomePage(),
          AppRoutes.USER_LIST: (_) => UserList(),
          AppRoutes.USER_FORM: (_) => UserForm(),
          AppRoutes.USER_DETAIL: (_) => UserDetail(),
          AppRoutes.TRAINING_REQUEST_LIST: (_) => TrainingRequestList(),
          AppRoutes.TRAINING_REQUEST_FORM: (_) => TrainingRequestForm(),
          AppRoutes.TRAINING_REQUEST_DETAIL: (_) => TrainingRequestDetail(),
          AppRoutes.TRAINING_SCHEDULE_LIST: (_) => TrainingScheduleList(),
          AppRoutes.TRAINING_SCHEDULE_FORM: (_) => TrainingScheduleForm(),
          AppRoutes.TRAINING_SCHEDULE_DETAIL: (_) => TrainingScheduleDetail(),
          AppRoutes.PHYSICAL_EVALUATION_LIST: (_) => PhysicalEvaluationList(),
          AppRoutes.PHYSICAL_EVALUATION_FORM: (_) => PhysicalEvaluationForm(),
          AppRoutes.PHYSICAL_EVALUATION_DETAIL: (_) =>
              PhysicalEvaluationDetail(),
        },
      ),
    );
  }

  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showMessage(
            message['notification']['title'], message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        showMessage(
            message['notification']['title'], message['notification']['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        showMessage(
            message['notification']['title'], message['notification']['body']);
      },
    );

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );
    }

    super.initState();
  }

  showMessage(title, description) {
    Provider.of<Users>(context, listen: false)
        .getScaffoldKey
        .currentState
        .showSnackBar(
          SnackBar(
            content: Text(
              title + description,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87),
            ),
            backgroundColor: AppThemes().notificationColor,
            /*action: SnackBarAction(
              label: 'Ver',
              onPressed: () {
                if (title == 'Nova solicitação de treino. ' ||
                    title == 'Sua solicitação de treino foi aprovada. ') {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.TRAINING_REQUEST_LIST);
                } else if (title == 'Você recebeu um novo treino. ' ||
                    title == 'Você recebeu um novo feedback. ') {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.TRAINING_SCHEDULE_LIST);
                } else if (title == 'Você tem numa nova avaliação física. ') {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PHYSICAL_EVALUATION_LIST);
                }
              },
            ),*/
          ),
        );
  }
}
