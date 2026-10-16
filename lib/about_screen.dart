import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('حول التطبيق'),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: settings.isDarkMode
                ? [const Color(0xFF121A1E), const Color(0xFF0F171A)]
                : [const Color(0xFFE0F2F1), const Color(0xFFF4F7F6)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF00695C),
                      child: Icon(Icons.mosque, size: 45, color: Colors.amberAccent),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'الرفيق اليومي الإسلامي',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 1.5),
                    const SizedBox(height: 12),
                    const Text(
                      'هذا البرنامج مجاني بالكامل ولوجه الله تعالى.\nنرجو منكم صالح الدعاء.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person_outline, color: Color(0xFF00695C), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'صانع البرنامج: إبراهيم غنيم',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004D40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}