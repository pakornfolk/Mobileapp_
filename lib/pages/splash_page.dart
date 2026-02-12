import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
      'assets/videos/Intro_2.mp4',
    )
      ..initialize().then((_) {
        _videoController.setVolume(0); // ปิดเสียงวิดิโอ
        setState(() {});
        _videoController.play();
      });
    /// 🎨 ใช้สำหรับ fade 
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        Tween<double>(begin: 1, end: 0).animate(_fadeController);
    _fadeController.forward();

    _videoController.addListener(() async {
      if (!_isNavigated &&
          _videoController.value.position >=
              _videoController.value.duration) {

        _isNavigated = true;

        await _fadeController.reverse();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => const LoginPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _videoController.value.isInitialized
          ? Stack(
              children: [

                /// 🎬 วิดีโอเต็มจอ
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                ),
                
                /// 🎨 fade ดำตอนจบ
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(color: const Color.fromARGB(255, 0, 74, 173)),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
