import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import 'package:midterm_book/widgets/drawer.dart';
import 'package:permission_handler/permission_handler.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  EditBookScreen({required this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late double _rating;
  late bool _isRead;
  File? _pickedImage;
  String? _pickedPdfPath;

  @override
  void initState() {
    super.initState();
    _title = widget.book.title;
    _author = widget.book.author;
    _rating = widget.book.rating;
    _isRead = widget.book.isRead;
    _pickedImage = widget.book.imagePath != null ? File(widget.book.imagePath!) : null;
    _pickedPdfPath = widget.book.pdfPath;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPdf() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pickedPdfPath = result.files.single.path!;
        });
      }
    } catch (e) {
      print('Error picking PDF: $e');
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedBook = Book(
        id: widget.book.id,
        title: _title,
        author: _author,
        rating: _rating,
        isRead: _isRead,
        imagePath: _pickedImage?.path,
        pdfPath: _pickedPdfPath,
      );
      Provider.of<BookProvider>(context, listen: false).updateBook(updatedBook);

      // Show alert dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Message'),
          content: Text('Book updated successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidemenu(),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          'Edit Book',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: _author,
                    decoration: InputDecoration(
                      labelText: 'Author',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an author';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _author = value!;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    initialValue: _rating.toString(),
                    decoration: InputDecoration(
                      labelText: 'Rating',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a rating';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _rating = double.parse(value!);
                    },
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    title: Text('Read'),
                    value: _isRead,
                    onChanged: (value) {
                      setState(() {
                        _isRead = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _pickedImage == null
                        ? TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pick Image'),
                    )
                        : Column(
                      children: [
                        Image.file(
                          _pickedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.add_circle_outlined),
                          label: Text('Change Image'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _pickedPdfPath == null
                        ? TextButton.icon(
                      onPressed: _pickPdf,
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text('Pick PDF'),
                    )
                        : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'PDF Added',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: _pickPdf,
                          icon: Icon(Icons.add_circle_outlined),
                          label: Text('Change PDF'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Colors.orange,
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
