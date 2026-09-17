import 'package:flutter/material.dart';

import '../../core/dependencies.dart';
import '../../models/app_user.dart';
import '../../widgets/common.dart';
import 'catalog_view_model.dart';

class CatalogScreen extends StatefulWidget {
  final Dependencies deps;
  const CatalogScreen(this.deps, {super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final vm = CatalogViewModel(widget.deps.products);
  @override
  void initState() {
    super.initState();
    vm.load();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    final ok = await widget.deps.auth.logout();
    if (!mounted) return;
    if (!ok) {
      message(context, widget.deps.auth.error!, error: true);
      return;
    }
    widget.deps.cart.clear();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.deps.session;
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Tienda Aula'),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                ListTile(
                  title: Text(s.user?.fullName ?? ''),
                  subtitle: Text(s.role?.label ?? ''),
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.storefront),
                  title: const Text('Catálogo'),
                  onTap: () => Navigator.pop(context),
                ),
                if (s.canManage)
                  ListTile(
                    leading: const Icon(Icons.add_box_outlined),
                    title: const Text('Nuevo producto'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/product/new');
                    },
                  ),
                const Divider(),
                ListenableBuilder(
                  listenable: widget.deps.auth,
                  builder: (_, child) => ListTile(
                    enabled: !widget.deps.auth.busy && !widget.deps.cart.busy,
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar sesión'),
                    onTap: logout,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: s.canManage
            ? FloatingActionButton.extended(
                onPressed: () => Navigator.pushNamed(context, '/product/new'),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo producto'),
              )
            : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                'Explora el catálogo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final category in <String?>[null, ...vm.categories])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category ?? 'Ver todos'),
                        selected: vm.category == category,
                        onSelected: vm.busy ? null : (_) => vm.load(category),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: vm.busy
                  ? const Center(child: CircularProgressIndicator())
                  : vm.error != null
                      ? ErrorPanel(vm.error!, () => vm.load(vm.category))
                      : vm.products.isEmpty
                          ? const Center(
                              child:
                                  Text('No hay productos en esta categoría.'),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await vm.load(vm.category);
                              },
                              child: LayoutBuilder(
                                builder: (_, constraints) => GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: constraints.maxWidth < 420
                                        ? 1
                                        : constraints.maxWidth < 750
                                            ? 2
                                            : 3,
                                    mainAxisExtent: 300,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: vm.products.length,
                                  itemBuilder: (context, i) {
                                    final p = vm.products[i];
                                    return Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          '/detail',
                                          arguments: p.id,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                  child: ProductImage(p.image)),
                                              const SizedBox(height: 16),
                                              Text(
                                                p.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Spacer(),
                                              Text(
                                                money(p.price),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
