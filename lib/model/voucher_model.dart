class VoucherModel {
  int? id;
    String? kode;
    int? nominal;
    String? createdAt;
    String? updatedAt;

    VoucherModel({
         this.id,
         this.kode,
         this.nominal,
         this.createdAt,
         this.updatedAt,
    });

    factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
      id: json["id"],
      kode: json["kode"],
      nominal: json["nominal"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "nominal": nominal,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}