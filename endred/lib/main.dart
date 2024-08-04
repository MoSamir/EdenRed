import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feature/beneficiary_home/di/beneficiaries_provider.dart';
import 'feature/beneficiary_home/presentation/ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const EdenredApp()));
}

class EdenredApp extends StatelessWidget {
  const EdenredApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        title: 'Edenred App',
        home: BlocProvider(
          create: (context) => initBeneficiaryBloc(),
          child: const HomeScreen(),
        ));
  }
}

bool localSourceOnly = true;
