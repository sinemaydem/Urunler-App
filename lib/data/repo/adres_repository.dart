import 'package:bitirme/data/entity/adres.dart';
import 'package:bitirme/sqlite/veritabani_yardimcisi.dart';
import 'package:sqflite/sqflite.dart';


class AdresRepository {

  Future<List<Adres>> getAllAddresses() async {
    final db = await VeritabaniYardimcisi.veritabaniErisim();
    final List<Map<String, dynamic>> maps = await db.query('adres');
    return maps.map((map) => Adres.fromJson(map)).toList();
  }

  //Adres Ekle
  Future<void> addAddress(Adres address) async {
    final db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.insert(
      'adres',
      address.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Adres güncelle
  Future<void> updateAddress(Adres address) async {
    final db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.update(
      'adres',
      address.toJson(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  //Adres sil
  Future<void> deleteAddress(int id) async {
    final db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete(
      'adres',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
