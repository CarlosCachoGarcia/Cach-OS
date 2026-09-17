import 'package:flutter/material.dart';

import '../../core/dependencies.dart';
import '../../models/cart.dart';
import '../../widgets/common.dart';

class CartScreen extends StatelessWidget {
  final Dependencies deps;
  const CartScreen(this.deps, {super.key});
  Future<void> change(BuildContext context, CartLine line, int quantity) async {
    final ok = await deps.cart.change(line, quantity);
    if (!context.mounted || ok) return;
    message(context, deps.cart.error!, error: true);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: deps.cart,
        builder: (_, child) {
          final vm = deps.cart;
          return Scaffold(
            appBar: AppBar(title: const Text('Mi carrito')),
            body: Column(
              children: [
                if (vm.busy) const LinearProgressIndicator(),
                Expanded(
                  child: vm.lines.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_basket_outlined, size: 64),
                                SizedBox(height: 16),
                                Text(
                                  'Tu carrito está vacío, explora el catálogo',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.lines.length,
                          itemBuilder: (context, index) {
                            final line = vm.lines[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line.product.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                        '${money(line.product.price)} por unidad'),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 8,
                                      children: [
                                        IconButton(
                                          tooltip: 'Disminuir cantidad',
                                          onPressed: vm.busy
                                              ? null
                                              : () => change(
                                                    context,
                                                    line,
                                                    line.quantity - 1,
                                                  ),
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),
                                        Text('${line.quantity}'),
                                        IconButton(
                                          tooltip: 'Aumentar cantidad',
                                          onPressed: vm.busy
                                              ? null
                                              : () => change(
                                                    context,
                                                    line,
                                                    line.quantity + 1,
                                                  ),
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                        Text(money(line.subtotalCents / 100)),
                                        IconButton(
                                          tooltip: 'Eliminar artículo',
                                          onPressed: vm.busy
                                              ? null
                                              : () => change(context, line, 0),
                                          icon:
                                              const Icon(Icons.delete_outline),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total: ${money(vm.totalCents / 100)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: vm.lines.isEmpty || vm.busy
                              ? null
                              : () => showDialog<void>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Simulación de pago'),
                                      content: Text(
                                        'Total: ${money(vm.totalCents / 100)}. Esta demostración no realiza ningún cobro.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Entendido'),
                                        ),
                                      ],
                                    ),
                                  ),
                          child: const Text('Proceder al pago'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}
