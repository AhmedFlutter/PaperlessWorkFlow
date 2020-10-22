import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
  fillColor: Color(0Xf2f2f2),
  filled: true,
  hintStyle: TextStyle(color: Colors.black26),
  contentPadding: EdgeInsets.all(14.0),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(color: Colors.red, width:1.0)
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(color: Colors.red, width:1.0)
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(color: Colors.red, width:2.0)
  )
);
