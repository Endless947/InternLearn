import 'package:nexus/features/search/data/models/search_result_item.dart';
import 'package:nexus/features/search/services/search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
FutureOr<List<SearchResultItem>> contentSearch(Ref ref, String query) {
  return SearchService.searchContent(query);
}
