import 'package:bitirme/data/repo/urunler_dao_repository.dart';
import 'package:bitirme/ui/cubit/sepet_cubit.dart';
import 'package:bitirme/ui/views/anasayfa.dart';
import 'package:bitirme/ui/views/detay_sayfa.dart';
import 'package:bitirme/ui/views/profil.dart';
import 'package:bitirme/ui/views/sepet_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/data/entity/urunler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Kategori extends StatefulWidget {
  final List<Urunler> tumUrunler;
  final Urunler urunler;
  final String kullaniciAdi;

  const Kategori({
    Key? key,
    required this.tumUrunler,
    required this.urunler,
    required this.kullaniciAdi
  }) : super(key: key);

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> with SingleTickerProviderStateMixin {
  int adet = 1;
  late TabController _tabController;
  late List<String> kategoriler;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    kategoriler = widget.tumUrunler.map((e) => e.kategori).toSet().toList();
    _tabController = TabController(length: kategoriler.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        break;
      case 2: // Sepet
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SepetCubit(UrunlerDaoRepository(), 'sinem'),
              child: SepetSayfa(kullaniciAdi: 'sinem'),
            ),
          ),
        );
        break;
      case 3: // Profil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Profil()),
        );
        break;
    }
  }

  List<Urunler> getUrunlerByKategori(String kategori) {
    return widget.tumUrunler.where((urun) => urun.kategori == kategori).toList();
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
              "Kategoriler",
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicator: BoxDecoration(
                color: Colors.yellow.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 6.0),
              tabs: kategoriler.map((kategori) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    kategori,
                    style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 14, // Yazı boyutu
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: kategoriler.map((kategori) {
                final kategoriUrunleri = getUrunlerByKategori(kategori);
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: kategoriUrunleri.length,
                  itemBuilder: (context, index) {
                    final urun = kategoriUrunleri[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => SepetCubit(UrunlerDaoRepository(), 'sinem'),
                                    child: DetaySayfa(urunler: urun, kullaniciAdi: "sinem"),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    'http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}',
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        urun.ad,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        urun.marka,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${urun.fiyat} ₺',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.deepOrangeAccent,
                                size: 24,
                              ),
                              onPressed: () async {
                                await context.read<SepetCubit>().sepeteUrunEkle(urun, 1);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${urun.ad} sepete eklendi!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );


                  },
                );
              }).toList(),
            ),
          ),

        ],
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