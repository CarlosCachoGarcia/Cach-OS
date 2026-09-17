import 'package:flutter/material.dart';

import '../../core/dependencies.dart';
import '../../models/product.dart';
import '../../widgets/common.dart';
import 'product_form_view_model.dart';

class ProductFormScreen extends StatefulWidget {
  final Dependencies deps;
  final Product? product;
  const ProductFormScreen(this.deps, {this.product, super.key});
  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final form = GlobalKey<FormState>();
  late final vm = ProductFormViewModel(widget.deps.products);
  late final title = TextEditingController(text: widget.product?.title);
  late final price = TextEditingController(
    text: widget.product?.price.toString(),
  );
  late final description = TextEditingController(
    text: widget.product?.description,
  );
  late final category = TextEditingController(text: widget.product?.category);
  late final image = TextEditingController(text: widget.product?.image);
  @override
  void dispose() {
    for (final c in [title, price, description, category, image]) {
      c.dispose();
    }
    vm.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    final ok = await vm.save(
      Product(
        id: widget.product?.id ?? 0,
        title: title.text.trim(),
        price: double.parse(price.text.replaceAll(',', '.')),
        description: description.text.trim(),
        category: category.text.trim(),
        image: image.text.trim(),
      ),
      widget.product == null,
    );
    if (!mounted) return;
    if (!ok) {
      message(context, vm.error!, error: true);
      return;
    }
    if (widget.product != null) {
      message(context, 'Producto actualizado (Simulación)');
      Navigator.pop(context, vm.saved);
    } else {
      message(context, 'Producto creado con ID ${vm.saved!.id} (Simulación)');
      for (final c in [title, price, description, category, image]) {
        c.clear();
      }
      form.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: vm,
        builder: (_, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              widget.product == null ? 'Nuevo producto' : 'Editar producto',
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: form,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text('Completa la información del artículo.'),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: title,
                      enabled: !vm.busy,
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: ProductFormViewModel.requiredText,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: price,
                      enabled: !vm.busy,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Precio'),
                      validator: ProductFormViewModel.price,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: description,
                      enabled: !vm.busy,
                      maxLines: 4,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      validator: ProductFormViewModel.requiredText,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: category,
                      enabled: !vm.busy,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      validator: ProductFormViewModel.requiredText,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: image,
                      enabled: !vm.busy,
                      decoration:
                          const InputDecoration(labelText: 'URL de imagen'),
                      validator: ProductFormViewModel.imageUrl,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: vm.busy ? null : save,
                      child: Text(vm.busy ? 'Guardando…' : 'Guardar producto'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
