import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_flutter/ui/local/local_view_model.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';
import 'package:mvvm_flutter/models/client.dart';
import 'package:mvvm_flutter/models/rezervare.dart';
import 'package:mvvm_flutter/models/plata.dart';
import 'package:mvvm_flutter/models/serviciu.dart';
import 'package:mvvm_flutter/models/departament.dart';
import 'package:mvvm_flutter/models/tip_camera.dart';


class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen>
    with SingleTickerProviderStateMixin {
  final LocalViewModel _vm = GetIt.instance.get<LocalViewModel>();
  late TabController _tabController;
  bool _globalVisible = false;

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
    return ChangeNotifierProvider<LocalViewModel>.value(
      value: _vm,
      child: Consumer<LocalViewModel>(
        builder: (ctx, vm, _) => Column(
          children: [
            _buildHeader(vm),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _HotelTab(vm: vm),
                  _AngajatTab(vm: vm),
                  _CameraTab(vm: vm),
                  _ClientTab(vm: vm),
                  _RezervareTab(vm: vm),
                  _PlataTab(vm: vm),
                  _ServiciuTab(vm: vm),
                  _DepartamentTab(vm: vm),
                  _TipCameraTab(vm: vm),
                ],
              ),
            ),
            _buildGlobalCard(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(LocalViewModel vm) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Baza de date locala: ',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              DropdownButton<String?>(
                value: vm.oras,
                onChanged: (v) {
                  if (v != null) vm.setOras(v);
                },
                items: ['Bucuresti', 'Constanta']
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
              if (vm.loading)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
            ],
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalCard(LocalViewModel vm) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            dense: true,
            title: const Text('Efecte la nivel global',
                style: TextStyle(fontWeight: FontWeight.w600)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Actualizeaza'),
                  onPressed: () async {
                    await vm.refreshGlobal();
                    setState(() => _globalVisible = true);
                  },
                ),
                IconButton(
                  icon: Icon(
                      _globalVisible ? Icons.expand_less : Icons.expand_more),
                  onPressed: () =>
                      setState(() => _globalVisible = !_globalVisible),
                ),
              ],
            ),
          ),
          if (_globalVisible)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Text(
                'Hoteluri: ${vm.globalHotels.length}  |  '
                'Angajati: ${vm.globalAngajati.length}  |  '
                'Camere: ${vm.globalCamere.length}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

// ── HELPERS ───────────────────────────────────────────────────────────────────

Future<bool> _confirm(BuildContext context, String? message) async {
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
    body: ListView.builder(
        itemCount: count, itemBuilder: (ctx, i) => itemBuilder(i)),
    floatingActionButton:
        FloatingActionButton(onPressed: onAdd, child: const Icon(Icons.add)),
  );
}

// ── HOTEL TAB ─────────────────────────────────────────────────────────────────

