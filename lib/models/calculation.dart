class Calculation {
  final int? id;
  final String expression;
  final String result;
  final int timestamp;
  final bool isFavorite;

  Calculation({
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
    this.isFavorite = false,
  }) {
    if (expression.isEmpty) throw ArgumentError('Expression cannot be empty');
    if (result.isEmpty) throw ArgumentError('Result cannot be empty');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Calculation.fromMap(Map<String, dynamic> map) {
    if (map['expression'] == null ||
        map['result'] == null ||
        map['timestamp'] == null) {
      throw ArgumentError('Missing required fields in Calculation map');
    }
    return Calculation(
      id: map['id'],
      expression: map['expression'] as String,
      result: map['result'] as String,
      timestamp: map['timestamp'] as int,
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Calculation copyWith({
    int? id,
    String? expression,
    String? result,
    int? timestamp,
    bool? isFavorite,
  }) {
    return Calculation(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get formattedDate {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Calculation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          expression == other.expression &&
          result == other.result &&
          timestamp == other.timestamp &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^
      expression.hashCode ^
      result.hashCode ^
      timestamp.hashCode ^
      isFavorite.hashCode;

  @override
  String toString() {
    return 'Calculation{id: $id, expression: $expression, result: $result, '
        'timestamp: $timestamp, isFavorite: $isFavorite}';
  }
}
