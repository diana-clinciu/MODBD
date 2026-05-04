import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_flutter/ui/global/global_view_model.dart';
import 'package:mvvm_flutter/models/hotel.dart';
import 'package:mvvm_flutter/models/angajat_global.dart';
import 'package:mvvm_flutter/models/camera_local.dart';

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
        tabs: const [
          Tab(text: 'Hoteluri'),
          Tab(text: 'Angajati'),
          Tab(text: 'Camere'),
        ],
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
        Text(
          'Entitate: $entitate  #$id',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FragmentCard(
                title: 'Fragment Bucuresti',
                data: buc,
                color: Colors.blue.shade50,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _FragmentCard(
                title: 'Fragment Constanta',
                data: con,
                color: Colors.green.shade50,
              ),
            ),
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

  const _FragmentCard(
      {required this.title, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 4),
          if (data == null)
            const Text('Nu exista',
                style: TextStyle(color: Colors.red, fontSize: 12))
          else if (data is Map)
            ...(data as Map<String?, dynamic>)
                .entries
                .map((e) => Text('${e.key}: ${e.value}',
                    style: const TextStyle(fontSize: 11)))
                .toList()
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
                '${h.oras} • ${h.nrStele != null ? '${h.nrStele}★' : '–'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.search, size: 20),
                  tooltip: 'Verifica propagare',
                  onPressed: () => vm.verificaHotel(h.idHotel),
                ),
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
                    if (await _confirm(ctx, 'Sterge hotel global #${h.idHotel}?')) {
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

class _AngajatGlobalTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _AngajatGlobalTab({required this.vm});

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
            subtitle: Text(
                '${a.functie ?? 'N/A'} • Hotel ${a.idHotel} • ${a.cnp}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.search, size: 20),
                  tooltip: 'Verifica propagare',
                  onPressed: () => vm.verificaAngajat(a.idAngajat),
                ),
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
          final a = await AngajatGlobal.showAddDialog(context);
          if (a != null) await vm.addAngajat(a);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── CAMERA TAB ────────────────────────────────────────────────────────────────

class _CameraGlobalTab extends StatelessWidget {
  final GlobalViewModel vm;
  const _CameraGlobalTab({required this.vm});

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
                  icon: const Icon(Icons.search, size: 20),
                  tooltip: 'Verifica propagare',
                  onPressed: () => vm.verificaCamera(c.idCamera),
                ),
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
          final c = await CameraLocal.showAddDialog(context, 1);
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
