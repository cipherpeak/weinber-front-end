class DaxServiceItem {
  String? type;
  String? subType;
  String? level;
  String? rollMeter;
  String? layer;

  Map<String, dynamic> toJson() {
    return {
      "type": type ?? "none",
      "sub_type": subType ?? "none",
      "level": level ?? "none",
      "roll_meter": rollMeter ?? "none",
      "layer": layer ?? "none",
    };
  }
}
