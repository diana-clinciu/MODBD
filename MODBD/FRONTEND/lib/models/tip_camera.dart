class TipCamera {
  final int idTipCamera;
  final String? tipCamera;
  final String? clasaConfort;
  final String? categorieCamera;
  final double pret;

  TipCamera({
    required this.idTipCamera,
    required this.tipCamera,
    required this.clasaConfort,
    required this.categorieCamera,
    required this.pret,
  });

  factory TipCamera.fromJson(Map<String, dynamic> j) => TipCamera(
        idTipCamera: j['id_tip_camera'] as int,
        tipCamera: j['tip_camera'] as String?,
        clasaConfort: j['clasa_confort'] as String?,
        categorieCamera: j['categorie_camera'] as String?,
        pret: (j['pret'] as num).toDouble(),
      );

  @override
  String toString() => '${tipCamera ?? ''} – ${clasaConfort ?? ''} (${pret.toStringAsFixed(0)} RON/noapte)';
}
