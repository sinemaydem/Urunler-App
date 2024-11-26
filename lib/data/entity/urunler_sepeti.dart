
class UrunlerSepeti {
  final int sepetId;
  final String ad;
  final String resim;
  final String kategori;
  final int fiyat;
  final String marka;
  int siparisAdeti;
  final String kullaniciAdi;

  UrunlerSepeti({
    required this.sepetId,
    required this.ad,
    required this.resim,
    required this.kategori,
    required this.fiyat,
    required this.marka,
    required this.siparisAdeti,
    required this.kullaniciAdi,
  });

  factory UrunlerSepeti.fromJson(Map<String, dynamic> json) {
    return UrunlerSepeti(
      sepetId: int.parse(json['sepetId'].toString()),
      ad: json['ad'].toString(),
      resim: json['resim'].toString(),
      kategori: json['kategori'].toString(),
      fiyat: int.parse(json['fiyat'].toString()),
      marka: json['marka'].toString(),
      siparisAdeti: int.parse(json['siparisAdeti'].toString()),
      kullaniciAdi: json['kullaniciAdi'].toString(),
    );
  }

  /*Urunler toUrunler() {
    return Urunler(
      id: sepetId,
      ad: ad,
      resim: resim,
      kategori: kategori,
      fiyat: fiyat,
      marka: marka,
    );
  }
*/

  UrunlerSepeti copyWith({
    int? sepetId,
    String? ad,
    String? resim,
    String? kategori,
    int? fiyat,
    String? marka,
    int? siparisAdeti,
    String? kullaniciAdi,
  }) {
    return UrunlerSepeti(
      sepetId: sepetId ?? this.sepetId,
      ad: ad ?? this.ad,
      resim: resim ?? this.resim,
      kategori: kategori ?? this.kategori,
      fiyat: fiyat ?? this.fiyat,
      marka: marka ?? this.marka,
      siparisAdeti: siparisAdeti ?? this.siparisAdeti,
      kullaniciAdi: kullaniciAdi ?? this.kullaniciAdi,
    );
  }
}
