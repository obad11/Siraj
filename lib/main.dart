
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/adhkar_page.dart';
import 'screens/quran_page.dart';

const Color bg = Color(0xFF07130F);
const Color panel = Color(0xFF10271E);
const Color panelLight = Color(0xFF16372A);
const Color green = Color(0xFF20C997);
const Color muted = Color(0xFFA8B9B0);
const Color gold = Color(0xFFE4C477);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SirajApp());
}

class SirajApp extends StatelessWidget {
  const SirajApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سراج',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          brightness: Brightness.dark,
          surface: panel,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: panel,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: green,
            foregroundColor: bg,
            minimumSize: const Size(48, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const SirajShell(),
    );
  }
}

// =====================================================
// التطبيق الرئيسي والتنقل
// =====================================================

class SirajShell extends StatefulWidget {
  const SirajShell({super.key});

  @override
  State<SirajShell> createState() => _SirajShellState();
}

class _SirajShellState extends State<SirajShell> {
  int index = 0;

  final List<Widget> pages = const [
    HomePage(),
    AdhkarPage(),
    TasbeehPage(),
    SettingsPage(),
  ];

  final List<String> titles = const [
    'سراج',
    'الأذكار',
    'المسبحة الإلكترونية',
    'الإعدادات',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titles[index],
            style: const TextStyle(
              color: green,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: IndexedStack(
          index: index,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: panel,
          indicatorColor: green.withValues(alpha: 0.18),
          selectedIndex: index,
          onDestinationSelected: (value) {
            setState(() => index = value);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: green),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.wb_twilight_outlined),
              selectedIcon: Icon(Icons.wb_twilight, color: green),
              label: 'الأذكار',
            ),
            NavigationDestination(
              icon: Icon(Icons.fingerprint),
              selectedIcon: Icon(Icons.fingerprint, color: green),
              label: 'التسبيح',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: green),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// الصفحة الرئيسية
// =====================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
      children: [
        const _WelcomeCard(),
        const SizedBox(height: 24),

        const Text(
          'أقسام سراج',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 14),

        _SectionCard(
          icon: Icons.menu_book_rounded,
          title: 'القرآن الكريم',
          subtitle: 'فهرس السور والقراءة والبحث',
          onTap: () {
            openPage(context, const QuranPage());
          },
        ),

        const SizedBox(height: 11),

        _SectionCard(
          icon: Icons.wb_twilight_rounded,
          title: 'الأذكار',
          subtitle: 'أذكار الصباح والمساء وسائر الأوقات',
          onTap: () {
            openPage(context, const AdhkarPage());
          },
        ),

        const SizedBox(height: 11),

        _SectionCard(
          icon: Icons.fingerprint,
          title: 'المسبحة الإلكترونية',
          subtitle: 'عداد تسبيح يُحفظ على جهازك',
          onTap: () {
            openPage(context, const TasbeehPage());
          },
        ),

        const SizedBox(height: 11),

        _SectionCard(
          icon: Icons.volunteer_activism_outlined,
          title: 'الأدعية',
          subtitle: 'قسم الأدعية يحتاج إلى إضافة محتواه الموثوق',
          onTap: () {
            openFeatureInfo(
              context,
              'الأدعية',
              'سيُجهز هذا القسم بنصوص الأدعية من القرآن الكريم والسنة، مع ذكر المصادر والتحقق من صحة النصوص.',
            );
          },
        ),

        const SizedBox(height: 11),

        _SectionCard(
          icon: Icons.explore_outlined,
          title: 'القبلة ومواقيت الصلاة',
          subtitle: 'قسم يحتاج إلى تفعيل الحسابات والموقع',
          onTap: () {
            openFeatureInfo(
              context,
              'القبلة ومواقيت الصلاة',
              'لم يتم تفعيل الحسابات بعد. يتطلب هذا القسم حساب مواقيت الصلاة واتجاه القبلة ومعالجة أذونات الموقع وإعدادات المدينة.',
            );
          },
        ),

        const SizedBox(height: 24),

        const _ReminderCard(),

        const SizedBox(height: 20),

        const Center(
          child: Text(
            'سراج — رفيقك في رحلتك إلى الله',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF174A35),
            Color(0xFF0B2119),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: green.withValues(alpha: 0.24),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.mosque_outlined,
            color: green,
            size: 58,
          ),
          SizedBox(height: 18),
          Text(
            'بسم الله الرحمن الرحيم',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'رفيقك في رحلتك إلى الله',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold.withValues(alpha: 0.20),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: gold,
            size: 27,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تذكير',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'اجعل لك وردًا من القرآن ووقتًا للذكر كل يوم.',
                  style: TextStyle(
                    color: muted,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// بطاقة القسم
// =====================================================

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: green,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_back_ios_new,
                color: muted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// المسبحة الإلكترونية
// =====================================================

class TasbeehPage extends StatefulWidget {
  const TasbeehPage({super.key});

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  static const String countKey = 'tasbeeh_count';

  int count = 0;
  int target = 33;
  bool loading = true;
  bool saving = false;

  final List<int> targets = const [33, 100, 300, 500, 1000];

  @override
  void initState() {
    super.initState();
    loadCount();
  }

  Future<void> loadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      setState(() {
        count = prefs.getInt(countKey) ?? 0;
        target = prefs.getInt('tasbeeh_target') ?? 33;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> saveCount() async {
    if (saving) return;

    saving = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(countKey, count);
      await prefs.setInt('tasbeeh_target', target);
    } catch (_) {
      // يستمر العداد بالعمل إن تعذر الحفظ مؤقتًا.
    } finally {
      saving = false;
    }
  }

  Future<void> increment() async {
    if (loading) return;

    setState(() => count++);

    await saveCount();

    if (!mounted) return;

    if (count == target) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('أكملت $target تسبيحة، تقبل الله منك'),
          backgroundColor: panelLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> changeTarget(int? value) async {
    if (value == null) return;

    setState(() => target = value);
    await saveCount();
  }

  Future<void> reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: panel,
          title: const Text('تصفير العداد'),
          content: const Text(
            'هل تريد تصفير عدد التسبيحات الحالي؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('تصفير'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => count = 0);
    await saveCount();
  }

  @override
  Widget build(BuildContext context) {
    final progress = target <= 0
        ? 0.0
        : (count / target).clamp(0.0, 1.0).toDouble();

    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const SizedBox(height: 12),

        const Icon(
          Icons.fingerprint,
          color: green,
          size: 65,
        ),

        const SizedBox(height: 12),

        const Text(
          'المسبحة الإلكترونية',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'اختر الذكر الذي تريد ترديده',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted),
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: green.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'العدد الحالي',
                style: TextStyle(color: muted),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: 190,
                height: 190,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: loading ? null : progress,
                        strokeWidth: 7,
                        backgroundColor: bg,
                        color: green,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          loading ? '...' : '$count',
                          style: const TextStyle(
                            fontSize: 48,
                            color: green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'من $target',
                          style: const TextStyle(
                            color: muted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              DropdownButtonFormField<int>(
                value: target,
                dropdownColor: panel,
                decoration: InputDecoration(
                  labelText: 'هدف التسبيح',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: targets.map((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value تسبيحة'),
                  );
                }).toList(),
                onChanged: loading ? null : changeTarget,
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: loading ? null : increment,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'تسبيحة جديدة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: loading ? null : reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('تصفير العداد'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'أذكار مقترحة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const _SuggestedDhikr(text: 'سبحان الله'),
        const _SuggestedDhikr(text: 'الحمد لله'),
        const _SuggestedDhikr(text: 'الله أكبر'),
        const _SuggestedDhikr(text: 'أستغفر الله'),
        const _SuggestedDhikr(text: 'لا إله إلا الله'),
      ],
    );
  }
}

class _SuggestedDhikr extends StatelessWidget {
  final String text;

  const _SuggestedDhikr({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.favorite_border,
          color: green,
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 17),
        ),
        trailing: const Icon(
          Icons.info_outline,
          color: muted,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('الذكر المختار: $text'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// الإعدادات
// =====================================================

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),

        const Icon(
          Icons.mosque_outlined,
          color: green,
          size: 66,
        ),

        const SizedBox(height: 12),

        const Text(
          'إعدادات سراج',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'رفيقك في رحلتك إلى الله',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted),
        ),

        const SizedBox(height: 24),

        const _SettingTile(
          icon: Icons.palette_outlined,
          title: 'المظهر',
          subtitle: 'الأخضر الداكن',
        ),

        const SizedBox(height: 10),

        const _SettingTile(
          icon: Icons.language,
          title: 'اللغة',
          subtitle: 'العربية',
        ),

        const SizedBox(height: 10),

        const _SettingTile(
          icon: Icons.offline_bolt_outlined,
          title: 'العمل دون إنترنت',
          subtitle:
              'تعتمد إمكانية العمل دون اتصال على البيانات والمكتبات المستخدمة',
        ),

        const SizedBox(height: 10),

        _SettingTile(
          icon: Icons.info_outline,
          title: 'حول التطبيق',
          subtitle: 'سراج — رفيقك في رحلتك إلى الله',
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'سراج',
              applicationVersion: '1.0.0',
              applicationLegalese:
                  'تطبيق إسلامي للقرآن الكريم والأذكار',
              children: const [
                SizedBox(height: 12),
                Text(
                  'يهدف سراج إلى تسهيل قراءة القرآن والمواظبة على الأذكار.',
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        const Center(
          child: Text(
            'نسأل الله القبول والنفع',
            style: TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(15),
        leading: Icon(
          icon,
          color: green,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: muted,
              height: 1.6,
            ),
          ),
        ),
        trailing: onTap == null
            ? null
            : const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: muted,
              ),
      ),
    );
  }
}

// =====================================================
// التنقل والرسائل المشتركة
// =====================================================

void openPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: page,
      ),
    ),
  );
}

void openFeatureInfo(
  BuildContext context,
  String title,
  String message,
) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: panel,
          title: Text(title),
          content: Text(
            message,
            style: const TextStyle(height: 1.7),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('حسنًا'),
            ),
          ],
        ),
      );
    },
  );
}
