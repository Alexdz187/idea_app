import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../servicios/notification_servicio.dart';

class VistaConfiguracion extends StatefulWidget {
  const VistaConfiguracion({super.key});

  @override
  State<VistaConfiguracion> createState() => _VistaConfiguracionState();
}

class _VistaConfiguracionState extends State<VistaConfiguracion> {
  int _frecuenciaSeleccionada = 7; // Por defecto, 7 días

  @override
  void initState() {
    super.initState();
    _cargarPreferencia();
  }

  Future<void> _cargarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _frecuenciaSeleccionada = prefs.getInt('frecuenciaNotificaciones') ?? 7;
    });
  }

  Future<void> _guardarPreferencia(int? valor) async {
    if (valor == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('frecuenciaNotificaciones', valor);

    setState(() {
      _frecuenciaSeleccionada = valor;
    });

    await NotificationServicio().programarNotificacionPeriodica(valor);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_getMensajeConfirmacion(valor))),
    );
  }

  String _getMensajeConfirmacion(int valor) {
    if (valor == 0) return "Notificaciones desactivadas.";
    if (valor == 1) return "Recordatorios programados diariamente.";
    return "Recordatorios programados semanalmente.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Frecuencia de Recordatorios', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            dense: true,
          ),
          RadioListTile<int>(
            title: const Text('Diariamente'),
            value: 1,
            groupValue: _frecuenciaSeleccionada,
            onChanged: _guardarPreferencia,
          ),
          // OPCIÓN DE 3 DÍAS ELIMINADA
          RadioListTile<int>(
            title: const Text('Semanalmente'),
            subtitle: const Text('Recomendado'),
            value: 7,
            groupValue: _frecuenciaSeleccionada,
            onChanged: _guardarPreferencia,
          ),
          const Divider(),
          RadioListTile<int>(
            title: const Text('Desactivar notificaciones'),
            value: 0,
            groupValue: _frecuenciaSeleccionada,
            onChanged: _guardarPreferencia,
          ),
        ],
      ),
    );
  }
}