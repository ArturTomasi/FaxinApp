import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'cleaning_view.dart';

class CleaningTimeline extends StatefulWidget {
  @override
  _CleaningTimelineState createState() => _CleaningTimelineState();
}

class _CleaningTimelineState extends State<CleaningTimeline> {
  @override
  Widget build(BuildContext context) {
    CleaningBloc _bloc = BlocProvider.of(context);

    return StreamBuilder<List<Cleaning>>(
      stream: _bloc.pendencies,
      initialData: _bloc.pendencyCache,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Container(
              color: AppColors.PRIMARY_LIGHT,
              child: Center(
                child: Icon(
                  Icons.clear_all,
                  size: 100,
                  color: AppColors.SECONDARY,
                ),
              ),
            );
          }
          return CleaningTimelineWidget(snapshot.data);
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

class CleaningTimelineWidget extends StatelessWidget {
  final List<Cleaning> items;

  CleaningTimelineWidget(this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.PRIMARY_LIGHT,
      child: RefreshIndicator(
        onRefresh: () {
          return SharedUtil.syncronized( buildContext: context );
        },
        child: ListView.builder(
          itemBuilder: centerTimelineBuilder,
          itemCount: items.length,
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }

  Widget centerTimelineBuilder(BuildContext context, int i) {
    final cleaning = items[i];

    return GestureDetector(
      onTap: () async {
        CleaningBloc bloc = BlocProvider.of<CleaningBloc>(context);

        var provider = BlocProvider(
          bloc: bloc,
          child: CleaningView(
            cleaning: cleaning,
          ),
        );

        Cleaning next = await Navigator.push(
          context,
          AnimateRoute(
            builder: (context) => provider,
          ),
        );

        bloc.update(cleaning, next);
      },
      child: OrientationBuilder(
        builder: (context, i) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                      color: AppColors.PRIMARY_DARK,
                      blurRadius: 20.0,
                      spreadRadius: 1)
                ],
                shape: BoxShape.circle,
                color: AppColors.SECONDARY,
              ),
              width: 75,
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${cleaning.nextDate.day}',
                    style: TextStyle(
                      fontSize: 30,
                      color: AppColors.PRIMARY_LIGHT,
                    ),
                  ),
                  Container(
                    height: 2,
                    color: AppColors.PRIMARY_LIGHT,
                    width: 30,
                  ),
                  Text(
                    DateFormat.MMM().format(cleaning.nextDate),
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.PRIMARY_LIGHT,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              borderOnForeground: false,
              clipBehavior: Clip.antiAlias,
              elevation: 9,
              semanticContainer: false,
              color: AppColors.PRIMARY_DARK,
              margin: EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        heightFactor: 0,
                        alignment: Alignment.topRight,
                        child: cleaning.type == CleaningType.COMMON
                            ? Container()
                            : Icon(
                                cleaning.type == CleaningType.IMPORTED
                                    ? Icons.cloud_download
                                    : Icons.share,
                                color: AppColors.PRIMARY,
                                size: 18,
                              ),
                      ),
                      Text(
                        cleaning.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        cleaning.guidelines,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          deadline(cleaning),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: color(cleaning),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String deadline(Cleaning c) {
    DateTime now = DateTime.now();

    Duration duration = c.nextDate.difference(now);
    //complicated
    if (duration.inDays > 0 ||
        (duration.inDays == 0 && c.nextDate.day > now.day)) {
      return "Faltam ${duration.inDays + 1} dia${duration.inDays > 1 ? 's' : ''}";
    } else if (duration.inDays < 0 ||
        (duration.inDays == 0 && c.nextDate.day < now.day)) {
      return "${duration.inDays * -1} dia${duration.inDays > 1 ? 's' : ''} em atraso";
    } else {
      return "Hoje";
    }
  }

  Color color(Cleaning c) {
    DateTime now = DateTime.now();

    Duration duration = c.nextDate.difference(now);
    //complicated
    if (duration.inDays > 0 ||
        (duration.inDays == 0 && c.nextDate.day > now.day)) {
      return Colors.green;
    } else if (duration.inDays < 0 ||
        (duration.inDays == 0 && c.nextDate.day < now.day)) {
      return Colors.red;
    } else {
      return Colors.yellow.shade700;
    }
  }
}
