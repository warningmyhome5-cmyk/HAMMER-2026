import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class TadhkirahScreen extends StatefulWidget {
  const TadhkirahScreen({Key? key}) : super(key: key);

  @override
  State<TadhkirahScreen> createState() => _TadhkirahScreenState();
}

class _TadhkirahScreenState extends State<TadhkirahScreen> {
  double localFontSize = 18.0;
  String searchQuery = '';
  int selectedChapterIndex = 0;
  List<dynamic> tadhkirahChapters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTadhkirahJsonData();
  }

  // تحميل بيانات كتاب التذكرة بالكامل من ملف الـ JSON
  Future<void> loadTadhkirahJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/tadhkirah_data.json');
      final data = await json.decode(response);
      setState(() {
        tadhkirahChapters = data;
        isLoading = false;
      });
    } catch (e) {
      // في حالة عدم وجود الملف يظهر تنبيه ميسر
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('كتاب التذكرة للقرطبي'), backgroundColor: const Color(0xFF004D40)),
        body: const Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    if (tadhkirahChapters.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('كتاب التذكرة للقرطبي'), backgroundColor: const Color(0xFF004D40)),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('يرجى التأكد من إضافة ملف assets/tadhkirah_data.json بكامل أبواب الكتاب.'),
          ),
        ),
      );
    }

    var currentChapter = tadhkirahChapters[selectedChapterIndex];
    bool isIntroPage = currentChapter['isIntro'] ?? false;

    // البحث الشامل داخل محتوى الـ JSON
    List matchedSections = [];
    if (searchQuery.isNotEmpty) {
      for (var ch in tadhkirahChapters) {
        if (!(ch['isIntro'] ?? false)) {
          for (var sec in ch['sections']) {
            if (sec['title'].toString().contains(searchQuery) || sec['content'].toString().contains(searchQuery)) {
              matchedSections.add({...sec, 'sourceChapter': ch['chapterTitle']});
            }
          }
        }
      }
    }

    List currentChapterSections = isIntroPage ? [] : currentChapter['sections'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('كتاب التذكرة للقرطبي'),
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
        child: Column(
          children: [
            // شريط البحث والتحكم في حجم الخط
            Container(
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث في أبواب وفصول الكتاب الكاملة...',
                      prefixIcon: const Icon(Icons.search, color: Colors.teal),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                      filled: true,
                      fillColor: settings.isDarkMode ? Colors.black26 : Colors.grey.shade100,
                    ),
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.format_size, color: Colors.teal, size: 20),
                          const SizedBox(width: 6),
                          const Text('خط القراءة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                            onPressed: () {
                              if (localFontSize > 14) {
                                setState(() => localFontSize -= 2);
                              }
                            },
                          ),
                          Text('${localFontSize.toInt()}px', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                            onPressed: () {
                              if (localFontSize < 36) {
                                setState(() => localFontSize += 2);
                              }
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade700),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.auto_stories, size: 14, color: Colors.amber),
                            SizedBox(width: 4),
                            Text('وضع القراءة المريح', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // شريط الأبواب والكتب
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                itemCount: tadhkirahChapters.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedChapterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        tadhkirahChapters[index]['chapterTitle'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.teal.shade900,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF00695C),
                      backgroundColor: Colors.teal.shade50,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedChapterIndex = index;
                            searchQuery = '';
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // عرض المحتوى المشرق المريح
            Expanded(
              child: searchQuery.isNotEmpty
                  ? _buildSearchResultsList(matchedSections, settings)
                  : (isIntroPage
                      ? _buildTadhkirahIntro(settings)
                      : _buildChapterSectionsList(currentChapterSections, settings)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterSectionsList(List sections, AppSettings settings) {
    if (sections.isEmpty) {
      return const Center(child: Text('لا توجد نصوص مسجلة في هذا الباب حالياً'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        var sec = sections[index];
        return _buildSectionCard(sec, null, settings);
      },
    );
  }

  Widget _buildSearchResultsList(List matchedSections, AppSettings settings) {
    if (matchedSections.isEmpty) {
      return Center(child: Text('لا توجد نتائج تطابق بحثك («$searchQuery»)'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: matchedSections.length,
      itemBuilder: (context, index) {
        var sec = matchedSections[index];
        return _buildSectionCard(sec, sec['sourceChapter'], settings);
      },
    );
  }

  Widget _buildSectionCard(Map sec, String? chapterName, AppSettings settings) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chapterName != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'الباب: $chapterName',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              sec['title']!,
              style: TextStyle(
                fontSize: localFontSize * 0.9,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            const Divider(height: 20),
            Text(
              sec['content']!,
              style: TextStyle(
                fontSize: localFontSize,
                height: 1.8,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTadhkirahIntro(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_stories_rounded, color: Color(0xFF00695C), size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'مقدمة كتاب «التذكرة بأحوال الموتى وأمور الآخرة»',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'عن المصنّف والكتاب:',
                style: TextStyle(fontSize: localFontSize * 0.95, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
              ),
              const SizedBox(height: 6),
              Text(
                'كتاب «التذكرة بأحوال الموتى وأمور الآخرة» صنّفه الإمام الحافظ أَبُو عَبْدِ اللَّهِ مُحَمَّدُ بْنُ أَحْمَدَ بْنِ أَبِي بَكْرٍ المَالِكِيُّ القُرْطُبِيُّ (المتوفى سنة 671 هـ)، صاحب التفسير الشهير «الجامع لأحكام القرآن».',
                style: TextStyle(fontSize: localFontSize * 0.85, height: 1.7),
              ),
              const SizedBox(height: 16),
              Text(
                'أهمية الكتاب ومحتواه:',
                style: TextStyle(fontSize: localFontSize * 0.95, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
              ),
              const SizedBox(height: 6),
              Text(
                'يُعدّ كتاب التذكرة من أنفع وأعظم ما كُتب في التذكير بالمصير، وتهذيب النفوس، وإيقاظ القلوب من غفلتها. جَمَع فيه الإمام القرطبي بين الآيات القرآنية، والأحاديث النبوية، وآثار الصحابة والتابعين، مع بيان أحكام الفقه والتوجيه التربوي الأخلاقي.',
                style: TextStyle(fontSize: localFontSize * 0.85, height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}