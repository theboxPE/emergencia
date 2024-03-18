import 'dart:io';
import 'package:emergencia/db.dart';
import 'package:emergencia/evento.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  AddEventScreenState createState() => AddEventScreenState();
}

class AddEventScreenState extends State<AddEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _insertEvent() async {
  final db = await DatabaseProvider.db.database;
  final event = Event(
    title: _titleController.text,
    description: _descriptionController.text,
    date: _selectedDate,
    imagePath: _imageFile?.path,
  );
  await db.insert('events', event.toMap());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fecha: ${_selectedDate.toString().substring(0, 10)}'),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Seleccionar fecha'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 100.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
            ElevatedButton(
              onPressed: () {
                _selectImage(context);
              },
              child: const Text('Agregar Foto'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                  // Almacena el contexto en una variable
                await _insertEvent();
                // Crear un nuevo evento con los datos ingresados
                Event newEvent = Event(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  date: _selectedDate,
                  imagePath: _imageFile?.path,
                );
                // Devolver el nuevo evento a la pantalla anterior
                Navigator.pop(context, newEvent); // Utiliza la variable contextReference en lugar de context
              },
              child: const Text('Agregar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}
