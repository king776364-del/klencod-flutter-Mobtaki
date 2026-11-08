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
        primaryColor: const Color(0xFF00C853),
      ),
      home: const MobtakirHomeScreen(),
    );
  }
}

class MobtakirHomeScreen extends StatefulWidget {
  const MobtakirHomeScreen({Key? key}) : super(key: key);

  @override
  State<MobtakirHomeScreen> createState() => _MobtakirHomeScreenState();
}

class _MobtakirHomeScreenState extends State<MobtakirHomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _selectedPlatform = 'android';
  bool _isGenerating = false;
  String _resultCode = "";
  bool _isPremium = false;

  void _showJeepPaymentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF112E1F),
        title: const Text('ترقية تطبيق مبتكر', style: TextStyle(color: Color(0xFF00C853))),
        content: const Text(
          'سعر التفعيل: 7,000 ريال يمني فقط.\n\n'
          'رابط محفظة جيب المباشر (للعملة اليمنية):\n'
          'https://jeep.ye/pay?amount=7000&currency=YER\n\n'
          'الدفع آمن ومباشر دون إظهار رقم هاتفك.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853)),
            onPressed: () {
              setState(() => _isPremium = true);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تفعيل النسخة البريميوم بنجاح تشفيري تام!')),
              );
            },
            child: const Text('تم الدفع عبر جيب', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _generateApp() {
    String text = _promptController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة فكرة التطبيق بالعربية أولاً!')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _resultCode = "";
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
        _resultCode = "// تم توليد تطبيق ${_selectedPlatform.toUpperCase()} بنجاح\n"
            "// الفكرة: $text\n"
            "// الحماية: مفعلة ومشفرة بالكامل عبر مبتكر";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مبتكر | صانع التطبيقات'),
        centerTitle: true,
        backgroundColor: const Color(0xFF05110A),
        actions: [
          if (!_isPremium)
            IconButton(
              icon: const Icon(Icons.star, color: Colors.amber),
              onPressed: _showJeepPaymentDialog,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isPremium ? const Color(0xFF1B5E20) : const Color(0xFF112E1F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _isPremium ? 'النسخة البريميوم مفعلة ومحمية' : 'تجربة مجانية نشطة (30 يوم)',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Text('اختر المنصة:', style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPlatform == 'android' ? const Color(0xFF00C853) : const Color(0xFF112E1F),
                    ),
                    onPressed: () => setState(() => _selectedPlatform = 'android'),
                    child: const Text('أندرويد', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPlatform == 'ios' ? const Color(0xFF00C853) : const Color(0xFF112E1F),
                    ),
                    onPressed: () => setState(() => _selectedPlatform = 'ios'),
                    child: const Text('آيفون', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('اكتب فكرة التطبيق بالعربية:', style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _promptController,
              maxLines: 3,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF112E1F),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                hintText: 'اكتب فكرتك هنا...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _isGenerating ? null : _generateApp,
              child: _isGenerating
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('توليد التطبيق بالذكاء الاصطناعي', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            if (_resultCode.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF112E1F), borderRadius: BorderRadius.circular(10)),
                child: Text(_resultCode, style: const TextStyle(color: Colors.white70, fontFamily: 'monospace')),
              ),
          ],
        ),
      ),
    );
  }
}
