import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:swarnet_admin_client/widgets/post_media_attachment.dart';
import 'package:swarnet_admin_client/widgets/swarnet_loading_logo.dart';
import '../../models/topic.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class ContentCreationPostScreen extends StatefulWidget {
  const ContentCreationPostScreen({super.key});

  @override
  State<ContentCreationPostScreen> createState() =>
      _ContentCreationPostScreenState();
}

class _ContentCreationPostScreenState extends State<ContentCreationPostScreen> {
  final _formKey = GlobalKey<FormState>();

  String content = "";
  Topic? selectedTopic;
  List<XFile> attachments = [];
  List<String> tags = [];
  final ImagePicker _picker = ImagePicker();
  bool includePosition = false;
  RichTextController? _controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ContentCreationPostBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<ContentCreationPostBloc>(context);
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<ContentCreationPostBloc, ContentCreationPostState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is ContentCreationInvalidState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Post rejected ${state.failureReason}')),
                );
              }
              if (state is ContentCreationValidState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Post accepted! Uploading and broadcasting!')),
                );
              }
            },
            builder: (context, state) {
              if (state is ContentCreationLoadedState) {
                content = content.isEmpty ? state.content : content;
                attachments = state.attachments;
                selectedTopic = state.topic;
                _controller?.text = content;

                return _buildForm(context, state.topicList);
              }
              if (state is ContentCreationInvalidState) {
                content = content.isEmpty ? state.content : content;
                attachments = state.attachments;
                selectedTopic = state.topic;
                _controller?.text = content;

                return _buildForm(context, state.topicList);
              }
              return const SwarnetLoadingLogo();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<Topic> topicList) {
    final bloc = BlocProvider.of<ContentCreationPostBloc>(context);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          bloc.add(ContentCreationVerifyPostEvent(
                              attachments: attachments,
                              content: _controller!.text,
                              includeLocation: includePosition,
                              topic: selectedTopic!,
                              tags: tags));
                        }
                      },
                      child: const Text('Create Post'),
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<Topic>(
                value: selectedTopic,
                decoration: InputDecoration(
                  labelText: "Topic",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Set the border radius here
                  ),
                ),
                validator: (Topic? value) {
                  if (value == null) {
                    return 'Please select a topic';
                  }
                  selectedTopic = value;
                  return null;
                },
                items: topicList
                    .map((Topic e) => DropdownMenuItem<Topic>(
                          child: Text(e.text),
                          value: e,
                        ))
                    .toList(),
                onChanged: (Topic? value) {
                  selectedTopic = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
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
                minLines: 7,
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
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        //TODO: Make this content photo+video
                        final XFile? image =
                            await _picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            attachments.add(image);
                          });
                        }
                      },
                      icon: const Icon(Icons.add_a_photo)),
                  IconButton(
                      onPressed: () async {
                        //TODO: Make this content photo+video
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            attachments.add(image);
                          });
                        }
                      },
                      icon: const Icon(Icons.attachment)),
                  IconButton(
                      onPressed: () {
                        if (includePosition) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Remove location?"),
                                  content: const Text(
                                      "Would you like to remove your location?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          includePosition = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Yes, remove"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          includePosition = true;
                        }
                        setState(() {});
                      },
                      icon: Icon(!includePosition
                          ? Icons.location_off
                          : Icons.location_on)),
                  Expanded(
                      child: Text(
                    !includePosition
                        ? "Location currently off"
                        : "Location currently on",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ))
                ],
              ),
              if (attachments.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: attachments.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      XFile file = attachments[index];
                      return PostMediaAttachment(
                        mediaInWidth: 2.5,
                        file: file,
                        onRemove: () {
                          setState(() {
                            attachments.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
