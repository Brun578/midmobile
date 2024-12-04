import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_screen.dart';

class BookItemHome extends StatelessWidget {
  final Book book;

  BookItemHome(this.book);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book),
          ),
        );
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: book.imagePath != null
                  ? Image.file(
                File(book.imagePath!),
                width: 130, // Adjusted width
                height: 180, // Adjusted height
                fit: BoxFit.cover,
              )
                  : Container(
                width: 120,
                height: 170,
                color: Colors.grey,
                child: Icon(Icons.book, size: 60, color: Colors.white),
              ),
            ),
            // SizedBox(height: -2.0),
            Text(
              book.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 19.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3.0),
            Row(
              children: [
                Text(
                  '${book.rating.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 1.0),
                Row(
                  children: List.generate(1, (index) {
                    return Icon(
                      index < book.rating.floor()
                          ? Icons.star
                          : (index < book.rating
                          ? Icons.star_half
                          : Icons.star_border),
                      color: Colors.orange,
                    );
                  }),
                ),


              ],
            ),

          ],
        ),
      ),
    );
  }
}
