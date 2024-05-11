import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:titan_talk/utils/colors.dart';

void main() {
  test('Color Constants Test', () {
    expect(backgroundColor, Color.fromRGBO(13, 33, 54, 1));
    expect(buttonColor, Color.fromRGBO(28, 170, 96, 1));
    expect(footerColor, Color.fromRGBO(13, 33, 54, 1));
    expect(secondaryBackgroundColor, Color.fromRGBO(13, 33, 54, 1));
  });

  test('Button Color Test', () {
    expect(buttonColor, isNot(equals(backgroundColor)));
    expect(buttonColor, isInstanceOf<Color>());
  });
}
