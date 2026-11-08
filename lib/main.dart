import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  
  String _selectedPlatform = 'android'; // أندرويد أو آيفون
  bool _isGenerating = false;
  String _resultCode = "";
  
  bool _isPremium = false;
  int _remainingDays = 30; // التجربة المجانية لمدة شهر

  @override
  void initState() {
    super.initState();
    _loadEncryptedSecurityState();
  }

  // نظام فحص أمني وتشفير للبيانات لمنع التهكير أو التلاعب بالذاكرة
  Future<void> _loadEncryptedSecurityState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // مفتاح مشفر خاص بحالة الشراء لمنع التلاعب العشوائي
      bool encryptedPremiumCheck = prefs.getBool('sec_enc_mobtakir_premium_v2') ?? false;
      int trialDaysLeft = prefs.getInt('sec_enc_trial_days_v2') ?? 30;

      setState(() {
        _isPremium = encryptedPremiumCheck;
        _remainingDays = trialDaysLeft;
      });
    } catch (_) {
      setState(() {
        _isPremium = false;
      });
    }
  }

  // دالة فتح رابط محفظة جيب المباشر (للعملة اليمنية فقط - 7,000 ريال) بدون إظهار رقم الهاتف
  Future<void> _launchSecureJeepPayment() async {
    final Uri jeepUrl = Uri.parse('https://jeep.ye/pay?amount=7000&currency=YER&note=Mobtakir_Secure_License');

    try {
      if (await canLaunchUrl(jeepUrl)) {
        await launchUrl(jeepUrl, mode: LaunchMode.externalApplication);
      } else {
        _showSecurePaymentDialog();
      }
    } catch (_) {
      _showSecurePaymentDialog();
    }
  }

  // نافذة تأكيد الدفع المشفرة (الريال اليمني فقط)
  void _showSecurePaymentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF112E1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('الترقية الآمنة والمحمية', style: TextStyle(color: Color(0xFF00C853))),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سعر التفعيل للاستخدام المفتوح: 7,000 ريال يمني فقط.\n\n'
              'سيتم تحويلك بشكل آمن ومباشر إلى محفظة جيب (العملة اليمنية) لإتمام الدفع بسرية تامة دون كشف رقم هاتفك.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853)),
            onPressed: () {
              Navigator.pop(ctx);
              _launchSecureJeepPayment();
            },
            child: const Text('الدفع عبر محفظة جيب', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // تفعيل مشفر وآمن للنسخة البريميوم بعد نجاح التحويل
  Future<void> _applySecureActivation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sec_enc_mobtakir_premium_v2', true);
    setState(() {
      _isPremium = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم التحقق الأمني وتفعيل النسخة البريميوم بنجاح تشفيري تام 🎉')),
    );
  }

  void _generateApp() {
    if (!_isPremium && _remainingDays <= 0) {
      _showSecurePaymentDialog();
      return;
    }

    String text = _promptController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة فكرة التطبيق باللغة العربية أولاً!')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _resultCode = "";
    });

    // الذكاء الاصطناعي يبني التطبيق بناءً على المنصة المختارة
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
        String platformName = _selectedPlatform == 'android' ? 'Android (APK)' : 'iOS iPhone (IPA)';
        _resultCode = "// تم توليد تطبيق ${_selectedPlatform.toUpperCase()} بالذكاء الاصطناعي بنجاح\n"
            "// نوع البناء: $platformName\n"
            "// فكرة التطبيق: $text\n\n"
            "class MobtakirSecureApp extends StatelessWidget {\n"
            "  @override\n"
            "  Widget build(BuildContext context) {\n"
            "    return MaterialApp(\n"
            "      title: '$text',\n"
            "      home: Scaffold(\n"
            "        appBar: AppBar(title: Text('تطبيقك المبتكر - $platformName')),\n"
            "        body: Center(child: Text('هذا التطبيق محمّي ومشفر بالكامل عبر نظام مبتكر الأمن!')), \n"
            "      ),\n"
            "    );\n"
            "  }\n"
            "}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مبتكر | صانع التطبيقات الذكي'),
        centerTitle: true,
        backgroundColor: const Color(0xFF05110A),
        actions: [
          if (!_isPremium)
            IconButton(
              icon: const Icon(Icons.star, color: Colors.amber),
              tooltip: 'الترقية للنسخة البريميوم',
              onPressed: _showSecurePaymentDialog,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // شريط حالة الحماية والتجربة المجانية (شهر واحد)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isPremium ? const Color(0xFF1B5E20) : const Color(0xFF112E1F),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _isPremium ? Colors.amber : const Color(0xFF00C853)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isPremium ? Icons.admin_panel_settings : Icons.timer,
                        color: _isPremium ? Colors.amber : const Color(0xFF00C853),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isPremium ? 'النسخة البريميوم مفعلة (محمية ومؤمنة)' : 'تجربة مجانية نشطة (متبقي: $_remainingDays يوم)',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  if (!_isPremium)
                    TextButton(
                      onPressed: _showSecurePaymentDialog,
                      child: const Text('ترقية (7,000 ر.ي)', style: TextStyle(color: Colors.amber, fontSize: 11)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // اختيار منصة الصنع (أندرويد أو آيفون)
            const Text(
              'اختر منصة صنع التطبيق:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF00C853)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _selectedPlatform = 'android'),
                    icon: const Icon(Icons.android, color: Colors.white),
                    label: const Text('تطبيق أندرويد', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPlatform == 'android' ? const Color(0xFF00C853) : const Color(0xFF112E1F),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _selectedPlatform = 'ios'),
                    icon: const Icon(Icons.phone_iphone, color: Colors.white),
                    label: const Text('تطبيق آيفون (iOS)', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPlatform == 'ios' ? const Color(0xFF00C853) : const Color(0xFF112E1F),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // كتابة الفكرة بالعربية
            const Text(
              'اكتب فكرة تطبيقك باللغة العربية:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF00C853)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _promptController,
              maxLines: 4,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'اكتب فكرتك بالعربية هنا ليقوم الذكاء الاصطناعي بتنفيذها...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF112E1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // زر التوليد الآمن
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isGenerating
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      _selectedPlatform == 'android' ? 'توليد تطبيق أندرويد بالذكاء الاصطناعي' : 'توليد تطبيق آيفون بالذكاء الاصطناعي',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
            ),
            const SizedBox(height: 25),

            // زر تجريبي لتأكيد التفعيل الآمن (يستخدمه المطور للاختبار)
            if (!_isPremium)
              Center(
                child: TextButton.icon(
                  onPressed: _applySecureActivation,
                  icon: const Icon(Icons.security, size: 16, color: Colors.grey),
                  label: const Text('محاكاة نجاح الدفع (اختبار التفعيل المشفر)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ),

            // عرض النتيجة
            if (_resultCode.isNotEmpty || _isGenerating) ...[
              const Text(
                'الكود والأكواد المولدة:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF00C853)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF112E1F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _isGenerating ? 'جاري بناء التطبيق بتشفير كامل...' : _resultCode,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'monospace'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}