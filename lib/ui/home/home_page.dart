import 'package:flutter/material.dart';
import 'package:item_tracker/models/Item.dart';
import 'package:item_tracker/providers/item_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          var item = context.watch<ItemProvider>().items[index];
          return ListTile(
            title: Text(item.name ?? ""),
            subtitle: Text(item.description ?? ""),
          );
        },
        itemCount: context.watch<ItemProvider>().items.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ItemProvider>().addItem("Item", "description");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
