import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/bookitemhome.dart';
import 'package:midterm_book/widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.books;

    return Scaffold(
      drawer: Sidemenu(),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('My Book Library',style: TextStyle(fontWeight: FontWeight.bold
        ,fontSize: 26),),
        centerTitle: true,
        actions: [
          // Filter PopupMenuButton
          PopupMenuButton<String>(

            onSelected: (value) {
              bookProvider.setFilter(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'All',
                  child: Text('All'),
                ),
                PopupMenuItem<String>(
                  value: 'Read',
                  child: Text('Read'),
                ),
                PopupMenuItem<String>(
                  value: 'Unread',
                  child: Text('Unread'),
                ),
              ];
            },
            icon: Icon(Icons.filter_list), // Filter icon
          ),
          // Sorting PopupMenuButton
          PopupMenuButton<String>(
            onSelected: (value) {
              bookProvider.setSortingPreference(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'title',
                  child: Text('Sort by Title'),
                ),
                PopupMenuItem<String>(
                  value: 'author',
                  child: Text('Sort by Author'),
                ),
                PopupMenuItem<String>(
                  value: 'rating',
                  child: Text('Sort by Rating'),
                ),
              ];
            },
          ),
          SizedBox(width: 10), // Space between icons

        ],
      ),
      body:
      Column(

        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Book',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                bookProvider.searchBooks(value);
              },
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'My Books',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.orange,
              decoration: TextDecoration.underline,decorationColor: Colors.orange,),
          ),
          Expanded(
            child: books.isEmpty
                ? Center(
              child: Text(
                'No books found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                childAspectRatio: 0.7, // Adjust the aspect ratio to fit the images nicely
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 33.0,
              ),
              itemCount: books.length,
              itemBuilder: (ctx, index) {
                return BookItemHome(books[index]);
              },
            ),
          ),
        ],
      ),

    );
  }
}
