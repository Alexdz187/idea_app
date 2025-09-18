import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'providers/promesa_provider.dart';
import 'providers/objetivo_provider.dart';
import 'providers/diario_provider.dart';
import 'temas/tema_app.dart';
import 'vistas/vista_principal.dart';
import 'vistas/onboarding/vista_bienvenida.dart';
import 'servicios/notification_servicio.dart'; 
// IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  // Inicializar servicio de notificaciones y pedir permisos
  final notificationServicio = NotificationServicio();
  await notificationServicio.init();
  await notificationServicio.requestPermissions();

  final prefs = await SharedPreferences.getInstance();
  final haVistoOnboarding = prefs.getBool('haVistoOnboarding') ?? false;
  
  runApp(AppPromesas(haVistoOnboarding: haVistoOnboarding));
}


class AppPromesas extends StatelessWidget {
  final bool haVistoOnboarding;

  const AppPromesas({super.key, required this.haVistoOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PromesaProvider()),
        ChangeNotifierProvider(create: (_) => ObjetivoProvider()),
        ChangeNotifierProvider(create: (_) => DiarioProvider()), // Provider añadido
      ],
      child: MaterialApp(
        title: 'App de Promesas',
        theme: TemaApp.temaClaro,
        debugShowCheckedModeBanner: false,
        home: haVistoOnboarding ? const VistaPrincipal() : const VistaBienvenida(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
        ],
      ),
    );
  }
}