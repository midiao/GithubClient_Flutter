import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:github_client/common/constants/assets.dart';
import 'package:github_client/common/constants/colors.dart';
import 'package:github_client/common/model/issue.dart';

class MainIssuesItem extends StatelessWidget {
  final Issue issue;

  MainIssuesItem({Key key, this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Image(
                    image: NetworkImage(issue.assignee.avatarUrl),
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                Expanded(
                  child: _itemContent(),
                  flex: 1,
                ),
                Container(
                  margin: EdgeInsets.only(left: 3.0),
                  child: Offstage(
                    offstage: issue.comments < 0,
                    child: Row(
                      children: <Widget>[
                        Image(
                          width: 16.0,
                          height: 16.0,
                          image: AssetImage(issue.comments >= 5
                              ? issuesCommentFireDark
                              : issuesCommentNormalDark),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 1.0),
                          alignment: Alignment.center,
                          child: Text(
                            issue.comments.toString(),
                            style:
                                TextStyle(color: colorPrimary, fontSize: 12.0),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemContent() {
    final int labelsCount = issue.labels.length;
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 16.0),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RichText(
              textAlign: TextAlign.start,
              text: TextSpan(text: '', children: [
                TextSpan(
                  text: issue.title,
                  style: TextStyle(color: colorPrimaryText, fontSize: 14.0),
                ),
                TextSpan(
                  text: '#${issue.number}',
                  style:
                      TextStyle(color: colorSecondaryTextGray, fontSize: 14.0),
                )
              ])),
          Container(
            margin: EdgeInsets.only(top: 6.0, left: 1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: AssetImage(issuesTime),
                    width: 12.0,
                    height: 12.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  child: Text(
                    _transformEventTime(issue.updatedAt),
                    style: TextStyle(
                        color: colorSecondaryTextGray, fontSize: 12.0),
                  ),
                ),
                Offstage(
                  offstage: labelsCount <= 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0),
                    child: Image(
                      image: AssetImage(issuesTag),
                      width: 11.0,
                      height: 11.0,
                    ),
                  ),
                ),
                Offstage(
                  offstage: labelsCount <= 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 4.0),
                    child: Text(
                      labelsCount.toString(),
                      style: TextStyle(
                          color: colorSecondaryTextGray, fontSize: 12.0),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String _transformEventTime(final String createAt) {
    final int formatTimes = DateTime.parse(createAt).millisecondsSinceEpoch;
    setLocaleInfo('zh_normal', ZhInfo());
    final int now = DateTime.now().millisecondsSinceEpoch;
    final String timeLine = TimelineUtil.format(formatTimes,
        locTimeMillis: now, locale: 'zh_normal', dayFormat: DayFormat.Common);
    return timeLine;
  }
}
