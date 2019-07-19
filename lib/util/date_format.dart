
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

void initDateFormat(){
  Intl.defaultLocale = "pt_BR";
  
  initializeDateFormattingCustom(
      locale: "pt_BR",
      symbols: new DateSymbols(
          NAME: "pt_BR",
          ERAS: const ['a.C.', 'd.C.'],
          ERANAMES: const ['antes de Cristo', 'depois de Cristo'],
          NARROWMONTHS: const [
            'J',
            'F',
            'M',
            'A',
            'M',
            'J',
            'J',
            'A',
            'S',
            'O',
            'N',
            'D'
          ],
          STANDALONENARROWMONTHS: const [
            'J',
            'F',
            'M',
            'A',
            'M',
            'J',
            'J',
            'A',
            'S',
            'O',
            'N',
            'D'
          ],
          MONTHS: const [
            'Janeiro',
            'Fevereiro',
            'Março',
            'Abril',
            'Maio',
            'Junho',
            'Julho',
            'Agosto',
            'Setembro',
            'Outubro',
            'Novembro',
            'Dezembro'
          ],
          STANDALONEMONTHS: const [
            'Janeiro',
            'Fevereiro',
            'Março',
            'Abril',
            'Maio',
            'Junho',
            'Julho',
            'Agosto',
            'Setembro',
            'Outubro',
            'Novembro',
            'Dezembro'
          ],
          SHORTMONTHS: const [
            'Jan',
            'Fev',
            'Mar',
            'Abr',
            'Mai',
            'Jun',
            'Jul',
            'Ago',
            'Set',
            'Out',
            'Nov',
            'Dez'
          ],
          STANDALONESHORTMONTHS: const [
            'Jan',
            'Fev',
            'Mar',
            'Abr',
            'Mai',
            'Jun',
            'Jul',
            'Ago',
            'Set',
            'Out',
            'Nov',
            'Dez'
          ],
          WEEKDAYS: const [
            'Domingo',
            'Segunda-Feira',
            'Terça-Feira',
            'Quarta-Feira',
            'Quinta-Feira',
            'Sexta-Feira',
            'Sábado'
          ],
          STANDALONEWEEKDAYS: const [
            'Domingo',
            'Segunda-Feira',
            'Terça-Feira',
            'Quarta-Feira',
            'Quinta-Feira',
            'Sexta-Feira',
            'Sábado'
          ],
          SHORTWEEKDAYS: const [
            'Dom',
            'Seg',
            'Ter',
            'Qua',
            'Qui',
            'Sex',
            'Sáb'
          ],
          STANDALONESHORTWEEKDAYS: const [
            'Dom',
            'Seg',
            'Ter',
            'Qua',
            'Qui',
            'Sex',
            'Sáb'
          ],
          NARROWWEEKDAYS: const ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'],
          STANDALONENARROWWEEKDAYS: const ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'],
          SHORTQUARTERS: const ['T1', 'T2', 'T3', 'T4'],
          QUARTERS: const [
            '1º trimestre',
            '2º trimestre',
            '3º trimestre',
            '4º trimestre'
          ],
          AMPMS: const ['AM', 'PM'],
          DATEFORMATS: const [
            'EEEE, d \'de\' MMMM \'de\' y',
            'd \'de\' MMMM \'de\' y',
            'd \'de\' MMM \'de\' y',
            'dd/MM/y'
          ],
          TIMEFORMATS: const [
            'HH:mm:ss zzzz',
            'HH:mm:ss z',
            'HH:mm:ss',
            'HH:mm'
          ],
          DATETIMEFORMATS: const ['{1} {0}', '{1} {0}', '{1} {0}', '{1} {0}'],
          FIRSTDAYOFWEEK: 6,
          WEEKENDRANGE: const [5, 6],
          FIRSTWEEKCUTOFFDAY: 5),
      patterns: {
        'd': 'd', // DAY
        'E': 'ccc', // ABBR_WEEKDAY
        'EEEE': 'cccc', // WEEKDAY
        'LLL': 'LLL', // ABBR_STANDALONE_MONTH
        'LLLL': 'LLLL', // STANDALONE_MONTH
        'M': 'L', // NUM_MONTH
        'Md': 'd/M', // NUM_MONTH_DAY
        'MEd': 'EEE, dd/MM', // NUM_MONTH_WEEKDAY_DAY
        'MMM': 'LLL', // ABBR_MONTH
        'MMMd': 'd \'de\' MMM', // ABBR_MONTH_DAY
        'MMMEd': 'EEE, d \'de\' MMM', // ABBR_MONTH_WEEKDAY_DAY
        'MMMM': 'LLLL', // MONTH
        'MMMMd': 'd \'de\' MMMM', // MONTH_DAY
        'MMMMEEEEd': 'EEEE, d \'de\' MMMM', // MONTH_WEEKDAY_DAY
        'QQQ': 'QQQ', // ABBR_QUARTER
        'QQQQ': 'QQQQ', // QUARTER
        'y': 'y', // YEAR
        'yM': 'MM/y', // YEAR_NUM_MONTH
        'yMd': 'dd/MM/y', // YEAR_NUM_MONTH_DAY
        'yMEd': 'EEE, dd/MM/y', // YEAR_NUM_MONTH_WEEKDAY_DAY
        'yMMM': 'MMM \'de\' y', // YEAR_ABBR_MONTH
        'yMMMd': 'd \'de\' MMM \'de\' y', // YEAR_ABBR_MONTH_DAY
        'yMMMEd': 'EEE, d \'de\' MMM \'de\' y', // YEAR_ABBR_MONTH_WEEKDAY_DAY
        'yMMMM': 'MMMM \'de\' y', // YEAR_MONTH
        'yMMMMd': 'd \'de\' MMMM \'de\' y', // YEAR_MONTH_DAY
        'yMMMMEEEEd': 'EEEE, d \'de\' MMMM \'de\' y', // YEAR_MONTH_WEEKDAY_DAY
        'yQQQ': 'QQQ \'de\' y', // YEAR_ABBR_QUARTER
        'yQQQQ': 'QQQQ \'de\' y', // YEAR_QUARTER
        'H': 'HH', // HOUR24
        'Hm': 'HH:mm', // HOUR24_MINUTE
        'Hms': 'HH:mm:ss', // HOUR24_MINUTE_SECOND
        'j': 'HH', // HOUR
        'jm': 'HH:mm', // HOUR_MINUTE
        'jms': 'HH:mm:ss', // HOUR_MINUTE_SECOND
        'jmv': 'HH:mm v', // HOUR_MINUTE_GENERIC_TZ
        'jmz': 'HH:mm z', // HOUR_MINUTETZ
        'jz': 'HH z', // HOURGENERIC_TZ
        'm': 'm', // MINUTE
        'ms': 'mm:ss', // MINUTE_SECOND
        's': 's', // SECOND
        'v': 'v', // ABBR_GENERIC_TZ
        'z': 'z', // ABBR_SPECIFIC_TZ
        'zzzz': 'zzzz', // SPECIFIC_TZ
        'ZZZZ': 'ZZZZ' // ABBR_UTC_TZ
      });
}