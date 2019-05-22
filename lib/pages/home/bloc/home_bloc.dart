import 'dart:async';

import 'package:faxinapp/bloc/bloc_provider.dart';

class HomeBloc implements BlocBase {
  StreamController<String> _titleController =
      StreamController<String>.broadcast();

  Stream<String> get title => _titleController.stream;

  @override
  void dispose() {
    _titleController.close();
  }

  void updateTitle(String title) {
    _titleController.sink.add(title);
  }
}
