import 'package:bitirme/ui/cubit/anasayfa_cubit.dart';
import 'package:bitirme/ui/views/anasayfa.dart';
import 'package:bitirme/ui/views/kategori.dart';
import 'package:bitirme/ui/views/profil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bitirme/data/entity/urunler_sepeti.dart';
import 'package:bitirme/ui/cubit/sepet_cubit.dart';

class SepetSayfa extends StatefulWidget {
  final String kullaniciAdi;

  const SepetSayfa({Key? key, required this.kullaniciAdi}) : super(key: key);

  @override
  _SepetSayfaState createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {
  int _selectedIndex = 2; //  Sepet

  @override
  void initState() {
    super.initState();
    context.read<SepetCubit>().fetchSepettekiUrunler();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Anasayfa
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Anasayfa()),
              (route) => false,
        );
        break;
      case 1: // Kategori

        final urunlerState = context.read<AnasayfaCubit>().state;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Kategori(
              tumUrunler: urunlerState,
              urunler: urunlerState.first,
              kullaniciAdi: 'sinem',
            ),
          ),
        );
        break;
      case 2: // Sepet
        break;
      case 3: // Profil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Profil()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.deepOrangeAccent,
                Colors.pinkAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Sepetim",
              style: TextStyle(
                fontFamily: "Baumans",
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: BlocBuilder<SepetCubit, List<UrunlerSepeti>>(
        builder: (context, urunler) {
          if (urunler.isEmpty) {
            return Center(
              child: Text(
                'Sepetiniz boş!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          int toplamTutar = urunler.fold(
              0, (sum, urun) => sum + (urun.fiyat * urun.siparisAdeti));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: urunler.length,
                  itemBuilder: (context, index) {
                    final urun = urunler[index];
                    String imageUrl = urun.resim.startsWith('http')
                        ? urun.resim
                        : 'http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}';

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        title: Text(
                          urun.ad,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${urun.fiyat} ₺ x ${urun.siparisAdeti} = ${urun.fiyat * urun.siparisAdeti} ₺',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (urun.siparisAdeti > 1) {
                                            context.read<SepetCubit>().adetAzalt(urun.sepetId);
                                          } else {
                                            context.read<SepetCubit>().sepettenUrunSil(urun.sepetId);
                                          }
                                        },
                                      ),
                                      Text('${urun.siparisAdeti}'),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          context.read<SepetCubit>().adetArtir(urun.sepetId);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    context.read<SepetCubit>().sepettenUrunSil(urun.sepetId);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toplam Tutar:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${toplamTutar} ₺',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Sipariş verme işlemi (aktif değil)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Siparişi Onayla',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.deepOrangeAccent,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }


}