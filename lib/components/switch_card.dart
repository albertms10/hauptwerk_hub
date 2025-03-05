import 'package:flutter/material.dart';

class SwitchCard extends StatefulWidget {
  final bool isEnabled;
  final Widget? child;
  final Widget enabledLabel;
  final Widget disabledLabel;
  final void Function()? onEnabled;
  final void Function()? onDisabled;

  const SwitchCard({
    super.key,
    this.isEnabled = false,
    this.child,
    required this.enabledLabel,
    required this.disabledLabel,
    this.onEnabled,
    this.onDisabled,
  });

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  late var _isEnabled = widget.isEnabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 16,
          top: 8,
          bottom: 8,
          end: 8,
        ),
        child: Row(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.child != null) Expanded(child: widget.child!),
            if (_isEnabled)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEnabled = false;
                  });
                  widget.onDisabled?.call();
                },
                child: widget.disabledLabel,
              )
            else
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEnabled = true;
                  });
                  widget.onEnabled?.call();
                },
                child: widget.enabledLabel,
              ),
          ],
        ),
      ),
    );
  }
}
