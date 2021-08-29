class Vocabulary {
  final String id;
  final String en;
  final String vi;
  final String? en2;
  final String? vi2;
  final String? extra; //part of speech

  Vocabulary({
    required this.id,
    required this.en,
    required this.vi,
    String? en2,
    String? vi2,
    String? extra,
  })  : this.en2 = (en2 == '') ? null : en2,
        this.vi2 = (vi2 == '') ? null : vi2,
        this.extra = (extra == '') ? null : extra;

  Vocabulary.fromMap(this.id, Map vocab)
      : this.en = vocab['en'],
        this.vi = vocab['vi'],
        this.en2 = vocab['en2'],
        this.vi2 = vocab['vi2'],
        this.extra = vocab['extra'];

  Map toMap() {
    Map<String, dynamic> result = {
      'en': en,
      'vi': vi,
      'en2': en2,
      'vi2': vi2,
      'extra': extra
    };
    result.removeWhere((_, value) => value == null);
    return result;
  }

  Vocabulary copyWith(
      {String? id,
      String? en,
      String? vi,
      String? en2,
      String? vi2,
      String? extra}) {
    return Vocabulary(
        id: id == null ? this.id : id,
        en: en == null ? this.en : en,
        vi: vi == null ? this.vi : vi,
        en2: en2 == null ? this.en2 : en2,
        vi2: vi2 == null ? this.vi2 : vi2,
        extra: extra == null ? this.extra : extra);
  }
}
