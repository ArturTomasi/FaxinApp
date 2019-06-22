import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onChanged;
  DateTime initialValue;

  DatePicker({this.onChanged, this.initialValue});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String _dateString = '';
  DateTime _date;
  String _timeString = '';
  TimeOfDay _time;

  DateTime _getDate() =>
      widget.initialValue != null ? widget.initialValue : DateTime.now();

  TimeOfDay _getTime() => widget.initialValue != null
      ? TimeOfDay.fromDateTime(widget.initialValue)
      : TimeOfDay.now();

  Future _selectDate() async {
    _date = await showDatePicker(
        context: context,
        initialDate: _getDate(),
        firstDate: DateTime(_getDate().year),
        lastDate: DateTime(_getDate().year + 5),
        initialDatePickerMode: DatePickerMode.day,
        );

    setState(() {
      if (_date != null) {
        _dateString = DateFormat('dd/MM/yyyy').format(_date);
      } else {
        _dateString = 'dd/MM/yyy';
      }
    });
    fireChanges();
  }

  Future _selectTime() async {
  
    _time = await showTimePicker(context: context, 
    initialTime: _getTime());
    setState(() {
      if (_time != null) {
        _timeString = DateFormat.Hm().format( new DateTime(0, 0, 0, _time.hour, _time.minute ) );
      } else {
        _timeString = 'hh:mm';
      }
    });
    fireChanges();
  }

  void fireChanges() {
    if (widget.onChanged != null) {
      if ( _date != null && _time != null ) {
        widget.onChanged( DateTime( _date.year, _date.month, _date.day, _time.hour, _time.minute ) );
      }
      else if ( _date != null ) {
        widget.onChanged( DateTime( _date.year, _date.month, _date.day ) );
      }
      else {
        widget.onChanged(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 5, bottom: 10),
          child: Text("Agendamento",
              style: TextStyle(fontSize: 16, color: AppColors.SECONDARY),
              textAlign: TextAlign.start),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: _selectDate,
              child: Row(
                children: <Widget>[
                  Icon(Icons.calendar_today,
                      size: 30, color: AppColors.SECONDARY),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 150,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        _dateString != null && _dateString.isNotEmpty
                            ? _dateString
                            : 'dd/mm/yyy',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ))
                ],
              ),
            ),
            GestureDetector(
              onTap: _selectTime,
              child: Row(
                children: <Widget>[
                  Icon(Icons.timer, size: 30, color: AppColors.SECONDARY),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: 150,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        _timeString != null && _timeString.isNotEmpty
                            ? _timeString
                            : 'hh:mm',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Container(
          color: AppColors.PRIMARY_DARK,
          width: double.infinity,
          height: 1,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
      ],
    );
  }
}
