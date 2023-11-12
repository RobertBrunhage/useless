import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:useless/generated/l10n.dart';
import 'package:useless/onboarding/onboarding_page.dart';
import 'package:useless/ui_library/styles.dart';

void main() {
  runApp(const AppInitializer());
}

sealed class AppLoadingState {}

class AppLoading extends AppLoadingState {}

class AppSuccessfulLoading extends AppLoadingState {}

class AppFailedLoading extends AppLoadingState {}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  ValueNotifier<AppLoadingState> loadingState = ValueNotifier(AppLoading());

  @override
  void initState() {
    super.initState();
    unawaited(bootstrap());
  }

  Future<void> bootstrap() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (!kReleaseMode) {
        debugPrint(
          '${record.level.name} : ${record.loggerName} : ${record.message}',
        );
      }
    });

    try {
      loadingState.value = AppSuccessfulLoading();
    } catch (e) {
      loadingState.value = AppFailedLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loadingState,
      builder: (context, state, child) {
        return switch (state) {
          AppLoading() => const ThemedApp(
              home: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          AppFailedLoading() => ThemedApp(
              home: Center(
                child: Text(S.of(context).failedToLoad),
              ),
            ),
          AppSuccessfulLoading() => ThemedApp(
              home: OnboardingPage(),
            ),
        };
      },
    );
  }
}

class ThemedApp extends StatelessWidget {
  const ThemedApp({
    super.key,
    required this.home,
  });

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Styles$Colors.white100,
          surface: Colors.black,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Styles$Colors.black100,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            iconColor: MaterialStateProperty.all(Styles$Colors.grey600),
          ),
        ),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
