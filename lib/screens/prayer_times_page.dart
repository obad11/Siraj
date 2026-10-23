
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';

const prayerBg = Color(0xFF07130F);
const prayerPanel = Color(0xFF10271E);
const prayerGreen = Color(0xFF20C997);
const prayerMuted = Color(0xFFA8B9B0);

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  // إحداثيات تقريبية لمدينة تعز في اليمن.
  // يمكن تغيير المدينة والإحداثيات لاحقًا من الإعدادات.
  static const Coordinates coordinates =
      Coordinates(13.5795, 44.0209);

  CalculationMethod calculationMethod =
      CalculationMethod.muslimWorldLeague;

  Madhab madhab = Madhab.shafi;

  DateTime selectedDate = DateTime.now();

  PrayerTimes? prayerTimes;

  @override
  void initState() {
    super.initState();
    _calculatePrayerTimes();
  }

  void _calculatePrayerTimes() {
    final dateComponents = DateComponents.from(selectedDate);

    final params = calculationMethod.getParameters();
    params.madhab = madhab;

    final calculated = PrayerTimes(
      coordinates,
      dateComponents,
      params,
    );

    setState(() {
      prayerTimes = calculated;
    });
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';

    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'م' : 'ص';

    return '$hour:$minute $period';
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _chooseDate() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: prayerGreen,
              surface: prayerPanel,
            ),
          ),
          child: child!,
        );
      },
    );

    if (chosen != null && mounted) {
      setState(() {
        selectedDate = chosen;
      });
      _calculatePrayerTimes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final times = prayerTimes;

    final prayers = <Map<String, dynamic>>[
      {
        'name': 'الفجر',
        'time': times?.fajr,
        'icon': Icons.nightlight_round,
      },
      {
        'name': 'الشروق',
        'time': times?.sunrise,
        'icon': Icons.wb_twilight,
      },
      {
        'name': 'الظهر',
        'time': times?.dhuhr,
        'icon': Icons.wb_sunny_outlined,
      },
      {
        'name': 'العصر',
        'time': times?.asr,
        'icon': Icons.sunny,
      },
      {
        'name': 'المغرب',
        'time': times?.maghrib,
        'icon': Icons.wb_twilight,
      },
      {
        'name': 'العشاء',
        'time': times?.isha,
        'icon': Icons.dark_mode_outlined,
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: prayerBg,
        appBar: AppBar(
          backgroundColor: prayerBg,
          foregroundColor: Colors.white,
          title: const Text(
            'مواقيت الصلاة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: _chooseDate,
              tooltip: 'اختيار التاريخ',
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: prayerPanel,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: prayerGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: prayerGreen,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تعز - اليمن',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'التاريخ: ${_formatDate(selectedDate)}',
                    style: const TextStyle(color: prayerMuted),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'تُحسب الأوقات وفق الإحداثيات وطريقة الحساب المحددتين',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: prayerMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'مواقيت اليوم',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...prayers.map((prayer) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 17,
                ),
                decoration: BoxDecoration(
                  color: prayerPanel,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      prayer['icon'] as IconData,
                      color: prayerGreen,
                      size: 25,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        prayer['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(prayer['time'] as DateTime?),
                      style: const TextStyle(
                        color: prayerGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: prayerPanel,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'طريقة حساب الصلاة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<CalculationMethod>(
                    value: calculationMethod,
                    dropdownColor: prayerPanel,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'طريقة الحساب',
                      labelStyle: TextStyle(color: prayerMuted),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: prayerMuted),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: prayerGreen),
                      ),
                    ),
                    items: CalculationMethod.values.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(
                          method.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (method) {
                      if (method == null) return;
                      setState(() {
                        calculationMethod = method;
                      });
                      _calculatePrayerTimes();
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Madhab>(
                    value: madhab,
                    dropdownColor: prayerPanel,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'المذهب في حساب العصر',
                      labelStyle: TextStyle(color: prayerMuted),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: prayerMuted),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: prayerGreen),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: Madhab.shafi,
                        child: Text('الشافعي والمالكي والحنبلي'),
                      ),
                      DropdownMenuItem(
                        value: Madhab.hanafi,
                        child: Text('الحنفي'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        madhab = value;
                      });
                      _calculatePrayerTimes();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'تنبيه: هذه النسخة تستخدم إحداثيات تقريبية لمدينة تعز، ولا تستخدم موقع الهاتف الحالي. راجع الأوقات مع تقويم المسجد المحلي قبل الاعتماد عليها.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: prayerMuted,
                fontSize: 12,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
