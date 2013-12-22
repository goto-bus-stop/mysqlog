-- Adminer 3.7.1 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = '+01:00';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `uid` int(11) NOT NULL DEFAULT '1',
  `content` varchar(1000) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `comments` (`id`, `pid`, `uid`, `content`, `date`) VALUES
(1,	1,	1,	'Hello Hello',	'0000-00-00 00:00:00'),
(2,	1,	2,	'comm',	'0000-00-00 00:00:00');

DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `value` varchar(300) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `config` (`id`, `name`, `value`) VALUES
(1,	'base',	'/mycms');

DROP TABLE IF EXISTS `pages`;
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `func` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `pages` (`id`, `name`, `func`) VALUES
(1,	'index',	'-- WTFTJ Blog Engine\r\n\r\nSELECT ShowPage(REPLACE(t.cont, \'${list}\', CONCAT(\r\n  \'<ul>\',\r\n  (\r\n    SELECT GROUP_CONCAT(CONCAT(\'<li><a href=\"post/\', p.id, \'\">\', p.title, \'</a> - <time>\', p.date, \'</time></li>\') SEPARATOR \'\')\r\n    FROM posts p\r\n    ORDER BY p.date DESC\r\n    LIMIT 10\r\n  ),\r\n  \'</ul>\'\r\n)))\r\nFROM templates t\r\nWHERE t.name = \'home\''),
(2,	'post',	'-- WTFTJ Blog Engine\r\n\r\nSELECT ShowPage(\r\n  REPLACE(\r\n    REPLACE(\r\n      REPLACE(\r\n        REPLACE(\r\n          REPLACE(cont, \'${id}\', p.id),\r\n          \'${title}\', p.title),\r\n        \'${date}\', p.date\r\n      ),\r\n      \'${content}\', p.content\r\n    ),\r\n    \'${comments}\', IFNULL((\r\n      SELECT GROUP_CONCAT(\r\n        REPLACE(\r\n          REPLACE(cont, \'${author}\', IFNULL(u.name, \'Anonymous\')),\r\n          \'${content}\', c.content\r\n        ) SEPARATOR \'\')\r\n      FROM templates t, comments c, users u\r\n      WHERE t.name = \'comment\' AND c.pid = params.value AND (u.id = c.uid)\r\n    ), \'No Comments\')\r\n  )\r\n)\r\nFROM templates t, posts p, params\r\nWHERE t.name = \'post\' AND params.name = \'postId\' AND p.id = params.value'),
(3,	'post-comment',	'-- WTFTJ Blog Engine\r\n\r\nSELECT ShowPage(\r\n  IF ((LoggedIn() AND AddComment(\r\n        (SELECT value FROM params WHERE name = \'postId\'),\r\n        LoggedIn(),\r\n        GetStringParam(@POST, \'comment\')\r\n  ))\r\n  , \"Comment posted\"\r\n  , \"You should log in before posting\")\r\n)');

DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '1',
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `posts` (`id`, `uid`, `title`, `content`, `date`) VALUES
(1,	2,	'Test Post',	'Posting',	'2013-12-13 08:48:46'),
(2,	2,	'Another Post',	'From later',	'2013-12-13 08:50:13');

DROP TABLE IF EXISTS `routes`;
CREATE TABLE `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(100) NOT NULL,
  `parseAs` varchar(100) NOT NULL,
  `resolve` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `routes` (`id`, `path`, `parseAs`, `resolve`) VALUES
(1,	'^/$',	'',	'index'),
(2,	'^/post/[^/]+$',	'/post/@postId',	'post'),
(3,	'^/post/[^/]+/comment$',	'/post/@postId/comment',	'post-comment');

DROP TABLE IF EXISTS `templates`;
CREATE TABLE `templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `cont` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `templates` (`id`, `name`, `cont`) VALUES
(1,	'layout',	'<!DOCTYPE html>\r\n<html>\r\n  <head>\r\n    <title> MyCMS </title>\r\n    <link href=\"//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css\" rel=\"stylesheet\">\r\n  </head>\r\n  <body>\r\n    <main role=\"main\" class=\"container\">\r\n      ${content}\r\n    </main>\r\n  </body>\r\n</html>'),
(2,	'post',	'<ol class=\"breadcrumb\">\r\n  <li><a href=\"../\">Home</a></li>\r\n  <li>${title}</li>\r\n</ol>\r\n<article>\r\n  <header>\r\n    <h1>${title} <time class=\"small\">posted on ${date}</time></h1>\r\n  </header>\r\n  <div class=\"post-content\"> ${content} </div>\r\n  <section>\r\n    <header>\r\n      <h2>Comments</h2>\r\n    </header>\r\n    <div> ${comments} </div>\r\n    <hr> <h3>Write Comment</h3>\r\n    <form action=\"./${id}/comment\" method=\"post\">\r\n      <div class=\"form-group\">\r\n        <textarea class=\"form-control\" name=\"comment\"></textarea>\r\n      </div>\r\n      <button class=\"btn btn-default\" type=\"submit\">Post Comment</button>\r\n    </form>\r\n  </section>\r\n</article>'),
(3,	'comment',	'<div class=\"media comment\">\r\n  <div class=\"media-body\">\r\n    <strong class=\"media-heading\">${author}</strong>\r\n    <p>${content}</p>\r\n  </div>\r\n</div>'),
(4,	'redirect',	'<script>setTimeout(function () { window.location = \'${url}\' }, 100)</script>'),
(5,	'home',	'<ol class=\"breadcrumb\">\r\n  <li>Home</li>\r\n</ol>\r\n${list}');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `password` char(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `users` (`id`, `name`, `password`) VALUES
(1,	'Anonymous',	'b6589fc6ab0dc82cf12099d1c2d40ab994e8410c'),
(2,	'Admin',	'a94a8fe5ccb19ba61c4c0873d391e987982fbbd3'),
(3,	'Test',	'a94a8fe5ccb19ba61c4c0873d391e987982fbbd3');

-- 2013-12-22 22:05:07