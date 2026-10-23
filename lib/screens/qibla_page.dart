
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

const Color qiblaBg = Color(0xFF07130F);
const Color qiblaPanel = Color(0xFF10271E);
const Color qiblaGreen = Color(0xFF20C997);
const Color qiblaMuted = Color(0xFFA8B9B0);

// إحداثيات الكعبة المشرفة
const double kaabaLatitude = 21.422487;
const double kaabaLongitude = 39.826206;

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? heading;
  String status = 'جارٍ انتظار قراءة البوصلة';

  @override
  void initState() {
    super.initState();
  }

  double calculateQiblaBearing(
    double latitude,
    double longitude,
  ) {
    final lat1 = latitude * math.pi / 180;
    final lat2 = kaabaLatitude * math.pi / 180;
    final deltaLongitude =
        (kaabaLongitude - longitude) * math.pi / 180;

    final y = math.sin(deltaLongitude);
    final x = math.cos(lat1) * math.tan(lat2) -
        math.sin(lat1) * math.cos(deltaLongitude);

    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }

  String compassDirection(double degrees) {
    const directions = [
      'الشمال',
      'الشمال الشرقي',
      'الشرق',
      'الجنوب الشرقي',
      'الجنوب',
      'الجنوب الغربي',
      'الغرب',
      'الشمال الغربي',
    ];

    final index = ((degrees % 360) / 45).round() % 8;
    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: qiblaBg,
        appBar: AppBar(
          backgroundColor: qiblaBg,
          title: const Text(
            'اتجاه القبلة',
            style: TextStyle(
              color: qiblaGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            final direction = snapshot.data?.heading;

            if (direction == null) {
              return const _QiblaUnavailable();
            }

            heading = direction;

            return ListView(
              padding: const EdgeInsets.all(22),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: qiblaPanel,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: qiblaGreen.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.explore_outlined,
                        color: qiblaGreen,
                        size: 45,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'بوصلة القبلة',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ضع الهاتف بشكل أفقي وبعيدًا عن المعادن والمغناطيس',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: qiblaMuted,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Center(
                  child: SizedBox(
                    width: 270,
                    height: 270,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: qiblaPanel,
                            border: Border.all(
                              color: qiblaGreen.withValues(alpha: 0.6),
                              width: 2,
                            ),
                          ),
                        ),
                        ...List.generate(4, (index) {
                          return Transform.rotate(
                            angle: index * math.pi / 2,
                            child: const Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: qiblaMuted,
                                ),
                              ),
                            ),
                          );
                        }),
                        const Positioned(
                          top: 18,
                          child: Text(
                            'شمال',
                            style: TextStyle(color: qiblaMuted),
                          ),
                        ),
                        Transform.rotate(
                          angle: -direction * math.pi / 180,
                          child: const Icon(
                            Icons.navigation,
                            color: qiblaGreen,
                            size: 125,
                          ),
                        ),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: qiblaPanel,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'اتجاه الشمال بالنسبة للهاتف',
                        style: TextStyle(color: qiblaMuted),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${direction.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: qiblaGreen,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        compassDirection(direction),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'مهم: البوصلة وحدها لا تحدد اتجاه القبلة. يلزم حساب زاوية القبلة من موقعك الجغرافي ومقارنتها باتجاه الهاتف. سنربط حساب الموقع في خطوة الدمج التالية.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: qiblaMuted,
                    height: 1.8,
                    fontSize: 13,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QiblaUnavailable extends StatelessWidget {
  const _QiblaUnavailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.explore_off_outlined,
              color: qiblaGreen,
              size: 60,
            ),
            const SizedBox(height: 18),
            const Text(
              'البوصلة غير متاحة',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'تأكد أن هاتفك يدعم مستشعر البوصلة، وأن المكتبة مضافة للمشروع.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: qiblaMuted,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
