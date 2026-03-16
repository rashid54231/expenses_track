import 'package:flutter/material.dart';
import '../../../models/tag_model.dart';
import '../controllers/tag_controller.dart';
import 'create_tag_screen.dart';

class TagListScreen extends StatefulWidget {
  const TagListScreen({super.key});

  @override
  State<TagListScreen> createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> {

  final TagController controller = TagController();

  @override
  void initState() {
    super.initState();
    controller.loadTags();
  }

  void deleteTag(String id){
    controller.deleteTag(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Tags"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTagScreen(),
            ),
          );

          if(result != null){
            controller.addTag(result);
            setState(() {});
          }

        },
        child: const Icon(Icons.add),
      ),

      body: controller.tags.isEmpty
          ? const Center(
        child: Text(
          "No Tags Found",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(

        itemCount: controller.tags.length,

        itemBuilder: (context,index){

          TagModel tag = controller.tags[index];

          return Card(

            margin: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 8),

            child: ListTile(

              leading: const CircleAvatar(
                child: Icon(Icons.label),
              ),

              title: Text(tag.name),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateTagScreen(tag: tag),
                        ),
                      );

                      if(result != null){
                        controller.updateTag(result);
                        setState(() {});
                      }

                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete,color: Colors.red),
                    onPressed: (){
                      deleteTag(tag.id);
                    },
                  ),

                ],
              ),

            ),

          );

        },

      ),

    );

  }

}