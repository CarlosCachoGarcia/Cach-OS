import 'package:flutter/material.dart';

import '../../core/dependencies.dart';
import '../../models/product.dart';
import '../../widgets/common.dart';
import 'detail_view_model.dart';

class DetailScreen extends StatefulWidget {
  final Dependencies deps;
  final int id;
  const DetailScreen(this.deps, this.id, {super.key});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final vm = DetailViewModel(widget.deps.products);
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final ok = await vm.load(widget.id);
    if (!mounted || ok) return;
    message(context, 'Producto no disponible', error: true);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  Future<void> edit() async {
    final result = await Navigator.pushNamed(
      context,
      '/product/edit',
      arguments: vm.product,
    );
    if (mounted && result is Product) vm.replace(result);
  }

  Future<void> remove() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text('¿Estás seguro de eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    final ok = await vm.delete();
    if (!mounted) return;
    message(
      context,
      ok ? 'Producto eliminado (Simulación)' : vm.error!,
      error: !ok,
    );
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          final p = vm.product;
          return Scaffold(
            appBar: AppBar(title: const Text('Detalle del producto')),
            body: p == null || vm.busy
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          ProductImage(p.image, height: 260),
                          const SizedBox(height: 24),
                          Text(
                            p.category,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            p.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            money(p.price),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 20),
                          Text(p.description),
                          const SizedBox(height: 28),
                          if (widget.deps.session.canManage)
                            Wrap(
                              spacing: 12,
                              children: [
                                FilledButton.icon(
                                  onPressed: edit,
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text('Editar'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: remove,
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Eliminar'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      );
}
