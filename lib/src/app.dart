import 'dart:convert';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';

const ink = Color(0xFF0F172A);
const muted = Color(0xFF64748B);
const blue = Color(0xFF185ADB);

class PrepExamiApp extends StatelessWidget {
  const PrepExamiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PrepExami',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    ),
    home: !AppConfig.isConfigured
        ? const SetupScreen()
        : StreamBuilder<AuthState>(
            stream: Supabase.instance.client.auth.onAuthStateChange,
            builder: (context, authState) =>
                Supabase.instance.client.auth.currentSession == null
                ? const LandingScreen()
                : const SignedInHomeScreen(),
          ),
  );
}

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', height: 70),
                const SizedBox(height: 20),
                const Text(
                  'Connect PrepExami',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Supply the public Supabase values at build time. Server secrets remain in Next.js.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                const SelectableText(
                  'flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=API_BASE_URL=http://10.0.2.2:3000',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class SignedInHomeScreen extends StatelessWidget {
  const SignedInHomeScreen({super.key});

  void _openPractice(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SelectExamScreen()),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAF8FF),
    body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF0EDF5))),
            ),
            child: Row(
              children: [
                Image.asset('assets/logo.png', width: 148, fit: BoxFit.contain),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountSettingsScreen(),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(18),
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFF0649C9),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
              children: [
                const Text(
                  'Hi, Student 👋',
                  style: TextStyle(
                    color: Color(0xFF071631),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  "Let's hit today's targeted practice milestone!",
                  style: TextStyle(
                    color: Color(0xFF3F4D6B),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFCDD8F1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              '●  CONTINUE PRACTICE',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF0649C9),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Quant Practice',
                            style: TextStyle(
                              color: Color(0xFF3E4A65),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11),
                      const Text(
                        'Speed Math & Approximations',
                        style: TextStyle(
                          color: Color(0xFF101B35),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Q 6 of 20 remaining  •  14 answered',
                        style: TextStyle(
                          color: Color(0xFF58647D),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 11),
                      Row(
                        children: [
                          const Expanded(
                            child: LinearProgressIndicator(
                              value: .7,
                              minHeight: 4,
                              backgroundColor: Color(0xFFE6EAFF),
                              color: Color(0xFF1251C9),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 35),
                          FilledButton.icon(
                            onPressed: () => _openPractice(context),
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(Icons.arrow_forward, size: 14),
                            label: const Text('Resume'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0649C9),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Choose Practice Mode',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF101A32),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'IBPS PO Prelims',
                      style: TextStyle(color: Color(0xFF5B667E), fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _HomeModeCard(
                        icon: Icons.timer_outlined,
                        iconColor: const Color(0xFF164ED0),
                        iconBackground: const Color(0xFFE5E9FF),
                        title: 'Exam Simulation',
                        description:
                            'Full Mocks & Sectionals\nin real timed test\nenvironment',
                        buttonLabel: 'Start Test',
                        buttonColor: const Color(0xFFE1E6FF),
                        buttonTextColor: const Color(0xFF184BCD),
                        onPressed: () => _openPractice(context),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _HomeModeCard(
                        icon: Icons.menu_book_outlined,
                        iconColor: const Color(0xFF007E5D),
                        iconBackground: const Color(0xFFDDF8EE),
                        title: 'Concept Drills',
                        description:
                            'Topic-wise speed sets\nwith instant solutions &\ntricks',
                        buttonLabel: 'Start Drills',
                        buttonColor: const Color(0xFFDFF8EE),
                        buttonTextColor: const Color(0xFF007A56),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConceptSubjectScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _HomeNavigation(onPractice: () => _openPractice(context)),
        ],
      ),
    ),
  );
}

class _HomeModeCard extends StatelessWidget {
  const _HomeModeCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onPressed,
  });
  final IconData icon;
  final Color iconColor, iconBackground, buttonColor, buttonTextColor;
  final String title, description, buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFEAE7F0)),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Color(0x080F172A), blurRadius: 8)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(height: 9),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF101A32),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xFF4B5871),
            fontSize: 10,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onPressed,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward, size: 13),
            label: Text(buttonLabel),
            style: FilledButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: buttonTextColor,
              padding: const EdgeInsets.symmetric(vertical: 8),
              visualDensity: VisualDensity.compact,
              textStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _HomeNavigation extends StatelessWidget {
  const _HomeNavigation({required this.onPractice});
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) => Container(
    height: 58,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFE7E5EC))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const _HomeNavItem(
          icon: Icons.home_outlined,
          label: 'Home',
          selected: true,
        ),
        _HomeNavItem(
          icon: Icons.menu_book_outlined,
          label: 'Practice',
          onTap: onPractice,
        ),
        _HomeNavItem(
          icon: Icons.analytics_outlined,
          label: 'Progress',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
          ),
        ),
        _HomeNavItem(
          icon: Icons.person_outline,
          label: 'Profile',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
          ),
        ),
      ],
    ),
  );
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE5E9FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected
                    ? const Color(0xFF1752D1)
                    : const Color(0xFF4F586D),
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF1752D1)
                    : const Color(0xFF5A6275),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PracticeProgress {
  const _PracticeProgress({
    this.answered = 0,
    this.correct = 0,
    this.subjects = const {},
    this.topics = const {},
  });

  final int answered;
  final int correct;
  final Set<String> subjects;
  final Set<String> topics;

  int get accuracy => answered == 0 ? 0 : (correct * 100 / answered).round();

  static String? get _key {
    if (!AppConfig.isConfigured) return null;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    return userId == null ? null : 'practice_progress_$userId';
  }

  static Future<_PracticeProgress> load() async {
    final key = _key;
    if (key == null) return const _PracticeProgress();
    final raw = (await SharedPreferences.getInstance()).getString(key);
    if (raw == null) return const _PracticeProgress();
    try {
      final value = Map<String, dynamic>.from(jsonDecode(raw));
      return _PracticeProgress(
        answered: value['answered'] as int? ?? 0,
        correct: value['correct'] as int? ?? 0,
        subjects: Set<String>.from(value['subjects'] as List? ?? const []),
        topics: Set<String>.from(value['topics'] as List? ?? const []),
      );
    } catch (_) {
      return const _PracticeProgress();
    }
  }

  static Future<void> record({
    required String subject,
    required String topic,
    required bool isCorrect,
  }) async {
    final key = _key;
    if (key == null) return;
    final current = await load();
    await (await SharedPreferences.getInstance()).setString(
      key,
      jsonEncode({
        'answered': current.answered + 1,
        'correct': current.correct + (isCorrect ? 1 : 0),
        'subjects': {...current.subjects, subject}.toList(),
        'topics': {...current.topics, topic}.toList(),
      }),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Progress')),
    body: FutureBuilder<_PracticeProgress>(
      future: _PracticeProgress.load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final progress = snapshot.data ?? const _PracticeProgress();
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Your Practice Progress',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.analytics_outlined, size: 48, color: blue),
                    const SizedBox(height: 12),
                    Text(
                      '${progress.answered} Questions Answered',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _ProgressStat(
                          value: '${progress.accuracy}%',
                          label: 'Accuracy',
                        ),
                        _ProgressStat(
                          value: '${progress.subjects.length}',
                          label: 'Subjects',
                        ),
                        _ProgressStat(
                          value: '${progress.topics.length}',
                          label: 'Topics',
                        ),
                      ],
                    ),
                    if (progress.answered == 0) ...[
                      const SizedBox(height: 14),
                      const Text(
                        'Your performance history will appear after your first practice session.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _ProgressStat extends StatelessWidget {
  const _ProgressStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: blue,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(color: muted, fontSize: 11)),
      ],
    ),
  );
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  bool get _isSignedIn =>
      AppConfig.isConfigured &&
      Supabase.instance.client.auth.currentSession != null;

  void _openProtected(BuildContext context, WidgetBuilder builder) {
    if (!_isSignedIn) {
      _openAuth(context);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    final isSignedIn =
        AppConfig.isConfigured &&
        Supabase.instance.client.auth.currentSession != null;
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF0EDF5))),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 148,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  if (isSignedIn)
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountSettingsScreen(),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(18),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF0649C9),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    )
                  else
                    OutlinedButton(
                      onPressed: () => _openAuth(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(58, 31),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        side: const BorderSide(color: Color(0xFFDCE3F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Log in',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF174ECF),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 27, 15, 14),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEBFF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🎯', style: TextStyle(fontSize: 11)),
                          SizedBox(width: 7),
                          SizedBox(
                            width: 160,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Competitive Exam Practice',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF142853),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  const Text(
                    'Master your exams\nthrough pure practice.',
                    style: TextStyle(
                      color: Color(0xFF071631),
                      fontSize: 25,
                      height: 1.08,
                      letterSpacing: -1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No notes, no clutter. Select your path and start\nsolving in 1 tap.',
                    style: TextStyle(
                      color: Color(0xFF3F4A66),
                      fontSize: 13,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 19),
                  LandingPracticeCard(
                    icon: Icons.assignment,
                    iconColor: const Color(0xFF2455DD),
                    iconBackground: const Color(0xFFE8ECFF),
                    badge: 'EXAM MODE',
                    badgeColor: const Color(0xFF274CD6),
                    title: 'Full Exam Practice',
                    description:
                        'Full length mock tests, sectional papers &\nprevious year questions.',
                    chips: const ['IBPS PO', 'SBI Clerk', 'SSC CGL'],
                    buttonLabel: 'Practise by Exam',
                    buttonColor: const Color(0xFF2454DC),
                    onPressed: () => _openProtected(
                      context,
                      (_) => const SelectExamScreen(),
                    ),
                  ),
                  const SizedBox(height: 13),
                  LandingPracticeCard(
                    icon: Icons.psychology,
                    iconColor: const Color(0xFF007A56),
                    iconBackground: const Color(0xFFE6F9F1),
                    badge: 'SPEED DRILLS',
                    badgeColor: const Color(0xFF007A56),
                    title: 'Concept & Topic Drills',
                    description:
                        'Target specific topics, strengthen weak\nconcepts, speed drills.',
                    chips: const ['Quant', 'Reasoning', 'English', 'GK'],
                    buttonLabel: 'Practise by Topic',
                    buttonColor: const Color(0xFFE1E5FF),
                    buttonTextColor: const Color(0xFF2850DA),
                    onPressed: () => _openProtected(
                      context,
                      (_) => const ConceptSubjectScreen(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ConceptSubjectScreen(trialMode: true),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.bolt,
                              color: Color(0xFF2754E5),
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              'Try a 3-minute sample drill without\nsigning up',
                              style: TextStyle(
                                color: Color(0xFF111D3A),
                                fontSize: 11,
                                height: 1.15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Color(0xFF2754E5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Targeting IBPS, SSC & State Govt Exams',
                      style: TextStyle(color: Color(0xFF69718A), fontSize: 9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAuth(BuildContext context) => showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const AuthScreen(),
  );
}

class SelectExamScreen extends StatefulWidget {
  const SelectExamScreen({super.key});

  @override
  State<SelectExamScreen> createState() => _SelectExamScreenState();
}

class _SelectExamScreenState extends State<SelectExamScreen> {
  final search = TextEditingController();
  String selectedExam = 'IBPS PO';
  String category = 'All Exams';

  static const exams = <_ExamChoice>[
    _ExamChoice(
      'IBPS PO',
      Icons.account_balance,
      Color(0xFFE3EAFF),
      Color(0xFF2E65D3),
      'Banking & Insurance',
    ),
    _ExamChoice(
      'SBI Clerk',
      Icons.receipt_long,
      Color(0xFFDAFAEE),
      Color(0xFF008A64),
      'Banking & Insurance',
    ),
    _ExamChoice(
      'SSC CGL',
      Icons.military_tech,
      Color(0xFFE9ECFF),
      Color(0xFF4668DA),
      'SSC',
    ),
    _ExamChoice(
      'IBPS Clerk',
      Icons.account_balance_wallet,
      Color(0xFFF0F1F6),
      Color(0xFF5C6272),
      'Banking & Insurance',
    ),
    _ExamChoice(
      'RBI Grade B',
      Icons.apartment,
      Color(0xFFE8EBFF),
      Color(0xFF9B7115),
      'Banking & Insurance',
    ),
    _ExamChoice(
      'SSC CHSL',
      Icons.school,
      Color(0xFFF0F0FF),
      Color(0xFF5D6478),
      'SSC',
    ),
  ];

  List<_ExamChoice> get filteredExams {
    final term = search.text.trim().toLowerCase();
    return exams.where((exam) {
      final matchesSearch =
          term.isEmpty || exam.name.toLowerCase().contains(term);
      final matchesCategory =
          category == 'All Exams' || exam.category == category;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAF8FF),
    body: SafeArea(
      child: Column(
        children: [
          _examHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(13, 11, 9, 20),
              children: [
                const Text(
                  'Select Exam',
                  style: TextStyle(
                    color: Color(0xFF08162F),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF273451),
                      size: 22,
                    ),
                    hintText: 'Search exam (e.g., IBPS PO, SSC CGL)...',
                    hintStyle: TextStyle(
                      color: Color(0xFF69728B),
                      fontSize: 13,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
                const SizedBox(height: 13),
                SizedBox(
                  height: 37,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryPill(
                        label: 'All Exams',
                        count: '18',
                        selected: category == 'All Exams',
                        onTap: () => setState(() => category = 'All Exams'),
                      ),
                      _CategoryPill(
                        label: 'Banking & Insurance',
                        icon: Icons.account_balance,
                        selected: category == 'Banking & Insurance',
                        onTap: () =>
                            setState(() => category = 'Banking & Insurance'),
                      ),
                      _CategoryPill(
                        label: 'SSC',
                        icon: Icons.train,
                        selected: category == 'SSC',
                        onTap: () => setState(() => category = 'SSC'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 21),
                Row(
                  children: [
                    const Text(
                      'Popular Exams',
                      style: TextStyle(
                        color: Color(0xFF20263A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text('🔥', style: TextStyle(fontSize: 13)),
                    const Spacer(),
                    Text(
                      '${filteredExams.length} exams',
                      style: const TextStyle(
                        color: Color(0xFF4A5063),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                ...filteredExams.map((exam) => _examTile(exam)),
                if (filteredExams.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No exams found',
                        style: TextStyle(color: muted),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(13, 11, 9, 9),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE4E2E9))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final selected = competitiveExams.entries.firstWhere(
                    (entry) => entry.value['name'] == selectedExam,
                    orElse: () => competitiveExams.entries.first,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectSubjectScreen(
                        examKey: selected.key,
                        examName: '${selected.value['name']}',
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0848C8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue with $selectedExam',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _examHeader() => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Color(0xFFF0EDF5))),
    ),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 35),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1A2540),
            size: 22,
          ),
        ),
        const SizedBox(width: 5),
        Image.asset('assets/logo.png', width: 148, fit: BoxFit.contain),
        const Spacer(),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
          ),
          borderRadius: BorderRadius.circular(18),
          child: const CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFF0649C9),
            child: Icon(Icons.person_outline, color: Colors.white, size: 18),
          ),
        ),
      ],
    ),
  );

  Widget _examTile(_ExamChoice exam) {
    final selected = selectedExam == exam.name;
    return InkWell(
      onTap: () => setState(() => selectedExam = exam.name),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 66,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE1E7FF) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFD8DFFE) : const Color(0xFFF1EEF6),
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: exam.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(exam.icon, color: exam.iconColor, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                exam.name,
                style: const TextStyle(
                  color: Color(0xFF353B4D),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0649C9)
                    : const Color(0xFFDDE5FF),
                shape: BoxShape.circle,
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConceptSubject {
  const _ConceptSubject({
    required this.databaseName,
    required this.label,
    required this.shortLabel,
    required this.id,
    required this.topicCount,
  });
  final String databaseName, label, shortLabel, id;
  final int topicCount;
}

class ConceptSubjectScreen extends StatefulWidget {
  const ConceptSubjectScreen({this.trialMode = false, super.key});

  final bool trialMode;

  @override
  State<ConceptSubjectScreen> createState() => _ConceptSubjectScreenState();
}

class _ConceptSubjectScreenState extends State<ConceptSubjectScreen> {
  final search = TextEditingController();
  String? selectedId;
  late Future<List<_ConceptSubject>> subjects = _loadSubjects();

  static const subjectLabels = <String, (String, String)>{
    'Quantitative Aptitude': ('Quantitative Aptitude', 'Q'),
    'Reasoning': ('Reasoning Ability', 'R'),
    'English Language': ('English Language', 'E'),
    'Data and Main Topics': ('Data Interpretation', 'DI'),
    'General Awareness': ('General & Financial Awareness', 'GA'),
    'Banking Core': ('Banking Core Awareness', 'BA'),
    'Banking Specific': ('Banking Specific Awareness', 'BS'),
  };

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<List<_ConceptSubject>> _loadSubjects() async {
    final loaded = await Future.wait(
      subjectLabels.entries.map((entry) async {
        final id = competitiveSubjectIds[entry.key]!;
        final response = await Supabase.instance.client
            .from('master_topics')
            .select('id')
            .eq('subject_id', id)
            .count(CountOption.exact);
        return _ConceptSubject(
          databaseName: entry.key,
          label: entry.value.$1,
          shortLabel: entry.value.$2,
          id: id,
          topicCount: response.count,
        );
      }),
    );
    if (selectedId == null && loaded.isNotEmpty) selectedId = loaded.first.id;
    return loaded;
  }

  void _continue(List<_ConceptSubject> subjects) {
    final selected = subjects.firstWhere((item) => item.id == selectedId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectTopicScreen(
          examName: 'Concept Practice',
          trialMode: widget.trialMode,
          subject: SubjectChoice(
            name: selected.databaseName,
            id: selected.id,
            questionCount: 0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAF8FF),
    body: SafeArea(
      child: FutureBuilder<List<_ConceptSubject>>(
        future: subjects,
        builder: (context, snapshot) {
          final all = snapshot.data ?? const <_ConceptSubject>[];
          final term = search.text.trim().toLowerCase();
          final visible = all
              .where((subject) => subject.label.toLowerCase().contains(term))
              .toList();
          final selected = all
              .where((subject) => subject.id == selectedId)
              .firstOrNull;
          return Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFF0EDF5))),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 20),
                    ),
                    const Text(
                      'Concept Practice',
                      style: TextStyle(
                        color: Color(0xFF1A243C),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/logo.png',
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                    ? Center(
                        child: ErrorCard(
                          message: 'Unable to load subjects. ${snapshot.error}',
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(13, 14, 13, 16),
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8EDFF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'CONCEPT PRACTICE',
                                  style: TextStyle(
                                    color: Color(0xFF1752D1),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '⚙ ${all.length} Subjects',
                                style: const TextStyle(
                                  color: Color(0xFF46536D),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Select Subject',
                            style: TextStyle(
                              color: Color(0xFF071631),
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Pick a subject to start concept drills.',
                            style: TextStyle(
                              color: Color(0xFF526079),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 13),
                          TextField(
                            controller: search,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search, size: 19),
                              hintText: 'Search subject...',
                              hintStyle: TextStyle(fontSize: 10),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 11),
                          ...visible.map(_subjectTile),
                          if (visible.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(30),
                              child: Center(child: Text('No subjects found.')),
                            ),
                        ],
                      ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 9),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE6E4ED))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: selected == null ? null : () => _continue(all),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: Text(
                      selected == null
                          ? 'Select a Subject'
                          : 'Practise ${selected.label}',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2054D8),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget _subjectTile(_ConceptSubject subject) {
    final locked =
        widget.trialMode && subject.databaseName != subjectLabels.keys.first;
    final selected = selectedId == subject.id;
    return InkWell(
      onTap: locked
          ? () => showDialog<void>(
              context: context,
              builder: (_) => const AuthScreen(),
            )
          : () => setState(() => selectedId = subject.id),
      borderRadius: BorderRadius.circular(10),
      child: Opacity(
        opacity: locked ? .42 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 59,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F4FF) : Colors.white,
            border: Border.all(
              color: selected
                  ? const Color(0xFF2760EF)
                  : const Color(0xFFF0EDF5),
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF1554D8)
                      : const Color(0xFFE9EDFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subject.shortLabel,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF173F9D),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            subject.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF17213A),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1E8FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '✓ Active',
                              style: TextStyle(
                                color: Color(0xFF1752D1),
                                fontSize: 7,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      locked
                          ? 'Login required'
                          : '${subject.topicCount} Topics available',
                      style: const TextStyle(
                        color: Color(0xFF5B6880),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                locked ? Icons.lock_outline : Icons.arrow_forward,
                size: 17,
                color: selected
                    ? const Color(0xFF1752D1)
                    : const Color(0xFFBDC4D5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectChoice {
  const SubjectChoice({
    required this.name,
    required this.id,
    required this.questionCount,
  });
  final String name, id;
  final int questionCount;
}

class SelectSubjectScreen extends StatefulWidget {
  const SelectSubjectScreen({
    required this.examKey,
    required this.examName,
    super.key,
  });
  final String examKey, examName;
  @override
  State<SelectSubjectScreen> createState() => _SelectSubjectScreenState();
}

class _SelectSubjectScreenState extends State<SelectSubjectScreen> {
  late Future<List<SubjectChoice>> subjects = _loadSubjects();
  String? selectedId;

  Future<List<SubjectChoice>> _loadSubjects() async {
    final configured = List<String>.from(
      competitiveExams[widget.examKey]?['subjects'] ?? const [],
    );
    final available = configured
        .where(competitiveSubjectIds.containsKey)
        .toList();
    final values = await Future.wait(
      available.map((name) async {
        final id = competitiveSubjectIds[name]!;
        final response = await Supabase.instance.client
            .from('master_questions')
            .select('id')
            .eq('subject_id', id)
            .count(CountOption.exact);
        return SubjectChoice(name: name, id: id, questionCount: response.count);
      }),
    );
    if (selectedId == null && values.isNotEmpty) selectedId = values.first.id;
    return values;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAF8FF),
    body: SafeArea(
      child: FutureBuilder<List<SubjectChoice>>(
        future: subjects,
        builder: (context, snapshot) {
          final items = snapshot.data ?? const <SubjectChoice>[];
          return Column(
            children: [
              const _PracticeFlowHeader(),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                    ? Center(
                        child: ErrorCard(
                          message: 'Unable to load subjects. ${snapshot.error}',
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(13, 14, 13, 18),
                        children: [
                          _TargetGoalCard(examName: widget.examName),
                          const SizedBox(height: 14),
                          const Row(
                            children: [
                              _StepBadge(label: 'STEP 1 OF 3'),
                              Spacer(),
                              Icon(
                                Icons.tune,
                                size: 13,
                                color: Color(0xFF0A9A64),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Self-Paced Practice',
                                style: TextStyle(
                                  color: Color(0xFF45617F),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Choose Subject',
                            style: TextStyle(
                              color: Color(0xFF0D1830),
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Select a core syllabus module to view and practice\ntailored chapter sets.  •  ${items.length} Subjects Available',
                            style: const TextStyle(
                              color: Color(0xFF5F6880),
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...items.asMap().entries.map(
                            (entry) => _subjectTile(entry.value, entry.key),
                          ),
                          if (items.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(30),
                              child: Center(
                                child: Text('No subjects are configured.'),
                              ),
                            ),
                        ],
                      ),
              ),
              _FlowBottomBar(
                label: selectedId == null
                    ? 'Select a Subject'
                    : 'Select Topics (${items.firstWhere((item) => item.id == selectedId).name})',
                onPressed: selectedId == null
                    ? null
                    : () {
                        final selected = items.firstWhere(
                          (item) => item.id == selectedId,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SelectTopicScreen(
                              examName: widget.examName,
                              subject: selected,
                            ),
                          ),
                        );
                      },
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget _subjectTile(SubjectChoice subject, int index) {
    final selected = selectedId == subject.id;
    final icons = [
      Icons.search,
      Icons.psychology_outlined,
      Icons.translate,
      Icons.bar_chart,
      Icons.account_balance_outlined,
      Icons.menu_book_outlined,
      Icons.public,
    ];
    return InkWell(
      onTap: () => setState(() => selectedId = subject.id),
      borderRadius: BorderRadius.circular(11),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(9, 10, 10, 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1F4FF) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFCCD8FF) : const Color(0xFFF0EDF5),
          ),
          borderRadius: BorderRadius.circular(11),
          boxShadow: const [BoxShadow(color: Color(0x080F172A), blurRadius: 7)],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0748C9)
                    : const Color(0xFFE9EDFF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icons[index % icons.length],
                color: selected ? Colors.white : const Color(0xFF173F9D),
                size: 18,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF17213A),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '● Available for practice  •  ${subject.questionCount} Questions',
                    style: const TextStyle(
                      color: Color(0xFF07845D),
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 11,
              backgroundColor: selected
                  ? const Color(0xFF0748C9)
                  : const Color(0xFFF0F3FF),
              child: Icon(
                selected ? Icons.check : Icons.chevron_right,
                color: selected ? Colors.white : const Color(0xFF6E7CA6),
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicChoice {
  const _TopicChoice({
    required this.id,
    required this.name,
    required this.questionCount,
  });
  final String id, name;
  final int questionCount;
}

class SelectTopicScreen extends StatefulWidget {
  const SelectTopicScreen({
    required this.examName,
    required this.subject,
    this.trialMode = false,
    super.key,
  });
  final String examName;
  final SubjectChoice subject;
  final bool trialMode;
  @override
  State<SelectTopicScreen> createState() => _SelectTopicScreenState();
}

class _SelectTopicScreenState extends State<SelectTopicScreen> {
  final search = TextEditingController();
  final selectedIds = <String>{};
  late Future<List<_TopicChoice>> topics = _loadTopics();
  String? trialTopicId;

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<List<_TopicChoice>> _loadTopics() async {
    final rows = List<Map<String, dynamic>>.from(
      await Supabase.instance.client
          .from('master_topics')
          .select('id,name,sort_order')
          .eq('subject_id', widget.subject.id)
          .order('sort_order'),
    );
    final loaded = await Future.wait(
      rows.map((row) async {
        final id = '${row['id']}';
        final response = await Supabase.instance.client
            .from('master_questions')
            .select('id')
            .eq('topic_id', id)
            .count(CountOption.exact);
        return _TopicChoice(
          id: id,
          name: '${row['name']}',
          questionCount: response.count,
        );
      }),
    );
    if (widget.trialMode && loaded.isNotEmpty) {
      trialTopicId = loaded.first.id;
      selectedIds
        ..clear()
        ..add(trialTopicId!);
    }
    return loaded;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAF8FF),
    body: SafeArea(
      child: FutureBuilder<List<_TopicChoice>>(
        future: topics,
        builder: (context, snapshot) {
          final all = snapshot.data ?? const <_TopicChoice>[];
          final term = search.text.trim().toLowerCase();
          final visible = all
              .where((topic) => topic.name.toLowerCase().contains(term))
              .toList();
          return Column(
            children: [
              const _PracticeFlowHeader(),
              Container(
                margin: const EdgeInsets.fromLTRB(13, 10, 13, 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4FF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school,
                      color: Color(0xFF174FCB),
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${widget.examName}  •  ${widget.subject.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF28344D),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Change',
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: TextField(
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, size: 19),
                    hintText: 'Search topic (e.g. Percentage, Time & Work)',
                    hintStyle: TextStyle(fontSize: 11),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 5),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Topics',
                            style: TextStyle(
                              color: Color(0xFF101A32),
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Pick topics to include in this practice module',
                            style: TextStyle(
                              color: Color(0xFF65708A),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: all.isEmpty || widget.trialMode
                          ? null
                          : () => setState(() {
                              if (selectedIds.length == all.length) {
                                selectedIds.clear();
                              } else {
                                selectedIds
                                  ..clear()
                                  ..addAll(all.map((topic) => topic.id));
                              }
                            }),
                      icon: Icon(
                        selectedIds.length == all.length
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 14,
                      ),
                      label: Text(
                        'Select All (${all.length})',
                        style: const TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                    ? Center(
                        child: ErrorCard(
                          message: 'Unable to load topics. ${snapshot.error}',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(13, 3, 13, 10),
                        itemCount: visible.length,
                        itemBuilder: (context, index) =>
                            _topicTile(visible[index], index),
                      ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 9),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE6E4ED))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${selectedIds.length} Topics Selected\nApprox. ${all.where((topic) => selectedIds.contains(topic.id)).fold<int>(0, (sum, topic) => sum + topic.questionCount)} Questions pool',
                        style: const TextStyle(
                          color: Color(0xFF59627A),
                          fontSize: 9,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: selectedIds.isEmpty
                          ? null
                          : () {
                              final selected = all
                                  .where(
                                    (topic) => selectedIds.contains(topic.id),
                                  )
                                  .toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CompetitiveQuizScreen(
                                    subjectName: widget.subject.name,
                                    subjectId: widget.subject.id,
                                    topicIds: selected
                                        .map((topic) => topic.id)
                                        .toList(),
                                    topicName: selected.length == 1
                                        ? selected.first.name
                                        : '${selected.length} Topics',
                                    guestTrial: widget.trialMode,
                                  ),
                                ),
                              );
                            },
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward, size: 17),
                      label: const Text('Continue to Practice'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1752D1),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget _topicTile(_TopicChoice topic, int index) {
    final locked = widget.trialMode && topic.id != trialTopicId;
    final selected = selectedIds.contains(topic.id);
    final icons = [
      Icons.percent,
      Icons.balance,
      Icons.bar_chart,
      Icons.trending_up,
      Icons.savings_outlined,
      Icons.account_balance_outlined,
      Icons.groups_outlined,
      Icons.engineering_outlined,
      Icons.water_drop_outlined,
      Icons.functions,
    ];
    return InkWell(
      onTap: locked
          ? () => showDialog<void>(
              context: context,
              builder: (_) => const AuthScreen(),
            )
          : () => setState(() {
              if (!selectedIds.add(topic.id)) selectedIds.remove(topic.id);
            }),
      borderRadius: BorderRadius.circular(10),
      child: Opacity(
        opacity: locked ? .42 : 1,
        child: Container(
          height: 57,
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F4FF) : Colors.white,
            border: Border.all(color: const Color(0xFFF0EDF5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF1554D8)
                      : const Color(0xFFEDF1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icons[index % icons.length],
                  size: 16,
                  color: selected ? Colors.white : const Color(0xFF3157A7),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF17213A),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      locked
                          ? 'Login required'
                          : '${topic.questionCount} Questions',
                      style: const TextStyle(
                        color: Color(0xFF63708A),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0751D1)
                      : const Color(0xFFE8EDFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: locked
                    ? const Icon(Icons.lock_outline, size: 12)
                    : selected
                    ? const Icon(Icons.check, color: Colors.white, size: 13)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeFlowHeader extends StatelessWidget {
  const _PracticeFlowHeader();
  @override
  Widget build(BuildContext context) => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 11),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Color(0xFFF0EDF5))),
    ),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 34),
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Color(0xFF19253F),
          ),
        ),
        const SizedBox(width: 5),
        Image.asset('assets/logo.png', width: 148, fit: BoxFit.contain),
        const Spacer(),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
          ),
          borderRadius: BorderRadius.circular(18),
          child: const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFF0649C9),
            child: Icon(Icons.person_outline, color: Colors.white, size: 17),
          ),
        ),
      ],
    ),
  );
}

class _TargetGoalCard extends StatelessWidget {
  const _TargetGoalCard({required this.examName});
  final String examName;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F3FF),
      borderRadius: BorderRadius.circular(11),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 17,
          backgroundColor: Color(0xFFE2E8FF),
          child: Icon(Icons.gps_fixed, size: 16, color: Color(0xFF174FCB)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TARGET GOAL',
                style: TextStyle(color: Color(0xFF65708C), fontSize: 8),
              ),
              Text(
                examName,
                style: const TextStyle(
                  color: Color(0xFF12203B),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(55, 28),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          child: const Text('Change ↔', style: TextStyle(fontSize: 8)),
        ),
      ],
    ),
  );
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFFE7ECFF),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFF2055C6),
        fontSize: 8,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _FlowBottomBar extends StatelessWidget {
  const _FlowBottomBar({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(13, 8, 13, 9),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFE6E4ED))),
    ),
    child: SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.arrow_forward, size: 17),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF0750CF),
          padding: const EdgeInsets.symmetric(vertical: 13),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
    ),
  );
}

class _ExamChoice {
  const _ExamChoice(
    this.name,
    this.icon,
    this.background,
    this.iconColor,
    this.category,
  );
  final String name, category;
  final IconData icon;
  final Color background, iconColor;
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
    this.icon,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? count;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 7),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0649C9) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF0649C9) : const Color(0xFFE8E4EE),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? Colors.white : const Color(0xFF3C465E),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF202943),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF356DD1)
                      : const Color(0xFFE9EEFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count!,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF2454DC),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class LandingPracticeCard extends StatelessWidget {
  const LandingPracticeCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.chips,
    required this.buttonLabel,
    required this.buttonColor,
    required this.onPressed,
    this.buttonTextColor = Colors.white,
    super.key,
  });

  final IconData icon;
  final Color iconColor,
      iconBackground,
      badgeColor,
      buttonColor,
      buttonTextColor;
  final String badge, title, description, buttonLabel;
  final List<String> chips;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE9E7F1)),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A0F172A),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF071631),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xFF38425C),
            fontSize: 11.5,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 11),
        Wrap(
          spacing: 6,
          children: chips
              .map(
                (chip) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7FF),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    chip,
                    style: const TextStyle(
                      color: Color(0xFF142853),
                      fontSize: 9,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: buttonTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Positioned(
                  right: 0,
                  child: Icon(Icons.arrow_forward, size: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class FeatureCard extends StatelessWidget {
  const FeatureCard(this.icon, this.title, this.body, {super.key});
  final IconData icon;
  final String title, body;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEFF6FF),
        child: Icon(icon, color: blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(body),
      ),
    ),
  );
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({required this.onMenu, this.close = false, super.key});
  final VoidCallback onMenu;
  final bool close;

  @override
  Widget build(BuildContext context) => Container(
    height: 66,
    padding: const EdgeInsets.symmetric(horizontal: 28),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Color(0xFFE5EAF1))),
    ),
    child: Row(
      children: [
        Image.asset('assets/logo.png', width: 194, fit: BoxFit.contain),
        const Spacer(),
        IconButton(
          onPressed: onMenu,
          icon: Icon(
            close ? Icons.close : Icons.menu,
            color: const Color(0xFF07172D),
            size: 27,
          ),
        ),
      ],
    ),
  );
}

Future<void> showCreditDialog(
  BuildContext context,
  int credits,
) => showDialog<void>(
  context: context,
  barrierColor: Colors.black54,
  builder: (dialogContext) => Dialog(
    insetPadding: const EdgeInsets.fromLTRB(17, 55, 17, 55),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buy Credits',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: ink,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Continue studying without interruption.',
                        style: TextStyle(color: muted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(color: const Color(0xFFBFDBFE)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.credit_card,
                    size: 17,
                    color: Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$credits Credits Available',
                    style: const TextStyle(
                      color: Color(0xFF0758E8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 19),
            ...const [
              (
                'Starter',
                '150 Credits',
                '≈ 6 Document Generations',
                '₹79',
                false,
              ),
              (
                'Basic',
                '300 Credits',
                '≈ 12 Document Generations',
                '₹129',
                false,
              ),
              (
                'Popular',
                '450 Credits',
                '≈ 18 Document Generations',
                '₹199',
                true,
              ),
              (
                'Premium',
                '600 Credits',
                '≈ 24 Document Generations',
                '₹299',
                false,
              ),
            ].map(
              (pack) => _CreditPack(
                name: pack.$1,
                credits: pack.$2,
                documents: pack.$3,
                price: pack.$4,
                popular: pack.$5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                border: Border.all(color: const Color(0xFFBBF7D0)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '👑 Pro Unlimited',
                          style: TextStyle(
                            color: Color(0xFF087A34),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Unlimited Documents, Flashcards, MCQs & Practice Tests',
                          style: TextStyle(
                            color: Color(0xFF159447),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF05A946),
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Text(
                        '₹399/mo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

class _CreditPack extends StatelessWidget {
  const _CreditPack({
    required this.name,
    required this.credits,
    required this.documents,
    required this.price,
    required this.popular,
  });
  final String name, credits, documents, price;
  final bool popular;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout opens on the secure PrepExami payment page.'),
      ),
    ),
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: popular ? const Color(0xFFEFF6FF) : Colors.white,
        border: Border.all(
          color: popular ? const Color(0xFF2874FF) : const Color(0xFFDCE3ED),
          width: popular ? 1.7 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (popular)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2264F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⭐ Most Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                Text(credits, style: const TextStyle(color: Color(0xFF41536E))),
                Text(
                  documents,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: ink,
            ),
          ),
        ],
      ),
    ),
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final email = TextEditingController(), password = TextEditingController();
  bool signUp = false, loading = false;
  String? error;
  StreamSubscription<AuthState>? authSubscription;

  @override
  void initState() {
    super.initState();
    authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      state,
    ) {
      if (state.event == AuthChangeEvent.signedIn &&
          mounted &&
          Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 8) {
      setState(
        () => error =
            'Enter a valid email and a password of at least 8 characters.',
      );
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      if (signUp) {
        await Supabase.instance.client.auth.signUp(
          email: email.text.trim(),
          password: password.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check your email to verify your account.'),
            ),
          );
        }
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email.text.trim(),
          password: password.text,
        );
      }
      if (mounted) Navigator.pop(context);
    } on AuthException catch (e) {
      setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> googleSignIn() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.prepexami.prepexami://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
        queryParams: const {'prompt': 'select_account'},
      );
    } on AuthException catch (exception) {
      if (mounted) setState(() => error = exception.message);
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 22, 40, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
            ),
          ),
          Text(
            signUp ? 'Create Account' : 'Login',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: googleSignIn,
            icon: const Text(
              'G',
              style: TextStyle(
                color: Color(0xFF4285F4),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Continue with Google',
                style: TextStyle(color: Color(0xFF41536E), fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('OR', style: TextStyle(color: Color(0xFF91A3BF))),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 27),
          const Text('Email', style: TextStyle(color: ink)),
          const SizedBox(height: 8),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'name@university.edu'),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              const Text('Password', style: TextStyle(color: ink)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(hintText: '••••••••'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Forgot your password? Reset it instantly.',
            style: TextStyle(color: Color(0xFF7185A1), fontSize: 13),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 26),
          FilledButton(
            onPressed: loading ? null : submit,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: loading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      signUp ? 'Create Account' : 'Sign In',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
            ),
          ),
          const SizedBox(height: 11),
          FilledButton.tonal(
            onPressed: () => setState(() => signUp = !signUp),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                signUp ? 'Back to Sign In' : 'Create Account',
                style: const TextStyle(
                  color: Color(0xFF1656F4),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  int credits = 0;

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final row = await Supabase.instance.client
        .from('profiles')
        .select('credits')
        .eq('id', user.id)
        .maybeSingle();
    if (mounted) {
      setState(() => credits = (row?['credits'] as num?)?.toInt() ?? 0);
    }
  }

  Future<void> _showMenu() => showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close menu',
    barrierColor: Colors.black12,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, secondaryAnimation) => Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandHeader(
                onMenu: () => Navigator.pop(dialogContext),
                close: true,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _MenuTile(
                      icon: Icons.credit_card,
                      label: 'Credits: $credits',
                      highlighted: true,
                      onTap: () {},
                    ),
                    _MenuTile(
                      label: 'Buy Credits',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        showCreditDialog(context, credits);
                      },
                    ),
                    _MenuTile(
                      icon: Icons.upload,
                      label: 'Upload',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        setState(() => index = 1);
                      },
                    ),
                    _MenuTile(
                      label: 'Dashboard',
                      border: false,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        setState(() => index = 0);
                      },
                    ),
                    _MenuTile(
                      label: 'Practice',
                      border: false,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        setState(() => index = 2);
                      },
                    ),
                    _MenuTile(
                      label: 'Profile',
                      border: false,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        setState(() => index = 3);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardScreen(),
      const StudioScreen(),
      const PracticeScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BrandHeader(onMenu: _showMenu),
            Expanded(
              child: IndexedStack(index: index, children: pages),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.label,
    required this.onTap,
    this.icon,
    this.highlighted = false,
    this.border = true,
  });
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool highlighted, border;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      color: highlighted ? const Color(0xFFEFF6FF) : Colors.white,
      border: border
          ? Border.all(
              color: highlighted
                  ? const Color(0xFFBFDBFE)
                  : const Color(0xFFDCE3ED),
            )
          : null,
      borderRadius: BorderRadius.circular(9),
    ),
    child: ListTile(
      onTap: onTap,
      minTileHeight: 49,
      leading: icon == null
          ? null
          : Icon(
              icon,
              size: 18,
              color: highlighted ? const Color(0xFF0284C7) : blue,
            ),
      title: Text(label, style: const TextStyle(color: ink, fontSize: 16)),
    ),
  );
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> docs;
  @override
  void initState() {
    super.initState();
    docs = load();
  }

  Future<List<Map<String, dynamic>>> load() async {
    final rows = await Supabase.instance.client
        .from('documents')
        .select('id,file_name,chunk_count,flashcard_count,mcq_count,created_at')
        .order('created_at', ascending: false)
        .limit(20);
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => setState(() => docs = load()),
    child: FutureBuilder<List<Map<String, dynamic>>>(
      future: docs,
      builder: (_, snapshot) {
        final data = snapshot.data ?? [];
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 52, 18, 28),
          children: [
            const Text(
              'My Documents',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: ink,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Organize and process your educational materials with\nAI-powered insights.',
              style: TextStyle(color: Color(0xFF58708E), height: 1.45),
            ),
            const SizedBox(height: 22),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator()),
            if (snapshot.hasError)
              ErrorCard(message: snapshot.error.toString()),
            if (snapshot.connectionState == ConnectionState.done &&
                data.isEmpty)
              const FeatureCard(
                Icons.upload_file,
                'No documents yet',
                'Open Create to add your first study source.',
              ),
            ...data.map(
              (d) => Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: SizedBox(
                              width: 47,
                              height: 47,
                              child: Icon(
                                Icons.description_outlined,
                                color: Color(0xFF1267F5),
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.more_vert, color: Color(0xFF8EA2BF)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${d['file_name'] ?? 'Untitled'}',
                        style: const TextStyle(
                          fontSize: 19,
                          height: 1.3,
                          fontWeight: FontWeight.w900,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _date(d['created_at']),
                        style: const TextStyle(color: Color(0xFF58708E)),
                      ),
                      const Divider(height: 38, color: Color(0xFFEDF1F6)),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CHUNKS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF91A3BF),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${d['chunk_count'] ?? 0}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'STATUS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF91A3BF),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Complete',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF00A431),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            backgroundColor: const Color(0xFFF3E8FF),
                            side: BorderSide.none,
                            label: Text(
                              '${d['mcq_count'] ?? 0} MCQs',
                              style: const TextStyle(
                                color: Color(0xFF7E22CE),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Chip(
                            backgroundColor: const Color(0xFFFFEDD5),
                            side: BorderSide.none,
                            label: Text(
                              '${d['flashcard_count'] ?? 0} Flashcards',
                              style: const TextStyle(
                                color: Color(0xFFCE3A00),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
  String _date(dynamic value) {
    final d = DateTime.tryParse('$value');
    return d == null ? '' : DateFormat.yMMMd().format(d.toLocal());
  }
}

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});
  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabs = TabController(length: 3, vsync: this);
  final url = TextEditingController(), text = TextEditingController();
  bool loading = false;
  bool studyMode = true;
  Future<void> send(String type) async {
    setState(() => loading = true);
    try {
      http.Response response;
      final headers = {
        'Authorization':
            'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken ?? ''}',
      };
      if (type == 'pdf') {
        final picked = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
          withData: true,
        );
        if (picked == null) return;
        final request =
            http.MultipartRequest(
                'POST',
                Uri.parse('${AppConfig.apiBaseUrl}/api/pdf'),
              )
              ..headers.addAll(headers)
              ..fields['mode'] = 'study';
        final file = picked.files.single;
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
        response = await http.Response.fromStream(await request.send());
      } else {
        headers['Content-Type'] = 'application/json';
        response = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/api/$type'),
          headers: headers,
          body: jsonEncode({
            type: type == 'text' ? text.text : url.text,
            'mode': 'study',
          }),
        );
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!response.statusCode.toString().startsWith('2')) {
        throw Exception(body['error'] ?? 'Processing failed');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Study material created. Find it in your library.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(31, 13, 31, 28),
    children: [
      const Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Turn any PDF, video, or\nlecture into '),
            TextSpan(
              text: 'practice\nexams',
              style: TextStyle(color: Color(0xFF235BFF)),
            ),
            TextSpan(text: ' in seconds.'),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 29,
          height: 1.25,
          fontWeight: FontWeight.w900,
          color: ink,
          letterSpacing: -0.8,
        ),
      ),
      const SizedBox(height: 18),
      const Text(
        'Stop spending hours writing summaries. Paste\nlinks or drop documents to instantly generate\nstructured notes, flashcards, and exam-pattern\npractice tests.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF526782), height: 1.45, fontSize: 14),
      ),
      const SizedBox(height: 31),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFDCE3ED)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE1E7EF)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ModeButton(
                        label: 'Study\nMode',
                        icon: Icons.school,
                        selected: studyMode,
                        onTap: () => setState(() => studyMode = true),
                      ),
                    ),
                    Expanded(
                      child: _ModeButton(
                        label: 'Practice\nMode',
                        icon: Icons.star,
                        selected: !studyMode,
                        badge: 'Competitive',
                        onTap: () => setState(() => studyMode = false),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No Signup Required for Preview',
                  style: TextStyle(color: Color(0xFF8DA1BD), fontSize: 12),
                ),
              ),
              const Divider(height: 28, color: Color(0xFFE7ECF2)),
              TabBar(
                controller: tabs,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: const Color(0xFF0758E8),
                unselectedLabelColor: const Color(0xFF4A5D77),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
                tabs: const [
                  Tab(text: 'Upload\nDocument'),
                  Tab(text: '🌐  Web\nURL'),
                  Tab(text: '―  Paste\nText'),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 278,
                child: TabBarView(
                  controller: tabs,
                  children: [
                    InkWell(
                      onTap: loading ? null : () => send('pdf'),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFB9D7FF),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x180F172A),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Color(0xFF1967F2),
                                  size: 34,
                                ),
                              ),
                            ),
                            SizedBox(height: 18),
                            Text(
                              'Upload your study file or\ndrag and drop it here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                fontWeight: FontWeight.w800,
                                color: ink,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Supports PDFs, Word\ndocuments, images, notes, and\nmore',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7185A1),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 41),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFB9D7FF),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: url,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                              hintText: 'Paste article URL...',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: loading ? null : () => send('url'),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text('Generate'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 41,
                        vertical: 31,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFB9D7FF),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: text,
                            minLines: 4,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText:
                                  'Paste lecture text, formulas, or\nsyllabus content directly...',
                              contentPadding: EdgeInsets.all(14),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: loading ? null : () => send('text'),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text('Generate'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (loading) const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    ],
  );
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badge,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: selected ? Border.all(color: const Color(0xFFDDE5EF)) : null,
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x140F172A),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 13,
            color: icon == Icons.star ? Colors.orange : blue,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF0758E8)
                  : const Color(0xFF41536E),
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Color(0xFFB95C00),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

const competitiveExams = <String, Map<String, dynamic>>{
  'ibps_po': {
    'name': 'IBPS PO',
    'subjects': [
      'Quantitative Aptitude',
      'Reasoning',
      'English Language',
      'Data and Main Topics',
      'Banking Core',
      'Banking Specific',
      'General Awareness',
    ],
  },
  'ibps_clerk': {
    'name': 'IBPS Clerk',
    'subjects': [
      'Quantitative Aptitude',
      'Reasoning',
      'English Language',
      'Banking Core',
      'General Awareness',
    ],
  },
  'sbi_po': {
    'name': 'SBI PO',
    'subjects': [
      'Quantitative Aptitude',
      'Reasoning',
      'English Language',
      'Data and Main Topics',
      'Banking Core',
      'Banking Specific',
      'General Awareness',
    ],
  },
  'sbi_clerk': {
    'name': 'SBI Clerk',
    'subjects': [
      'Quantitative Aptitude',
      'Reasoning',
      'English Language',
      'Banking Core',
      'General Awareness',
    ],
  },
  'rbi_grade_b': {
    'name': 'RBI Grade B',
    'subjects': [
      'Quantitative Aptitude',
      'Reasoning',
      'English Language',
      'General Awareness',
    ],
  },
  'ssc_cgl': {
    'name': 'SSC CGL',
    'subjects': [
      'Quantitative Aptitude',
      'Advanced Math',
      'Reasoning',
      'English Language',
      'General Awareness',
    ],
  },
  'ssc_chsl': {
    'name': 'SSC CHSL',
    'subjects': [
      'Quantitative Aptitude',
      'Advanced Math',
      'Reasoning',
      'English Language',
      'General Awareness',
    ],
  },
  'ssc_cpo': {
    'name': 'SSC CPO',
    'subjects': [
      'Quantitative Aptitude',
      'Advanced Math',
      'Reasoning',
      'English Language',
      'General Awareness',
    ],
  },
  'cat': {
    'name': 'CAT',
    'subjects': ['Quantitative Aptitude', 'English Language'],
  },
  'xat': {
    'name': 'XAT',
    'subjects': [
      'Quantitative Aptitude',
      'Reasoning',
      'English Language',
      'General Awareness',
    ],
  },
  'nmat': {
    'name': 'NMAT',
    'subjects': ['Quantitative Aptitude', 'Reasoning', 'English Language'],
  },
  'rrb_ntpc': {
    'name': 'RRB NTPC',
    'subjects': ['Quantitative Aptitude', 'Reasoning', 'General Awareness'],
  },
  'upsc_csat': {
    'name': 'UPSC CSAT',
    'subjects': ['Quantitative Aptitude', 'Reasoning', 'English Language'],
  },
  'gre': {
    'name': 'GRE General Test',
    'subjects': ['Quantitative Aptitude', 'Advanced Math', 'English Language'],
  },
  'gmat': {
    'name': 'GMAT Focus Edition',
    'subjects': ['Quantitative Aptitude', 'English Language'],
  },
  'sat': {
    'name': 'SAT',
    'subjects': ['Quantitative Aptitude', 'Advanced Math', 'English Language'],
  },
  'act': {
    'name': 'ACT',
    'subjects': ['Quantitative Aptitude', 'Advanced Math', 'English Language'],
  },
  'tcs_nqt': {
    'name': 'TCS NQT',
    'subjects': ['Quantitative Aptitude', 'Reasoning', 'English Language'],
  },
};

const competitiveSubjectIds = <String, String>{
  'Reasoning': '2494b854-3a5b-4ff7-b3da-edfc8d6341ff',
  'Quantitative Aptitude': '05b3d6bf-e3c5-4d1a-bf5a-59b273625b0a',
  'English Language': '3530c70b-e15a-4f4a-a74a-e7db9c3d511e',
  'Banking Core': '1548508d-3578-4eab-83a8-16cb9aba7f76',
  'Banking Specific': 'e611cb8d-cee4-4125-a0e5-784855eab0ae',
  'Advanced Math': 'db376785-3e0b-4ed7-931d-c0ce0d23ab32',
  'General Awareness': 'b73f02d5-0740-4dcd-ac87-8abe79690020',
  'Data and Main Topics': 'db1f29e4-dbb1-47ba-bae0-a2cbbe515f06',
  'Logical': 'bac373b1-32bb-48b1-8066-88a7319b43ae',
};

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeModePill extends StatelessWidget {
  const _PracticeModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x1A0F172A),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? ink : const Color(0xFF58708E),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _PracticeScreenState extends State<PracticeScreen> {
  bool competitive = true;
  final practiceSearch = TextEditingController();
  String? path,
      curriculum,
      level,
      subject,
      examKey,
      competitiveSubject,
      topicId;
  bool loadingTopics = false;
  List<Map<String, dynamic>> paths = [],
      curriculums = [],
      levels = [],
      subjects = [],
      chapters = [],
      topics = [];

  @override
  void initState() {
    super.initState();
    query('learning_paths').then((value) {
      if (mounted) setState(() => paths = value);
    });
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? key,
    String? value,
  }) async {
    dynamic request = Supabase.instance.client.from(table).select('id,name');
    if (key != null) request = request.eq(key, value!);
    return List<Map<String, dynamic>>.from(await request.order('name'));
  }

  Future<void> loadTopics(String subjectName) async {
    final subjectId = competitiveSubjectIds[subjectName];
    setState(() {
      competitiveSubject = subjectName;
      topicId = null;
      topics = [];
      loadingTopics = true;
    });
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/api/topics?subjectIds=$subjectId'),
      );
      if (response.statusCode != 200) throw Exception('Could not load topics');
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      if (mounted) {
        setState(
          () => topics = List<Map<String, dynamic>>.from(
            payload['topics'] ?? const [],
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => loadingTopics = false);
    }
  }

  DropdownButtonFormField<String> picker(
    String label,
    String? value,
    List<Map<String, dynamic>> data,
    ValueChanged<String?> changed,
  ) => DropdownButtonFormField(
    initialValue: value,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: data
        .map(
          (e) => DropdownMenuItem(
            value: '${e['id']}',
            child: Text('${e['name']}', overflow: TextOverflow.ellipsis),
          ),
        )
        .toList(),
    onChanged: changed,
  );

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(40, 62, 40, 28),
    children: [
      const Text(
        'What do you want to\npractice?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          height: 1.2,
          fontWeight: FontWeight.w900,
          color: ink,
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Choose your competitive target, filter topics, and\ngenerate targeted adaptive mock drills.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF58708E), fontSize: 12, height: 1.35),
      ),
      const SizedBox(height: 25),
      Center(
        child: Container(
          height: 38,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF3F8),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PracticeModePill(
                label: '🎯  Exam Prep',
                selected: competitive,
                onTap: () => setState(() {
                  competitive = true;
                  practiceSearch.clear();
                  examKey = competitiveSubject = topicId = null;
                  topics = [];
                }),
              ),
              _PracticeModePill(
                label: '🌐  Concept Practice',
                selected: !competitive,
                onTap: () => setState(() {
                  competitive = false;
                  practiceSearch.clear();
                  examKey = competitiveSubject = topicId = null;
                  topics = [];
                }),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
          side: const BorderSide(color: Color(0xFFDDE4EC)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 25, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SEARCH COMPETITIVE EXAM',
                style: TextStyle(
                  color: Color(0xFF8CA1C3),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .4,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: practiceSearch,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF3B82C4),
                    size: 19,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(9),
                    alignment: Alignment.center,
                    width: 31,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '⌘K',
                      style: TextStyle(color: Color(0xFF8DA1BD), fontSize: 11),
                    ),
                  ),
                  hintText: competitive
                      ? 'Search exams (e.g. IBPS PO)'
                      : 'Search subjects (e.g. Algebra)',
                  hintStyle: const TextStyle(
                    color: Color(0xFF93A1B5),
                    fontSize: 13,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              if (practiceSearch.text.isNotEmpty) ..._searchResults(),
              if (examKey != null || competitiveSubject != null) ...[
                const SizedBox(height: 15),
                _selectionContent(),
              ],
            ],
          ),
        ),
      ),
    ],
  );

  List<Widget> _searchResults() {
    final query = practiceSearch.text.toLowerCase();
    if (competitive) {
      return competitiveExams.entries
          .where(
            (entry) => '${entry.value['name']}'.toLowerCase().contains(query),
          )
          .take(6)
          .map(
            (entry) => ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 4),
              title: Text(
                '${entry.value['name']}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: const Icon(Icons.arrow_forward, size: 17, color: blue),
              onTap: () => setState(() {
                examKey = entry.key;
                competitiveSubject = topicId = null;
                topics = [];
                practiceSearch.clear();
              }),
            ),
          )
          .toList();
    }
    return competitiveSubjectIds.keys
        .where((name) => name.toLowerCase().contains(query))
        .take(8)
        .map(
          (name) => ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 4),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: const Icon(Icons.arrow_forward, size: 17, color: blue),
            onTap: () {
              practiceSearch.clear();
              loadTopics(name);
            },
          ),
        )
        .toList();
  }

  Widget _selectionContent() {
    if (!competitive && competitiveSubject != null) return _topicChooser();
    final selectedExam = examKey == null ? null : competitiveExams[examKey];
    final examSubjects = List<String>.from(
      selectedExam?['subjects'] ?? const [],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selectedExam != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${selectedExam['name']}',
              style: const TextStyle(color: blue, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),
          ...examSubjects.map(
            (name) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(_subjectIcon(name), size: 20, color: blue),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => loadTopics(name),
            ),
          ),
        ],
        if (competitiveSubject != null) _topicChooser(),
      ],
    );
  }

  Widget _topicChooser() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (loadingTopics)
        const Padding(
          padding: EdgeInsets.all(18),
          child: Center(child: CircularProgressIndicator()),
        ),
      if (!loadingTopics) ...[
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: topicId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Topic-wise practice'),
          items: topics
              .map(
                (topic) => DropdownMenuItem(
                  value: '${topic['id']}',
                  child: Text(
                    '${topic['name']}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => topicId = value),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: topicId == null
              ? null
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CompetitiveQuizScreen(
                      subjectName: competitiveSubject!,
                      subjectId: competitiveSubjectIds[competitiveSubject!]!,
                      topicId: topicId!,
                      topicName:
                          '${topics.firstWhere((topic) => '${topic['id']}' == topicId)['name']}',
                    ),
                  ),
                ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Start Practice'),
          ),
        ),
      ],
    ],
  );

  // Retained for the expanded selector variant.
  // ignore: unused_element
  Widget _competitiveContent() {
    final selectedExam = examKey == null ? null : competitiveExams[examKey];
    final examSubjects = List<String>.from(
      selectedExam?['subjects'] ?? const [],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: examKey,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Target exam'),
          items: competitiveExams.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text('${entry.value['name']}'),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() {
            examKey = value;
            competitiveSubject = null;
            topicId = null;
            topics = [];
          }),
        ),
        if (selectedExam != null) ...[
          const SizedBox(height: 18),
          const Text(
            'Choose a subject',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...examSubjects.map(
            (name) => Card(
              color: competitiveSubject == name
                  ? const Color(0xFFEFF6FF)
                  : Colors.white,
              child: ListTile(
                leading: Icon(_subjectIcon(name), color: blue),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: competitiveSubject == name
                    ? const Icon(Icons.check_circle, color: blue)
                    : const Icon(Icons.chevron_right),
                onTap: () => loadTopics(name),
              ),
            ),
          ),
        ],
        if (loadingTopics)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (competitiveSubject != null && !loadingTopics) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: topicId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Topic-wise practice'),
            items: topics
                .map(
                  (topic) => DropdownMenuItem(
                    value: '${topic['id']}',
                    child: Text(
                      '${topic['name']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => topicId = value),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: topicId == null
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompetitiveQuizScreen(
                        subjectName: competitiveSubject!,
                        subjectId: competitiveSubjectIds[competitiveSubject!]!,
                        topicId: topicId!,
                        topicName:
                            '${topics.firstWhere((topic) => '${topic['id']}' == topicId)['name']}',
                      ),
                    ),
                  ),
            icon: const Icon(Icons.play_arrow),
            label: const Padding(
              padding: EdgeInsets.all(14),
              child: Text('Start Practice'),
            ),
          ),
        ],
      ],
    );
  }

  // Retained for the academic curriculum variant.
  // ignore: unused_element
  Widget _schoolContent() => Column(
    children: [
      picker('Learning path', path, paths, (v) async {
        setState(() {
          path = v;
          curriculum = level = subject = null;
        });
        final rows = await query(
          'curriculums',
          key: 'learning_path_id',
          value: v,
        );
        if (mounted) setState(() => curriculums = rows);
      }),
      const SizedBox(height: 12),
      picker('Curriculum', curriculum, curriculums, (v) async {
        setState(() {
          curriculum = v;
          level = subject = null;
        });
        final rows = await query('levels', key: 'curriculum_id', value: v);
        if (mounted) setState(() => levels = rows);
      }),
      const SizedBox(height: 12),
      picker('Grade / level', level, levels, (v) async {
        setState(() {
          level = v;
          subject = null;
        });
        final rows = await query('subjects', key: 'grade_id', value: v);
        if (mounted) setState(() => subjects = rows);
      }),
      const SizedBox(height: 12),
      picker('Subject', subject, subjects, (v) async {
        setState(() => subject = v);
        final rows = await query('chapters', key: 'subject_id', value: v);
        if (mounted) setState(() => chapters = rows);
      }),
      const SizedBox(height: 18),
      ...chapters.map(
        (chapter) => Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.menu_book_outlined)),
            title: Text(
              '${chapter['name']}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    ],
  );

  IconData _subjectIcon(String name) {
    if (name.contains('Quant') ||
        name.contains('Math') ||
        name.contains('Data')) {
      return Icons.calculate_outlined;
    }
    if (name.contains('English')) return Icons.translate;
    if (name.contains('Awareness')) return Icons.public;
    if (name.contains('Banking')) return Icons.account_balance_outlined;
    return Icons.psychology_outlined;
  }
}

