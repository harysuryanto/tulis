class WindowSize {
  final double width;
  final double height;

  const WindowSize({
    required this.width,
    required this.height,
  });

  factory WindowSize.fromMap(Map<String, dynamic> json) {
    return WindowSize(
      width: json['width'] as double,
      height: json['height'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': width,
      'height': height,
    };
  }
}
