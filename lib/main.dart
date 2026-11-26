import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/dashboard_page.dart';
import 'pages/vocab_page.dart';
import 'pages/reading_page.dart';
import 'pages/listening_page.dart';
import 'pages/writing_page.dart';
import 'services/study_storage_service.dart';
import 'services/tts_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final initialDark = await StudyStorageService.loadDarkMode();
  TtsService.instance.init();
  runApp(Cet6PassApp(initialDark: initialDark));
}

class Cet6PassApp extends StatefulWidget {
  final bool initialDark;

  const Cet6PassApp({super.key, required this.initialDark});

  @override
  State<Cet6PassApp> createState() => _Cet6PassAppState();
}

class _Cet6PassAppState extends State<Cet6PassApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialDark ? ThemeMode.dark : ThemeMode.light;
    _applySystemUi();
  }

  void _applySystemUi() {
    final isDark = _themeMode == ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }

  void _toggleTheme() {
    HapticFeedback.lightImpact();
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
    StudyStorageService.saveDarkMode(_themeMode == ThemeMode.dark);
    _applySystemUi();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '六级必过通',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: MainShell(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const MainShell({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    if (_currentIndex == 3) {
      TtsService.instance.stop();
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final primary = AppTheme.primary(isDark);

    final pages = [
      DashboardPage(onNavigateTab: _switchTab),
      const VocabPage(),
      const ReadingPage(),
      const ListeningPage(),
      const WritingPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          // 右上角一键切换护眼夜间模式胶囊按钮
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onToggleTheme,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(isDark).withOpacity(0.94),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                    size: 18,
                    color: isDark ? AppTheme.warmAmber : AppTheme.kleinBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface(isDark),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.36 : 0.06),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
            child: Row(
              children: [
                _navTab(0, Icons.dashboard_rounded, '驾驶舱', primary, isDark),
                _navTab(1, Icons.style_rounded, '高频词', primary, isDark),
                _navTab(2, Icons.menu_book_rounded, '精读', primary, isDark),
                _navTab(3, Icons.headphones_rounded, '精听', primary, isDark),
                _navTab(4, Icons.edit_note_rounded, '写译', primary, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navTab(
    int index,
    IconData icon,
    String label,
    Color primary,
    bool isDark,
  ) {
    final selected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _switchTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: selected ? primary.withOpacity(isDark ? 0.18 : 0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: selected ? 22 : 20,
                color: selected ? primary : AppTheme.textSecondary(isDark),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                  color: selected ? primary : AppTheme.textSecondary(isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
