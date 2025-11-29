import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showErrorMessage(BuildContext context, String message){
toastification.show(
	  context: context,
	  type: ToastificationType.error,
	  style: ToastificationStyle.flatColored,
	  title: Text("Error"),
	  description: Text(message),
	  alignment: Alignment.topCenter,
	  autoCloseDuration: const Duration(seconds: 5),
	  animationBuilder: (context, animation, alignment, child) {
	    return ScaleTransition(scale: animation, child: child);
	  },
	  backgroundColor: Color(0xFF5C905C),
	  icon: Icon(Icons.cancel_outlined),
	  borderRadius: BorderRadius.circular(12.0),
	  boxShadow: lowModeShadow,
	  dragToClose: true,
	);
}