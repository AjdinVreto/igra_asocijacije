const String tablePojam = "Pojam";

class PojamFields {
  static final List<String> values = [Id, Naziv];

  static const String Id = "Id";
  static const String Naziv = "Pojam";
}

class Pojam {
  final int? Id;
  final String? Naziv;

  const Pojam({
    this.Id,
    this.Naziv,
  });

  Pojam copy({required int id}) => Pojam(Id: this.Id);

  Map<String, Object?> toJson() =>
      {PojamFields.Id: Id, PojamFields.Naziv: Naziv};

  static Pojam fromJson(Map<String, Object?> json) => Pojam(
      Id: json[PojamFields.Id] as int,
      Naziv: json[PojamFields.Naziv] as String);
}
