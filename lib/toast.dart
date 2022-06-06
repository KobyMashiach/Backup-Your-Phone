import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMassageShort {
  final String msg;
  final Color? color;
  ToastMassageShort({required this.msg, this.color}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? const Color.fromARGB(255, 37, 37, 37),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class ToastMassageLong {
  final String msg;
  final Color? color;
  final ToastGravity? toastGravity;
  ToastMassageLong({required this.msg, this.color, this.toastGravity}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: toastGravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? const Color.fromARGB(255, 37, 37, 37),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
