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
              new charts.Series<dynamic, String>(
                id: 'products',
                colorFn: (_, __) => charts.ColorUtil.fromDartColor(
                  AppColors.SECONDARY,
                ),
                labelAccessorFn: (p, _) => '${p['name']}',
                domainFn: (p, _) {
                  String x = p['name'];
                  if (x.length > 15) {
                    return '${x.substring(0, 15)}...';
                  }
                  return x;
                },
                measureFn: (p, _) => p['value'],
                outsideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
                insideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(AppColors.PRIMARY),
                ),
                data: data.data,
              )
            ],
            animate: true,
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
            domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.SmallTickRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 12,
                  color: charts.MaterialPalette.white,
                ),
                lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white,
                ),
              ),
            ),
            behaviors: [
              charts.ChartTitle(
                "Consumo de Produtos",
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
                  color: Colors.white,
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
