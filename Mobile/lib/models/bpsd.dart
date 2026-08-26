class BPSD {
  String? key;
  late String title;
  String? tooltip;
  bool? lazy;
  bool? unselectable;
  bool? expanded;
  String? dateExpired;
  List<BPSD>? children;


  BPSD({
    this.key,
    this.title = "",
    this.tooltip,
    this.lazy,
    this.unselectable,
    this.expanded,
    this.dateExpired,
    this.children,
  });



  BPSD.fromJson(Map<String, dynamic> json) {
    key = json["key"]?.toString();
    title = json["title"]?.toString() ?? "";
    tooltip = json["tooltip"]?.toString();
    lazy = json["lazy"];
    unselectable = json["unselectable"];
    expanded = json["expanded"];
    dateExpired = json["dateExpired"]?.toString();
    children = [];
    if (json["children"] != null) {
      var e = json["children"] as List<dynamic>;
      e.forEach((element) {
        children!.add(BPSD.fromJson(element));
      });
    }
    // (json["children"] as List<dynamic>).map((i) => BPSD.fromJson(i)).toList();
  }

  static List<BPSD> listFromJson(List<dynamic> list) {
    List<BPSD> rows = list.map((i) => BPSD.fromJson(i)).toList();
    return rows;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["key"] = key;
    data["title"] = title;
    data["tooltip"] = tooltip;
    data["lazy"] = lazy;
    data["unselectable"] = unselectable;
    data["expanded"] = expanded;
    data["dateExpired"] = dateExpired;
    return data;
  }
}
