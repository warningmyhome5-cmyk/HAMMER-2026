import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prayer_screen.dart';
import 'qibla_screen.dart';
import 'dhikr_screen.dart';
import 'tadhkirah_screen.dart';
import 'about_screen.dart'; // استيراد شاشة حول التطبيق

// مدير الإعدادات العامة (الخط والوضع الليلي)
class AppSettings with ChangeNotifier {
  double _fontSize = 18.0; 
  bool _isDarkMode = false; 

  double get fontSize => _fontSize;
  bool get isDarkMode => _isDarkMode;

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettings(),
      child: const DailyCompanionApp(),
    ),
  );
}

class DailyCompanionApp extends StatelessWidget {
  const DailyCompanionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الرفيق اليومي - Daily Companion',
      theme: ThemeData(
        brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: settings.isDarkMode ? const Color(0xFF121A1E) : const Color(0xFFF4F7F6),
        cardColor: settings.isDarkMode ? const Color(0xFF1E2A30) : Colors.white,
        fontFamily: 'Cairo',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.mosque, size: 24, color: Colors.amberAccent),
            SizedBox(width: 8),
            Text('الرفيق اليومي الإسلامي', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(settings.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: Colors.amberAccent),
            onPressed: () {
              settings.toggleTheme();
            },
            tooltip: 'تغيير وضع الإضاءة وراحة العين',
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00695C),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rate_rounded, color: Colors.amberAccent, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '« وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ »',
                            style: TextStyle(color: Colors.amberAccent, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'صاحبك الرقمي للعبادات، مواقيت الصلاة، والقيام',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('حجم الخط العام:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                          onPressed: () {
                            if (settings.fontSize > 14) {
                              settings.setFontSize(settings.fontSize - 2);
                            }
                          },
                        ),
                        Text('${settings.fontSize.toInt()}px', style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                          onPressed: () {
                            if (settings.fontSize < 30) {
                              settings.setFontSize(settings.fontSize + 2);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      'مواقيت الصلاة والعبادات',
                      Icons.access_time_filled,
                      const Color(0xFF00796B),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrayerScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'القبلة والبدائل الذكية',
                      Icons.explore,
                      const Color(0xFF0288D1),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const QiblaScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'الأذكار والسبحة',
                      Icons.spa,
                      const Color(0xFF388E3C),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DhikrScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'كتاب التذكرة للقرطبي',
                      Icons.auto_stories,
                      const Color(0xFF8D6E63),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TadhkirahScreen()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'حول التطبيق',
                      Icons.info_outline,
                      const Color(0xFF00695C),
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final settings = Provider.of<AppSettings>(context);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: ColorFilter != null ? MainAxisAlignment.center : MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: settings.fontSize * 0.85,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}