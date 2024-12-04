import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/bookitemhome.dart';
import '../screens/add_edit_book_screen.dart';

class Booklisthome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<BookProvider>(context).books;
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              childAspectRatio: 0.7, // Adjust the aspect ratio to fit the images nicely
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: books.length,
            itemBuilder: (ctx, index) {
              final book = books[index];
              return BookItemHome(book);
            },
          ),
        ),
      ],
    );
  }
}
