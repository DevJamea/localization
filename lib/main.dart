import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localization/map_provider.dart';
import 'package:localization/maps.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapsProvider>(
      create: (context) => MapsProvider(),
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Consumer<MapsProvider>(builder: (context, provider, widget) {
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    provider.moveToUserPosition();
                  },
                ),
              ),
              body: MapsScreen());
        }),
        // home: Scaffold(
        //   appBar: AppBar(
        //     centerTitle: true,
        //     title: const Text('app_name').tr(),
        //     actions: [
        //       Switch(value: context.locale == const Locale('ar'), onChanged: (value) {
        //         value ? context.setLocale(const Locale('ar')) : context.setLocale(const Locale('en')) ;
        //       },)
        //     ],
        //     leading: IconButton(icon: const Icon(Icons.map) , onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) {
        //         return MapsScreen();
        //       },));
        //     },),
        //   ),
        //   body: Column(
        //     children: [
        //       const SizedBox(height: 10,),
        //       RowWidget('user_name' , 'name'),
        //       const SizedBox(height: 10,),
        //       RowWidget('program_name' , 'program'),
        //       const SizedBox(height: 10,),
        //       RowWidget('company_name' , 'company'),
        //     ],
        //   ),
        //   ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  String text1, text2;
  RowWidget(this.text1, this.text2, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(text1).tr(), Spacer(), Text(text2).tr()],
    );
  }
}
