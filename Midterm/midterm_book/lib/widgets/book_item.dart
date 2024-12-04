// lib/widgets/book_item.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../screens/edit_book_screen.dart'; // Import the EditBookScreen
import '../screens/book_detail_screen.dart';

class BookItem extends StatelessWidget {
  final Book book;

  BookItem(this.book);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.imagePath != null
          ? Image.file(
        File(book.imagePath!),
        width: 60,
        height: 90,
        fit: BoxFit.cover,
      )
          : Icon(Icons.book),
      title: Text(book.title,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
      subtitle: Text('by ${book.author}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditBookScreen(book: book), // Navigate to EditBookScreen
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete,color: Colors.red,),
            onPressed: () {
              Provider.of<BookProvider>(context, listen: false).deleteBook(book.id!);
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book),
          ),
        );
      },
    );
  }
}
