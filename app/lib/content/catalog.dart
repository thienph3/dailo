import 'dart:convert';
import 'package:flutter/material.dart' show Color, Icons, IconData;
import 'package:flutter/services.dart' show rootBundle;

/// One course available to add, described in assets/catalog.json.
class CatalogEntry {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String coursePath; // asset path to this course's course.json
  final String contentBase; // asset base folder for its lesson files

  const CatalogEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.coursePath,
    required this.contentBase,
  });

  factory CatalogEntry.fromJson(Map<String, dynamic> j) => CatalogEntry(
        id: j['id'] as String,
        title: j['title'] as String,
        subtitle: (j['subtitle'] ?? '') as String,
        description: (j['description'] ?? '') as String,
        icon: _iconFor((j['icon'] ?? 'school') as String),
        color: Color(int.parse((j['color'] ?? '0xFF2EB872') as String)),
        coursePath: j['coursePath'] as String,
        contentBase: j['contentBase'] as String,
      );

  static IconData _iconFor(String name) {
    switch (name) {
      case 'code':
        return Icons.code_rounded;
      case 'design':
        return Icons.brush_rounded;
      case 'finance':
        return Icons.savings_rounded;
      case 'language':
        return Icons.translate_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}

/// Loads the course catalog from the bundled asset.
class CatalogLoader {
  List<CatalogEntry>? _entries;

  /// Test hook: provide catalog entries up front (no asset I/O).
  void seed(List<CatalogEntry> entries) => _entries = entries;

  Future<List<CatalogEntry>> load() async {
    if (_entries != null) return _entries!;
    final raw = await rootBundle.loadString('assets/catalog.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    _entries = (map['courses'] as List)
        .map((e) => CatalogEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return _entries!;
  }

  Future<CatalogEntry> byId(String id) async {
    final all = await load();
    return all.firstWhere((c) => c.id == id);
  }
}
