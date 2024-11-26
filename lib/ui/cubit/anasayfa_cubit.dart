import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bitirme/data/entity/urunler.dart';
import 'package:bitirme/data/repo/urunler_dao_repository.dart';

class AnasayfaCubit extends Cubit<List<Urunler>> {
  final UrunlerDaoRepository urunlerDaoRepository;

  AnasayfaCubit(this.urunlerDaoRepository) : super([]);

  // Ürünleri getir
  Future<void> tumUrunleriGetir() async {
    try {
      final urunler = await urunlerDaoRepository.tumUrunleriGetir();
      emit(urunler);
    } catch (e) {
      print('Hata: $e');
      emit([]);
    }
  }
}


