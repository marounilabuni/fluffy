import 'dart:async';

class CustomStream {
  static CustomStream instance = CustomStream();
  final _controller = StreamController<int>.broadcast();

  Stream<int> get stream => _controller.stream;

  void trigger(){
    updateData(12);
  }
  void updateData(int data) {
    _controller.sink.add(data);
  }

  void dispose() {
    _controller.close();
  }
}
