import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pedal_rpm/model/model.dart';
import 'package:pedal_rpm/models/bike_selector_model.dart';
import 'package:pedal_rpm/models/manager.dart';
import 'package:pedal_rpm/views/bike_selector.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Wakelock.enable();

  BikeSelectorModel bikeSelectorModel =
      BikeSelectorModel(await Bike().select().toList());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Manager(),
        ),
        ChangeNotifierProvider(
          create: (context) => bikeSelectorModel,
        ),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale("ar")],
        fallbackLocale: Locale("ar"),
        startLocale: Locale("ar"),
        path: 'assets/translations',
        child: App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        accentColor: Colors.amber,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.grey[600],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: BikeSelector(),
    );
  }
}
