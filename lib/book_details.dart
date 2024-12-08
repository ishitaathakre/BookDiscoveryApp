import 'package:book_discovery_app/home.dart';
import 'package:flutter/material.dart';
import 'parse_book.dart';

Color primaryColor = Colors.lightBlue.shade100; 
Color apptextColor = Colors.white;
Color accentColor = Colors.lightBlue[300]!;
Color backgroundColor = Colors.blueGrey[50]!; 
Color titleColor = Colors.black; 
Color subtitleColor = Colors.grey[700]!; 
Color buttonColor = Colors.blueGrey; 
Color headingColor = Colors.blue[400]!; 



class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    List<String> modifiedBookshelves = book.bookshelves.map((shelf) {
      if (shelf.startsWith('Browsing:')) {
        return shelf.replaceFirst('Browsing:', '').trim();
      }
      return shelf;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          book.title,
          style: TextStyle(color: apptextColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Image and Book Title + Author
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (book.imageUrl.isNotEmpty)
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      book.imageUrl,
                      // width: double.infinity,
                      height: 175,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 16),
                // Book Title and Authors
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      // Book Title
                      Text(
                        book.title,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: titleColor),
                        maxLines: 3, 
                        overflow: TextOverflow.ellipsis, 
                        textAlign: TextAlign.center, 
                      ),
                      // SizedBox(height: 8),
                      // Authors
                      if (book.authors.isNotEmpty)
                        Text(
                          book.authors
                              .map((author) => author['name'])
                              .join(', ') ?? 'Unknown Author',
                          style: TextStyle(
                            fontSize: 20,
                            color: subtitleColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,  
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Subjects Section
            if (book.subjects.isNotEmpty)
              Text(
                'Subjects',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: headingColor),
              ),
            Divider(color: Colors.grey),
            if (book.subjects.isNotEmpty)
              Text(
                book.subjects.join(', '),
                style: TextStyle(fontSize: 18),
              ),

            SizedBox(height: 8),

            // Bookshelves Section
            if (modifiedBookshelves.isNotEmpty)
            //   Text(
            //     'Bookshelves',
            //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: headingColor),
            //   ),
            // Divider(color: Colors.grey),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: modifiedBookshelves.map((shelf) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: buttonColor,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    shelf,
                    style: TextStyle(fontSize: 18, color: buttonColor, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Other Book Details Section
            Text(
              "Other Book Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: headingColor),
            ),
            Divider(color: Colors.grey),

            if (book.languages.isNotEmpty || book.downloadCount != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Languages Section
                    if (book.languages.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Languages: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              book.languages.join(', '),
                              style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    // Download Count Section
                    if (book.downloadCount != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Downloads: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                              '${book.downloadCount}',
                              style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            SizedBox(height: 16),

            // Links to Book Formats Section
            if (book.formats.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Formats:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: headingColor),
                  ),
                  Divider(color: Colors.grey),
                  ...book.formats.entries.map((format) {
                    final formatName = format.key.split('/').last;
                    return GestureDetector(
                      onTap: () {
                        // Open the format link
                        print('Tapped on ${format.key}: ${format.value}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '- $formatName',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
