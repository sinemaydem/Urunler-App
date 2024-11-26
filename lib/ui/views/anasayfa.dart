import 'package:bitirme/data/entity/urunler.dart';
import 'package:bitirme/data/repo/urunler_dao_repository.dart';
import 'package:bitirme/ui/cubit/anasayfa_cubit.dart';
import 'package:bitirme/ui/cubit/sepet_cubit.dart';
import 'package:bitirme/ui/views/adresler.dart';
import 'package:bitirme/ui/views/detay_sayfa.dart';
import 'package:bitirme/ui/views/kategori.dart';
import 'package:bitirme/ui/views/profil.dart';
import 'package:bitirme/ui/views/sepet_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = 'Azalan';
  String _selectedAddress = 'Evim';
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context.read<AnasayfaCubit>().tumUrunleriGetir();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    switch (index) {
      case 0:
      // Anasayfa
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profil(),
          ),
        );
        break;
    }
  }
  void _openAddressPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Adresler(
          initialSelectedAddress: _selectedAddress,
          onAddressSelected: (selectedAddress) {
            setState(() {
              _selectedAddress = selectedAddress;
            });
          },
        ),
      ),
    );
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
              "Merhaba " ,
              style: TextStyle(
                fontFamily: "Baumans",
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 22,
              ),
            ),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Teslim Adresi:",
                      style: TextStyle(
                          color: Colors.yellow),
                    ),
                    Text(
                      _selectedAddress,
                      style: const TextStyle(
                        fontFamily: "Baumans",
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.home_work, color: Colors.yellow, size: 28),
                onPressed: _openAddressPage,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: _selectedSort,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSort = newValue!;
                  });
                },
                items: ['Azalan', 'Artan', 'Normal']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

            ),
          ),

          Expanded(
            child: BlocBuilder<AnasayfaCubit, List<Urunler>>(
              builder: (context, urunler) {
                if (urunler.isEmpty) {
                  return const Center(child: Text("Ürün bulunamadı"));
                }

                final filteredUrunler = urunler.where((urun) {
                  return urun.ad.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                if (_selectedSort == 'Artan') {
                  filteredUrunler.sort((a, b) => a.fiyat.compareTo(b.fiyat));
                } else if (_selectedSort == 'Azalan') {
                  filteredUrunler.sort((a, b) => b.fiyat.compareTo(a.fiyat));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredUrunler.length,
                  itemBuilder: (context, index) {
                    var urun = filteredUrunler[index];
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
                                          fontSize: 16,
                                          color: Colors.pink,
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
              },
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