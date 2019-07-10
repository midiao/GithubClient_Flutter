class IssuesRepository {
  IssuesRepository._();

  static const String SORT_CREATED = 'created';
  static const String SORT_UPDATED = 'updated';
  static const String SORT_COMMENTS = 'comments';
  static const String STATE_OPEN = 'open';
  static const String STATE_CLOSED = 'closed';
  static const String STATE_ALL = 'all';

  static void _verifyIssueApiParams(final String sort, final String state) {
    if (![SORT_CREATED, SORT_UPDATED, SORT_COMMENTS].contains(sort)) {
      throw Exception('错误的sort参数，请使用SORT_CREATED、SORT_UPDATED、SORT_COMMENTS');
    }
    if (![STATE_OPEN, STATE_CLOSED, STATE_ALL].contains(state)) {
      throw Exception(
          '错误的 state 参数，请使用SORT_CREATED、SORT_UPDATED、SORT_COMMENTS');
    }
  }
}
