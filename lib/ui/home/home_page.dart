import 'package:flutter/material.dart';
import 'package:item_tracker/models/item.dart';
import 'package:item_tracker/providers/item_provider.dart';
import 'package:item_tracker/utils/form_action.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _scaffoldKey = GlobalKey();
  final GlobalKey _listViewKey = GlobalKey();
  int cols = 0;
  int aspectRatio=0;

  void showAddItemDialog(FormAction action, {Item? item}) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    if (item != null) {
      nameController.text = item.name ?? "";
      descriptionController.text = item.description ?? "";
    }

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name can't be empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "Enter Name"),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description can't be empty!!";
                        }
                        return null;
                      },
                      decoration:
                      const InputDecoration(hintText: "Enter Description"),
                    )
                  ],
                )),
            title: Text(action == FormAction.add ? "Add Item" : 'Update Item'),
            actions: <Widget>[
              InkWell(
                child: const Text('Submit'),
                onTap: () {
                  if (formKey.currentState?.validate() == true) {
                    if (action == FormAction.add) {
                      context.read<ItemProvider>().addItem(
                          nameController.text.trim(),
                          descriptionController.text.trim());
                    } else {
                      context.read<ItemProvider>().updateItem(
                          item!.itemId,
                          nameController.text.trim(),
                          descriptionController.text.trim());
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  void _calculateAndAdjustLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? listViewBox =
      _listViewKey.currentContext?.findRenderObject() as RenderBox?;

      if (listViewBox != null) {
        final Size listViewSize = listViewBox.size;

        final Offset listViewPosition = listViewBox.localToGlobal(Offset.zero);

        print('ListView Size: $listViewSize');
        print('ListView Position: $listViewPosition');

        setState(() {
          if(listViewSize.width>800){
            cols = 3;
            aspectRatio = 3;
          }else if(listViewSize.width>400) {
            cols = 2;
            aspectRatio = 2;
          } else{
            cols = 3;
            aspectRatio  = 2;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        // _calculateAndAdjustLayout();

        if (context.watch<ItemProvider>().items.isNotEmpty) {
          return GridView.builder(
            key: _listViewKey,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > 800 ? 3 : constraints.maxWidth > 400 ? 2 : 1,
              childAspectRatio: constraints.maxWidth > 800 ? 3 : constraints.maxWidth > 400 ? 1 : 3,
            ),
            itemBuilder: (context, index) {
              var item = context.watch<ItemProvider>().items[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(item.name ?? ""),
                  subtitle: Text(item.description ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            showAddItemDialog(FormAction.update, item: item);
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            context.read<ItemProvider>().removeItem(item.itemId!);
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              );
            },
            itemCount: context.watch<ItemProvider>().items.length,
          );
        }
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty),
              SizedBox(height: 16),
              Text(
                "No items in the list!\nUse \"+\" icon button to add new item",
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddItemDialog(FormAction.add);
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
