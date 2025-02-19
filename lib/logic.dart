import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

Client getClient(String name) {
  return Client(name, databaseBuilder: (_) async {
    final dir = await getApplicationSupportDirectory();

    final db = HiveCollectionsDatabase("LOCALDB", dir.path);

    await db.open();
    return db;
  });
}

Client? clientInfo;

bool clientInfoInited() => (clientInfo == null) ? false : true;
