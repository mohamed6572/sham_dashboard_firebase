import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham/Layout/cubit/home_cubit.dart';
import 'package:sham/admin/cubit/post_cubit.dart';
import 'package:sham/admin/widget/admin_layout.dart';
import 'package:sham/admin/widget/login.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Layout/home_Layout.dart';
import 'core/services/custom_bloc_observer.dart';
import 'firebase_options.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // MobileAds.instance.initialize();
  Bloc.observer = CustomBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => PostCubit()),
      ],
      child: MaterialApp(
        title: 'لوحة التحكم شبكة صحم',
        debugShowCheckedModeBanner: false,
        home:FirebaseAuth.instance.currentUser!=null?AdminLayout(): LoginScreen(),
       //  home: Directionality(
       //    textDirection: TextDirection.rtl,
       //    child: MyHomePage(),
       //  ),


      ),
    );
  }
}
