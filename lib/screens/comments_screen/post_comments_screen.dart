import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/models/comment_model.dart';
import 'package:stagebook/models/live_show_post_model.dart';
import 'package:stagebook/models/post_model.dart';
import 'package:stagebook/models/user_data.dart';
import 'package:stagebook/models/user_model.dart';
import 'package:stagebook/screens/profile_screen/profile_screen.dart';
import 'package:stagebook/services/database_service.dart';
import 'package:stagebook/utilities.dart/constants.dart';

class PostCommentScreen extends StatefulWidget {
  final Post post;
  final int starCount;
  final LiveShowPost liveShowPost;

  PostCommentScreen({this.starCount, this.post, this.liveShowPost});

  @override
  _PostCommentScreenState createState() => _PostCommentScreenState();
}

class _PostCommentScreenState extends State<PostCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  _buildComment(Comment comment) {
    return FutureBuilder(
      future: DatabaseService.getUserWithId(comment.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User author = snapshot.data;
        return ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(
                currentUserId: Provider.of<UserData>(context).currentUserId.uid,
                userId: comment.authorId,
              ),
            ),
          ),
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            backgroundImage: author.profileImageUrl == null
                ? AssetImage('assets/images/placeholder_profile_image.png')
                : CachedNetworkImageProvider(author.profileImageUrl),
          ),
          title: Text(
            author.fullName,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                comment.content,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
                style: TextStyle(color: Colors.grey),
              ),
              Divider(
                color: Colors.redAccent,
              )
            ],
          ),
        );
      },
    );
  }

  _buildCommentTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: TextField(
                style: TextStyle(
                  color: Colors.redAccent,
                ),
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment) {
                  setState(() {
                    _isCommenting = comment.length > 0;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'write a comment...',
                  fillColor: Colors.redAccent,
                  hintStyle: TextStyle(
                      color: Colors.redAccent, backgroundColor: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  if (_isCommenting) {
                    DatabaseService.commentOnPost(
                      currentUserId: currentUserId.uid,
                      post: widget.post == null
                          ? widget.liveShowPost
                          : widget.post,
                      comment: _commentController.text,
                    );
                    _commentController.clear();
                    setState(() {
                      _isCommenting = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text(
          'Comments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 25.0,
          ),
          SingleChildScrollView(
            child: GFAvatar(
              radius: 100,
              shape: GFAvatarShape.standard,
              backgroundColor: Colors.grey,
              backgroundImage: widget.post.imageUrl == null
                  ? AssetImage('assets/images/placeholder_profile_image.png')
                  : CachedNetworkImageProvider(widget.post.imageUrl),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              '${widget.starCount} stars',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent),
            ),
          ),
          StreamBuilder(
            stream: commentsRef
                .document(widget.post.id == null
                    ? widget.liveShowPost.id
                    : widget.post.id)
                .collection('postComments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment comment =
                        Comment.fromDoc(snapshot.data.documents[index]);

                    return _buildComment(comment);
                  },
                ),
              );
            },
          ),
          Divider(
            height: 1.0,
          ),
          _buildCommentTF(),
        ],
      ),
    );
  }
}
