import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // للوصول لإعدادات الخط والوضع الليلي

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({Key? key}) : super(key: key);

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  // المؤذنون الأساسيون (مدمجون Offline) + قائمة التحميل بالإنترنت
  final List<String> defaultMuadhins = [
    'الشيخ محمد رفعت (مدمج)',
    'الشيخ عبد الباسط عبد الصمد (مدمج)',
    'الشيخ محمد صديق المنشاوي (مدمج)',
    'الشيخ سيد النقشبندي (مدمج)',
    'القارئ مشاري راشد العفاسي (مدمج)',
  ];

  final List<String> onlineMuadhins = [
    'الشيخ ناصر القطامي (تحميل بالإنترنت)',
    'الشيخ فارس عباد (تحميل بالإنترنت)',
    'الشيخ عبد الرحمن السديس (تحميل بالإنترنت)',
  ];

  // أصوات النداء والمناجاة لقيام الليل
  final List<String> qiyamAudioOptions = [
    'مناجاة سحرية بصوت خاشع (مدمج)',
    'نداء: "قم يا عبد الله يناجيك ربك" (مدمج)',
    'تنشيط بصوت الشيخ سيد النقشبندي (مدمج)',
    'دعاء وتضرع خاشع قبل الفجر (مدمج)',
    'نغمة هادئة تصاعدية (مدمج)',
  ];

  // خريطة لتخزين المؤذن المختار لكل صلاة
  final Map<String, String> prayerMuadhin = {
    'الفجر': 'الشيخ محمد رفعت (مدمج)',
    'الظهر': 'الشيخ عبد الباسط عبد الصمد (مدمج)',
    'العصر': 'القارئ مشاري راشد العفاسي (مدمج)',
    'المغرب': 'الشيخ محمد صديق المنشاوي (مدمج)',
    'العشاء': 'الشيخ سيد النقشبندي (مدمج)',
  };

  // تحديد من يقيم الصلاة لكل فرض
  final Map<String, String> prayerIqamaMuadhin = {
    'الفجر': 'إمام المسجد الأساسي',
    'الظهر': 'إمام المسجد الأساسي',
    'العصر': 'إمام المسجد الأساسي',
    'المغرب': 'إمام المسجد الأساسي',
    'العشاء': 'إمام المسجد الأساسي',
  };

  // وقت الإقامة بالدقائق لكل صلاة
  final Map<String, int> iqamaOffsets = {
    'الفجر': 20,
    'الظهر': 15,
    'العصر': 15,
    'المغرب': 10,
    'العشاء': 15,
  };

  // مواقيت الصلاة لليوم
  final Map<String, String> prayerTimes = {
    'الفجر': '04:25 ص',
    'الشروق': '05:50 ص',
    'الظهر': '11:55 ص',
    'العصر': '03:15 م',
    'المغرب': '06:05 م',
    'العشاء': '07:25 م',
  };

  bool fastingAlertsEnabled = true;

  // إعدادات تنبيهات وأصوات قيام الليل
  bool alertFirstThird = false;
  bool alertSecondThird = false;
  bool alertLastThird = true;

  String selectedFirstThirdAudio = 'مناجاة سحرية بصوت خاشع (مدمج)';
  String selectedSecondThirdAudio = 'نداء: "قم يا عبد الله يناجيك ربك" (مدمج)';
  String selectedLastThirdAudio = 'تنشيط بصوت الشيخ سيد النقشبندي (مدمج)';

  // أشهر السنة الهجرية
  final List<String> hijriMonths = [
    'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
    'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
    'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
  ];

  int selectedHijriMonthIndex = 3;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);
    List<String> allMuadhins = [...defaultMuadhins, ...onlineMuadhins];

    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة والعبادات'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. بطاقة النتيجة الأساسية والعد التنازلي
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.teal, Colors.tealAccent],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'التاريخ: الخميس، 15 أكتوبر 2026 م / 4 ربيع الآخر 1448 هـ',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  'الصلاة القادمة: الظهر',
                  style: TextStyle(color: Colors.white, fontSize: settings.fontSize * 1.1, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'متبقي على الأذان: 01:42:15',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: settings.fontSize * 1.3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. بطاقة تنبيهات ومناجاة قيام الليل (أثلاث الليل مع التنبيه الصوتي)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.brightness_2, color: Colors.indigo, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'منظومة قيام الليل والمناجاة الصوتية',
                        style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(
                    'اختر أثلاث الليل المراد الاستيقاظ لها وصوت المناجاة أو النداء المفضل لكل ثلث:',
                    style: TextStyle(fontSize: settings.fontSize * 0.85, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),

                  // الثلث الأول + اختيار صوت المناجاة
                  ExpansionTile(
                    leading: Checkbox(
                      value: alertFirstThird,
                      activeColor: Colors.indigo,
                      onChanged: (val) {
                        setState(() {
                          alertFirstThird = val ?? false;
                        });
                      },
                    ),
                    title: Text('الثلث الأول من الليل', style: TextStyle(fontSize: settings.fontSize * 0.85, fontWeight: FontWeight.bold)),
                    subtitle: const Text('من 06:05 م إلى 09:45 م', style: TextStyle(fontSize: 11)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('صوت التنبيه والمناجاة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedFirstThirdAudio,
                              items: qiyamAudioOptions.map((audio) {
                                return DropdownMenuItem<String>(
                                  value: audio,
                                  child: Text(audio, style: const TextStyle(fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => selectedFirstThirdAudio = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // الثلث الثاني + اختيار صوت المناجاة
                  ExpansionTile(
                    leading: Checkbox(
                      value: alertSecondThird,
                      activeColor: Colors.indigo,
                      onChanged: (val) {
                        setState(() {
                          alertSecondThird = val ?? false;
                        });
                      },
                    ),
                    title: Text('الثلث الثاني من الليل', style: TextStyle(fontSize: settings.fontSize * 0.85, fontWeight: FontWeight.bold)),
                    subtitle: const Text('من 09:45 م إلى 01:25 ص', style: TextStyle(fontSize: 11)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('صوت التنبيه والمناجاة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedSecondThirdAudio,
                              items: qiyamAudioOptions.map((audio) {
                                return DropdownMenuItem<String>(
                                  value: audio,
                                  child: Text(audio, style: const TextStyle(fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => selectedSecondThirdAudio = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // الثلث الأخير (الوقت الأفضل) + اختيار صوت المناجاة
                  ExpansionTile(
                    leading: Checkbox(
                      value: alertLastThird,
                      activeColor: Colors.indigo,
                      onChanged: (val) {
                        setState(() {
                          alertLastThird = val ?? false;
                        });
                      },
                    ),
                    title: Text('الثلث الأخير من الليل (وقت الاستغفار)', style: TextStyle(fontSize: settings.fontSize * 0.85, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    subtitle: const Text('من 01:25 ص إلى أذان الفجر (وقت النزول الإلهي)', style: TextStyle(fontSize: 11)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('صوت التنبيه والمناجاة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: selectedLastThirdAudio,
                              items: qiyamAudioOptions.map((audio) {
                                return DropdownMenuItem<String>(
                                  value: audio,
                                  child: Text(audio, style: const TextStyle(fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => selectedLastThirdAudio = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. النتيجة الهجرية الكاملة للسنة وتحديد أيام الصيام بالألوان
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.teal, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'النتيجة الهجرية وأيام الصيام',
                            style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Switch(
                        value: fastingAlertsEnabled,
                        activeColor: Colors.teal,
                        onChanged: (val) {
                          setState(() {
                            fastingAlertsEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('عرض شهر:', style: TextStyle(fontSize: settings.fontSize * 0.9, fontWeight: FontWeight.bold)),
                      DropdownButton<int>(
                        value: selectedHijriMonthIndex,
                        items: List.generate(12, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(hijriMonths[index], style: TextStyle(fontSize: settings.fontSize * 0.85)),
                          );
                        }),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedHijriMonthIndex = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      int dayNumber = index + 1;
                      bool isWhiteDay = (dayNumber == 13 || dayNumber == 14 || dayNumber == 15);
                      bool isMonThu = (dayNumber % 7 == 2 || dayNumber % 7 == 5);

                      Color boxColor = Colors.grey.withOpacity(0.1);
                      Color textColor = Colors.black87;

                      if (isWhiteDay) {
                        boxColor = Colors.amber.shade300;
                        textColor = Colors.black;
                      } else if (isMonThu) {
                        boxColor = Colors.teal.shade100;
                        textColor = Colors.teal.shade900;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(8),
                          border: isWhiteDay ? Border.all(color: Colors.amber.shade800, width: 1.5) : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: settings.fontSize * 0.75,
                            fontWeight: (isWhiteDay || isMonThu) ? FontWeight.bold : FontWeight.normal,
                            color: textColor,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(width: 14, height: 14, color: Colors.amber.shade300),
                          const SizedBox(width: 4),
                          Text('الأيام البيض (13-15)', style: TextStyle(fontSize: settings.fontSize * 0.7)),
                        ],
                      ),
                      Row(
                        children: [
                          Container(width: 14, height: 14, color: Colors.teal.shade100),
                          const SizedBox(width: 4),
                          Text('الإثنين والخميس', style: TextStyle(fontSize: settings.fontSize * 0.7)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 4. جدول مواقيت الصلاة اليومية
          Text(
            'مواقيت الصلاة لليوم:',
            style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: prayerTimes.entries.map((entry) {
                  bool isNext = entry.key == 'الظهر';
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isNext ? Colors.teal.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: settings.fontSize,
                            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                            color: isNext ? Colors.teal : null,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: settings.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 5. قسم الإعدادات والضبط المتقدم لكل صلاة
          Text(
            'إعدادات الأذان والإقامة لكل صلاة:',
            style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ...prayerMuadhin.keys.map((prayerName) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: Text(
                  'ضبط صلاة $prayerName',
                  style: TextStyle(fontSize: settings.fontSize, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'المؤذن: ${prayerMuadhin[prayerName]} | الإقامة: ${iqamaOffsets[prayerName]} ق',
                  style: TextStyle(fontSize: settings.fontSize * 0.75, color: Colors.grey),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('اختيار مؤذن صلاة $prayerName:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: settings.fontSize * 0.9)),
                        const SizedBox(height: 6),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: prayerMuadhin[prayerName],
                          items: allMuadhins.map((String muadhin) {
                            return DropdownMenuItem<String>(
                              value: muadhin,
                              child: Text(
                                muadhin,
                                style: TextStyle(
                                  fontSize: settings.fontSize * 0.85,
                                  color: muadhin.contains('تحميل') ? Colors.blueAccent : Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                prayerMuadhin[prayerName] = newValue;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        Text('من يقوم بالإقامة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: settings.fontSize * 0.9)),
                        const SizedBox(height: 6),
                        TextField(
                          decoration: InputDecoration(
                            hintText: prayerIqamaMuadhin[prayerName],
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (val) {
                            prayerIqamaMuadhin[prayerName] = val;
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('وقت الإقامة (${iqamaOffsets[prayerName]} دقيقة):', style: TextStyle(fontSize: settings.fontSize * 0.85)),
                            Slider(
                              value: iqamaOffsets[prayerName]!.toDouble(),
                              min: 5,
                              max: 30,
                              divisions: 5,
                              label: '${iqamaOffsets[prayerName]} دقيقة',
                              onChanged: (double val) {
                                setState(() {
                                  iqamaOffsets[prayerName] = val.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}