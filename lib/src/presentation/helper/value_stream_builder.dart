import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class ValueStreamBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext, T) builder;
  final ValueStream<T> stream;
  const ValueStreamBuilder(
      {super.key, required this.builder, required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      initialData: stream.value,
      builder: (context, AsyncSnapshot<T> snap) => builder(context, snap.data!),
    );
  }
}
