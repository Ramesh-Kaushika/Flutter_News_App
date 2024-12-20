import 'package:flutter/material.dart';
import 'package:news_app/models/category_data.dart';
import 'package:news_app/services/news_api_service.dart';
import 'package:news_app/views/article_details_screen.dart';
import 'package:news_app/views/category_screen.dart';

import '../models/article.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  List<NewsModel> articles = [];
  List<CategoryModel> categories = [];
  bool isLoadin = true;

  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  String selectedSortBy = 'relevancy'; // Default sorting

  getNews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews(
      country: 'us',
      query: searchTerm,

      sortBy: selectedSortBy, // Pass selected sortBy
    );
    articles = newsApi.dataStore;
    setState(() {
      isLoadin = false;
    });
  }

  @override
  void initState() {
    categories = getCategories();
    getNews();
    super.initState();
  }

  void refreshNews() {
    setState(() {
      isLoadin = true; // Show loading indicator
    });
    getNews(); // Re-fetch the news articles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isSearching ? searchAppBar() : appBar(),
      body: isLoadin
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : articles.isEmpty
              ? const Center(
                  child: Text(
                    "No articles found. Try a different search term.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // for category selection
                      Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectedCategoryNews(
                                      category: category.categoryName!,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.2), // Shadow color
                                          blurRadius:
                                              10, // Softness of the shadow
                                          offset: const Offset(
                                              0, 4), // Shadow position (x, y)
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.red),
                                  child: Center(
                                    child: Text(
                                      category.categoryName!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 15),
                            child: const Text(
                              "Top Headlines",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold, // Makes the text bold
                                fontSize: 21,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 88,
                          ),
                          sortDropdown()
                        ],
                      ),
                      // for home screen news
                      ListView.builder(
                        itemCount: articles.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetail(newsModel: article),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Background color of the container
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Shadow color
                                    blurRadius: 10, // Softness of the shadow
                                    offset: const Offset(
                                        0, 4), // Shadow position (x, y)
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      article.urlToImage!,
                                      height: 250,
                                      width: 400,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, right: 6, bottom: 6),
                                    child: Text(
                                      article.title!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  // const Divider(thickness: 2),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  searchAppBar() {
    return AppBar(
      title: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: const InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.black38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            )),
      ),
      leading: IconButton(
        onPressed: () {
          setState(() {
            isSearching = false;
            searchTerm = null;
            searchController.text = "";
            getNews();
          });
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                searchTerm = searchController.text;
                getNews();
              });
            },
            icon: const Icon(
              Icons.search,
              size: 30,
            ))
      ],
    );
  }

  appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          setState(() {
            isSearching = true;
          });
        },
        icon: const Icon(
          Icons.search,
          size: 30,
        ),
      ),
      title: const Center(
        child: Text(
          "News App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            refreshNews();
          },
          icon: const Icon(Icons.refresh,
          size: 30,
          ),
        ),
      ],
    );
  }

  sortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Set your desired background color here
        borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
      ),
      child: DropdownButton<String>(
        value: selectedSortBy,
        items: const [
          DropdownMenuItem(
            value: 'relevancy',
            child: Text('Relevance'),
          ),
          DropdownMenuItem(
            value: 'popularity',
            child: Text('Popularity'),
          ),
          DropdownMenuItem(
            value: 'publishedAt',
            child: Text('Published Date'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedSortBy = value!;
            isLoadin = true;
            getNews();
          });
        },
      ),
    );
  }
}
