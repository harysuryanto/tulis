class WindowPosition {
  final double dx;
  final double dy;

  const WindowPosition({
    required this.dx,
    required this.dy,
  });

  factory WindowPosition.fromMap(Map<String, dynamic> json) {
    return WindowPosition(
      dx: json['dx'] as double,
      dy: json['dy'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dx': dx,
      'dy': dy,
    };
  }
}
