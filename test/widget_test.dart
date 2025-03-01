// This is a basic Flutter widget test.

//

// To perform an interaction with a widget in your test, use the WidgetTester

// utility in the flutter_test package. For example, you can send tap and scroll

// gestures. You can also use WidgetTester to find child widgets in the widget

// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:everything/app.dart';
import 'package:everything/core/services/api_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final apiService = ApiService('http://test-api-base-url');
    
    await tester.pumpWidget(EverythingApp(
      prefs: prefs,
      apiService: apiService,
    ));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
