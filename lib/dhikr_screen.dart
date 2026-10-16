import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // للوصول لإعدادات الخط والوضع الليلي

class DhikrScreen extends StatefulWidget {
  const DhikrScreen({Key? key}) : super(key: key);

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen> {
  int selectedTabIndex = 0; // 0: الأذكار, 1: السبحة الرقمية

  // عداد السبحة الرقمية
  int tasbihCount = 0;
  String currentTasbihText = 'سُبْحَانَ اللَّهِ';
  
  final List<String> tasbihList = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'اللَّهُ أَكْبَرُ',
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
    'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
  ];
  int tasbihIndex = 0;

  // إعدادات التنبيه الموقوت للأذكار
  Map<String, TimeOfDay> azkarNotificationTimes = {
    'أذكار الصباح': const TimeOfDay(hour: 7, minute: 0),   // 07:00 ص
    'أذكار المساء': const TimeOfDay(hour: 17, minute: 0),  // 05:00 م
    'أذكار قبل النوم': const TimeOfDay(hour: 23, minute: 0), // 11:00 م
  };

  Map<String, bool> azkarNotificationEnabled = {
    'أذكار الصباح': true,
    'أذكار المساء': true,
    'أذكار قبل النوم': true,
  };

  // قائمة الأذكار الشاملة (كتابة وصوت وتوقيت)
  final List<Map<String, String>> azkarCategories = [
    {
      'title': 'أذكار الصباح',
      'desc': 'أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له.. (تُقال عند الصباح لطمأنينة القلب وبداية مباركة).',
      'count': 'تُقَال صَباحاً',
      'audio': 'تشغيل صوتي: أذكار الصباح بصوت خاشع',
      'defaultTimeText': 'الموعد الافتراضي: 07:00 صباحاً',
    },
    {
      'title': 'أذكار المساء',
      'desc': 'أمسينا وأمسى الملك لله، والحمد لله، اللَّهُمَّ بك أمسينا وبك أصبحنا.. (تُقال عند المساء لحفظ الله ورعايته).',
      'count': 'تُقَال مَسَاءً',
      'audio': 'تشغيل صوتي: أذكار المساء الهادئة',
      'defaultTimeText': 'الموعد الافتراضي: 05:00 مساءً',
    },
    {
      'title': 'أذكار قبل النوم',
      'desc': 'باسمك ربي وضعت جنبي وبك أرفعه، إن أمسكت نفسي فارحمها وإن أرسلتها فاحفظها بما تحفظ به عبادك الصالحين.. ويقرأ آية الكرسي والمعوذات ويجمع كفيه ويصنع فيهما..',
      'count': 'قبل النوم مباشرة',
      'audio': 'تشغيل صوتي: أذكار النوم والمناجاة الليلية',
      'defaultTimeText': 'الموعد الافتراضي: 11:00 مساءً',
    },
    {
      'title': 'أذكار بعد الصلاة',
      'desc': 'أستغفر الله (ثلاثاً)، اللهم أنت السلام ومنك السلام تباركت يا ذا الجلال والإكرام.. لا إله إلا الله وحده لا شريك له..',
      'count': 'دُبُر كل صلاة',
      'audio': 'تشغيل صوتي: دعاء وتعقيبات الصلاة',
      'defaultTimeText': 'مرتبطة بأوقات الفروض',
    },
    {
      'title': 'أدعية نبوية جامعة',
      'desc': 'اللهم إني أعوذ بك من العجز والكسل، والبخل والجبن، وعذاب القبر، وفِتنة المحيا والممات..',
      'count': 'وقت الحاجة والدعاء',
      'audio': 'تشغيل صوتي: الأدعية الجامعة',
      'defaultTimeText': 'تذكير اختياري',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار والسبحة الرقمية'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 1. شريط التبديل بين الأذكار والسبحة
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    _buildTabButton(0, 'حصن الأذكار والمواعيد', Icons.menu_book),
                    _buildTabButton(1, 'السبحة الرقمية', Icons.spa),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. عرض المحتوى بناءً على التبويب المختار
              Expanded(
                child: selectedTabIndex == 0 ? _buildAzkarListView(settings) : _buildTasbihCounterView(settings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    bool isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00695C) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.amberAccent : Colors.teal),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // قسم عرض الأذكار مع التحكم بتوقيت التنبيه
  Widget _buildAzkarListView(AppSettings settings) {
    return ListView.builder(
      itemCount: azkarCategories.length,
      itemBuilder: (context, index) {
        var azkar = azkarCategories[index];
        String title = azkar['title']!;
        bool hasTimeConfig = azkarNotificationTimes.containsKey(title);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF00695C),
              child: Icon(Icons.bookmark_added, color: Colors.amberAccent, size: 20),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: settings.fontSize * 0.9, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${azkar['count']!} | ${azkar['defaultTimeText']!}',
              style: TextStyle(fontSize: settings.fontSize * 0.7, color: Colors.teal),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // النص المكتوب مع دعم تكبير الخط
                    Text(
                      azkar['desc']!,
                      style: TextStyle(fontSize: settings.fontSize * 0.85, height: 1.6),
                    ),
                    const Divider(height: 24),

                    // ضبط التنبيه الموقوت لهذه المجموعة
                    if (hasTimeConfig) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.alarm, color: Colors.amber, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'التنبيه الموقوت: ${azkarNotificationTimes[title]!.format(context)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          Switch(
                            value: azkarNotificationEnabled[title] ?? true,
                            activeColor: Colors.teal,
                            onChanged: (val) {
                              setState(() {
                                azkarNotificationEnabled[title] = val;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],

                    // زر التشغيل الصوتي للذكر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            azkar['audio']!,
                            style: TextStyle(fontSize: 12, color: Colors.teal.shade800, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00695C),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('جاري تشغيل: $title صوتياً...')),
                            );
                          },
                          icon: const Icon(Icons.volume_up, size: 18, color: Colors.amberAccent),
                          label: const Text('استماع', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // قسم السبحة الرقمية التفاعلية
  Widget _buildTasbihCounterView(AppSettings settings) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              tasbihIndex = (tasbihIndex + 1) % tasbihList.length;
              currentTasbihText = tasbihList[tasbihIndex];
              tasbihCount = 0;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.swap_horiz, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  'الذكر: $currentTasbihText (اضغط للتغيير)',
                  style: TextStyle(fontSize: settings.fontSize * 0.8, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        GestureDetector(
          onTap: () {
            setState(() {
              tasbihCount++;
            });
          },
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00796B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$tasbihCount',
                  style: const TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'اضغط للتسبيح',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                setState(() {
                  tasbihCount = 0;
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('إعادة ضبط العداد', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}