import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_item.dart';
import '../screens/add_edit_book_screen.dart';

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<BookProvider>(context).books;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (ctx, index) {
              final book = books[index];
              return BookItem(book);
            },
          ),
        ),

      ],
    );
  }
}
