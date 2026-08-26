class TVHD {
  String? id;
  String? ten;
  String? chucvu;
  String? daidien;
  String? chucdanh;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["Id"] = id;
    data["HoTen"] = ten;
    data["ChucVu"] = chucvu;
    data["DaiDien"] = daidien;
    data["ViTri"] = chucdanh;
    return data;
  }

  TVHD();

  TVHD.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['_id'].toString();
    ten = parsedJson['HoTen'] != null ? parsedJson['HoTen'].trim() : "";
    chucvu = parsedJson['ChucVu'].toString();
    daidien = parsedJson['DaiDien'].toString();
    chucdanh = parsedJson['ViTri'].toString();
  }

  static listFromJson(List<dynamic> list) {
    List<TVHD> rows = list.map((i) => TVHD.fromJson(i)).toList();
    return rows;
  }
}
