import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostMediaAttachment extends StatelessWidget {
  final XFile file;
  final VoidCallback onRemove;
  final double mediaInWidth;
  const PostMediaAttachment(
      {Key? key, required this.file, required this.onRemove, required this.mediaInWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / mediaInWidth,
        height: MediaQuery.of(context).size.height /4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(
                File(file.path),
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () async {
                    bool result = await _confirmDelete(context);
                    if (result) {
                      onRemove();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text(
                  "Are you sure you want to remove this attachment from the post?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
