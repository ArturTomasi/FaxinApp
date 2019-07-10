import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_view.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class PushNotification {
  final String channelId = "com.me.fa.faxinapp.cleaning.channel";
  final String channelName = "Agenda de Faxinas";
  final String channelInfo = "Canal para agendamento de faxinas";

  final BuildContext context;
  FlutterLocalNotificationsPlugin notifications;

  PushNotification(this.context) {
    initialize();
  }

  void initialize() {
    notifications = new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    notifications.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void schedule(Cleaning cleaning) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        channelId, channelName, channelInfo,
        color: AppColors.SECONDARY,
        importance: Importance.Max,
        priority: Priority.High);

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await notifications.schedule(cleaning.id, cleaning.name,
        cleaning.guidelines, cleaning.nextDate, platformChannelSpecifics,
        payload: 'faxinapp:${cleaning.id}');
  }

  Future cancel(Cleaning cleaning) async {
    await notifications.cancel(cleaning.id);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null && payload.startsWith('faxinapp:')) {
      Cleaning cleaning = await CleaningRepository.get().find(
        int.parse(
          payload.substring('faxinapp:'.length),
        ),
      );

      if (cleaning != null) {
        var provider = BlocProvider(
          bloc: CleaningBloc(),
          child: CleaningView(cleaning: cleaning),
        );

        Navigator.push(
          context,
          AnimateRoute(builder: (context) => provider),
        );
      }
    }
  }
}
