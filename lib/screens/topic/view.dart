import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/widgets/swarnet_loading_logo.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TopicBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<TopicBloc>(context);

    return Scaffold(
      body: BlocConsumer<TopicBloc, TopicState>(
        bloc: bloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is TopicLoadedState) {
            final List<Topic> topics = state.topics;
            return _renderTopicTable(context, topics);
          }
          return const SwarnetLoadingLogo();
        },
      ),
    );
  }

  Widget _renderTopicTable(
    BuildContext context,
    List<Topic> topics,
  ) {
    final bloc = BlocProvider.of<TopicBloc>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          _showAddTopicDialog(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search topics',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (query) {
                  bloc.add(TopicFilterEvent(query));
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Ensure vertical scrolling
                child: DataTable(
                  dataRowMinHeight: 20,
                  dataRowMaxHeight: 90,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Topic')),
                    DataColumn(label: Text('Keywords')),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      'Post Count',
                      overflow: TextOverflow.ellipsis,
                    ))),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  rows: topics.map((topic) {
                    List<Widget> keywordChips =
                        topic.keywords.split(',').map((keyword) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          backgroundColor: ([
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.secondaryContainer,
                            Theme.of(context).colorScheme.tertiaryContainer,
                            Theme.of(context).colorScheme.errorContainer,
                          ]..shuffle())
                              .first,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(
                            keyword.trim(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          labelPadding: EdgeInsets.zero,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 0,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    }).toList();

                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(topic.text)),
                        DataCell(
                          Wrap(
                            children: keywordChips,
                          ),
                        ),
                        DataCell(Text("${topic.postCount}")),
                        DataCell(
                          IconButton(
                            onPressed: () async {
                              await _showEditTopicDialog(context, topic);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            onPressed: () async {
                              bool shouldDelete =
                                  await _showDeleteTopicDialog(context);
                              if (shouldDelete) {
                                bloc.add(TopicDeleteEvent(topic));
                              }
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    final bloc = BlocProvider.of<TopicBloc>(context);
    String topicName = "";
    String topicKeywords = "";
    String similarityThreshold = "";
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
              Text('Create Topic',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Topic Name",
                          alignLabelWithHint: true,
                          hintText: "What's swarming right now?",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a name for the topic.';
                          }
                          topicName = value;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Topic Keywords",
                          alignLabelWithHint: true,
                          hintText: "rain,falling,flood,raining",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a comma separated list of your keywords for this topic.';
                          }
                          topicKeywords = value;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Similarity Threshold",
                          alignLabelWithHint: true,
                          hintText: "5",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter the Similarity Threshold you need for posts to this topic';
                          }
                          similarityThreshold = value;
                          return null;
                        },
                      ),
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
                                bloc.add(TopicCreateEvent(topicName,
                                    topicKeywords, similarityThreshold));
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Save Topic'),
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

  Future<bool> _showDeleteTopicDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit website builder?'),
        content: const Text('Are you sure you want to remove this topic?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FilledButton(
            child: const Text('Yes, Remove'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  Future<bool> _showEditTopicDialog(BuildContext context, Topic topic) async {
    final bloc = BlocProvider.of<TopicBloc>(context);
    String topicName = topic.text;
    String topicKeywords = topic.keywords;
    String similarityThreshold = "${topic.similarityThreshold}";
    return await showDialog(
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
                  Text('Create Topic',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Topic Name",
                              alignLabelWithHint: true,
                              hintText: "What's swarming right now?",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            initialValue: topicName,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a name for the topic.';
                              }
                              topicName = value;
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Topic Keywords",
                              alignLabelWithHint: true,
                              hintText: "rain,falling,flood,raining",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            initialValue: topicKeywords,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a comma separated list of your keywords for this topic.';
                              }
                              topicKeywords = value;
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Similarity Threshold",
                              alignLabelWithHint: true,
                              hintText: "5",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            initialValue: similarityThreshold,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter the Similarity Threshold you need for posts to this topic';
                              }
                              similarityThreshold = value;
                              return null;
                            },
                          ),
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
                                    bloc.add(TopicEditEvent(topic.id, topicName,
                                        topicKeywords, similarityThreshold));
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Save Topic'),
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
        ) ??
        false;
  }
}
