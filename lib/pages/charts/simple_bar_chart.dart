import 'package:charts_flutter/flutter.dart' as charts;
import 'package:faxinapp/pages/products/models/product_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: ProductRepository.get().getCharProducts(),
      builder: (context, data) {
        if (data.hasData && data.data.isNotEmpty) {
          return new charts.BarChart(
            [
              new charts.Series<Map, String>(
                id: 'products',
                colorFn: (_, __) =>
                    charts.ColorUtil.fromDartColor(AppColors.SECONDARY),
                labelAccessorFn: (p, _) => '${p['value'].toInt()}%',
                domainFn: (p, _) => p['name'],
                measureFn: (p, _) => p['value'],
                data: data.data,
              )
            ],
            animate: true,
            vertical: false,
            barRendererDecorator: new charts.BarLabelDecorator<String>(
                labelPosition: charts.BarLabelPosition.inside,
                labelAnchor: charts.BarLabelAnchor.end),
            animationDuration: Duration(
              milliseconds: 500,
            ),
            domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                labelJustification: charts.TickLabelJustification.inside,
                labelAnchor: charts.TickLabelAnchor.centered,
                labelStyle: charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
                lineStyle: charts.LineStyleSpec(
                  dashPattern: [3],
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
              ),
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
            behaviors: [
              charts.ChartTitle(
                "Consumo de Produtos",
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
