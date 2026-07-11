import 'package:alkher/services/test_connection.dart';
import 'package:flutter/material.dart';

class TestUi extends StatefulWidget {
  const TestUi({super.key});

  @override
  State<TestUi> createState() => _TestUiState();
}

class _TestUiState extends State<TestUi> {

  @override
  void initState() {
    
    super.initState();
    TestConnection().testConnection();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test UI'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}