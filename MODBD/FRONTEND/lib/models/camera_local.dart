import 'package:flutter/material.dart';

class CameraLocal {
  final int idCamera;
  final int nrCamera;
  final int idTipCamera;
  final int idHotel;

  CameraLocal({
    required this.idCamera,
    required this.nrCamera,
    required this.idTipCamera,
    required this.idHotel,
  });

  factory CameraLocal.fromJson(Map<String, dynamic> j) => CameraLocal(
        idCamera: j['id_camera'] as int,
        nrCamera: j['nr_camera'] as int,
        idTipCamera: j['id_tip_camera'] as int,
        idHotel: j['id_hotel'] as int,
      );

  Map<String, String> toFormFields() => {
        'id_camera': idCamera.toString(),
        'nr_camera': nrCamera.toString(),
        'id_tip_camera': idTipCamera.toString(),
        'id_hotel': idHotel.toString(),
      };

  static Future<CameraLocal?> showAddDialog(
          BuildContext context, int defaultIdHotel) =>
      _showDialog(context, null, defaultIdHotel);

  static Future<CameraLocal?> showEditDialog(
          BuildContext context, CameraLocal c) =>
      _showDialog(context, c, c.idHotel);

  static Future<CameraLocal?> _showDialog(
      BuildContext context, CameraLocal? existing, int defaultIdHotel) {
    final idCtrl =
        TextEditingController(text: existing?.idCamera.toString() ?? '');
    final nrCtrl =
        TextEditingController(text: existing?.nrCamera.toString() ?? '');
    final tipCtrl = TextEditingController(
        text: existing?.idTipCamera.toString() ?? '');
    final hotelCtrl = TextEditingController(
        text: existing?.idHotel.toString() ?? defaultIdHotel.toString());

    return showDialog<CameraLocal>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Adauga Camera' : 'Editeaza Camera'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'ID Camera *'),
              keyboardType: TextInputType.number,
              enabled: existing == null,
            ),
            TextField(
              controller: nrCtrl,
              decoration: const InputDecoration(labelText: 'Nr Camera *'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tipCtrl,
              decoration:
                  const InputDecoration(labelText: 'ID Tip Camera *'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: hotelCtrl,
              decoration: const InputDecoration(labelText: 'ID Hotel *'),
              keyboardType: TextInputType.number,
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
              final nr = int.tryParse(nrCtrl.text.trim());
              final tip = int.tryParse(tipCtrl.text.trim());
              final hotel = int.tryParse(hotelCtrl.text.trim());
              if (id == null || nr == null || tip == null || hotel == null) return;
              Navigator.pop(
                ctx,
                CameraLocal(
                  idCamera: existing?.idCamera ?? id,
                  nrCamera: nr,
                  idTipCamera: tip,
                  idHotel: hotel,
                ),
              );
            },
            child: const Text('Salveaza'),
          ),
        ],
      ),
    );
  }
}
