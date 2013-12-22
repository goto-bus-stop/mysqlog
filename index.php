<?php
$c = json_decode(file_get_contents('conf.json'));
$db = new mysqli($c->host, $c->username, $c->password, $c->database);
foreach ($_POST as $k => $v) $post[] = urlencode($k) . '=' . urlencode($v);
$r = $db->query('CALL Route("' . $db->real_escape_string($_SERVER['REQUEST_URI']) . '", "' . implode('&', $post) . '")');
$r ? (print($r->fetch_row()[0]) and $r->free()) : print($db->error);