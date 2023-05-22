class ItemModel {
    int id;
    String nama;
    int harga;
    String tipe;
    String gambar;

    ItemModel({
        required this.id,
        required this.nama,
        required this.harga,
        required this.tipe,
        required this.gambar,
    });

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
      id: json["id"], 
      nama: json["nama"],
      harga: json["harga"], 
      tipe: json["tipe"],
      gambar: json["gambar"]);

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "harga": harga,
        "tipe": tipe,
        "gambar": gambar
      };

}