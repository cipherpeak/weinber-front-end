String extractTimeZoneName(String raw) {
  final match = RegExp(r'TimezoneInfo\(([^,]+),').firstMatch(raw);
  return match != null ? match.group(1)! : raw;
}
