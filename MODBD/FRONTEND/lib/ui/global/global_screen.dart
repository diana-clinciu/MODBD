import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_flutter/ui/global/global_view_model.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';


class GlobalScreen extends StatefulWidget {
  const GlobalScreen({super.key});

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen>
    with SingleTickerProviderStateMixin {
  final GlobalViewModel _vm = GetIt.instance.get<GlobalViewModel>();
  late TabController _tabController;
  bool _verificareVisible = false;

  static const _tabs = [
    'Hoteluri', 'Angajati', 'Camere',
    'Clienti', 'Rezervari', 'Plati',
    'Servicii', 'Departamente', 'Tipuri Camera',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _vm.loadAll());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GlobalViewModel>.value(
      value: _vm,
      child: Consumer<GlobalViewModel>(
        builder: (ctx, vm, _) => Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _HotelGlobalTab(vm: vm),
                  _AngajatGlobalTab(vm: vm),
                  _CameraGlobalTab(vm: vm),
                  _ClientTab(vm: vm),
                  _RezervareTab(vm: vm),
                  _PlataTab(vm: vm),
                  _ServiciuTab(vm: vm),
                  _DepartamentTab(vm: vm),
                  _TipCameraTab(vm: vm),
                ],
              ),
            ),
            _buildVerificareCard(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _buildVerificareCard(GlobalViewModel vm) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            dense: true,
            title: const Text('Verificare propagare locala (Req 4)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (vm.verificareLoading)
                  const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                IconButton(
                  icon: Icon(_verificareVisible
                      ? Icons.expand_less
                      : Icons.expand_more),
                  onPressed: () =>
                      setState(() => _verificareVisible = !_verificareVisible),
                ),
              ],
            ),
          ),
          if (_verificareVisible && vm.lastVerificare != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: _VerificareWidget(data: vm.lastVerificare!),
            ),
          if (_verificareVisible && vm.lastVerificare == null)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Apasa butonul de cautare de langa o entitate pentru a verifica propagarea.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

// ── HELPERS ───────────────────────────────────────────────────────────────────

Future<bool> _confirmG(BuildContext context, String? message) async {
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(message ?? ''),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Nu')),
            ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Da')),
          ],
        ),
      ) ??
      false;
}

Widget _buildTab({
  required bool loading,
  String? error,
  required int count,
  required Widget Function(int) itemBuilder,
  required VoidCallback onAdd,
}) {
  if (loading) return const Center(child: CircularProgressIndicator());
  if (error != null) return Center(child: Text('Eroare: $error'));
  return Scaffold(
    body: ListView.builder(itemCount: count, itemBuilder: (ctx, i) => itemBuilder(i)),
    floatingActionButton: FloatingActionButton(onPressed: onAdd, child: const Icon(Icons.add)),
  );
}

// ── VERIFICARE WIDGET ─────────────────────────────────────────────────────────

class _VerificareWidget extends StatelessWidget {
  final Map<String?, dynamic> data;
  const _VerificareWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    final buc = data['fragment_bucuresti'];
    final con = data['fragment_constanta'];
    final entitate = data['entitate'] ?? '';
    final id = data['id'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Entitate: $entitate  #$id',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _FragmentCard(title: 'Fragment Bucuresti', data: buc, color: Colors.blue.shade50)),
            const SizedBox(width: 8),
            Expanded(child: _FragmentCard(title: 'Fragment Constanta', data: con, color: Colors.green.shade50)),
          ],
        ),
      ],
    );
  }
}

