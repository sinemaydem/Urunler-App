class Urunler {
  final int id;
  final String ad;
  final String resim;
  final String kategori;
  final int fiyat;
  final String marka;


  Urunler({
    required this.id,
    required this.ad,
    required this.resim,
    required this.kategori,
    required this.fiyat,
    required this.marka,
  });


  factory Urunler.fromJson(Map<String, dynamic> json) {
    return Urunler(
      id: int.parse(json['id'].toString()),
      ad: json['ad'],
      resim: json['resim'],
      kategori: json['kategori'],
      fiyat: int.parse(json['fiyat'].toString()),
      marka: json['marka'],
    );
  }


}



