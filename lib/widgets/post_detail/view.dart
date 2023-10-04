import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swarnet_admin_client/models/attachment.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:intl/intl.dart';
import 'package:swarnet_admin_client/services/api.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class PostDetailWidget extends StatefulWidget {
  const PostDetailWidget({super.key, required this.post});

  final Post post;

  @override
  State<PostDetailWidget> createState() => _PostDetailWidgetState();
}

class _PostDetailWidgetState extends State<PostDetailWidget> {
  final Api api = Api();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PostDetailBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<PostDetailBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4),
      child: Card(
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: CircleAvatar(),
              title: Text(
                "${widget.post.user.first_name} ${widget.post.user.last_name}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('dd-MMM hh:mm aa')
                    .format(widget.post.composed.toLocal()),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                widget.post.text,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(),
              ),
            ),
            if (widget.post.media.isNotEmpty)
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of images in a row
                ),
                shrinkWrap: true,
                itemCount: widget.post.media.length,
                itemBuilder: (BuildContext context, int index) {
                  Attachment media = widget.post.media[index];
                  return Padding(
                    padding:
                        const EdgeInsets.all(5), // Adjust the padding as needed
                    child: Image.network(
                      "https://${api.host}/${media.path}",
                      width: MediaQuery.of(context).size.width *
                          0.9 /
                          3, // Divide by the number of images in a row
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      widget.post.isLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.shadow),
                    onPressed: () async {
                      setState(() {
                        widget.post.isLiked = !widget.post.isLiked;
                        if (widget.post.isLiked) {
                          widget.post.numLikes++;
                        } else {
                          widget.post.numLikes--;
                        }
                      });
                      if (widget.post.isLiked) {
                        await api.likePost(widget.post.id);
                      } else {
                        await api.unlikePost(widget.post.id);
                      }
                    },
                    label: Text("${widget.post.numLikes}"),
                  ),
                ),
                const VerticalDivider(
                  width: 3,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      widget.post.isDisliked
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.shadow),
                    onPressed: () async {
                      setState(() {
                        widget.post.isDisliked = !widget.post.isDisliked;
                        if (widget.post.isDisliked) {
                          widget.post.numDislikes++;
                        } else {
                          widget.post.numDislikes--;
                        }
                      });
                      final Api api = Api();
                      if (widget.post.isDisliked) {
                        await api.dislikePost(widget.post.id);
                      } else {
                        await api.undislikePost(widget.post.id);
                      }
                    },
                    label: Text("${widget.post.numDislikes}"),
                  ),
                ),
                const VerticalDivider(
                  width: 3,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.mode_comment_outlined),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.shadow),
                    label: Text("${widget.post.replies.length}"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
