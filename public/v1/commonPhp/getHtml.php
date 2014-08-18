<?php

$timeout=0;

function getHtml($url)
{
	global $timeout;
	
	$cUrl=curl_init();
	curl_setopt($cUrl,CURLOPT_URL,$url);
	curl_setopt($cUrl,CURLOPT_RETURNTRANSFER,1);
	curl_setopt($cUrl,CURLOPT_CONNECTTIMEOUT,$timeout);
	$rawData=curl_exec($cUrl);
	curl_close($cUrl);
	
	return $rawData;
}

?>