import '../core/api_client.dart';
import '../core/session.dart';
import '../models/app_user.dart';

class AuditRepository {
  final ApiClient api;
  final Session session;
  AuditRepository(this.api, this.session);
  Future<List<AppUser>> users() async {
    session.require(session.canAudit);
    return (await api.request('GET', '/users') as List)
        .map((j) => AppUser.fromJson(j))
        .toList();
  }
}
