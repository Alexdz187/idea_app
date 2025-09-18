import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/promesa_provider.dart';
import '../temas/tema_app.dart';

class VistaEstadisticas extends StatelessWidget {
  const VistaEstadisticas({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PromesaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Progreso'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildResumen(provider),
          const SizedBox(height: 32),
          Text(
            'Promesas creadas (últimos 7 días)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildGraficoPromesas(context, provider),
        ],
      ),
    );
  }

  Widget _buildResumen(PromesaProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTarjetaStat('Total', provider.totalPromesas.toString()),
        _buildTarjetaStat('Completadas', provider.promesasCompletadas.toString(), color: TemaApp.verdeSuave),
      ],
    );
  }

  Widget _buildTarjetaStat(String titulo, String valor, {Color color = Colors.white}) {
    return Card(
      color: color,
      elevation: 2,
      child: Container(
        width: 150,
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(valor, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(titulo, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoPromesas(BuildContext context, PromesaProvider provider) {
    // Lógica para agrupar promesas por día en los últimos 7 días
    final Map<int, int> datosGrafico = { for (var i = 0; i < 7; i++) i: 0 };
    final hoy = DateTime.now();
    
    for (var promesa in provider.promesas) {
      final diferencia = hoy.difference(promesa.fechaCreacion).inDays;
      if (diferencia >= 0 && diferencia < 7) {
        datosGrafico[6 - diferencia] = (datosGrafico[6 - diferencia] ?? 0) + 1;
      }
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
                  final hoyWeekday = hoy.weekday; // Lunes = 1, Domingo = 7
                  final diaIndex = (hoyWeekday - 7 + value.toInt()) % 7;
                  return SideTitleWidget(axisSide: meta.axisSide, child: Text(dias[diaIndex]));
                },
                reservedSize: 38,
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: datosGrafico.entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: TemaApp.azulClaro,
                  width: 16,
                  borderRadius: BorderRadius.circular(4)
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}