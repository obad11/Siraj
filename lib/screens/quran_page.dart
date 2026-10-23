
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';

const Color _bg = Color(0xFF07130F);
const Color _panel = Color(0xFF10271E);
const Color _green = Color(0xFF20C997);
const Color _muted = Color(0xFFA8B9B0);

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final TextEditingController _searchController =
      TextEditingController();

  List<_AyahResult> _searchResults = [];
  bool _searchMode = false;
  bool _searching = false;
  String _searchMessage = '';

  int _lastSurah = 1;
  int _lastAyah = 1;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _lastSurah = prefs.getInt('siraj_quran_last_surah') ?? 1;
      _lastAyah = prefs.getInt('siraj_quran_last_ayah') ?? 1;
    });
  }

  Future<void> _saveLastRead(int surah, int ayah) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('siraj_quran_last_surah', surah);
    await prefs.setInt('siraj_quran_last_ayah', ayah);

    if (!mounted) return;

    setState(() {
      _lastSurah = surah;
      _lastAyah = ayah;
    });
  }

  Future<void> _searchQuran() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _searchMessage = 'اكتب كلمة للبحث في القرآن الكريم';
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _searching = true;
      _searchResults = [];
      _searchMessage = 'جارٍ البحث في القرآن الكريم...';
    });

    final List<_AyahResult> results = [];

    try {
      for (int surah = 1; surah <= quran.totalSurahCount; surah++) {
        final int count = quran.getVerseCount(surah);

        for (int ayah = 1; ayah <= count; ayah++) {
          final String text = quran.getVerse(surah, ayah);

          if (text.contains(query)) {
            results.add(
              _AyahResult(
                surah: surah,
                ayah: ayah,
                text: text,
              ),
            );

            if (results.length >= 100) {
              break;
            }
          }
        }

        if (results.length >= 100) {
          break;
        }
      }

      if (!mounted) return;

      setState(() {
        _searchResults = results;
        _searchMessage = results.isEmpty
            ? 'لم يتم العثور على آيات تحتوي على هذه العبارة'
            : 'نتائج البحث: ${results.length}';
        _searching = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _searching = false;
        _searchMessage = 'تعذر إكمال البحث. تحقق من إعداد الحزمة.';
      });
    }
  }

  void _openSurah(int surah, {int initialAyah = 1}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuranReaderPage(
          surahNumber: surah,
          initialAyah: initialAyah,
          onReadChanged: _saveLastRead,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: Colors.white,
        title: const Text(
          'القرآن الكريم',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'البحث في القرآن',
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchMode = !_searchMode;
                _searchResults = [];
                _searchMessage = '';
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_searchMode) _buildSearchBox(),
            Expanded(
              child: _searchMode
                  ? _buildSearchResults()
                  : _buildSurahList(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: const Text(
                'مصدر النص: حزمة Quran المعتمدة في هذا التطبيق. '
                'للتعريف بمصدر النص وشروطه راجع صفحة المصدر.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _muted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _green.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book_rounded,
            color: _green,
            size: 42,
          ),
          const SizedBox(height: 8),
          const Text(
            'وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'اقرأ وتدبّر واحفظ موضع قراءتك',
            style: TextStyle(color: _muted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: _bg,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => _openSurah(
                _lastSurah,
                initialAyah: _lastAyah,
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                'متابعة القراءة: ${quran.getSurahNameArabic(_lastSurah)} '
                '— الآية $_lastAyah',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'ابحث عن كلمة أو عبارة قرآنية',
              hintStyle: const TextStyle(color: _muted),
              filled: true,
              fillColor: _panel,
              prefixIcon: const Icon(
                Icons.search,
                color: _green,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onSubmitted: (_) => _searchQuran(),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _searching ? null : _searchQuran,
              child: const Text('بحث'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searching) {
      return const Center(
        child: CircularProgressIndicator(color: _green),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _searchMessage.isEmpty
                ? 'اكتب كلمة ثم اضغط بحث'
                : _searchMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];

        return Card(
          color: _panel,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          child: ListTile(
            title: Text(
              '${quran.getSurahNameArabic(result.surah)} '
              '— الآية ${result.ayah}',
              style: const TextStyle(
                color: _green,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                result.text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.9,
                ),
              ),
            ),
            onTap: () => _openSurah(
              result.surah,
              initialAyah: result.ayah,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahList() {
    return ListView.builder(
      itemCount: quran.totalSurahCount,
      itemBuilder: (context, index) {
        final int number = index + 1;
        final String name = quran.getSurahNameArabic(number);
        final int verses = quran.getVerseCount(number);
        final String place = quran.getPlaceOfRevelation(number);

        return Card(
          color: _panel,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          child: ListTile(
            leading: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$number',
                style: const TextStyle(
                  color: _green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '$verses آية • $place',
              style: const TextStyle(color: _muted),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: _green,
            ),
            onTap: () => _openSurah(number),
          ),
        );
      },
    );
  }
}

class _AyahResult {
  final int surah;
  final int ayah;
  final String text;

  const _AyahResult({
    required this.surah,
    required this.ayah,
    required this.text,
  });
}

class QuranReaderPage extends StatefulWidget {
  final int surahNumber;
  final int initialAyah;
  final Future<void> Function(int surah, int ayah) onReadChanged;

  const QuranReaderPage({
    super.key,
    required this.surahNumber,
    this.initialAyah = 1,
    required this.onReadChanged,
  });

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Set<int> _favorites = {};
  final ScrollController _scrollController = ScrollController();

  bool _audioLoading = false;
  bool _isPlaying = false;
  bool _favoritesOnly = false;

  int get _surah => widget.surahNumber;
  int get _verseCount => quran.getVerseCount(_surah);

  String get _favoriteKey => 'siraj_quran_favorites';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state.playing;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialAyah();
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_favoriteKey) ?? [];

    if (!mounted) return;

    setState(() {
      _favorites
        ..clear()
        ..addAll(
          saved
              .where((value) => value.startsWith('$_surah:'))
              .map((value) => int.tryParse(value.split(':').last))
              .whereType<int>(),
        );
    });
  }

  Future<void> _toggleFavorite(int ayah) async {
    final key = '$_surah:$ayah';
    final prefs = await SharedPreferences.getInstance();
    final all = (prefs.getStringList(_favoriteKey) ?? []).toSet();

    if (_favorites.contains(ayah)) {
      _favorites.remove(ayah);
      all.remove(key);
    } else {
      _favorites.add(ayah);
      all.add(key);
    }

    await prefs.setStringList(_favoriteKey, all.toList());

    if (mounted) setState(() {});
  }

  Future<void> _savePosition(int ayah) async {
    await widget.onReadChanged(_surah, ayah);
  }

  void _scrollToInitialAyah() {
    if (!_scrollController.hasClients) return;

    final target = widget.initialAyah.clamp(1, _verseCount);
    const estimatedItemHeight = 150.0;

    _scrollController.jumpTo(
      ((target - 1) * estimatedItemHeight).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
    );
  }

  Future<void> _playSurah() async {
    setState(() => _audioLoading = true);

    try {
      final url = quran.getAudioURLBySurah(_surah);

      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر تشغيل التلاوة. تحقق من اتصال الإنترنت.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _audioLoading = false);
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String surahName = quran.getSurahNameArabic(_surah);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: Colors.white,
        title: Text(surahName),
        actions: [
          IconButton(
            tooltip: 'المفضلة فقط',
            icon: Icon(
              _favoritesOnly ? Icons.bookmark : Icons.bookmark_border,
              color: _green,
            ),
            onPressed: () {
              setState(() {
                _favoritesOnly = !_favoritesOnly;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Text(
                  surahName,
                  style: const TextStyle(
                    color: _green,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${quran.getPlaceOfRevelation(_surah)} • '
                  '$_verseCount آية • السورة $_surah',
                  style: const TextStyle(color: _muted),
                ),
                if (_surah != 1 && _surah != 9) ...[
                  const SizedBox(height: 12),
                  Text(
                    quran.basmala,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      height: 1.9,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _audioLoading
                          ? null
                          : _isPlaying
                              ? _stopAudio
                              : _playSurah,
                      icon: Icon(
                        _audioLoading
                            ? Icons.hourglass_top
                            : _isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                      ),
                      label: Text(
                        _audioLoading
                            ? 'جارٍ التحميل'
                            : _isPlaying
                                ? 'إيقاف مؤقت'
                                : 'استماع للتلاوة',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _verseCount,
              itemBuilder: (context, index) {
                final int ayah = index + 1;

                if (_favoritesOnly && !_favorites.contains(ayah)) {
                  return const SizedBox.shrink();
                }

                final String verse = quran.getVerse(
                  _surah,
                  ayah,
                  verseEndSymbol: true,
                );

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _panel,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _green.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _green.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$ayah',
                              style: const TextStyle(
                                color: _green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'حفظ الآية في المفضلة',
                            onPressed: () => _toggleFavorite(ayah),
                            icon: Icon(
                              _favorites.contains(ayah)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: _green,
                            ),
                          ),
                          IconButton(
                            tooltip: 'حفظ موضع القراءة',
                            onPressed: () async {
                              await _savePosition(ayah);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم حفظ موضع القراءة عند الآية $ayah',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.flag_outlined,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        verse,
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 2.1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
