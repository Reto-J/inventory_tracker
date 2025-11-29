import 'package:flutter/material.dart';

class Customtextfield extends StatefulWidget {
  final String? hintText;
  final String? text;
  final TextEditingController? controller;
  final bool? isSearch;
  final bool? isPassword;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;
  final int? maxLine; 
  final bool? isDis;
  final bool? removeBorder;
  const Customtextfield({
    super.key,
    this.hintText,
    this.text = "",
    this.controller,
    this.isPassword = false,
    this.validator,
    this.isSearch = false, 
    this.maxLine, 
    this.isDis = false,
    this.removeBorder = false, 
    this.prefixIcon,
  });

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  bool showpassword = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isDis! ? 50 : null,
      child: TextFormField(
        // maxLines: widget.maxLine,
        validator: widget.validator,
        obscuringCharacter: "*",
        obscureText: widget.isPassword! ? !showpassword : false,
        controller: widget.controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffix: widget.isPassword!
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showpassword = !showpassword;
                    });
                  },
                  icon: Icon(
                    showpassword ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
          label: Text(widget.text!),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderSide: widget.removeBorder! ? BorderSide.none : BorderSide(color: Colors.red, width: 20),
            borderRadius: widget.isSearch!
                ? BorderRadius.circular(50)
                : BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
