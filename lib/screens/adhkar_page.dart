
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/adhkar_data.dart';

const Color _bg = Color(0xFF07130F);
const Color _panel = Color(0xFF10271E);
const Color _green = Color(0xFF20C997);
const Color _muted = Color(0xFFA8B9B0);

class AdhkarPage extends StatelessWidget {
  const AdhkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'الأذكار والأوراد',
            style: TextStyle(
              color: _green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF123D2D), _panel],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _green.withValues(alpha: 0.25),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: _green,
                    size: 42,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'اذكر الله بقلب حاضر',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'أذكار من القرآن الكريم والسنة النبوية',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'اختر مجموعة الأذكار',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...adhkarCategories.map((category) {
              return Card(
                color: _panel,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: _green.withValues(alpha: 0.12),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF193B2D),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: _green,
                    ),
                  ),
                  title: Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${category.description}\n'
                      '${category.items.length} أذكار في هذه المجموعة',
                      style: const TextStyle(
                        color: _muted,
                        height: 1.6,
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: _green,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DhikrListPage(
                          category: category,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DhikrListPage extends StatefulWidget {
  final DhikrCategory category;

  const DhikrListPage({
    super.key,
    required this.category,
  });

  @override
  State<DhikrListPage> createState() => _DhikrListPageState();
}

class _DhikrListPageState extends State<DhikrListPage> {
  late List<int> counts;
  bool loading = true;
  bool saving = false;

  String get storageKey => 'siraj_adhkar_${widget.category.id}';

  @override
  void initState() {
    super.initState();
    counts = widget.category.items
        .map((item) => item.repetitions)
        .toList();
    loadCounts();
  }

  Future<void> loadCounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(storageKey);

      if (!mounted) return;

      if (saved != null &&
          saved.length == widget.category.items.length) {
        counts = List.generate(
          widget.category.items.length,
          (index) {
            final value = int.tryParse(saved[index]);
            final maximum =
                widget.category.items[index].repetitions;

            if (value == null) return maximum;
            return value.clamp(0, maximum);
          },
        );
      }
    } catch (_) {
      // تبقى العدادات الافتراضية إذا تعذر تحميل البيانات.
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> saveCounts() async {
    if (saving) return;
    saving = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        storageKey,
        counts.map((value) => value.toString()).toList(),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر حفظ التقدم على الجهاز'),
          ),
        );
      }
    } finally {
      saving = false;
    }
  }

  int get completed {
    int result = 0;

    for (int i = 0; i < counts.length; i++) {
      result += widget.category.items[i].repetitions - counts[i];
    }

    return result;
  }

  int get total => widget.category.items.fold(
        0,
        (sum, item) => sum + item.repetitions,
      );

  Future<void> decrement(int index) async {
    if (counts[index] <= 0) return;

    setState(() {
      counts[index]--;
    });

    await saveCounts();
  }

  Future<void> resetCounts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _panel,
        title: const Text('إعادة العدادات'),
        content: const Text(
          'هل تريد إعادة جميع عدادات هذه المجموعة إلى البداية؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: _bg,
            ),
            child: const Text('إعادة'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      counts = widget.category.items
          .map((item) => item.repetitions)
          .toList();
    });

    await saveCounts();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          title: Text(
            category.title,
            style: const TextStyle(
              color: _green,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'إعادة العدادات',
              onPressed: loading ? null : resetCounts,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(color: _green),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: total == 0 ? 0 : completed / total,
                            minHeight: 7,
                            backgroundColor: _panel,
                            color: _green,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'أنجزت $completed من $total تكرار',
                          style: const TextStyle(color: _muted),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: category.items.length,
                      itemBuilder: (context, index) {
                        final dhikr = category.items[index];
                        final remaining = counts[index];
                        final finished = remaining == 0;

                        return Card(
                          color: _panel,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: finished
                                  ? _green.withValues(alpha: 0.45)
                                  : Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (dhikr.note != null) ...[
                                  Text(
                                    dhikr.note!,
                                    style: const TextStyle(
                                      color: _green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                Text(
                                  dhikr.text,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    height: 2.0,
                                    color: Color(0xFFF0F5F1),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'المصدر: ${dhikr.source}',
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        finished
                                            ? 'اكتمل الذكر'
                                            : 'المتبقي: $remaining من '
                                                '${dhikr.repetitions}',
                                        style: TextStyle(
                                          color: finished ? _green : _muted,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: finished
                                          ? null
                                          : () => decrement(index),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: _green,
                                        foregroundColor: _bg,
                                      ),
                                      child: Text(
                                        finished ? 'تم' : 'تسبيح ✓',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}