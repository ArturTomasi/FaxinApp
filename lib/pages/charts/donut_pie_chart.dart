import 'package:charts_flutter/flutter.dart' as charts;
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: CleaningRepository.get().getDonutData(),
      builder: (context, data) {
        if (data.hasData && data.data.isNotEmpty) {
          return charts.PieChart(
            [
              charts.Series<dynamic, int>(
                id: 'donut-data',
                labelAccessorFn: (row, _) =>
                    '${Frequency.valueOf(row['type']).label}: ${row['count']}',
                colorFn: (row, _) => charts.Color.fromHex(
                    code: Frequency.valueOf(row['type']).color),
                domainFn: (sales, _) => sales['type'],
                measureFn: (sales, _) => sales['count'],
                data: data.data,
              )
            ],
            animate: true,
            animationDuration: Duration(
              milliseconds: 500,
            ),
            defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 40,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside,
                  outsideLabelStyleSpec: charts.TextStyleSpec(
                    color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                    fontFamily: '',
                    fontSize: 12,
                  ),
                  labelPadding: 0,
                  showLeaderLines: false,
                ),
              ],
            ),
            behaviors: [
              charts.ChartTitle(
                "Tipos de Faxina",
                subTitle: ' ',
                titleStyleSpec: charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
              ),
            ],
          );
        } else if (data.hasData) {
          return Container(
            color: AppColors.PRIMARY_LIGHT,
            child: Center(
              child: Text(
                "Sem dados",
                style: TextStyle(
                  color: AppColors.PRIMARY,
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: AppColors.PRIMARY_LIGHT,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
