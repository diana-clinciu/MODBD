import 'package:flutter/material.dart';

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

  Map<String, String> toFormFields() => {
        'id_tip_camera': idTipCamera.toString(),
        if (tipCamera != null) 'tip_camera': tipCamera!,
        if (clasaConfort != null) 'clasa_confort': clasaConfort!,
        if (categorieCamera != null) 'categorie_camera': categorieCamera!,
        'pret': pret.toString(),
      };

  static Future<TipCamera?> showAddDialog(BuildContext context) =>
      _showDialog(context, null);

  static Future<TipCamera?> showEditDialog(BuildContext context, TipCamera t) =>
      _showDialog(context, t);

  static Future<TipCamera?> _showDialog(BuildContext context, TipCamera? existing) {
    final idCtrl = TextEditingController(text: existing?.idTipCamera.toString() ?? '');
    final tipCtrl = TextEditingController(text: existing?.tipCamera ?? '');
    final clasaCtrl = TextEditingController(text: existing?.clasaConfort ?? '');
    final catCtrl = TextEditingController(text: existing?.categorieCamera ?? '');
    final pretCtrl = TextEditingController(text: existing?.pret.toString() ?? '');

    return showDialog<TipCamera>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Adauga Tip Camera' : 'Editeaza Tip Camera'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID Tip Camera *'),
              keyboardType: TextInputType.number,
              enabled: existing == null,
            ),
            TextField(controller: tipCtrl,
                decoration: const InputDecoration(labelText: 'Tip Camera')),
            TextField(controller: clasaCtrl,
                decoration: const InputDecoration(labelText: 'Clasa Confort')),
            TextField(controller: catCtrl,
                decoration: const InputDecoration(labelText: 'Categorie Camera')),
            TextField(
              controller: pretCtrl,
              decoration: const InputDecoration(labelText: 'Pret (RON) *'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Anuleaza')),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(idCtrl.text.trim());
              final pret = double.tryParse(pretCtrl.text.trim());
              if (id == null || pret == null) return;
              Navigator.pop(
                ctx,
                TipCamera(
                  idTipCamera: existing?.idTipCamera ?? id,
                  tipCamera: tipCtrl.text.trim().isEmpty ? null : tipCtrl.text.trim(),
                  clasaConfort: clasaCtrl.text.trim().isEmpty ? null : clasaCtrl.text.trim(),
                  categorieCamera: catCtrl.text.trim().isEmpty ? null : catCtrl.text.trim(),
                  pret: pret,
                ),
              );
            },
            child: const Text('Salveaza'),
          ),
        ],
      ),
    );
  }

  @override
  String toString() => '${tipCamera ?? ''} – ${clasaConfort ?? ''} (${pret.toStringAsFixed(0)} RON/noapte)';
}
