import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/acts_repository.dart';
import 'act_models.dart';

part 'acts_providers.g.dart';

/// Loads a section by composite key `actId__sectionId`.
/// Seeds the act into sqflite on first access if needed.
@riverpod
Future<SectionModel?> sectionDetail(
  SectionDetailRef ref,
  String compositeId,
) async {
  final parts = compositeId.split('__');
  final actId = parts[0];
  final id = parts[1];

  await ActsRepository().seedIfNeeded(actId);
  final local = await ActsRepository().getSection(id);
  if (local == null) return null;
  return SectionModel(
    id: local.id,
    sectionNo: local.sectionNo,
    title: local.title,
    content: local.content,
    relatedSections: local.relatedSections,
  );
}
