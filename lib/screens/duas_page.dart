
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color duaBg = Color(0xFF07130F);
const Color duaPanel = Color(0xFF10271E);
const Color duaGreen = Color(0xFF20C997);
const Color duaMuted = Color(0xFFA8B9B0);

class DuaItem {
  final String title;
  final String text;
  final String source;

  const DuaItem({
    required this.title,
    required this.text,
    required this.source,
  });
}

const List<DuaItem> quranDuas = [
  DuaItem(
    title: 'دعاء الخير في الدنيا والآخرة',
    text: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    source: 'سورة البقرة، الآية 201',
  ),
  DuaItem(
    title: 'دعاء الثبات',
    text: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ',
    source: 'سورة آل عمران، الآية 8',
  ),
  DuaItem(
    title: 'دعاء المغفرة',
    text: 'رَبَّنَا إِنَّنَا آمَنَّا فَاغْفِرْ لَنَا ذُنُوبَنَا وَقِنَا عَذَابَ النَّارِ',
    source: 'سورة آل عمران، الآية 16',
  ),
  DuaItem(
    title: 'دعاء الرحمة والمغفرة',
    text: 'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
    source: 'سورة الأعراف، الآية 23',
  ),
  DuaItem(
    title: 'دعاء التوكل',
    text: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
    source: 'سورة آل عمران، الآية 173',
  ),
  DuaItem(
    title: 'دعاء العلم',
    text: 'رَبِّ زِدْنِي عِلْمًا',
    source: 'سورة طه، الآية 114',
  ),
  DuaItem(
    title: 'دعاء تيسير الأمور',
    text: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
    source: 'سورة طه، الآيتان 25–26',
  ),
  DuaItem(
    title: 'دعاء صلاح الذرية',
    text: 'رَبِّ هَبْ لِي مِنْ لَدُنْكَ ذُرِّيَّةً طَيِّبَةً إِنَّكَ سَمِيعُ الدُّعَاءِ',
    source: 'سورة آل عمران، الآية 38',
  ),
  DuaItem(
    title: 'دعاء الوالدين',
    text: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    source: 'سورة الإسراء، الآية 24',
  ),
  DuaItem(
    title: 'دعاء الصبر',
    text: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
    source: 'سورة الأعراف، الآية 126',
  ),
  DuaItem(
    title: 'دعاء الهداية',
    text: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    source: 'سورة الفاتحة، الآية 6',
  ),
  DuaItem(
    title: 'دعاء الاستعاذة من الهم',
    text: 'رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَعُوذُ بِكَ رَبِّ أَنْ يَحْضُرُونِ',
    source: 'سورة المؤمنون، الآيتان 97–98',
  ),
  DuaItem(
    title: 'دعاء إصلاح الحال',
    text: 'رَبَّنَا أَتْمِمْ لَنَا نُورَنَا وَاغْفِرْ لَنَا إِنَّكَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    source: 'سورة التحريم، الآية 8',
  ),
  DuaItem(
    title: 'دعاء دخول الجنة',
    text: 'رَبَّنَا وَأَدْخِلْهُمْ جَنَّاتِ عَدْنٍ الَّتِي وَعَدْتَهُمْ وَمَنْ صَلَحَ مِنْ آبَائِهِمْ وَأَزْوَاجِهِمْ وَذُرِّيَّاتِهِمْ إِنَّكَ أَنْتَ الْعَزِيزُ الْحَكِيمُ',
    source: 'سورة غافر، الآية 8',
  ),
];

class DuasPage extends StatefulWidget {
  const DuasPage({super.key});

  @override
  State<DuasPage> createState() => _DuasPageState();
}

class _DuasPageState extends State<DuasPage> {
  final TextEditingController searchController =
      TextEditingController();

  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> copyDua(DuaItem dua) async {
    await Clipboard.setData(
      ClipboardData(
        text: '${dua.text}\n\n${dua.source}',
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الدعاء'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = quranDuas.where((dua) {
      return dua.title.contains(query) ||
          dua.text.contains(query) ||
          dua.source.contains(query);
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: duaBg,
        appBar: AppBar(
          backgroundColor: duaBg,
          title: const Text(
            'الأدعية من القرآن',
            style: TextStyle(
              color: duaGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: duaPanel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: duaGreen.withValues(alpha: 0.2),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.volunteer_activism_outlined,
                    color: duaGreen,
                    size: 42,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'أدعية من كتاب الله',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'آيات قرآنية تتضمن الدعاء والثناء والابتهال إلى الله',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: duaMuted,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() => query = value.trim());
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن دعاء أو كلمة أو سورة',
                prefixIcon: const Icon(
                  Icons.search,
                  color: duaGreen,
                ),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() => query = '');
                        },
                        icon: const Icon(Icons.close),
                      ),
                filled: true,
                fillColor: duaPanel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'عدد النتائج: ${filtered.length}',
              style: const TextStyle(
                color: duaMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('لا توجد أدعية مطابقة للبحث'),
                ),
              ),
            ...filtered.map(
              (dua) => Card(
                color: duaPanel,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dua.title,
                        style: const TextStyle(
                          color: duaGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SelectableText(
                        dua.text,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 21,
                          height: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dua.source,
                        style: const TextStyle(
                          color: duaMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () => copyDua(dua),
                          icon: const Icon(Icons.copy),
                          label: const Text('نسخ الدعاء'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
