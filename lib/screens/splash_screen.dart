import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'signup_page.dart';

// ─── Entry Point ──────────────────────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const CircularJOSplashApp());
}

// ─── App Root ─────────────────────────────────────────────────────────────────
class CircularJOSplashApp extends StatelessWidget {
  const CircularJOSplashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Circular JO',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── Splash Screen ────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Video
  late VideoPlayerController _videoController;
  bool _videoReady = false;

  // Text animation controllers (staggered reveals)
  late AnimationController _titleController;
  late AnimationController _taglineController;
  late AnimationController _subtitleController;
  late AnimationController _dotsController;
  late AnimationController _exitController;

  // Animations
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _dotsOpacity;
  late Animation<double> _exitFade;

  // Timers
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupVideo();
    _scheduleSequence();
  }

  // ─── Animation Setup ─────────────────────────────────────────────────────
  void _setupAnimations() {
    // Title: "Circular JO"
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFade = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutCubic,
    ));

    // Tagline: "Recover • Redistribute • Regenerate"
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineFade = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOutCubic,
    ));

    // Subtitle: "Turning surplus into verified impact"
    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _subtitleFade = CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeOut,
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeOutCubic,
    ));

    // Animated dots
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _dotsOpacity = CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeIn,
    );

    // Exit fade-out
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );
  }

  // ─── Video Setup ──────────────────────────────────────────────────────────
  void _setupVideo() {
    _videoController = VideoPlayerController.asset(
      'assets/videos/circular_symbol.mp4',
    )..initialize().then((_) {
      if (mounted) {
        setState(() => _videoReady = true);
        _videoController.setLooping(false);
        _videoController.setVolume(0);
        _videoController.play();
      }
    }).catchError((_) {
      // If asset not found, still show the screen gracefully
      if (mounted) setState(() => _videoReady = false);
    });
  }

  // ─── Animation Sequence (total ~6 seconds) ────────────────────────────────
  void _scheduleSequence() {
    // t=0ms   : Video starts playing
    // t=1400ms: Title fades in
    // t=2000ms: Tagline fades in
    // t=2600ms: Subtitle fades in
    // t=3200ms: Dots appear
    // t=5500ms: Begin exit fade
    // t=6000ms: Navigate away

    _timers.add(Timer(const Duration(milliseconds: 1400), () {
      if (mounted) _titleController.forward();
    }));

    _timers.add(Timer(const Duration(milliseconds: 2000), () {
      if (mounted) _taglineController.forward();
    }));

    _timers.add(Timer(const Duration(milliseconds: 2600), () {
      if (mounted) _subtitleController.forward();
    }));

    _timers.add(Timer(const Duration(milliseconds: 3200), () {
      if (mounted) _dotsController.forward();
    }));

    _timers.add(Timer(const Duration(milliseconds: 5500), () {
      if (mounted) _exitController.forward();
    }));

    _timers.add(Timer(const Duration(milliseconds: 6000), () {
      if (mounted) _navigateToSignup();
    }));
  }

  void _navigateToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const SignUpPage(),
      ),
    );
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _videoController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    _subtitleController.dispose();
    _dotsController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _exitFade,
      builder: (_, child) => Opacity(
        opacity: _exitFade.value,
        child: child,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF00502E), // deep forest green
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background radial gradient ──────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.15),
                  radius: 1.1,
                  colors: [
                    Color(0xFF006B3C), // lighter center
                    Color(0xFF003D22), // deep edges
                  ],
                ),
              ),
            ),

            // ── Decorative rings ────────────────────────────────────────
            const Positioned.fill(child: _DecorativeRings()),

            // ── Main content ────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // Logo area — upper 58% of screen
                  Expanded(
                    flex: 58,
                    child: Center(
                      child: _buildLogoArea(),
                    ),
                  ),

                  // Text area — lower 42% of screen
                  Expanded(
                    flex: 42,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // "Circular JO"
                          FadeTransition(
                            opacity: _titleFade,
                            child: SlideTransition(
                              position: _titleSlide,
                              child: const Text(
                                'Circular JO',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // "Recover • Redistribute • Regenerate"
                          FadeTransition(
                            opacity: _taglineFade,
                            child: SlideTransition(
                              position: _taglineSlide,
                              child: _buildTagline(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Divider line
                          FadeTransition(
                            opacity: _subtitleFade,
                            child: Container(
                              height: 1,
                              width: 48,
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // "Turning surplus into verified impact"
                          FadeTransition(
                            opacity: _subtitleFade,
                            child: SlideTransition(
                              position: _subtitleSlide,
                              child: Text(
                                'Turning surplus into verified impact',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.65),
                                  letterSpacing: 0.1,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Loading dots
                          FadeTransition(
                            opacity: _dotsOpacity,
                            child: const _PulsingDots(),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
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

  // ─── Logo Area ─────────────────────────────────────────────────────────────
  Widget _buildLogoArea() {
    return SizedBox(
      width: 240,
      height: 240,
      child: _videoReady && _videoController.value.isInitialized
          ? ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
      )
          : _buildStaticLogoFallback(),
    );
  }

  Widget _buildStaticLogoFallback() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.eco_rounded,
          size: 80,
          color: const Color(0xFF9BEFE0).withOpacity(0.9),
        ),
      ),
    );
  }

  // ─── Tagline with dots ─────────────────────────────────────────────────────
  Widget _buildTagline() {
    const items = ['Recover', 'Redistribute', 'Regenerate'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(items.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Dot separator
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9BEFE0).withOpacity(0.6),
              ),
            ),
          );
        }
        final word = items[i ~/ 2];
        return Text(
          word,
          style: const TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9BEFE0),
            letterSpacing: 0.5,
          ),
        );
      }),
    );
  }
}

// ─── Decorative Rings Painter ─────────────────────────────────────────────────
class _DecorativeRings extends StatelessWidget {
  const _DecorativeRings();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RingsPainter());
  }
}

class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height * 0.38;

    final radii = [160.0, 230.0, 310.0, 400.0];
    final opacities = [0.12, 0.08, 0.05, 0.03];

    for (int i = 0; i < radii.length; i++) {
      paint.color = Colors.white.withOpacity(opacities[i]);
      canvas.drawCircle(Offset(cx, cy), radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Pulsing Loading Dots ─────────────────────────────────────────────────────
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      );
      final anim = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
      _controllers.add(ctrl);
      _animations.add(anim);

      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(_animations[i].value),
            ),
          ),
        );
      }),
    );
  }
}