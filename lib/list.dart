import 'dart:io';
import 'package:emergencia/agregar.dart';
import 'package:emergencia/db.dart';
import 'package:emergencia/details.dart';
import 'package:emergencia/evento.dart';
import 'package:flutter/material.dart';


class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<EventListScreen> {
  List<Event> events = []; // Lista de eventos

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Llama a la función _loadEvents() al inicializar la pantalla
  }

  Future<void> _loadEvents() async {
    final db = await DatabaseProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    setState(() {
      events = List.generate(maps.length, (i) {
        return Event(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          date: DateTime.parse(maps[i]['date']),
          imagePath: maps[i]['image_path'],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            onTap: () {
              // Navega a la pantalla de detalles del evento cuando se hace clic en un elemento de la lista
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsScreen(event: event),
                ),
              );
            },
            leading: event.imagePath != null
                ? CircleAvatar(
                    backgroundImage: FileImage(File(event.imagePath!)),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.event),
                  ),
            title: Text(event.title),
            subtitle: Text(
              '${event.description}\n${event.date.toString()}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          ).then((newEvent) {
            if (newEvent != null) {
              setState(() {
                events.add(newEvent);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
