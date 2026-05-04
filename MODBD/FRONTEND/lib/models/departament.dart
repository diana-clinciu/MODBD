class Departament {
  final int idDepartament;
  final String? numeDepartament;

  Departament({required this.idDepartament, required this.numeDepartament});

  factory Departament.fromJson(Map<String, dynamic> j) => Departament(
        idDepartament: j['id_departament'] as int,
        numeDepartament: j['nume_departament'] as String?,
      );

  @override
  String toString() => numeDepartament ?? '';
}
