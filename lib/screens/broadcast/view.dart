import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/widgets/swarnet_loading_logo.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final _formKey = GlobalKey<FormState>();

  String content = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BroadcastBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<BroadcastBloc>(context);

    return BlocConsumer<BroadcastBloc, BroadcastState>(
        bloc: bloc,
        listener: (context, state) {
          // TODO: implement listener}
        },
        builder: (BuildContext context, BroadcastState state) {
          if (state is BroadcastLoadedState) {
            return Scaffold(
              body: _renderBroadcastTable(
                context,
                state.broadcasts,
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add_outlined),
                onPressed: () {
                  _showAddBroadcastDialog(context);
                },
              ),
            );
          }
          return const SwarnetLoadingLogo();
        });
  }

  Widget _renderBroadcastTable(BuildContext context, List<Post> broadcasts) {
    if (broadcasts.isEmpty) {
      return const Center(
        child: Text("There are no broadcasts. Make one and reload"),
      );
    }
    return ListView.builder(
      itemCount: broadcasts.length,
      itemBuilder: (BuildContext context, int idx) {
        Post p = broadcasts[idx];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                visualDensity: VisualDensity.compact,
                leading: const CircleAvatar(
                  radius: 22,
                ),
                title: Text(
                  "${p.user.first_name} ${p.user.last_name}",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd-MMM hh:mm aa')
                          .format(p.composed.toLocal()),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      p.text,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddBroadcastDialog(BuildContext context) {
    final bloc = BlocProvider.of<BroadcastBloc>(context);

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
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Broadcast Message",
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
                          content = value;
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
                                bloc.add(
                                  BroadcastCreateEvent(content),
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Broadcast'),
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
