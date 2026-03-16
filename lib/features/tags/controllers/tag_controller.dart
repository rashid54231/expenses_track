import '../../../models/tag_model.dart';

class TagController {

  List<TagModel> tags = [];

  // LOAD TAGS
  void loadTags() {

    // future me yaha Supabase se load honge
    // filhal empty hi rahenge

  }

  // ADD TAG
  void addTag(TagModel tag) {
    tags.add(tag);
  }

  // UPDATE TAG
  void updateTag(TagModel updatedTag) {

    int index = tags.indexWhere((t) => t.id == updatedTag.id);

    if(index != -1){
      tags[index] = updatedTag;
    }

  }

  // DELETE TAG
  void deleteTag(String id) {

    tags.removeWhere((tag) => tag.id == id);

  }

}