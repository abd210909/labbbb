import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/post_provider.dart';
import 'screens/flow_picker_screen.dart';

/// Flip to true when students connect a real Firebase project.
/// Firebase code below is kept — this APK just does not run it.
const bool kEnableFirebase = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kept for teaching — skipped so the student APK runs without Firebase.
  if (kEnableFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F6E56),
      brightness: Brightness.light,
    );

    return ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: MaterialApp(
        title: 'Posts App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: base,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F8F6),
          appBarTheme: AppBarTheme(
            centerTitle: false,
            backgroundColor: const Color(0xFFF7F8F6),
            foregroundColor: base.onSurface,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            titleTextStyle: TextStyle(
              color: base.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: base.primary,
            foregroundColor: base.onPrimary,
            elevation: 2,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: base.outlineVariant),
            ),
          ),
          listTileTheme: const ListTileThemeData(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const FlowPickerScreen(),
      ),
    );
  }
}
