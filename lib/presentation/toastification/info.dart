import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showInfoMessage(context, String message){
  toastification.show(
	  context: context,
	  type: ToastificationType.info,
	  style: ToastificationStyle.flatColored,
	  title: Text("Information"),
	  description: Text(message),
	  alignment: Alignment.topCenter,
	  autoCloseDuration: const Duration(seconds: 5),
	  animationBuilder: (context, animation, alignment, child) {
	    return ScaleTransition(scale: animation, child: child);
	  },
	  backgroundColor: Color(0xFF5C905C),
	  icon: Icon(Icons.info_outline_rounded),
	  borderRadius: BorderRadius.circular(12.0),
	  boxShadow: lowModeShadow,
	  dragToClose: true,
	);
}