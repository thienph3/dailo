// Data models for the Dailo course content.
//
// The content lives as JSON assets:
//   assets/course/course.json       — structure (laps, units, lesson file pointers)
//   assets/course/content/unit-NN/lesson-MM.json — the 10 exercises of one lesson
//
// These models mirror that shape and decode the 7 exercise types.

/// One exercise type. Kept as a string enum matching the JSON `type` field.
enum ExerciseType {
  multipleChoice,
  multiSelect,
  trueFalse,
  fillBlank,
  orderBlocks,
  matchPairs,
  tapTokens;

  static ExerciseType fromJson(String s) {
    switch (s) {
      case 'multipleChoice':
        return ExerciseType.multipleChoice;
      case 'multiSelect':
        return ExerciseType.multiSelect;
      case 'trueFalse':
        return ExerciseType.trueFalse;
      case 'fillBlank':
        return ExerciseType.fillBlank;
      case 'orderBlocks':
        return ExerciseType.orderBlocks;
      case 'matchPairs':
        return ExerciseType.matchPairs;
      case 'tapTokens':
        return ExerciseType.tapTokens;
      default:
        throw FormatException('Unknown exercise type: $s');
    }
  }
}

/// A single exercise. Type-specific payloads are stored in typed fields;
/// only the ones relevant to [type] are populated.
class Exercise {
  final String id;
  final ExerciseType type;
  final String prompt;
  final String explanation;

  // multipleChoice / multiSelect
  final List<String> options;

  // multipleChoice: int index | multiSelect: List<int> | trueFalse: bool |
  // fillBlank: String | orderBlocks: List<int> | tapTokens: List<String>
  final dynamic answer;

  // fillBlank
  final List<String> acceptable;

  // orderBlocks
  final List<String> blocks;

  // matchPairs
  final List<MatchPair> pairs;

  // tapTokens
  final List<String> tokens;

  const Exercise({
    required this.id,
    required this.type,
    required this.prompt,
    required this.explanation,
    this.options = const [],
    this.answer,
    this.acceptable = const [],
    this.blocks = const [],
    this.pairs = const [],
    this.tokens = const [],
  });

  factory Exercise.fromJson(Map<String, dynamic> j) {
    return Exercise(
      id: j['id'].toString(),
      type: ExerciseType.fromJson(j['type'] as String),
      prompt: j['prompt'].toString(),
      explanation: _asText(j['explanation']),
      options:
          (j['options'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      answer: j['answer'],
      acceptable: _asStringList(j['acceptable']),
      blocks:
          (j['blocks'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      pairs: (j['pairs'] as List?)
              ?.map((e) => MatchPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tokens:
          (j['tokens'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  /// Accept a String, a List (joined), or null → a plain string. Defensive
  /// against authoring slips where a string field was given a list value.
  static String _asText(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is List) return v.map((e) => e.toString()).join(' ');
    return v.toString();
  }

  /// Accept a List, a single String, or null → a list of strings.
  static List<String> _asStringList(dynamic v) {
    if (v == null) return const [];
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String) return [v];
    return [v.toString()];
  }
}

class MatchPair {
  final String left;
  final String right;
  const MatchPair(this.left, this.right);
  factory MatchPair.fromJson(Map<String, dynamic> j) =>
      MatchPair(j['left'] as String, j['right'] as String);
}

/// A lesson's metadata in course.json (title + file pointer). Exercises are
/// loaded lazily from [file] when the lesson is opened.
class LessonRef {
  final String id;
  final String title;
  final String file; // relative to assets/course/
  const LessonRef({required this.id, required this.title, required this.file});

  factory LessonRef.fromJson(Map<String, dynamic> j) => LessonRef(
        id: j['id'] as String,
        title: j['title'] as String,
        file: j['file'] as String,
      );
}

/// A fully-loaded lesson (its 10 exercises).
class Lesson {
  final String id;
  final String title;
  final String idea;
  final String? problem;
  final List<Exercise> exercises;
  const Lesson({
    required this.id,
    required this.title,
    required this.idea,
    this.problem,
    required this.exercises,
  });

  factory Lesson.fromJson(Map<String, dynamic> j) => Lesson(
        id: j['lessonId'] as String,
        title: j['title'] as String,
        idea: (j['idea'] ?? '') as String,
        problem: j['problem'] as String?,
        exercises: (j['exercises'] as List)
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class Unit {
  final String id;
  final Object lap; // int or String like "2a"
  final String beat; // MEET / TOOL / PRACTICE / LOOP
  final String title;
  final String tool;
  final List<String> prerequisites;
  final List<LessonRef> lessons;

  const Unit({
    required this.id,
    required this.lap,
    required this.beat,
    required this.title,
    required this.tool,
    required this.prerequisites,
    required this.lessons,
  });

  factory Unit.fromJson(Map<String, dynamic> j) => Unit(
        id: j['id'] as String,
        lap: j['lap'] as Object,
        beat: (j['beat'] ?? '') as String,
        title: j['title'] as String,
        tool: (j['tool'] ?? '') as String,
        prerequisites: (j['prerequisites'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        lessons: (j['lessons'] as List)
            .map((e) => LessonRef.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class Lap {
  final String id;
  final String name;
  final List<String> unitIds;
  const Lap({required this.id, required this.name, required this.unitIds});

  factory Lap.fromJson(Map<String, dynamic> j) => Lap(
        id: j['id'].toString(),
        name: j['name'] as String,
        unitIds:
            (j['units'] as List).map((e) => e.toString()).toList(),
      );
}

class Course {
  final String id;
  final String title;
  final String goal;
  final List<Lap> laps;
  final List<Unit> units;

  const Course({
    required this.id,
    required this.title,
    required this.goal,
    required this.laps,
    required this.units,
  });

  factory Course.fromJson(Map<String, dynamic> j) => Course(
        id: j['id'] as String,
        title: j['title'] as String,
        goal: (j['goal'] ?? '') as String,
        laps: (j['laps'] as List)
            .map((e) => Lap.fromJson(e as Map<String, dynamic>))
            .toList(),
        units: (j['units'] as List)
            .map((e) => Unit.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Unit unitById(String id) => units.firstWhere((u) => u.id == id);
}
