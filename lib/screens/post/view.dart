import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/widgets/post_detail/view.dart';
import 'package:swarnet_admin_client/widgets/post_media_attachment.dart';
import 'package:swarnet_admin_client/widgets/swarnet_loading_logo.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();

  String content = "";
  Topic? selectedTopic;
  List<XFile> attachments = [];
  List<String> tags = [];
  // final ImagePicker _picker = ImagePicker();
  bool includePosition = false;
  RichTextController? _controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PostBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      body: BlocConsumer<PostBloc, PostState>(
        bloc: bloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is PostLoadedState) {
            return _buildPostContent(context, state.posts, state.topics);
          }
          return const SwarnetLoadingLogo();
        },
      ),
    );
  }

  Widget _buildPostContent(
      BuildContext context, List<Post> posts, List<Topic> topics) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          _showAddPostDialog(context, topics);
        },
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return PostDetailWidget(post: posts[index]);
        },
      ),
    );
  }

  void _showAddPostDialog(BuildContext context, List<Topic> topics) {
    final bloc = BlocProvider.of<PostBloc>(context);

    _controller ??= RichTextController(
      patternMatchMap: {
        RegExp(r"\B#[a-zA-Z0-9]+\b"):
            TextStyle(color: Theme.of(context).colorScheme.tertiary),
      },
      deleteOnBack: false,
      onMatch: (List<String> matches) {
        tags = matches;
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Create Post',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<Topic>(
                              value: selectedTopic,
                              decoration: InputDecoration(
                                labelText: "Topic",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (Topic? value) {
                                if (value == null) {
                                  return 'Please select a topic';
                                }
                                selectedTopic = value;
                                return null;
                              },
                              items: topics
                                  .map((Topic e) => DropdownMenuItem<Topic>(
                                        value: e,
                                        child: Text(e.text),
                                      ))
                                  .toList(),
                              onChanged: (Topic? value) {
                                selectedTopic = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: "Post Content",
                          alignLabelWithHint: true,
                          hintText: "What's swarming right now?",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        minLines: 4,
                        maxLines: 14,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) => content = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the details of your post.';
                          }
                          return null;
                        },
                      ),
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () async {
                      //         //TODO: Make this content photo+video
                      //         final XFile? image = await _picker.pickImage(
                      //           source: ImageSource.camera,
                      //         );
                      //         if (image != null) {
                      //           setState(() {
                      //             attachments.add(image);
                      //           });
                      //         }
                      //       },
                      //       icon: const Icon(Icons.add_a_photo),
                      //     ),
                      //     IconButton(
                      //       onPressed: () async {
                      //         final XFile? image = await _picker.pickImage(
                      //           source: ImageSource.gallery,
                      //         );
                      //         if (image != null) {
                      //           setState(() {
                      //             attachments.add(image);
                      //           });
                      //         }
                      //       },
                      //       icon: const Icon(Icons.attachment),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {
                      //         if (includePosition) {
                      //           showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return AlertDialog(
                      //                 title: const Text("Remove location?"),
                      //                 content: const Text(
                      //                     "Would you like to remove your location?"),
                      //                 actions: [
                      //                   TextButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         includePosition = false;
                      //                       });
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: const Text("Yes, remove"),
                      //                   ),
                      //                   TextButton(
                      //                     onPressed: () {
                      //                       Navigator.of(context).pop();
                      //                     },
                      //                     child: const Text("Cancel"),
                      //                   ),
                      //                 ],
                      //               );
                      //             },
                      //           );
                      //         } else {
                      //           includePosition = true;
                      //         }
                      //         setState(() {});
                      //       },
                      //       icon: Icon(!includePosition
                      //           ? Icons.location_off
                      //           : Icons.location_on),
                      //     ),
                      //     Expanded(
                      //       child: Text(
                      //         !includePosition
                      //             ? "Location currently off"
                      //             : "Location currently on",
                      //         style: Theme.of(context).textTheme.bodyText2,
                      //         textAlign: TextAlign.end,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // if (attachments.isNotEmpty)
                      //   SizedBox(
                      //     height: 300,
                      //     child: ListView.builder(
                      //       itemCount: attachments.length,
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         XFile file = attachments[index];
                      //         return PostMediaAttachment(
                      //           mediaInWidth: 2.5,
                      //           file: file,
                      //           onRemove: () {
                      //             setState(() {
                      //               attachments.removeAt(index);
                      //             });
                      //           },
                      //         );
                      //       },
                      //     ),
                      //   ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Cancel'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                bloc.add(PostCreateEvent(
                                    selectedTopic!, _controller!.text));
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Save Post'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
