import 'package:faxinapp/pages/charts/donut_pie_chart.dart';
import 'package:faxinapp/pages/charts/simple_bar_chart.dart';
import 'package:faxinapp/pages/charts/simple_line_chart.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.PRIMARY_LIGHT,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.height * 0.4),
            child: DonutPieChart(),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric( horizontal: 10 ),
            child: SizedBox(
              height: (MediaQuery.of(context).size.height * 0.7 ),
              child: SimpleBarChart(),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.height * 0.4),
            child: SimpleLineChart(),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
