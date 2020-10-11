class Paragraph {
  Paragraph(
    {
      this.number,
      this.text,
    }
  );

  String number;
  String text;

  factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
      number: json["number"],
      text: json["text"],
  );

  Map<String, dynamic> toJson() => {
      "number": number,
      "text": text,
  };
}