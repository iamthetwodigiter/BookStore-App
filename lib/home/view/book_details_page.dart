import 'package:bookstore/home/widgets/custom_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookstore/providers/home_page_provider.dart';
import 'package:flutter/services.dart';

class BookDetailsPage extends ConsumerWidget {
  final String bookID;
  const BookDetailsPage({
    super.key,
    required this.bookID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookbyID = ref.watch(getByIDProvider(bookID));
    final size = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Container(
          color: CupertinoColors.lightBackgroundGray,
          height: size.height,
          child: bookbyID.when(
            loading: () {
              return const Center(child: CupertinoActivityIndicator());
            },
            error: (error, stackTrace) {
              return Center(child: Text(error.toString()));
            },
            data: (data) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(icon: CupertinoIcons.back),
                            CustomButton(icon: CupertinoIcons.heart),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.55,
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: CupertinoColors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: size.height * 0.12),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${data['title']}   ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        fontFamily: 'SFPro',
                                        color: CupertinoColors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "[${data['publishYear']}]",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 23,
                                        fontFamily: 'SFPro',
                                        color: CupertinoColors.systemBrown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "by ${data['author']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 23,
                                    fontFamily: 'SFPro',
                                    color: CupertinoColors.systemBrown,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: size.height * 0.2,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Summary:   ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          fontFamily: 'SFPro',
                                          color: CupertinoColors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: data['summary'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          fontFamily: 'SFPro',
                                          color: CupertinoColors.systemBrown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: data['id']));
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: const Text(
                                              "ID copied to clipboard"),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: const Text("OK"),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "ID:   ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          fontFamily: 'SFPro',
                                          color: CupertinoColors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: data['id'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          fontFamily: 'SFPro',
                                          color: CupertinoColors.systemBrown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: size.height * 0.12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: data['image']['url'],
                        height: 300,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(
                              CupertinoIcons.exclamationmark_circle_fill,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