class _FragmentCard extends StatelessWidget {
  final String? title;
  final dynamic data;
  final Color color;
  const _FragmentCard({required this.title, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 4),
          if (data == null)
            const Text('Nu exista', style: TextStyle(color: Colors.red, fontSize: 12))
          else if (data is Map)
            ...(data as Map<String?, dynamic>)
                .entries
                .map((e) => Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 11)))
          else
            Text(data.toString(), style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

// ── HOTEL TAB ─────────────────────────────────────────────────────────────────

class _HotelGlobalTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _HotelGlobalTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.hotels.length,
      onAdd: () async {
        final h = await Hotel.showAddDialog(context);
        if (h != null) await vm.addHotel(h);
      },
      itemBuilder: (i) {
        final h = vm.hotels[i];
        return ListTile(
          title: Text(h.numeHotel ?? ''),
          subtitle: Text('${h.oras} • ${h.nrStele != null ? '${h.nrStele}★' : '–'}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.search, size: 20), tooltip: 'Verifica propagare',
                onPressed: () => vm.verificaHotel(h.idHotel)),
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await Hotel.showEditDialog(context, h);
              if (updated != null) await vm.updateHotel(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge hotel global #${h.idHotel}?'))
                await vm.deleteHotel(h.idHotel);
            }),
          ]),
        );
      },
    );
  }
}

// ── ANGAJAT TAB ───────────────────────────────────────────────────────────────

class _AngajatGlobalTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _AngajatGlobalTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.angajati.length,
      onAdd: () async {
        final a = await AngajatGlobal.showAddDialog(context);
        if (a != null) await vm.addAngajat(a);
      },
      itemBuilder: (i) {
        final a = vm.angajati[i];
        return ListTile(
          title: Text('${a.nume} ${a.prenume}'),
          subtitle: Text('${a.functie ?? 'N/A'} • Hotel ${a.idHotel} • ${a.cnp}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.search, size: 20), tooltip: 'Verifica propagare',
                onPressed: () => vm.verificaAngajat(a.idAngajat)),
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await AngajatGlobal.showEditDialog(context, a);
              if (updated != null) await vm.updateAngajat(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge angajat #${a.idAngajat}?'))
                await vm.deleteAngajat(a.idAngajat);
            }),
          ]),
        );
      },
    );
  }
}

// ── CAMERA TAB ────────────────────────────────────────────────────────────────

class _CameraGlobalTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _CameraGlobalTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.camere.length,
      onAdd: () async {
        final c = await CameraLocal.showAddDialog(context, 1);
        if (c != null) await vm.addCamera(c);
      },
      itemBuilder: (i) {
        final c = vm.camere[i];
        return ListTile(
          title: Text('Camera ${c.nrCamera}'),
          subtitle: Text('Tip: ${c.idTipCamera} • Hotel: ${c.idHotel}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.search, size: 20), tooltip: 'Verifica propagare',
                onPressed: () => vm.verificaCamera(c.idCamera)),
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await CameraLocal.showEditDialog(context, c);
              if (updated != null) await vm.updateCamera(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge camera #${c.idCamera}?'))
                await vm.deleteCamera(c.idCamera);
            }),
          ]),
        );
      },
    );
  }
}

// ── CLIENT TAB ────────────────────────────────────────────────────────────────

class _ClientTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _ClientTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.clienti.length,
      onAdd: () async {
        final c = await Client.showAddDialog(context);
        if (c != null) await vm.addClient(c);
      },
      itemBuilder: (i) {
        final c = vm.clienti[i];
        return ListTile(
          title: Text('${c.nume} ${c.prenume}'),
          subtitle: Text(c.email ?? ''),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await Client.showEditDialog(context, c);
              if (updated != null) await vm.updateClient(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge client #${c.id}?'))
                await vm.deleteClient(c.id);
            }),
          ]),
        );
      },
    );
  }
}

// ── REZERVARE TAB ─────────────────────────────────────────────────────────────

