import 'package:flutter/material.dart';

class EditingSlider extends StatefulWidget {
  const EditingSlider({
    super.key,
    required this.initial,
    required this.onChanged,
  });
  final int initial;
  final ValueChanged<int> onChanged;

  @override
  State<EditingSlider> createState() => _ProficiencySliderState();
}

class _ProficiencySliderState extends State<EditingSlider> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initial;
  }

  @override
  //if the parent widget rebuilds with a different initial value, we need to update our state accordingly
  void didUpdateWidget(covariant EditingSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial) {
      value = widget.initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value.toDouble(),
      min: 0,
      max: 100,
      divisions: 100,
      onChanged: (v) {
        setState(() => value = v.round());
        widget.onChanged(value);
      },
    );
  }
}
