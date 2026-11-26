import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/listening_page.dart';
import 'pages/reading_page.dart';
import 'pages/vocab_page.dart';
import 'pages/writing_page.dart';
import 'services/app_store.dart';
import 'services/tts_service.dart';
import 'theme/app_theme.dart';
import 'widgets/minimal_top_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await AppStore.instance.init();
  await TtsService.instance.init();

  runApp(const Cet6PassApp());
}

class Cet6PassApp extends StatelessWidget {
  const Cet6PassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '六级必过通',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const MainShell(),
    );
  }
}

/// 严格划分为 4 个分工明确的独立 Tab 页：背词 / 听力 / 阅读 / 写译
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    VocabPage(),
    ListeningPage(),
    ReadingPage(),
    WritingPage(),
  ];

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;
    TtsService.instance.stop();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const MinimalTopBar(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _navItem(0, Icons.style_outlined, Icons.style_rounded, '背词'),
                _navItem(
                    1, Icons.headphones_outlined, Icons.headphones_rounded, '听力'),
                _navItem(
                    2, Icons.menu_book_outlined, Icons.menu_book_rounded, '阅读'),
                _navItem(
                    3, Icons.edit_note_outlined, Icons.edit_note_rounded, '写译'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final selected = _currentIndex == index;
    final color = selected ? AppColors.primary : AppColors.textMuted;
    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
