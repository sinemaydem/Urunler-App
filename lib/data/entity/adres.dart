class Adres {
  int? id;
  String title;
  String fullAddress;
  bool isSelected;

  Adres({
    this.id,
    required this.title,
    required this.fullAddress,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, //
      'title': title,
      'fullAddress': fullAddress,
      'isSelected': isSelected ? 1 : 0,
    };
  }

  factory Adres.fromJson(Map<String, dynamic> json) {
    return Adres(
      id: json['id'],
      title: json['title'],
      fullAddress: json['fullAddress'],
      isSelected: json['isSelected'] == 1,
    );
  }
}
