import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bitirme/data/entity/urunler.dart';
import 'package:bitirme/data/entity/urunler_sepeti.dart';
import 'package:bitirme/data/repo/urunler_dao_repository.dart';

class SepetCubit extends Cubit<List<UrunlerSepeti>> {
  final UrunlerDaoRepository urunlerDaoRepository;
  final String kullaniciAdi;

  SepetCubit(this.urunlerDaoRepository, this.kullaniciAdi) : super([]);



  Future<void> fetchSepettekiUrunler() async {
    try {
      final urunler = await urunlerDaoRepository.sepettekiUrunleriGetir(kullaniciAdi);
      emit(urunler);
    } catch (e) {
      print('Sepet yükleme hatası: $e');
      emit([]);
    }
  }

  //Sepete ürün ekleme
  Future<void> sepeteUrunEkle(Urunler urun, int adet) async {
    try {
      final duplicateUrunler = state.where(
              (sepetUrunu) => sepetUrunu.ad == urun.ad && sepetUrunu.kullaniciAdi == kullaniciAdi
      ).toList();

      for (var duplicateUrun in duplicateUrunler) {
        await urunlerDaoRepository.sepettenUrunSil(duplicateUrun.sepetId, kullaniciAdi);
      }

      final yeniUrun = UrunlerSepeti(
        sepetId: 0,
        ad: urun.ad,
        resim: urun.resim,
        kategori: urun.kategori,
        fiyat: urun.fiyat,
        marka: urun.marka,
        siparisAdeti: adet,
        kullaniciAdi: kullaniciAdi,
      );
      await urunlerDaoRepository.sepeteUrunEkle(yeniUrun);

      await fetchSepettekiUrunler();
    } catch (e) {
      print('Sepete ekleme hatası: $e');
    }
  }


  // Sepetten ürün sil
  Future<void> sepettenUrunSil(int sepetId) async {
    try {
      final guncelListe = List<UrunlerSepeti>.from(state)
        ..removeWhere((urun) => urun.sepetId == sepetId);
      emit(guncelListe);

      await urunlerDaoRepository.sepettenUrunSil(sepetId, kullaniciAdi);
    } catch (e) {

      print('Ürün silme hatası: $e');
      await fetchSepettekiUrunler();
    }
  }


  // Adet arttırma
  Future<void> adetArtir(int sepetId) async {
    try {
      final List<UrunlerSepeti> guncelUrunler = List.from(state);
      final urunIndex = guncelUrunler.indexWhere((urun) => urun.sepetId == sepetId);

      if (urunIndex != -1) {
        final guncelUrun = guncelUrunler[urunIndex].copyWith(
            siparisAdeti: guncelUrunler[urunIndex].siparisAdeti + 1
        );
        guncelUrunler[urunIndex] = guncelUrun;
        emit(guncelUrunler);


        await urunlerDaoRepository.sepeteUrunEkle(guncelUrun);
      }
    } catch (e) {
      print("Adet artırma hatası: $e");
    }
  }

  //Adet Azaltma
  Future<void> adetAzalt(int sepetId) async {
    try {
      final List<UrunlerSepeti> guncelUrunler = List.from(state);
      final urunIndex = guncelUrunler.indexWhere((urun) => urun.sepetId == sepetId);

      if (urunIndex != -1) {
        if (guncelUrunler[urunIndex].siparisAdeti > 1) {
          final guncelUrun = guncelUrunler[urunIndex].copyWith(
              siparisAdeti: guncelUrunler[urunIndex].siparisAdeti - 1
          );
          guncelUrunler[urunIndex] = guncelUrun;
          emit(guncelUrunler);

          await urunlerDaoRepository.sepeteUrunEkle(guncelUrun);
        } else {
          await sepettenUrunSil(sepetId);
        }
      }
    } catch (e) {
      print("Adet azaltma hatası: $e");
    }
  }
}