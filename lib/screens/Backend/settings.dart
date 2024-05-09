class AppSettings {
  final String appBarColour;
  final String colour;
  final int fontSize;
  final String textColour;

  AppSettings({
    required this.appBarColour,
    required this.colour,
    required this.fontSize,
    required this.textColour,
  });

  AppSettings.fromJson(Map<String, dynamic> json)
      : appBarColour = json['appBarColour']! as String,
        colour = json['colour']! as String,
        fontSize = json['font_Size']! as int,
        textColour = json['textColour']! as String;

  AppSettings copyWith({
    String? appBarColour,
    String? colour,
    int? fontSize,
    String? textColour,
  }) {
    return AppSettings(
      appBarColour: appBarColour ?? this.appBarColour,
      colour: colour ?? this.colour,
      fontSize: fontSize ?? this.fontSize,
      textColour: textColour  ?? this.textColour,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'appBarColour' : appBarColour,
      'colour' : colour,
      'font_Size' : fontSize,
      'textColour' : textColour,
    };
  }
}