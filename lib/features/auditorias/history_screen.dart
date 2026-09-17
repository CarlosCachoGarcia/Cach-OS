import 'package:flutter/material.dart';

import '../../core/dependencies.dart';
import '../../widgets/common.dart';
import 'audit_view_model.dart';

class HistoryScreen extends StatefulWidget {
  final Dependencies deps;
  const HistoryScreen(this.deps, {super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final vm = AuditViewModel(widget.deps.audit, widget.deps.products);
  @override
  void initState() {
    super.initState();
    vm.loadCarts();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: vm,
        builder: (_, child) => Scaffold(
          appBar: AppBar(title: const Text('Histórico de carritos')),
          body: vm.busy
              ? const Center(child: CircularProgressIndicator())
              : vm.error != null
                  ? ErrorPanel(vm.error!, vm.loadCarts)
                  : vm.carts.isEmpty
                      ? const Center(
                          child: Text('No hay carritos registrados.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.carts.length,
                          itemBuilder: (_, i) {
                            final c = vm.carts[i];
                            return Card(
                              child: ExpansionTile(
                                leading:
                                    const Icon(Icons.receipt_long_outlined),
                                title: Text(
                                    'Carrito #${c.id} · Usuario #${c.userId}'),
                                subtitle: Text(c.date.split('T').first),
                                children: [
                                  for (final line in c.quantities.entries)
                                    ListTile(
                                      title: Text(
                                        vm.titles[line.key] ??
                                            'Producto #${line.key}',
                                      ),
                                      subtitle: Text('ID: ${line.key}'),
                                      trailing: Text('× ${line.value}'),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
        ),
      );
}
