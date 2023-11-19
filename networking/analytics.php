<?php
function getUserIpAddr(){
    if(!empty($_SERVER['HTTP_CLIENT_IP'])){
        //ip from share internet
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    }elseif(!empty($_SERVER['HTTP_X_FORWARDED_FOR'])){
        //ip pass from proxy
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    }else{
        $ip = $_SERVER['REMOTE_ADDR'];
    }
    return $ip;
}
$ip = getUserIpAddr();
$time = $_SERVER["REQUEST_TIME"];
$uri = $_SERVER['REQUEST_URI'];
$referrer = $_SERVER["HTTP_REFERRER"];
$agent = $_SERVER["HTTP_USER_AGENT"];

$fp = fopen('./data.psv', 'a');
fwrite($fp, $ip.'|'.$time.'|'.$uri.'|'.$referrer.'|'.$agent);
fclose($fp);
?>
