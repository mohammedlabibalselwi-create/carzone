import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// تأكد من عمل استدعاء (import) لجميع الشاشات
import 'auth/otp_screen.dart';
import 'auth/reset_password_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/unified_login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'providers/settings_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CarZone',

            // الثيم يعمل الآن بأمان
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isLoaded ? settings.themeMode : ThemeMode.system,

            locale: settings.isLoaded ? settings.locale : const Locale('ar'),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // الشاشة الافتراضية صفحة الهوم بيج
            home: settings.isLoaded
                ? const MainNavigationScreen()
                : const Scaffold(body: Center(child: CircularProgressIndicator())),

            routes: {
              '/home': (_) => const MainNavigationScreen(),
              '/login': (_) => const UnifiedLoginScreen(),
              '/signup': (_) => const SignupScreen(),
            },
            onGenerateRoute: (settingsRoute) {
              // استقبال البيانات بشكل آمن لمنع الانهيار
              final args = settingsRoute.arguments as Map?;

              switch (settingsRoute.name) {
                case '/otp':
                  return MaterialPageRoute(
                    builder: (_) => OtpScreen(
                      identifier: args?['identifier']?.toString() ?? '',
                      method: args?['method']?.toString() ?? 'phone',
                    ),
                  );
                case '/reset-password':
                  return MaterialPageRoute(
                    builder: (_) => ResetPasswordScreen(
                      identifier: args?['identifier']?.toString() ?? '',
                      method: args?['method']?.toString() ?? 'phone',
                    ),
                  );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'auth/otp_screen.dart';
import 'auth/reset_password_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/unified_login_screen.dart';
import 'providers/settings_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          if (!settings.isLoaded) {
            // Splash while loading saved preferences.
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CarZone',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/login',
            routes: {
              '/login': (_) => const UnifiedLoginScreen(),
              '/signup': (_) => const SignupScreen(),
            },
            onGenerateRoute: (settingsRoute) {
              final args = settingsRoute.arguments;
              switch (settingsRoute.name) {
                case '/otp':
                  if (args is Map<String, dynamic>) {
                    return MaterialPageRoute(
                      builder: (_) => OtpScreen(
                        identifier: args['identifier'] ?? '',
                        method: args['method'] ?? 'phone',
                      ),
                    );
                  }
                  break;
                case '/reset-password':
                  if (args is Map<String, dynamic>) {
                    return MaterialPageRoute(
                      builder: (_) => ResetPasswordScreen(
                        identifier: args['identifier'] ?? '',
                        method: args['method'] ?? 'phone',
                      ),
                    );
                  }
                  break;
              }
              // Fallback: go to login if route/args invalid.
              return MaterialPageRoute(
                builder: (_) => const UnifiedLoginScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

 */