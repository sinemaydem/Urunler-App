import 'package:bitirme/data/repo/urunler_dao_repository.dart';
import 'package:bitirme/ui/cubit/anasayfa_cubit.dart';
import 'package:bitirme/ui/cubit/sepet_cubit.dart';
import 'package:bitirme/ui/views/anasayfa.dart';
import 'package:bitirme/ui/views/detay_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnasayfaCubit(UrunlerDaoRepository())),
        BlocProvider(create: (context) => SepetCubit(UrunlerDaoRepository(), 'sinem')),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Anasayfa(),
      ),
    );
  }
}