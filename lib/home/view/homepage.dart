import 'package:bookstore/home/view/book_details_page.dart';
import 'package:bookstore/home/view/search_result_page.dart';
import 'package:bookstore/providers/home_page_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String searchMode = 'Title';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageProvider.notifier).setData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final booksData = ref.watch(homePageProvider);
    return CupertinoPageScaffold(
      child: booksData.when(
        loading: () => const Center(
          child: CupertinoActivityIndicator(),
        ),
        error: (error, stack) => Center(
          child:
              Text('Error occurred while fetching data!\n${error.toString()}'),
        ),
        data: (data) => CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              backgroundColor: CupertinoColors.white,
              largeTitle: Text('Home'),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.read(homePageProvider.notifier).setData();
              },
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CupertinoTextField(
                    decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemBrown),
                        borderRadius: BorderRadius.circular(15)),
                    prefix: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Icon(CupertinoIcons.search),
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                        color: CupertinoColors.systemBrown.withAlpha(100),
                        padding: EdgeInsets.zero,
                        child: Text(
                          searchMode,
                          style: const TextStyle(
                            color: CupertinoColors.systemBrown,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            searchMode =
                                (searchMode == 'Title' ? 'ID' : 'Title');
                          });
                        },
                      ),
                    ),
                    placeholder: 'Search by',
                    placeholderStyle: const TextStyle(
                        color: CupertinoColors.systemBrown, fontSize: 20),
                    controller: _textEditingController,
                    onSubmitted: (value) {
                      if (searchMode == 'Title') {
                        ref
                            .read(searchByTitleProvider(value.trimRight())
                                .notifier)
                            .search();
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) =>
                              SearchResultPage(title: value.trimRight()),
                        ));
                      } else if (searchMode == 'ID') {
                        ref
                            .read(getByIDProvider(value.trimRight()).notifier)
                            .get();
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) =>
                              BookDetailsPage(bookID: value.trimRight()),
                        ));
                      }
                      _textEditingController.clear();
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                height: size.height * 0.25,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    viewportFraction: 0.8,
                  ),
                  items: data['data']
                      .take(5)
                      .map<Widget>((bookData) => GestureDetector(
                            onTap: () {
                              final bookID = bookData['id'];
                              ref.read(getByIDProvider(bookID).notifier).get();
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) =>
                                    BookDetailsPage(bookID: bookID),
                              ));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    bookData['image']['url'],
                                    fit: BoxFit.cover,
                                    width: 1000,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(CupertinoIcons
                                          .exclamationmark_circle_fill);
                                    },
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: CupertinoColors.systemBrown
                                          .withAlpha(200),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Text(
                                        bookData['title'],
                                        style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontSize: 20,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Text(
                  'Popular Books',
                  style: TextStyle(
                    color: CupertinoColors.systemBrown,
                    fontSize: 25,
                    fontFamily: 'SFPro',
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          final bookData = data['data'][3 * index];
                          final bookID = bookData['id'];
                          ref.read(getByIDProvider(bookID).notifier).get();
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                BookDetailsPage(bookID: bookID),
                          ));
                        },
                        child: _buildBookRow(size, data['data'][3 * index]),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          final bookData = data['data'][3 * index + 1];
                          final bookID = bookData['id'];
                          ref.read(getByIDProvider(bookID).notifier).get();
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                BookDetailsPage(bookID: bookID),
                          ));
                        },
                        child: _buildBookRow(size, data['data'][3 * index + 1]),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          final bookData = data['data'][3 * index + 2];
                          final bookID = bookData['id'];
                          ref.read(getByIDProvider(bookID).notifier).get();
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                BookDetailsPage(bookID: bookID),
                          ));
                        },
                        child: _buildBookRow(size, data['data'][3 * index + 2]),
                      ),
                    ],
                  );
                },
                childCount: (data['data'].length) ~/ 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildBookRow(Size size, Map<String, dynamic> bookData) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.2,
          width: size.width * 0.3,
          child: Image(
            image: NetworkImage(bookData['image']['url']),
            width: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(CupertinoIcons.exclamationmark_circle_fill);
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          width: size.width * 0.3,
          child: Text(
            bookData['title'],
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
