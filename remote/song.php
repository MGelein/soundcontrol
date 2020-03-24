<?php

if(isset($_GET['song'])){
    $song = $_GET['song'];
    $song = preg_replace('/[^a-zA-Z0-9\.-_]/', '', $song);
    file_put_contents("song.txt", $song);
    echo("Ok, song is now $song");
}else{
    die("No song parameter was specified");
}