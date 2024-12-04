import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data_access_layer/database_helper.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  String _filter = 'All';
  String _searchQuery = '';

  BookProvider() {
    fetchAndSetBooks();
  }

  List<Book> get books {
    List<Book> filteredBooks;

    if (_filter == 'Read') {
      filteredBooks = _books.where((book) => book.isRead).toList();
    } else if (_filter == 'Unread') {
      filteredBooks = _books.where((book) => !book.isRead).toList();
    } else {
      filteredBooks = [..._books];
    }

    if (_searchQuery.isNotEmpty) {
      filteredBooks = filteredBooks.where((book) {
        final titleLower = book.title.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    }

    return filteredBooks;
  }

  String get filter => _filter;

  Future<void> fetchAndSetBooks() async {
    _books = await DatabaseHelper.instance.fetchBooks();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await DatabaseHelper.instance.insertBook(book);
    _books.add(book);
    notifyListeners();
  }

  Future<void> updateBook(Book book) async {
    await DatabaseHelper.instance.updateBook(book);
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index >= 0) {
      _books[index] = book;
      notifyListeners();
    }
  }

  Future<void> deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSortingPreference(String sortingPreference) {
    if (sortingPreference == 'title') {
      _books.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortingPreference == 'author') {
      _books.sort((a, b) => a.author.compareTo(b.author));
    } else if (sortingPreference == 'rating') {
      _books.sort((a, b) => b.rating.compareTo(a.rating));
    }
    notifyListeners();
  }

  void searchBooks(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void removeBook(int id) {
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }
}
