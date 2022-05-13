import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class ValueStreamConsumer<T> extends StatefulWidget {
  final ValueStream<T> stream;
  final Widget Function(BuildContext, T) builder;
  final void Function(BuildContext, T) listener;
  const ValueStreamConsumer({
    Key? key,
    required this.stream,
    required this.builder,
    required this.listener,
  }) : super(key: key);

  @override
  State<ValueStreamConsumer<T>> createState() => _ValueStreamConsumerState<T>();
}

class _ValueStreamConsumerState<T> extends State<ValueStreamConsumer<T>> {
  late StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen((event) {
      widget.listener(context, event);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: widget.stream,
        initialData: widget.stream.value,
        builder: (context, AsyncSnapshot<T> state) {
          return widget.builder(context, state.data!);
        });
  }
}
