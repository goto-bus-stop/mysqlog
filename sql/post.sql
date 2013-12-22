-- WTFTJ Blog Engine

SELECT ShowPage(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(cont, '${id}', p.id),
          '${title}', p.title),
        '${date}', p.date
      ),
      '${content}', p.content
    ),
    '${comments}', IFNULL((
      SELECT GROUP_CONCAT(
        REPLACE(
          REPLACE(cont, '${author}', IFNULL(u.name, 'Anonymous')),
          '${content}', c.content
        ) SEPARATOR '')
      FROM templates t, comments c, users u
      WHERE t.name = 'comment' AND c.pid = params.value AND (u.id = c.uid)
    ), 'No Comments')
  )
)
FROM templates t, posts p, params
WHERE t.name = 'post' AND params.name = 'postId' AND p.id = params.value