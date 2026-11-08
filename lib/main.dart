import 'package:flutter/material.dart';

void main() {
  runApp(const MobtakirApp());
}

class MobtakirApp extends StatelessWidget {
  const MobtakirApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مبتكر',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1F13),
      ),
      home: const MobtakirHomeScreen(),
    );
  }
}

class MobtakirHomeScreen extends StatelessWidget {
  const MobtakirHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مبتكر | صانع التطبيقات بالذكاء'),
        centerTitle: true,
        backgroundColor: const Color(0xFF05110A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'اكتب فكرة تطبيقك:',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'مثال: تطبيق متجر أو أدوات...',
                filled: true,
                fillColor: const Color(0xFF112E1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'توليد التطبيق',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