class _HotelTab extends StatelessWidget {
  final LocalViewModel vm;
  const _HotelTab({required this.vm});

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
          subtitle: Text(
              '${h.oras} • ${h.nrStele != null ? '${h.nrStele}★' : '–'} '
              '• cap: ${h.capacitate ?? '–'}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated = await Hotel.showEditDialog(context, h);
                if (updated != null) await vm.updateHotel(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(context, 'Sterge hotel #${h.idHotel}?'))
                  await vm.deleteHotel(h.idHotel);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── ANGAJAT TAB ───────────────────────────────────────────────────────────────

class _AngajatTab extends StatelessWidget {
  final LocalViewModel vm;
  const _AngajatTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.angajati.length,
      onAdd: () async {
        final defaultHotel =
            vm.hotels.isNotEmpty ? vm.hotels.first.idHotel : 1;
        final a = await AngajatGlobal.showAddDialog(context, defaultHotel);
        if (a != null) await vm.addAngajat(a);
      },
      itemBuilder: (i) {
        final a = vm.angajati[i];
        return ListTile(
          title: Text('${a.nume} ${a.prenume}'),
          subtitle: Text('${a.functie ?? 'N/A'} • Hotel ${a.idHotel}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated = await AngajatGlobal.showEditDialog(context, a);
                if (updated != null) await vm.updateAngajat(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(
                    context, 'Sterge angajat #${a.idAngajat}?'))
                  await vm.deleteAngajat(a.idAngajat);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── CAMERA TAB ────────────────────────────────────────────────────────────────

class _CameraTab extends StatelessWidget {
  final LocalViewModel vm;
  const _CameraTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _buildTab(
      loading: vm.loading,
      error: vm.error,
      count: vm.camere.length,
      onAdd: () async {
        final defaultHotel =
            vm.hotels.isNotEmpty ? vm.hotels.first.idHotel : 1;
        final c = await CameraLocal.showAddDialog(context, defaultHotel);
        if (c != null) await vm.addCamera(c);
      },
      itemBuilder: (i) {
        final c = vm.camere[i];
        return ListTile(
          title: Text('Camera ${c.nrCamera}'),
          subtitle: Text('Tip: ${c.idTipCamera} • Hotel: ${c.idHotel}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated = await CameraLocal.showEditDialog(context, c);
                if (updated != null) await vm.updateCamera(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(context, 'Sterge camera #${c.idCamera}?'))
                  await vm.deleteCamera(c.idCamera);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── CLIENT TAB ────────────────────────────────────────────────────────────────

class _ClientTab extends StatelessWidget {
  final LocalViewModel vm;
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
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated = await Client.showEditDialog(context, c);
                if (updated != null) await vm.updateClient(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(context, 'Sterge client #${c.id}?'))
                  await vm.deleteClient(c.id);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── REZERVARE TAB ─────────────────────────────────────────────────────────────

class _RezervareTab extends StatelessWidget {
  final LocalViewModel vm;
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
        final s =
            '${r.dataStart.day}/${r.dataStart.month}/${r.dataStart.year}';
        final f =
            '${r.dataFinal.day}/${r.dataFinal.month}/${r.dataFinal.year}';
        return ListTile(
          title: Text('Rezervare #${r.id}'),
          subtitle: Text('Client: ${r.clientId} • $s → $f'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated =
                    await Rezervare.showEditDialog(context, r, vm.clienti);
                if (updated != null) await vm.updateRezervare(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(context, 'Sterge rezervare #${r.id}?'))
                  await vm.deleteRezervare(r.id);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── PLATA TAB ─────────────────────────────────────────────────────────────────

class _PlataTab extends StatelessWidget {
  final LocalViewModel vm;
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
        final d =
            '${p.dataPlata.day}/${p.dataPlata.month}/${p.dataPlata.year}';
        return ListTile(
          title: Text('Plata #${p.id} – ${p.suma} RON'),
          subtitle: Text('Rezervare: ${p.idRezervare} • $d • ${p.metoda}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated =
                    await Plata.showEditDialog(context, p, vm.rezervari);
                if (updated != null) await vm.updatePlata(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(context, 'Sterge plata #${p.id}?'))
                  await vm.deletePlata(p.id);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── SERVICIU TAB ──────────────────────────────────────────────────────────────

class _ServiciuTab extends StatelessWidget {
  final LocalViewModel vm;
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
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated = await Serviciu.showEditDialog(context, s);
                if (updated != null) await vm.updateServiciu(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(
                    context, 'Sterge serviciu #${s.idServiciu}?'))
                  await vm.deleteServiciu(s.idServiciu);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── DEPARTAMENT TAB ───────────────────────────────────────────────────────────

class _DepartamentTab extends StatelessWidget {
  final LocalViewModel vm;
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
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated = await Departament.showEditDialog(context, d);
                if (updated != null) await vm.updateDepartament(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(
                    context, 'Sterge departament #${d.idDepartament}?'))
                  await vm.deleteDepartament(d.idDepartament);
              },
            ),
          ]),
        );
      },
    );
  }
}

// ── TIP CAMERA TAB ────────────────────────────────────────────────────────────

class _TipCameraTab extends StatelessWidget {
  final LocalViewModel vm;
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
          subtitle: Text(
              '${t.clasaConfort} • ${t.categorieCamera} • ${t.pret.toStringAsFixed(0)} RON'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () async {
                final updated = await TipCamera.showEditDialog(context, t);
                if (updated != null) await vm.updateTipCamera(updated);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () async {
                if (await _confirm(
                    context, 'Sterge tip camera #${t.idTipCamera}?'))
                  await vm.deleteTipCamera(t.idTipCamera);
              },
            ),
          ]),
        );
      },
    );
  }
}
