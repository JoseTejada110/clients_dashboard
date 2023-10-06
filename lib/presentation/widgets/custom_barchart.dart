import 'package:flutter/material.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/data/models/chart_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomBarchart extends StatelessWidget {
  const CustomBarchart({
    super.key,
    required this.legendTitle,
    required this.chartData,
    this.legend1,
    this.legend2,
  });
  final String legendTitle;
  final List<ChartData> chartData;
  final String? legend1;
  final String? legend2;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        title: LegendTitle(
            text: legendTitle,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        // legendItemBuilder: (legendText, series, point, seriesIndex) {
        //   print(legendText);
        //   return Text(legendTitle);
        // },
      ),
      primaryYAxis: NumericAxis(),
      primaryXAxis: CategoryAxis(),
      trackballBehavior: TrackballBehavior(
        enable: true,
        lineColor: Colors.transparent,
        markerSettings: const TrackballMarkerSettings(
          markerVisibility: TrackballVisibilityMode.visible,
          height: 10,
          width: 10,
          borderWidth: 1,
        ),
        hideDelay: 2000,
        activationMode: ActivationMode.singleTap,
      ),
      series: [
        ColumnSeries(
          // width: .25,
          gradient: LinearGradient(
            colors: [
              Constants.blue.withOpacity(.5),
              Constants.blue,
            ],
          ),
          // color: const Color(0XFF7078c2),
          borderRadius: BorderRadius.circular(5),
          // color: Constants.blue,
          dataSource: chartData,
          xValueMapper: (ChartData point, _) => point.x1,
          yValueMapper: (ChartData point, _) => point.y1,
          legendItemText: legend1,
        ),
        ColumnSeries(
          gradient: LinearGradient(
            colors: [
              Constants.green.withOpacity(.5),
              Constants.green,
            ],
          ),
          borderRadius: BorderRadius.circular(5),
          // color: Constants.green,
          dataSource: chartData,
          xValueMapper: (ChartData point, _) => point.x2,
          yValueMapper: (ChartData point, _) => point.y2,
          legendItemText: legend2,
        ),
      ],
    );
  }
}