class _RezervareTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _RezervareTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.rezervari.length,
      onAdd: () async {
        final r = await Rezervare.showAddDialog(context, vm.clienti);
        if (r != null) await vm.addRezervare(r);
      },
      itemBuilder: (i) {
        final r = vm.rezervari[i];
        final s = '${r.dataStart.day}/${r.dataStart.month}/${r.dataStart.year}';
        final f = '${r.dataFinal.day}/${r.dataFinal.month}/${r.dataFinal.year}';
        return ListTile(
          title: Text('Rezervare #${r.id}'),
          subtitle: Text('Client: ${r.clientId} • $s → $f'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await Rezervare.showEditDialog(context, r, vm.clienti);
              if (updated != null) await vm.updateRezervare(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge rezervare #${r.id}?'))
                await vm.deleteRezervare(r.id);
            }),
          ]),
        );
      },
    );
  }
}

// ── PLATA TAB ─────────────────────────────────────────────────────────────────

class _PlataTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _PlataTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.plati.length,
      onAdd: () async {
        final p = await Plata.showAddDialog(context, vm.rezervari);
        if (p != null) await vm.addPlata(p);
      },
      itemBuilder: (i) {
        final p = vm.plati[i];
        final d = '${p.dataPlata.day}/${p.dataPlata.month}/${p.dataPlata.year}';
        return ListTile(
          title: Text('Plata #${p.id} – ${p.suma} RON'),
          subtitle: Text('Rezervare: ${p.idRezervare} • $d • ${p.metoda}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await Plata.showEditDialog(context, p, vm.rezervari);
              if (updated != null) await vm.updatePlata(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge plata #${p.id}?'))
                await vm.deletePlata(p.id);
            }),
          ]),
        );
      },
    );
  }
}

// ── SERVICIU TAB ──────────────────────────────────────────────────────────────

class _ServiciuTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _ServiciuTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.servicii.length,
      onAdd: () async {
        final s = await Serviciu.showAddDialog(context);
        if (s != null) await vm.addServiciu(s);
      },
      itemBuilder: (i) {
        final s = vm.servicii[i];
        return ListTile(
          title: Text(s.denumire ?? ''),
          subtitle: Text('${s.pretServiciu.toStringAsFixed(2)} RON'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await Serviciu.showEditDialog(context, s);
              if (updated != null) await vm.updateServiciu(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge serviciu #${s.idServiciu}?'))
                await vm.deleteServiciu(s.idServiciu);
            }),
          ]),
        );
      },
    );
  }
}

// ── DEPARTAMENT TAB ───────────────────────────────────────────────────────────

class _DepartamentTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _DepartamentTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.departamente.length,
      onAdd: () async {
        final d = await Departament.showAddDialog(context);
        if (d != null) await vm.addDepartament(d);
      },
      itemBuilder: (i) {
        final d = vm.departamente[i];
        return ListTile(
          title: Text(d.numeDepartament ?? ''),
          subtitle: Text('ID: ${d.idDepartament}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await Departament.showEditDialog(context, d);
              if (updated != null) await vm.updateDepartament(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge departament #${d.idDepartament}?'))
                await vm.deleteDepartament(d.idDepartament);
            }),
          ]),
        );
      },
    );
  }
}

// ── TIP CAMERA TAB ────────────────────────────────────────────────────────────

class _TipCameraTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _TipCameraTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.tipuriCamera.length,
      onAdd: () async {
        final t = await TipCamera.showAddDialog(context);
        if (t != null) await vm.addTipCamera(t);
      },
      itemBuilder: (i) {
        final t = vm.tipuriCamera[i];
        return ListTile(
          title: Text(t.tipCamera ?? ''),
          subtitle: Text('${t.clasaConfort} • ${t.categorieCamera} • ${t.pret.toStringAsFixed(0)} RON'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () async {
              final updated = await TipCamera.showEditDialog(context, t);
              if (updated != null) await vm.updateTipCamera(updated);
            }),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () async {
              if (await _confirmG(context, 'Sterge tip camera #${t.idTipCamera}?'))
                await vm.deleteTipCamera(t.idTipCamera);
            }),
          ]),
        );
      },
    );
  }
}
