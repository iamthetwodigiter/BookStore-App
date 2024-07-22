import 'package:bookstore/home/view/book_details_page.dart';
import 'package:bookstore/providers/home_page_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultPage extends ConsumerWidget {
  final String title;
  const SearchResultPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookData = ref.watch(searchByTitleProvider(title));
    final size = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              previousPageTitle: 'Home',
              largeTitle: Text('Search Results'),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: CupertinoColors.lightBackgroundGray,
                height: size.height,
                child: bookData.when(
                  loading: () {
                    return const Center(child: CupertinoActivityIndicator());
                  },
                  error: (error, stackTrace) {
                    return Center(child: Text(error.toString()));
                  },
                  data: (data) {
                    return data['data'].isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'Sorry, no search results found!!',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SFPro',
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: bookData.value!['data'].length,
                            itemBuilder: (context, index) {
                              final book =
                                  bookData.value!['data'].elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CupertinoListTile(
                                    backgroundColor: CupertinoColors.systemBrown
                                        .withAlpha(100),
                                    padding: const EdgeInsets.all(20),
                                    title: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: book['image']['url'],
                                          height: 100,
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            book['title'],
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => BookDetailsPage(
                                            bookID: book['id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