class CompetitiveQuizScreen extends StatefulWidget {
  const CompetitiveQuizScreen({
    required this.subjectName,
    required this.subjectId,
    this.topicId,
    this.topicIds = const [],
    this.guestTrial = false,
    required this.topicName,
    super.key,
  }) : assert(topicId != null || topicIds.length > 0);
  final String subjectName, subjectId, topicName;
  final String? topicId;
  final List<String> topicIds;
  final bool guestTrial;
  @override
  State<CompetitiveQuizScreen> createState() => _CompetitiveQuizScreenState();
}

class _CompetitiveQuizScreenState extends State<CompetitiveQuizScreen> {
  late Future<List<Map<String, dynamic>>> questions = _load();
  int index = 0, score = 0, answered = 0;
  String? selected;
  bool submitted = false;

  Future<List<Map<String, dynamic>>> _load() async {
    final signedIn =
        AppConfig.isConfigured &&
        Supabase.instance.client.auth.currentSession != null;
    if (!widget.guestTrial && !signedIn) {
      throw StateError('Please log in to start this practice.');
    }
    final requestedTopics = widget.topicIds.isNotEmpty
        ? widget.topicIds
        : [widget.topicId!];
    final selectedTopics = widget.guestTrial
        ? requestedTopics.take(1).toList()
        : requestedTopics;
    final rows = await Supabase.instance.client
        .from('master_questions')
        .select(
          'id,question,options,correct_answer,explanation,difficulty,directions,question_type,statement_1,statement_2,source,source_year,is_pyq',
        )
        .inFilter('topic_id', selectedTopics)
        .limit(10);
    return List<Map<String, dynamic>>.from(rows);
  }

