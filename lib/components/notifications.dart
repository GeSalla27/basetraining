import 'package:basetraining/provider/messaging.dart';

Future<void> sendMessage(_title, _body, _fcmToken) async {
  try {
    await Messaging.sendTo(
      title: _title,
      body: _body,
      fcmToken: _fcmToken,
    );
  } catch (e) {
    print(e);
  }
}
