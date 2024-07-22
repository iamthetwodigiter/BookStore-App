import 'package:bookstore/home/model/api_calls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  HomePageNotifier() : super(const AsyncLoading());

  Future<void> setData() async {
    try {
      final data = await getAllBooks();
      state = AsyncValue.data(data);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

final homePageProvider =
    StateNotifierProvider<HomePageNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  return HomePageNotifier();
});

class GetByIDNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final String _id;
  GetByIDNotifier(this._id) : super(const AsyncLoading());

  Future<void> get() async {
    try {
      final data = await getByID(_id);
      state = AsyncValue.data(data);
    } catch (error) {
      state = AsyncValue.error(
          const {'error': 'Error occured while fetching the books'},
          StackTrace.current);
    }
  }
}

final getByIDProvider = StateNotifierProvider.family<GetByIDNotifier,
    AsyncValue<Map<String, dynamic>>, String>((ref, id) {
  return GetByIDNotifier(id);
});

class SearchByTitleNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final String _title;
  SearchByTitleNotifier(this._title) : super(const AsyncLoading());

  Future<void> search() async {
    try {
      final data = await searchByTitle(_title);
      state = AsyncValue.data(data);
    } catch (error) {
      state = AsyncValue.error(
          const {'error': 'Error occured while fetching your book'},
          StackTrace.current);
    }
  }
}

final searchByTitleProvider = StateNotifierProvider.family<
    SearchByTitleNotifier,
    AsyncValue<Map<String, dynamic>>,
    String>((ref, title) {
  return SearchByTitleNotifier(title);
});
