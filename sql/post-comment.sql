-- WTFTJ Blog Engine

SELECT ShowPage(
  IF ((LoggedIn() AND AddComment(
        (SELECT value FROM params WHERE name = 'postId'),
        LoggedIn(),
        GetStringParam(@POST, 'comment')
  ))
  , "Comment posted"
  , "You should log in before posting")
)