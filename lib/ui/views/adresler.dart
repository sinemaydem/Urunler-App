import 'package:flutter/material.dart';
import 'package:bitirme/data/entity/adres.dart';
import 'package:bitirme/data/repo/adres_repository.dart';

class Adresler extends StatefulWidget {
  final String initialSelectedAddress;
  final Function(String) onAddressSelected;

  const Adresler({
    super.key,
    required this.initialSelectedAddress,
    required this.onAddressSelected,
  });

  @override
  State<Adresler> createState() => _AdreslerState();
}

class _AdreslerState extends State<Adresler> {
  final _adresRepo = AdresRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  int? selectedAddressId;

  @override
  void initState() {
    super.initState();
    _loadSelectedAddress();
  }

  //seçili adresi yükleme
  Future<void> _loadSelectedAddress() async {
    try {
      final addresses = await _adresRepo.getAllAddresses();

      if (addresses.isNotEmpty) {
        setState(() {
          final selectedAddress = addresses.firstWhere(
                (adres) => adres.isSelected,
            orElse: () => addresses.first,
          );

          selectedAddressId = selectedAddress.id;
        });
      } else {
        setState(() {
          selectedAddressId = null;
        });
      }
    } catch (e) {
      print('Adres yüklrmr hatası: $e');
      setState(() {
        selectedAddressId = null;
      });
    }
  }


  Future<void> _selectAddress(Adres address) async {
    final allAddresses = await _adresRepo.getAllAddresses();
    for (var addr in allAddresses) {
      addr.isSelected = addr.id == address.id;
      await _adresRepo.updateAddress(addr);
    }

    await _loadSelectedAddress();

    widget.onAddressSelected(address.title);
  }



  void _showAddressDialog({Adres? address}) {
    if (address != null) {
      _titleController.text = address.title;
      _addressController.text = address.fullAddress;
    } else {
      _titleController.clear();
      _addressController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(address != null ? 'Adresi Düzenle' : 'Yeni Adres Ekle'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Adres Başlığı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen adres başlığı girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Adres'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen adres girin';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (address != null) {
                    address.title = _titleController.text;
                    address.fullAddress = _addressController.text;
                    await _adresRepo.updateAddress(address);
                  } else {
                    final newAddress = Adres(
                      title: _titleController.text,
                      fullAddress: _addressController.text,
                      isSelected: false,
                    );
                    await _adresRepo.addAddress(newAddress);
                  }
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAddress(int id) async {
    await _adresRepo.deleteAddress(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Klavye açılınca ekranın yeniden boyutlanmasına izin ver
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
              "Adreslerim",
              style: TextStyle(
                fontFamily: "Baumans",
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.yellow),
                onPressed: () => _showAddressDialog(),
              ),
            ],
          ),
        ),
      ),

      body: FutureBuilder<List<Adres>>(
        future: _adresRepo.getAllAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Kayıtlı adres bulunamadı'));
          }

          final addresses = snapshot.data!;

          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                child: ListTile(
                  title: Text(address.title),
                  subtitle: Text(address.fullAddress),
                  leading: Radio<int>(
                    value: address.id!,
                    groupValue: selectedAddressId,
                    onChanged: (value) => _selectAddress(address),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.redAccent,
                    onPressed: () => _deleteAddress(address.id!),
                  ),
                  onTap: () => _showAddressDialog(address: address),
                ),
              );
            },
          );
        },
      ),

    );
  }
}
