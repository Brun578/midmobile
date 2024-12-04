import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import 'package:midterm_book/widgets/drawer.dart';
import '../widgets/book_list.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _author = '';
  double _rating = 0;
  bool _isRead = false;
  File? _pickedImage;
  String? _pickedPdfPath;

  // Check and request permissions
  Future<void> _checkAndRequestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final book = Book(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _title,
        author: _author,
        rating: _rating,
        isRead: _isRead,
        imagePath: _pickedImage?.path,
        pdfPath: _pickedPdfPath,
      );
      Provider.of<BookProvider>(context, listen: false).addBook(book);

      print('Saving book: ${book.toJson()}');

      // Show alert dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Message'),
          content: Text('Book added successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
                _clearForm();
              },
            ),
          ],
        ),
      );
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _title = '';
      _author = '';
      _rating = 0;
      _isRead = false;
      _pickedImage = null;
      _pickedPdfPath = null;
    });
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
    try {
      // Check permissions if needed
      await _checkAndRequestPermissions();

      // Pick the PDF file
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
      // Handle any errors here
      print('Error picking PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidemenu(),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text('Add/Edit Book', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(labelText: 'Title'),
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
                  TextFormField(
                    initialValue: _author,
                    decoration: InputDecoration(labelText: 'Author'),
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
                  // TextFormField(
                  //   initialValue: _rating.toString(),
                  //   decoration: InputDecoration(labelText: 'Rating'),
                  //   keyboardType: TextInputType.number,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter a rating';
                  //     }
                  //     if (double.tryParse(value) == null) {
                  //       return 'Please enter a valid number';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     _rating = double.parse(value!);
                  //   },
                  // ),
                  // SwitchListTile(
                  //   title: Text('Read'),
                  //   value: _isRead,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _isRead = value;
                  //     });
                  //   },
                  // ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _pickedImage == null
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
                            width: 70,
                            fit: BoxFit.cover,
                          ),

                          TextButton.icon(
                            icon: Icon(Icons.upload, color: Colors.red),
                            onPressed: _pickImage,
                            label: Text('Change Image'),
                          ),

                        ],
                      ),
                      _pickedPdfPath == null
                          ? TextButton.icon(
                        onPressed: _pickPdf,
                        icon: Icon(Icons.picture_as_pdf),
                        label: Text('Pick PDF'),
                      )
                          : Column(
                        children: [
                          Row(
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
                            icon: Icon(Icons.upload_file, color: Colors.red),
                            onPressed: _pickPdf,
                            label: Text('Change pdf'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: _saveForm,
                    child: Text('Save', style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Book List',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: BookList()),
          ],
        ),
      ),
    );
  }
}