  void _submit(Map<String, dynamic> question) {
    if (selected == null || submitted) return;
    final correct =
        '$selected'.trim().toUpperCase() ==
        '${question['correct_answer']}'.trim().toUpperCase();
    setState(() {
      submitted = true;
      answered++;
      if (correct) score++;
    });
    if (!widget.guestTrial) {
      unawaited(
        _PracticeProgress.record(
          subject: widget.subjectName,
          topic: widget.topicName,
          isCorrect: correct,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.topicName),
      backgroundColor: Colors.white,
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: questions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ErrorCard(
                message: 'Unable to load questions. ${snapshot.error}',
              ),
            ),
          );
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(
            child: Text('No questions are available for this topic yet.'),
          );
        }
        if (index >= items.length) return _results(items.length);
        final question = items[index];
        final rawOptions = question['options'];
        final options = rawOptions is Map
            ? Map<String, dynamic>.from(rawOptions)
            : <String, dynamic>{};
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Text(
                  '${widget.subjectName} • ${index + 1}/${items.length}',
                  style: const TextStyle(
                    color: muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Chip(label: Text('${question['difficulty'] ?? 'Medium'}')),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (index + 1) / items.length),
            if (question['directions'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Text(
                  '${question['directions']}',
                  style: const TextStyle(
                    color: muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              '${question['question']}',
              style: const TextStyle(
                fontSize: 21,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (question['statement_1'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text('I. ${question['statement_1']}'),
              ),
            if (question['statement_2'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('II. ${question['statement_2']}'),
              ),
            const SizedBox(height: 20),
            ...options.entries.map((option) {
              final key = option.key.toUpperCase();
              final correctKey = '${question['correct_answer']}'.toUpperCase();
              Color? color;
              if (submitted && key == correctKey) {
                color = const Color(0xFFDCFCE7);
              }
              if (submitted &&
                  key == selected?.toUpperCase() &&
                  key != correctKey) {
                color = const Color(0xFFFFE4E6);
              }
              final isSelected = selected == key;
              return Card(
                color: color,
                child: ListTile(
                  onTap: submitted
                      ? null
                      : () => setState(() => selected = key),
                  leading: CircleAvatar(child: Text(key)),
                  title: Text('${option.value}'),
                  trailing: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected ? blue : muted,
                  ),
                ),
              );
            }),
            if (submitted && question['explanation'] != null)
              Card(
                color: const Color(0xFFEFF6FF),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${question['explanation']}'),
                ),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: selected == null
                  ? null
                  : submitted
                  ? () => setState(() {
                      index++;
                      selected = null;
                      submitted = false;
                    })
                  : () => _submit(question),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  submitted
                      ? (index == items.length - 1
                            ? 'See Results'
                            : 'Next Question')
                      : 'Check Answer',
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  Widget _results(int total) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              const Text(
                'Practice complete',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                '$score / $total correct',
                style: const TextStyle(
                  fontSize: 20,
                  color: blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(score / total * 100).round()}% accuracy • $answered answered',
                style: const TextStyle(color: muted),
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Choose another topic'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final nameController = TextEditingController(text: 'PrepExami Student');
  final emailController = TextEditingController(text: 'student@example.com');
  String savedName = 'PrepExami Student';
  String savedEmail = 'student@example.com';
  bool saving = false;

  @override
  void initState() {
    super.initState();
    if (!AppConfig.isConfigured) return;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final accountName = '${metadata['full_name'] ?? metadata['name'] ?? ''}'
        .trim();
    final accountEmail = (user.email ?? '').trim();
    if (accountName.isNotEmpty) {
      savedName = accountName;
      nameController.text = accountName;
    }
    if (accountEmail.isNotEmpty) {
      savedEmail = accountEmail;
      emailController.text = accountEmail;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    if (name.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid name and email address.')),
      );
      return;
    }
    setState(() => saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() {
      savedName = name;
      savedEmail = email;
      saving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account changes saved on this device.')),
    );
  }

  Future<void> _showUpgrade() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Upgrade to Pro'),
        content: const Text(
          'Plan checkout will be connected here. No payment will be made from this preview.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      if (AppConfig.isConfigured) {
        await Supabase.instance.client.auth
            .signOut(scope: SignOutScope.local)
            .timeout(const Duration(seconds: 5));
      }
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not sign out. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAF8FF),
    body: SafeArea(
      child: Column(
        children: [
          Container(
            height: 51,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF0EDF5))),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 21),
                ),
                const Expanded(
                  child: Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Color(0xFF20263A),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF0649C9),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 7),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 22),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EDFF),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text(
                      '⚙ PREFERENCES & SECURITY',
                      style: TextStyle(
                        color: Color(0xFF2852BE),
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Manage your profile, active subscription, and account\nauthentication.',
                  style: TextStyle(
                    color: Color(0xFF33415F),
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF0EDF5)),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E9FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              savedName.isEmpty
                                  ? 'S'
                                  : savedName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF0649C9),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        savedName.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF071631),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.verified,
                                      color: Color(0xFF009B72),
                                      size: 14,
                                    ),
                                  ],
                                ),
                                Text(
                                  savedEmail,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF50607B),
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Text(
                            'Full Name',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Candidate ID #PX0000',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF64708A),
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(isDense: true),
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(height: 11),
                      const Row(
                        children: [
                          Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '◉ Primary',
                            style: TextStyle(
                              color: Color(0xFF008A64),
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(isDense: true),
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: saving ? null : _save,
                        icon: saving
                            ? const SizedBox(
                                width: 13,
                                height: 13,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check, size: 14),
                        label: Text(saving ? 'Saving...' : 'Save Changes'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2454DC),
                          textStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: Color(0xFF0751D1),
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Security',
                            style: TextStyle(
                              color: Color(0xFF071631),
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDF8ED),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '● Secured',
                              style: TextStyle(
                                color: Color(0xFF008A64),
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Your authentication is securely handled by Google Identity Services.',
                        style: TextStyle(
                          color: Color(0xFF4B5872),
                          fontSize: 9,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4FF),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xFF4285F4),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    savedEmail,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Text(
                                    'SSO  Single Sign-On Active',
                                    style: TextStyle(
                                      color: Color(0xFF4D5A75),
                                      fontSize: 7,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF65708A),
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 17),
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  '● FREE TIER ACTIVE',
                                  style: TextStyle(
                                    color: Color(0xFF9A6500),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '0/10 Mocks Used',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Upgrade Plan ⚡',
                              style: TextStyle(
                                color: Color(0xFF15203A),
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Unlock full-length sectional mocks, AI error log diagnostics, and rank benchmarking.',
                              style: TextStyle(
                                color: Color(0xFF46536D),
                                fontSize: 9,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 9),
                            const Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                _PlanChip('✓ Unlimited Mocks'),
                                _PlanChip('✓ Speed Diagnostics'),
                                _PlanChip('✓ State PSC + SSC'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: _showUpgrade,
                                icon: const Icon(
                                  Icons.workspace_premium_outlined,
                                ),
                                label: const Text('Upgrade to Pro'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Session Control',
                        style: TextStyle(
                          color: Color(0xFF17213A),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Sign out of this test device',
                        style: TextStyle(color: Color(0xFF58657D), fontSize: 9),
                      ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout, size: 15),
                        label: const Text('Sign Out'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC71F25),
                          textStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _PlanChip extends StatelessWidget {
  const _PlanChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(label, style: const TextStyle(fontSize: 7.5)),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Profile',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    child: Icon(Icons.person, size: 34),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.email ?? 'PrepExami learner',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manage your study account',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.workspace_premium_outlined),
                  title: Text('Current plan'),
                  trailing: Text('Free'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Sign out'),
                  onTap: () => Supabase.instance.client.auth.signOut(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  const ErrorCard({required this.message, super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Card(
    color: const Color(0xFFFFF1F2),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(message, style: const TextStyle(color: Colors.red)),
    ),
  );
}
