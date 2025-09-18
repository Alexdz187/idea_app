import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:math';

class NotificationServicio {
  static final NotificationServicio _instancia = NotificationServicio._internal();
  factory NotificationServicio() => _instancia;
  NotificationServicio._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  final List<String> _mensajesMotivacionales = [
    "Recuerda tu promesa. ¡Cada paso cuenta!",
    "¿Cómo vas con tu promesa? ¡No te rindas!",
    "Un pequeño progreso cada día suma grandes resultados. ¡Sigue así!",
    "Tu promesa es un compromiso contigo mismo. ¡Tú puedes!",
    "La disciplina es el puente entre tus metas y tus logros. ¡Adelante!"
  ];

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> cancelarNotificaciones() async {
    await _plugin.cancelAll();
  }

  Future<void> programarNotificacionPeriodica(int dias) async {
    await cancelarNotificaciones();

    if (dias == 0) {
      return;
    }

    final String mensajeAleatorio = _mensajesMotivacionales[Random().nextInt(_mensajesMotivacionales.length)];

    await _plugin.periodicallyShow(
      0,
      'Un recordatorio para ti',
      mensajeAleatorio,
      _mapearFrecuencia(dias),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_promesas',
          'Recordatorios de Promesas',
          channelDescription: 'Recordatorios para motivarte a cumplir tus promesas.',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // FUNCIÓN CORREGIDA
  RepeatInterval _mapearFrecuencia(int dias) {
    switch (dias) {
      case 1:
        return RepeatInterval.daily;
      case 7:
        return RepeatInterval.weekly;
      default:
        // Si por alguna razón llega otro valor, se usará semanal por defecto.
        return RepeatInterval.weekly;
    }
  }
}