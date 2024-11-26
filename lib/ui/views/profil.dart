import 'package:bitirme/data/repo/urunler_dao_repository.dart';
import 'package:bitirme/ui/cubit/anasayfa_cubit.dart';
import 'package:bitirme/ui/cubit/sepet_cubit.dart';
import 'package:bitirme/ui/views/anasayfa.dart';
import 'package:bitirme/ui/views/kategori.dart';
import 'package:bitirme/ui/views/sepet_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  // Kullanıcı bilgileri
  String ad = "Sinem";
  String soyad = "Aydemir";
  String email = "sinem0aydemir@gmail.com";
  String ulkeKodu = "+90";
  String telefon = "5012345678";

  int _selectedIndex = 3; // Profil

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: //anasayfa
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Anasayfa()),
              (route) => false,
        );
        break;
      case 1: //Kategori
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
      case 2: //sepet
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
      case 3:
        break; // Profil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              "Profilim",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoField("Adı", ad, (value) {
                setState(() {
                  ad = value;
                });
              }),
              _buildInfoField("Soyadı", soyad, (value) {
                setState(() {
                  soyad = value;
                });
              }),
              _buildInfoField("Email", email, (value) {
                setState(() {
                  email = value;
                });
              }),
              _buildInfoField("Ülke Kodu", ulkeKodu, (value) {
                setState(() {
                  ulkeKodu = value;
                });
              }),
              _buildInfoField("Cep Telefonu", telefon, (value) {
                setState(() {
                  telefon = value;
                });
              }),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Kaydet işlemi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Bilgiler kaydedildi!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Kaydet",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Hesabı kapatma işlemi (aktif değil)
                },
                child: Center(
                  child: Text(
                    "Hesabımı Kapat",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            label: 'Hesabım',
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

  Widget _buildInfoField(String label, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
