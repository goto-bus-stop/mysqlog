-- WTFTJ Blog Engine

SELECT ShowPage(REPLACE(t.cont, '${list}', CONCAT(
  '<ul>',
  (
    SELECT GROUP_CONCAT(CONCAT('<li><a href="post/', p.id, '">', p.title, '</a> - <time>', p.date, '</time></li>') SEPARATOR '')
    FROM posts p
    ORDER BY p.date DESC
    LIMIT 10
  ),
  '</ul>'
)))
FROM templates t
WHERE t.name = 'home'