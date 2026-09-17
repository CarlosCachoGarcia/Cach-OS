import 'package:flutter/material.dart';

import '../../core/dependencies.dart';
import '../../widgets/common.dart';
import 'audit_view_model.dart';

class UsersScreen extends StatefulWidget {
  final Dependencies deps;
  const UsersScreen(this.deps, {super.key});
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final vm = AuditViewModel(widget.deps.audit, widget.deps.products);
  @override
  void initState() {
    super.initState();
    vm.loadUsers();
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
          appBar: AppBar(title: const Text('Directorio de usuarios')),
          body: vm.busy
              ? const Center(child: CircularProgressIndicator())
              : vm.error != null
                  ? ErrorPanel(vm.error!, vm.loadUsers)
                  : vm.users.isEmpty
                      ? const Center(
                          child: Text('No hay usuarios registrados.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.users.length,
                          itemBuilder: (_, i) {
                            final u = vm.users[i];
                            return Card(
                              child: ExpansionTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person_outline),
                                ),
                                title: Text(u.fullName),
                                subtitle: Text('@${u.username}'),
                                childrenPadding: const EdgeInsets.all(16),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Correo: ${u.email}\nTeléfono: ${u.phone}\nDirección: ${u.address.street} ${u.address.number}, ${u.address.city}\nCP: ${u.address.zipcode}',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
        ),
      );
}
