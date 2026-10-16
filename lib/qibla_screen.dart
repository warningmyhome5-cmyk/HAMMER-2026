import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  int selectedCompassIndex = 0;
  bool isAutoLocation = true;
  String selectedCountry = 'مصر';
  String selectedCity = 'القاهرة';
  double qiblaAngle = 136.0;

  final Map<String, List<String>> countriesAndCities = {
    'مصر': ['القاهرة', 'الجيزة', 'الإسكندرية', 'المنصورة', 'أسوان'],
    'السعودية': ['مكة المكرمة', 'المدينة المنورة', 'الرياض', 'جدة'],
    'الإمارات': ['أبو ظبي', 'دبي', 'الشارقة'],
  };

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديد القبلة والموقع الجغرافي'),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.location_on, color: Colors.teal),
                            SizedBox(width: 8),
                            Text('الموقع الجغرافي:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(isAutoLocation ? 'تلقائي (GPS)' : 'يدوي', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            Switch(
                              value: isAutoLocation,
                              activeColor: Colors.teal,
                              onChanged: (val) {
                                setState(() {
                                  isAutoLocation = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    if (isAutoLocation) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'الموقع الحالي: $selectedCity، $selectedCountry (GPS)',
                              style: TextStyle(fontSize: settings.fontSize * 0.75, color: Colors.teal.shade800, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.teal),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCountry,
                              items: countriesAndCities.keys.map((country) {
                                return DropdownMenuItem<String>(
                                  value: country,
                                  child: Text(country, style: TextStyle(fontSize: settings.fontSize * 0.8)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    selectedCountry = val;
                                    selectedCity = countriesAndCities[val]!.first;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCity,
                              items: countriesAndCities[selectedCountry]!.map((city) {
                                return DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city, style: TextStyle(fontSize: settings.fontSize * 0.8)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    selectedCity = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  _buildCompassTab(0, 'مغناطيسية', Icons.explore),
                  _buildCompassTab(1, 'الخريطة', Icons.map),
                  _buildCompassTab(2, 'الشمس', Icons.wb_sunny),
                  _buildCompassTab(3, 'النجوم', Icons.bedtime),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.amberAccent, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSelectedCompassView(settings),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassTab(int index, String label, IconData icon) {
    bool isSelected = selectedCompassIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCompassIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00695C) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? Colors.amberAccent : Colors.teal),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCompassView(AppSettings settings) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.navigation, size: 100, color: Colors.teal),
        const SizedBox(height: 16),
        Text(
          'اتجاه القبلة لـ ($selectedCity): $qiblaAngle° شمال شرق',
          style: TextStyle(fontSize: settings.fontSize * 0.85, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}