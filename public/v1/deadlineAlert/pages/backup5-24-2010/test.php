<?php
include("deadlineAlertHelper.php");
/*
$lastUpdated=strtotime("2010-05-10");
$todaysDate=date("Y-m-d");
$today=strtotime($todaysDate);
echo "**".(($today-$lastUpdated)/(60*60*24))."**";
*/
/*
$alertDesc="SAT Reasoning / ACT score report due by";
echo "*".substr($alertDesc,strlen($alertDesc)-3,strlen($alertDesc))."*<br>";
echo "*".substr($alertDesc,0,strlen($alertDesc)-3)."*";
*/
/*
$theDateStr="2010-05-17";
$theDateDate=strtotime($theDateStr);
$theDate=date("F j, Y",$theDateDate);
echo $theDate;
*/
echo date("m");
echo "/";
echo date("d");
echo "/";
echo date("Y")+1;

?>

<script type="text/javascript">
/*
var lastDeadline = -1;

function showOpts(deadline)
{
	if (lastDeadline > 0)
	{
		hideOpts(lastDeadline);
	}
	
	lastDeadline = deadline;
	var deadlineInfo = document.getElementById('deadlineInfo' + deadline);
	var deadlineOpts = document.getElementById('deadlineOpts' + deadline);
	var wrap = document.getElementById('wrap' + deadline);
	var table = document.getElementById('table' + deadline);
	deadlineInfo.style.borderTop = 'solid 1px black';
	deadlineInfo.style.borderLeft = 'solid 1px black';
	deadlineInfo.style.borderRight = 'solid 1px black';
	deadlineInfo.style.borderBottom = 'solid 0px transparent';
	deadlineInfo.style.backgroundColor = '#ffffff';
	deadlineOpts.style.display = '';
	wrap.style.zIndex = '3';
	table.style.zIndex = '4';
	return true;
}

function hideOpts(deadline)
{
	lastDeadline = -1;
	var deadlineInfo = document.getElementById('deadlineInfo' + deadline);
	var deadlineOpts = document.getElementById('deadlineOpts' + deadline);
	var wrap = document.getElementById('wrap' + deadline);
	var table = document.getElementById('table' + deadline);
	deadlineInfo.style.border = 'solid 1px transparent';
	deadlineInfo.style.backgroundColor = 'transparent';
	deadlineOpts.style.display = 'none';
	wrap.style.zIndex = '0';
	table.style.zIndex = '0';
	return true;
}

var ajaxItem = null;

function getSchools()
{
	ajaxItem = GetXmlHttpObject();

	if (!ajaxItem)
		return;

	ajaxItem.onreadystatechange = stateChanged;
	ajaxItem.open('GET', buildQuery(), true);
	ajaxItem.send(null);
}

function parseResponse(response)
{
	clearSchools();
	var x = response.toString().split('=');
	var y = new Array();
	var z = null;
	var w = null;
	for (i = 0; i < x.length; i++)
	{
		z = document.getElementById('addSch' + i);
		w = document.getElementById('sch' + i);
		y = x[i].split('+');
		if (y[1] == undefined) return;
		z.value = y[1];
		z.style.display = 'block';
		w.value = y[0];
	}
}

function buildQuery()
{
	return 'findschool.aspx?keys=' + document.getElementById('ctl00_ContentPlaceHolder1_Keywords').value.replace(/ /g, '_');
}

function GetXmlHttpObject()
{
	if (window.XMLHttpRequest)
		return new XMLHttpRequest();
	
	if (window.ActiveXObject)
		return new ActiveXObject('Microsoft.XMLHTTP');
	
	return null;
}

function stateChanged()
{
	if (ajaxItem.readyState == 4)
	{
		parseResponse(ajaxItem.responseText);
	}
}

function add(num)
{
	var x = document.getElementById('ctl00_ContentPlaceHolder1_AddThisSchool');
	var y = document.getElementById('sch' + num);
	x.value = y.value;
	document.getElementById('ctl00_ContentPlaceHolder1_AddSchoolButton').click();
}

function clearSchools()
{
	for (j = 0; j < 10; j++)
	{
		document.getElementById('sch' + j).value = '';
		document.getElementById('addSch' + j).value = '';
		document.getElementById('addSch' + j).style.display = 'none';
	}
}
*/
</script>
