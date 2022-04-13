import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  fillColor: Color(0xFFF5F5F5),
  filled: true,
  hintText: 'Все бренды',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF5F5F5), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF5F5F5), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);
