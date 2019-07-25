import 'package:charts_flutter/flutter.dart' as charts;
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimpleLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: CleaningRepository.get().getFrequencyData(),
      builder: (context, data) {
        if (data.hasData && data.data.isNotEmpty) {
          return new charts.TimeSeriesChart(
            [
              new charts.Series<dynamic, DateTime>(
                id: 'clen',
                colorFn: (_, __) => charts.ColorUtil.fromDartColor(
                  AppColors.SECONDARY,
                ),
                domainFn: (p, _) => p['date'],
                measureFn: (p, _) => p['value'],
                data: data.data,
              )
            ],
            animate: true,
            dateTimeFactory: LocalDateTimeFactory(),
            animationDuration: Duration(
              milliseconds: 500,
            ),
            primaryMeasureAxis: new charts.NumericAxisSpec(
              renderSpec: new charts.GridlineRendererSpec(
                lineStyle: charts.LineStyleSpec(dashPattern: [3]),
                labelStyle: charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
                axisLineStyle: charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.SECONDARY),
                ),
              ),
            ),
            domainAxis: new charts.DateTimeAxisSpec(
              renderSpec: new charts.SmallTickRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 12,
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
                lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
              ),
              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                month: new charts.TimeFormatterSpec(),
                day: new charts.TimeFormatterSpec(),
              ),
            ),
            behaviors: [
              charts.ChartTitle(
                "Frequência de Faxinas",
                subTitle: 'Quantidade de faxinas realizadas por mês',
                subTitleStyleSpec: charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                  fontSize: 15
                ),
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

class LocalDateTimeFactory implements charts.DateTimeFactory {
  const LocalDateTimeFactory();

  DateTime createDateTimeFromMilliSecondsSinceEpoch(
      int millisecondsSinceEpoch) {
    return new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  DateTime createDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    return new DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }

  /// Returns a [DateFormat].
  DateFormat createDateFormat(String pattern) {
    return new DateFormat("MMMM yyyy", "PT_BR");
  }
}
