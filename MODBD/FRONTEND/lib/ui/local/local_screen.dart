import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_flutter/ui/local/local_view_model.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                    .map((o) =>
                        DropdownMenuItem(value: o, child: Text(o)))
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
            tabs: const [
              Tab(text: 'Hoteluri'),
              Tab(text: 'Angajati'),
              Tab(text: 'Camere'),
            ],
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
                  icon: Icon(_globalVisible
                      ? Icons.expand_less
                      : Icons.expand_more),
                  onPressed: () =>
                      setState(() => _globalVisible = !_globalVisible),
                ),
              ],
            ),
          ),
          if (_globalVisible)
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 12),
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

// ── HOTEL TAB ─────────────────────────────────────────────────────────────────

class _HotelTab extends StatelessWidget {
  final LocalViewModel vm;
  const _HotelTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.loading) return const Center(child: CircularProgressIndicator());
    if (vm.error != null) return Center(child: Text('Eroare: ${vm.error}'));
    return Scaffold(
      body: ListView.builder(
        itemCount: vm.hotels.length,
        itemBuilder: (ctx, i) {
          final h = vm.hotels[i];
          return ListTile(
            title: Text(h.numeHotel ?? ''),
            subtitle: Text(
                '${h.oras} • ${h.nrStele != null ? '${h.nrStele}★' : '–'} '
                '• cap: ${h.capacitate ?? '–'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    final updated = await Hotel.showEditDialog(ctx, h);
                    if (updated != null) await vm.updateHotel(updated);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () async {
                    if (await _confirm(ctx, 'Sterge hotel #${h.idHotel}?')) {
                      await vm.deleteHotel(h.idHotel);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final h = await Hotel.showAddDialog(context);
          if (h != null) await vm.addHotel(h);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── ANGAJAT TAB ───────────────────────────────────────────────────────────────

class _AngajatTab extends StatelessWidget {
  final LocalViewModel vm;
  const _AngajatTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.loading) return const Center(child: CircularProgressIndicator());
    if (vm.error != null) return Center(child: Text('Eroare: ${vm.error}'));
    return Scaffold(
      body: ListView.builder(
        itemCount: vm.angajati.length,
        itemBuilder: (ctx, i) {
          final a = vm.angajati[i];
          return ListTile(
            title: Text('${a.nume} ${a.prenume}'),
            subtitle:
                Text('${a.functie ?? 'N/A'} • Hotel ${a.idHotel}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    final updated =
                        await AngajatGlobal.showEditDialog(ctx, a);
                    if (updated != null) await vm.updateAngajat(updated);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () async {
                    if (await _confirm(
                        ctx, 'Sterge angajat #${a.idAngajat}?')) {
                      await vm.deleteAngajat(a.idAngajat);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final defaultHotel =
              vm.hotels.isNotEmpty ? vm.hotels.first.idHotel : 1;
          final a =
              await AngajatGlobal.showAddDialog(context, defaultHotel);
          if (a != null) await vm.addAngajat(a);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── CAMERA TAB ────────────────────────────────────────────────────────────────

class _CameraTab extends StatelessWidget {
  final LocalViewModel vm;
  const _CameraTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.loading) return const Center(child: CircularProgressIndicator());
    if (vm.error != null) return Center(child: Text('Eroare: ${vm.error}'));
    return Scaffold(
      body: ListView.builder(
        itemCount: vm.camere.length,
        itemBuilder: (ctx, i) {
          final c = vm.camere[i];
          return ListTile(
            title: Text('Camera ${c.nrCamera}'),
            subtitle:
                Text('Tip: ${c.idTipCamera} • Hotel: ${c.idHotel}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    final updated =
                        await CameraLocal.showEditDialog(ctx, c);
                    if (updated != null) await vm.updateCamera(updated);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () async {
                    if (await _confirm(
                        ctx, 'Sterge camera #${c.idCamera}?')) {
                      await vm.deleteCamera(c.idCamera);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final defaultHotel =
              vm.hotels.isNotEmpty ? vm.hotels.first.idHotel : 1;
          final c =
              await CameraLocal.showAddDialog(context, defaultHotel);
          if (c != null) await vm.addCamera(c);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
