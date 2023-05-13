import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/lottie.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:iconforest_iconoir/iconoir.dart';
import 'main.dart';

//소리 설정 페이지
class SoundsetPage extends StatefulWidget {
  const SoundsetPage({Key? key}) : super(key: key);

  @override
  State<SoundsetPage> createState() => _SoundsetPageState();
}

class _SoundsetPageState extends State<SoundsetPage>
    with TickerProviderStateMixin {
  FlutterTts flutterTts = FlutterTts();
  double volume = 0.5;
  double rate = 1.0;
  late AnimationController _volumedownController;
  late AnimationController _volumeupController;
  late AnimationController _speeddownController;
  late AnimationController _speedupController;

  @override
  void initState() {
    super.initState();

    getVolumeFromPrefs();
    getSpeechRateFromPrefs();

    _volumedownController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _volumeupController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _speeddownController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _speedupController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    saveVolumeToPrefs(); // 앱이 종료될 때 현재 소리 크기를 저장합니다.
    saveSpeechRateToPrefs();

    _volumedownController.dispose();
    _volumeupController.dispose();
    _speeddownController.dispose();
    _speedupController.dispose();

    super.dispose();
  }

  void getVolumeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedVolume =
        prefs.getDouble('volume') ?? 0.5; // 이전에 저장된 소리 크기가 없으면 초기값 0.5을 사용합니다.
    setState(() {
      volume = savedVolume;
      flutterTts.setVolume(volume); // 가져온 소리 크기를 적용합니다.
    });
  }

  void getSpeechRateFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedRate =
        prefs.getDouble('rate') ?? 1.0; // 이전에 저장된 소리 크기가 없으면 초기값 1.0을 사용합니다.
    setState(() {
      rate = savedRate;
      flutterTts.setSpeechRate(rate); // 가져온 소리 크기를 적용합니다.
    });
  }

  void saveVolumeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('volume', volume); // 현재 소리 크기를 저장합니다.
  }

  void saveSpeechRateToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('rate', rate); // 현재 소리 크기를 저장합니다.
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: MyApp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo4.png',
                      height: 50,
                    ),
                    const SizedBox(width: 20), // 이미지와 텍스트 사이 간격
                    const Text(
                      'CURE EYE',
                    ),
                  ],
                ),
                centerTitle: true,
                // backgroundColor: null,
              ),
              body: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                    width: 5.0,
                  ),
                ),
                child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 40,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                    padding: const EdgeInsets.only(
                        bottom: 0, left: 15, top: 100, right: 15),
                    children: [
                      InkWell(
                        onTap: () async {
                          if (MyApp.themeNotifier.value == ThemeMode.light) {
                            await flutterTts.speak('소리 낮추기');
                            _volumedownController.reset();
                            _volumedownController.forward();
                          } else {
                            await flutterTts.speak('소리 낮추기');
                          }
                        },
                        onDoubleTap: () {
                          if (volume > 0.1) {
                            setState(() {
                              volume -= 0.1;
                              flutterTts.setVolume(volume);
                            });
                          }
                        },
                        // highlightColor: Colors.blue,
                        hoverColor: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyApp.themeNotifier.value ==
                                          ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  width: 4.0),
                              borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.all(5.0),
                          child: MyApp.themeNotifier.value == ThemeMode.light
                              ? Transform.scale(
                                  scale: 1,
                                  child: Lottie.asset(Icons8.volume_1,
                                      controller: _volumedownController))
                              : Transform.scale(
                                  scale: 0.5,
                                  child: const Iconoir(Iconoir.sound_low,
                                      color: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (MyApp.themeNotifier.value == ThemeMode.light) {
                            await flutterTts.speak('소리 높이기');
                            _volumeupController.reset();
                            _volumeupController.forward();
                          } else {
                            await flutterTts.speak('소리 높이기');
                          }
                        },
                        onDoubleTap: () {
                          if (volume < 1.0) {
                            setState(() {
                              volume += 0.1;
                              flutterTts.setVolume(volume);
                            });
                          }
                        },
                        // highlightColor: Colors.blue,
                        hoverColor: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyApp.themeNotifier.value ==
                                          ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  width: 4.0),
                              borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.all(5.0),
                          child: MyApp.themeNotifier.value == ThemeMode.light
                              ? Transform.scale(
                                  scale: 1,
                                  child: Lottie.asset(Icons8.volume_2,
                                      controller: _volumeupController))
                              : Transform.scale(
                                  scale: 0.5,
                                  child: const Iconoir(Iconoir.sound_high,
                                      color: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (MyApp.themeNotifier.value == ThemeMode.light) {
                            await flutterTts.speak('속도 낮추기');
                            _speeddownController.reset();
                            _speeddownController.forward();
                          } else {
                            await flutterTts.speak('속도 낮추기');
                          }
                        },
                        onDoubleTap: () {
                          if (rate > 0.1) {
                            setState(() {
                              rate -= 0.1;
                              flutterTts.setSpeechRate(rate);
                            });
                          }
                        },
                        // highlightColor: Colors.blue,
                        hoverColor: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyApp.themeNotifier.value ==
                                          ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  width: 4.0),
                              borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.all(5.0),
                          child: MyApp.themeNotifier.value == ThemeMode.light
                              ? Transform.scale(
                                  scale: 1,
                                  child: Lottie.asset(Icons8.skip_backwards,
                                      controller: _speeddownController))
                              : const Icon(BootstrapIcons.skip_backward,
                                  size: 60),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (MyApp.themeNotifier.value == ThemeMode.light) {
                            await flutterTts.speak('속도 높이기');
                            _speedupController.reset();
                            _speedupController.forward();
                          } else {
                            await flutterTts.speak('속도 높이기');
                          }
                        },
                        onDoubleTap: () {
                          if (rate < 2.0) {
                            setState(() {
                              rate += 0.1;
                              flutterTts.setSpeechRate(rate);
                            });
                          }
                        },
                        // highlightColor: Colors.blue,
                        hoverColor: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyApp.themeNotifier.value ==
                                          ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  width: 4.0),
                              borderRadius: BorderRadius.circular(100)),
                          padding: const EdgeInsets.all(5.0),
                          child: MyApp.themeNotifier.value == ThemeMode.light
                              ? Transform.scale(
                                  scale: 1,
                                  child: Lottie.asset(Icons8.skip_forwards,
                                      controller: _speedupController))
                              : const Icon(BootstrapIcons.skip_forward,
                                  size: 60),
                        ),
                      ),
                    ]),
              ));
        });
  }
}