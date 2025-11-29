import 'package:flutter/material.dart';
import 'package:inventory_tracker/presentation/widgets/customTextField.dart';

class CustomRowContent extends StatefulWidget {
  final String fristName;
  final String secondName;
  final TextEditingController? firstController;
  final TextEditingController? secondController;

  const CustomRowContent({
    super.key, 
    required this.fristName, 
    required this.secondName, 
    this.firstController, 
    this.secondController
    });

  @override
  State<CustomRowContent> createState() => _CustomRowContentState();
}

class _CustomRowContentState extends State<CustomRowContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.fristName, style: TextStyle(fontWeight: FontWeight.bold),),
                Customtextfield(
                  removeBorder: true,
                  hintText: widget.firstController!.text == ""
                      ? widget.fristName
                      : widget.firstController!.text,
                  controller: widget.firstController,
                ),
              ],
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.secondName,style: TextStyle(fontWeight: FontWeight.bold),),
                Customtextfield(
                  removeBorder: true,
                  hintText: widget.secondController!.text == ""
                      ? widget.secondName
                      : widget.secondController!.text,
                  controller: widget.secondController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
