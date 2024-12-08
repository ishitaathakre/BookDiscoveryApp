import 'package:flutter/material.dart';
import 'api_calls.dart';
import 'parse_book.dart';
import 'book_details.dart';


Color primaryColor = Colors.blue[400]!; 
Color accentColor = Colors.lightBlue[300]!; 
Color backgroundColor = Colors.blueGrey[50]!; 
Color titleColor = Colors.black; 
Color subtitleColor = Colors.grey; 
Color buttonColor = Colors.blue[600]!; 
Color highlightColor = Colors.lightBlue[50]!;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];
  int currentPage = 1;
  bool isLoading = false;
  // bool hasMoreData=true;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMoreBooks();
  }

  Future<void> loadBooks() async {
    if (isLoading) return;
    isLoading = true;

    try {
      final newBooks = await MakeApiCalls.fetchBooks(currentPage);
      // hasMoreData=await MakeApiCalls.morePages(currentPage);
      setState(() {
        books.addAll(newBooks);
        currentPage++;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> searchBooks() async {
    if (isLoading || searchQuery.isEmpty) return;
    isLoading=true;

    try {
      final newBooks = await MakeApiCalls.searchBooks(searchQuery, currentPage);
      // hasMoreData=await MakeApiCalls.morePages(currentPage);
      setState(() {
        books.addAll(newBooks);
        currentPage++;
        isLoading=false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> loadMoreBooks() async {
    if (searchQuery.isEmpty) {
      await loadBooks();
    } else {
      await searchBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search books by title or author...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: highlightColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  books.clear();
                  isLoading=false;
                  currentPage=1;
                  searchQuery = searchController.text.trim();
                  loadMoreBooks();

                });

              },
              // style: ElevatedButton.styleFrom(
              //   color: Colors.blueAccent,
              // ),
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  side: BorderSide(color: Colors.white, width: 2),),
            ),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: books.length + 1, // Add 1 for the loading indicator
        itemBuilder: (context, index) {
          if (index == books.length) {
            // If we are at the end of the list, show the loading spinner
            loadMoreBooks();
            return Center(child: CircularProgressIndicator(color: Colors.grey,));
          }

          final book = books[index];
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                horizontalTitleGap: 25,
                leading: Container(
                  width: 50,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), 
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8), 
                        blurRadius: 5, 
                        offset: Offset(3, 3), 
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), 
                    child: book.imageUrl.isNotEmpty
                        ? Image.network(
                      book.imageUrl,
                      width: 50,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: Colors.grey[300], 
                      child: Icon(
                        Icons.book,
                        color: Colors.grey[700],
                        size: 40, 
                      ),
                    ),
                  ),
                ),
                title: Text(
                  book.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: titleColor),
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  book.authors.isNotEmpty
                      ? book.authors.map((author) => author['name']).join(', ')
                      : 'Unknown Author', 
                  style: TextStyle(fontSize: 16, color: subtitleColor, fontWeight: FontWeight.w600),
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
              // );

              onTap: () {
                  // Navigate to the book detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(book: book),
                    ),
                  );
                },
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 2,
                indent: 16,
                endIndent: 16,
              ),
            ],
          );
        },
      ),
    );
  }
}