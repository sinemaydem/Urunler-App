import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeritabaniYardimcisi {
  static final String veritabaniAdi = "adresler.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(),veritabaniAdi);

    if(await databaseExists(veritabaniYolu)){
      print("veritabanı durum: veritabanı var, kopyalamaya gerek yok.");

    }else{

      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");

      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes,flush: true);
      print("veritabanı durum: veritabanı yok, kopyalandı.");

    }

    return openDatabase(veritabaniYolu);
  }
}