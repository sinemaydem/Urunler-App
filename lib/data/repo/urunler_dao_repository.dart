import 'dart:convert';
import 'package:bitirme/data/entity/urunler_sepeti.dart';
import 'package:dio/dio.dart';
import 'package:bitirme/data/entity/urunler.dart';
import 'package:http/http.dart' as http;

class UrunlerDaoRepository {
  final String baseUrl = 'http://kasimadalan.pe.hu/urunler';
  final Dio dio = Dio();
  static const String kullaniciAdi = 'sinem';



  // Tüm ürünleri getir
  Future<List<Urunler>> tumUrunleriGetir() async {
    final response = await http.get(Uri.parse('$baseUrl/tumUrunleriGetir.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == 1 && data['urunler'] != null) {
        final List<dynamic> urunler = data['urunler'];
        return urunler.map((json) => Urunler.fromJson(json)).toList();
      }
      return [];
    }
    throw Exception('Ürünleri getirirken hata oluştu.');
  }


  // Sepete ürün ekle
  Future<void> sepeteUrunEkle(UrunlerSepeti item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sepeteUrunEkle.php'),
      body: {
        'ad': item.ad,
        'resim': item.resim,
        'kategori': item.kategori,
        'fiyat': item.fiyat.toString(),
        'marka': item.marka,
        'siparisAdeti': item.siparisAdeti.toString(),
        'kullaniciAdi': item.kullaniciAdi,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] != 1) {
        throw Exception('Sepete ürün eklerken hata: ${data['message']}');
      }
    } else {
      throw Exception('Sepete ürün eklerken hata: ${response.statusCode}');
    }
  }


  // Sepetteki ürünleri getir
  Future<List<UrunlerSepeti>> sepettekiUrunleriGetir(String kullaniciAdi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sepettekiUrunleriGetir.php'),
      body: {
        'kullaniciAdi': kullaniciAdi,
      },
    );

    if (response.statusCode == 200) {
      print("Sepetteki Ürünler API Yanıtı: ${response.body}");
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == 0) {
        throw Exception(jsonResponse['message']);
      }

      return (jsonResponse['urunler_sepeti'] as List)
          .map((urun) => UrunlerSepeti.fromJson(urun))
          .toList();
    } else {
      throw Exception('Ürünleri alırken hata: ${response.statusCode}');
    }
  }


  // Sepetten ürün sil
  Future<void> sepettenUrunSil(int sepetId, String kullaniciAdi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sepettenUrunSil.php'),
      body: {
        'sepetId': sepetId.toString(),
        'kullaniciAdi': kullaniciAdi,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] != 1) {
        throw Exception('Sepetten ürün silinirken hata oluştu: ${data['message']}');
      }
    } else {
      throw Exception('Sepetten ürün silinirken hata oluştu: ${response.statusCode}');
    }
  }
}
