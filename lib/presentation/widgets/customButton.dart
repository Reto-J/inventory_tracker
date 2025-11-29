import 'package:flutter/material.dart';

class Custombutton extends StatefulWidget {
  final Color? brColor;
  final Color? fgColor;
  final String text;
  final Function() onPressed;
  const Custombutton({
    super.key, 
    required this.text, 
    required this.onPressed, 
    this.brColor, 
    this.fgColor = Colors.white
    });

  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
              backgroundColor: widget.brColor ?? Colors.blue,
              foregroundColor: widget.fgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
        child: Text(widget.text),
            
      ),
    );
  }
}
