<?php
session_start();
//die("Testing...");

include("../../commonPhp/mySqlConnect.php");
include("../../commonPhp/getHtml.php");
include("deadlineAlertHelper.php");


//$userIdUsername=$_POST["userIdUsername"];
$userIdUsername = $_COOKIE["logcookie"];

/*
if (!isset($_SESSION["username"]) && $userIdUsername==null)
	header("location:deadlineAlertLauncher.php?login=session");
*/




/*
$db5 = mysql_query("SELECT DATABASE()") or die(mysql_error());
$rr = mysql_fetch_assoc($db5);
print_r($rr);
*/



$que = "SELECT USER_ID FROM TUSER WHERE USERNAME = '$userIdUsername';";

$gu = mysql_query($que) or die("An error has occurred. <br/>" . mysql_error());
$gu_rows = mysql_num_rows($gu);
//$gid = mysql_fetch_assoc($gu) or die("Count not fetch associative array. Error on line 33." . mysql_error());
if($gu_rows==0){
	die("User record not found.");
}
$gid2 = mysql_result($gu, 0, 'USER_ID'); //$gid['USER_ID'];




/*
$userArray=explode("^", $userIdUsername);
$userId=$userArray[0];
$username=$userArray[1];
*/

$userId =$gid2;
$username = $userIdUsername;


$_SESSION["userid"]=$userId;
$_SESSION["username"]=$username;

$deadlineList="";
$schoolIds="";
$checkCollegeBoardDays=90;  //in a future release, check the database for number of days instead of hard-coding

$sql1="SELECT DISTINCT(A.COLLEGE_ID), COLLEGEBOARD_ID, DATE_COLLEGEBOARD_CHECKED FROM TCOLLEGE A, TDEADLINEALERT_COLLEGES B WHERE B.COLLEGE_ID IN (SELECT DISTINCT(COLLEGE_ID) FROM TUSER_COLLEGE_DEADLINES WHERE USER_ID=$userId) AND A.COLLEGE_ID=B.COLLEGE_ID ORDER BY COLLEGE_NAME";
$result1=mysql_query($sql1);



if ($result1)
{
	while ($row1=mysql_fetch_array($result1))
	{
		$schoolId=$row1["COLLEGE_ID"];
		$collegeboardId=$row1["COLLEGEBOARD_ID"];
		$lastUpdated=strtotime($row2["DATE_COLLEGEBOARD_CHECKED"]);
		$todaysDate=date("Y-m-d");
		$today=strtotime($todaysDate);
		$daysElapsed=($today-$lastUpdated)/(60*60*24);

		$schoolIds.=$schoolId.",";
		
		if ($daysElapsed>$checkCollegeBoardDays)
			insertDeadlinesInDb($schoolId, $collegeboardId);
	}

	$schoolIds=substr($schoolIds,0,strlen($schoolIds)-1);
}

$mySchoolsList=createMySchoolsList($schoolIds);





//display by schools as default
$sql="SELECT D.COLLEGE_ID, COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID='$userId' AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY COLLEGE_NAME, B.ALERT_ID+'0'";
$deadlineList=createDeadlineTable($sql, true, true, "S");

//display by deadline as default
//$sql="SELECT D.COLLEGE_ID, COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY ALERT_DESCRIPTION, COLLEGE_NAME";
//$deadlineList=createDeadlineTable($sql, true, true, "D");

//display by date as default
//$sql="SELECT D.COLLEGE_ID, COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND DATE_DUE LIKE('%-%') AND DATE_DUE NOT LIKE ('%--%') AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY STR_TO_DATE(DATE_DUE,'%d-%b'), COLLEGE_NAME, B.ALERT_ID+0";
//$deadlineList=createDeadlineTable($sql, true, false, "A");
//$sql="SELECT D.COLLEGE_ID, COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND (DATE_DUE NOT LIKE('%-%') OR DATE_DUE LIKE ('%--%')) AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY DATE_DUE, COLLEGE_NAME, B.ALERT_ID+0";
//$deadlineList.=createDeadlineTable($sql, false, true, "A");

include("../../commonPhp/mySqlClose.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>

<head>

<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">
<link rel="stylesheet" type="text/css" href="../../commonCss/subModal.css">
<script type="text/javascript" src="../../commonJs/common.js"></script>
<script type="text/javascript" src="../../commonJs/subModal.js"></script>

<title>College & Retirement Solutions - Deadline Alerts</title>

<script language="JavaScript" type="text/javascript">
<!--
var schoolIds="<?php echo $schoolIds; ?>";
var schoolIdsArray=new Array("<?php echo str_replace(",","\",\"",$schoolIds); ?>");
var url="deadlineAlertUpdate.php";
//var monthArray=new Array("January","February","March","April","May","June","July","August","September","October","November","December");
var fadeStartColor="70C466";

function showHide(whichId)
{
	if (document.getElementById(whichId).style.display=="none")
		document.getElementById(whichId).style.display="inline";
	else
		document.getElementById(whichId).style.display="none";
}

function addSchool(whichButton)
{
	var schoolId=document.getElementById("hidSchool"+whichButton).value;

	if (schoolId=="")
		alert("Please select a school.");
	else if (schoolId!="0")
	{
		for (var i=0; i<schoolIdsArray.length; i++)
		{
			if (schoolIdsArray[i]==schoolId)
			{
				alert("You already have "+document.getElementById("btnAddSchool"+whichButton).value+" in your Deadline Alert list.");
				return false;
			}
		}

		schoolIds+=","+schoolId;
		schoolIdsArray[schoolIdsArray.length]=schoolId;

		var params="action=A&schoolId="+schoolId+"&schoolIds="+schoolIds;

		var xmlhttp=new XMLHttpRequest();

		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
			{
				var responseString=xmlhttp.responseText;
				var responseStringArray=responseString.split("|^|");
				document.getElementById("spnMySchoolsList").innerHTML=responseStringArray[0];
				document.getElementById("spnDeadlineTable").innerHTML=responseStringArray[1];
				var fadeEndColor=(document.getElementById("mySchools"+schoolId).className=="tr1" ? "FFFFFF" : "BBC4FD");
				fadeBackground("mySchools"+schoolId, fadeStartColor, fadeEndColor, 1000, 25, fadeEndColor);
			}
		}
		xmlhttp.open("POST", url, true);

		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.setRequestHeader("Content-length", params.length);
		xmlhttp.setRequestHeader("Connection", "close");

		xmlhttp.send(params);
		
		btnClearSchools_onclick();
	}
}

function filterSchool(schoolId)
{
	var imgSrc="../images/filter.gif";

	if (schoolIds.indexOf(schoolId+",")>=0)
	{
		schoolIds=schoolIds.replace(schoolId+",","");
		imgSrc="../images/filter_bw.gif";
	}
	else if (schoolIds.indexOf(","+schoolId)>=0)
	{
		schoolIds=schoolIds.replace(","+schoolId,"");
		imgSrc="../images/filter_bw.gif";
	}
	else if (schoolIds.indexOf(schoolId)>=0)
	{
		schoolIds=schoolIds.replace(schoolId,"");
		imgSrc="../images/filter_bw.gif";
	}
	else
	{
		schoolIds+=(schoolIds=="" ? schoolId : ","+schoolId);
		imgSrc="../images/filter.gif";
	}

	schoolIds=((schoolIds.indexOf(",")==schoolIds.length-1) ? schoolIds.replace(",","") : schoolIds);

	document.getElementById("imgFilter"+schoolId).src=imgSrc;
	
	filterViewByShow();
}

function filterViewByShow()
{
	var viewBy=document.frmDeadlineAlert.radViewBy;
	var viewByValue;
	var show=document.frmDeadlineAlert.radShow;
	var showValue;
	var deadlineListInstructions;
	
	for (i=0; i<viewBy.length; i++)
	{
		if (viewBy[i].checked)
		{
			viewByValue=viewBy[i].value;
			break;
		}
	}

	for (i=0; i<show.length; i++)
	{
		if (show[i].checked)
		{
			showValue=show[i].value;
			break;
		}
	}
	
	switch (viewByValue)
	{
		case "S":
			deadlineListInstructions="Click on a school to expand/contract";
			break;

		case "D":
			deadlineListInstructions="Click on a deadline to expand/contract";
			break;

		case "A":
			deadlineListInstructions="Click on a date to contract/expand<br>(Note: dates are ordered by school year, not calendar year)";
			break;
	}
	
	var params="action=F&schoolIds="+schoolIds+"&viewBy="+viewByValue+"&show="+showValue;

	var xmlhttp=new XMLHttpRequest();

	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			document.getElementById("spnDeadlineListInstructions").innerHTML=deadlineListInstructions;
			document.getElementById("spnDeadlineTable").innerHTML=xmlhttp.responseText;
		}
	}
	xmlhttp.open("POST", url, true);

	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader("Content-length", params.length);
	xmlhttp.setRequestHeader("Connection", "close");

	xmlhttp.send(params);
}

function removeSchool(schoolId, schoolName)
{
	if (confirm("Are you sure you want to delete "+schoolName+" from your Deadline Alerts?\n\nYou will lose all completed deadlines if you delete this school.\n\nYou can use the filter button to hide deadlines instead of removing the school entirely."))
	{
		if (schoolIds.indexOf(schoolId+",")>=0)
			schoolIds=schoolIds.replace(schoolId+",","");
		else if (schoolIds.indexOf(","+schoolId)>=0)
			schoolIds=schoolIds.replace(","+schoolId,"");
		else if (schoolIds.indexOf(schoolId)>=0)
			schoolIds=schoolIds.replace(schoolId,"");

		for (var i=0; i<schoolIdsArray.length; i++)
		{
			if (schoolIdsArray[i]==schoolId)
			{
				schoolIdsArray[i]="";
				break;
			}
		}

		var params="action=D&schoolId="+schoolId+"&schoolIds="+schoolIds;

		var xmlhttp=new XMLHttpRequest();

		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
			{
				var responseString=xmlhttp.responseText;
				var responseStringArray=responseString.split("|^|");
				document.getElementById("spnMySchoolsList").innerHTML=responseStringArray[0];
				document.getElementById("spnDeadlineTable").innerHTML=responseStringArray[1];
			}
		}
		xmlhttp.open("POST", url, true);

		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.setRequestHeader("Content-length", params.length);
		xmlhttp.setRequestHeader("Connection", "close");

		xmlhttp.send(params);
	}
}

function txtSearchSchoolName_onkeyup()
{
	var keywords=document.getElementById("txtSearchSchoolName").value;

	if (keywords=="")
		clearSchools();
	else
	{
		var params="keywords="+keywords;

		var xmlhttp=new XMLHttpRequest();

		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
			{
				clearSchools();
				var schoolList=xmlhttp.responseText;
				var schoolListArray=schoolList.split("|");

				document.getElementById("spnSchoolButtons").style.display="inline";

				for (var i=0; i<schoolListArray.length; i++)
				{
					var schoolIdNameArray=schoolListArray[i].split("^");
					var schoolId=schoolIdNameArray[0];
					var schoolName=schoolIdNameArray[1];
					document.getElementById("hidSchool"+(i+1)).value=schoolId;
					document.getElementById("btnAddSchool"+(i+1)).value=schoolName;
					document.getElementById("btnAddSchool"+(i+1)).style.display="block";
				}
			}
		}
		xmlhttp.open("POST", "deadlineAlertGetSchools.php", true);

		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.setRequestHeader("Content-length", params.length);
		xmlhttp.setRequestHeader("Connection", "close");

		xmlhttp.send(params);
	}
}

function btnClearSchools_onclick()
{
	document.getElementById("txtSearchSchoolName").value="";
	clearSchools();
}

function clearSchools()
{
	for (var i=1; i<=10; i++)
	{
		document.getElementById("hidSchool"+i).value="";
		document.getElementById("btnAddSchool"+i).value="";
		document.getElementById("btnAddSchool"+i).style.display="none";
	}
	
	document.getElementById("spnSchoolButtons").style.display="none";
	document.getElementById("txtSearchSchoolName").focus();
}

function deadline_onmouseover(whichTd)
{
	document.getElementById(whichTd.id).className="tdDeadlineAlertMouseover";
	document.getElementById("spnDeadline"+(whichTd.id.substring(2,whichTd.id.length))).style.display="inline";
}

function deadline_onmouseout(whichTd)
{
	document.getElementById(whichTd.id).className="tdDeadlineAlertMouseout";
	document.getElementById("spnDeadline"+(whichTd.id.substring(2,whichTd.id.length))).style.display="none";
}

function college_onmouseover(whichTd)
{
	document.getElementById(whichTd.id).className="tdRedBorderOn";
	document.getElementById("spnDeadline"+(whichTd.id.substring(2,whichTd.id.length))).style.display="inline";
}

function college_onmouseout(whichTd)
{
	document.getElementById(whichTd.id).className="";
	document.getElementById("spnDeadline"+(whichTd.id.substring(2,whichTd.id.length))).style.display="none";
}

function btnComplete_onclick(whichButton)
{
	var buttonId=whichButton.id.substring(11,whichButton.id.length);
	var params="action=MC&hidComplete="+buttonId;

	var xmlhttp=new XMLHttpRequest();

	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
			document.getElementById("spnDeadline"+buttonId).innerHTML="<br><span class=\"crsTiny\">Completed "+xmlhttp.responseText+"</span>&nbsp;&nbsp;<a class=\"crsTinyBlue\" href=\"javascript:lnkClear_onclick('"+buttonId+"');\">Clear</a>";
	}
	xmlhttp.open("POST", url, true);

	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader("Content-length", params.length);
	xmlhttp.setRequestHeader("Connection", "close");

	xmlhttp.send(params);	
}

function lnkClear_onclick(whichLink)
{
	if (confirm("Are you sure you want to clear the date completed for this deadline?"))
	{
		var params="action=UC&hidComplete="+whichLink;

		var xmlhttp=new XMLHttpRequest();

		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
			{
				var respTxt=xmlhttp.responseText;
				document.getElementById("spnDeadline"+whichLink).innerHTML="<br><input type=\"button\" class=\"crsDAButtonSmall\" name=\"btnComplete"+respTxt+"\" id=\"btnComplete"+respTxt+"\" value=\"Mark as Complete\" onclick=\"btnComplete_onclick(this);\"></span>";
			}
		}
		xmlhttp.open("POST", url, true);

		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.setRequestHeader("Content-length", params.length);
		xmlhttp.setRequestHeader("Connection", "close");

		xmlhttp.send(params);	
	}
}

function fadeBackground(elementId, startColor, endColor, duration, fps, originalColor) 
{
	var fadeElement=document.getElementById(elementId);

	if (originalColor==undefined)
		originalColor="Transparent";

	if(duration<=(1000/fps))
	{
		fadeElement.style.backgroundColor="#"+originalColor;
		return;
	}

	fadeElement.style.backgroundColor="#"+startColor;

	var rHs=startColor.substring(0,2);
	var rNs=parseInt(rHs,'16');
	var rHe=endColor.substring(0,2);
	var rNe=parseInt(rHe, '16');
	var gHs=startColor.substring(2,4);
	var gNs=parseInt(gHs,'16');
	var gHe=endColor.substring(2,4);
	var gNe=parseInt(gHe,'16');
	var bHs=startColor.substring(4,6);
	var bNs=parseInt(bHs,'16');
	var bHe=endColor.substring(4,6);
	var bNe=parseInt(bHe, '16');
	var deltaR=(rNs-rNe);
	var deltaG=(gNs-gNe);
	var deltaB=(bNs-bNe);
	var nextR=decToHex(rNs-(((1000/fps)/duration))*(deltaR));
	var nextG=decToHex(gNs-(((1000/fps)/duration))*(deltaG));
	var nextB=decToHex(bNs-(((1000/fps)/duration))*(deltaB));
	var nextRGB=nextR+nextG+nextB+"";

	duration=(duration-(1000/fps));

	setTimeout("fadeBackground('"+elementId+"','"+nextRGB+"','"+endColor+"','"+duration+"','"+fps+"','"+originalColor+"');",(1000/fps));
}

function decToHex(decimal)
{
	var a=decimal%16;
	var b=(decimal-a)/16;
	var hexChars="0123456789ABCDEF";
	return hexChars.charAt(b)+hexChars.charAt(a)+"";
}

function openHelp()
{
	showPopWin("deadlineAlertHelp.html", 450, 350, null);
}
-->
</script>

</head>

<body onLoad="document.frmDeadlineAlert.txtSearchSchoolName.focus();">

<!--<div id="crsWrapper">-->

<div id="crsContent">

<table width="100%" border="0">
	<tr>
		<td align="left" width="20%">&nbsp;<!--<?php if ($_SESSION["usertype"]=="A") echo "<a class=\"crsBlue\" href=\"collegeChoiceAdminConsole.php\">Admin Console</a>"; else echo "&nbsp;"; ?>--></td>
		<!--<td align="center" class="crsLargeBold">Deadline Alerts</td>-->
		<td align="center"><img src="../images/DeadlineAlertLogo.gif"></td>
		<td align="right" width="20%">&nbsp;</td>
	</tr>
</table>

<form name="frmDeadlineAlert" method="POST" action="deadlineAlertUpdate.php">
<table width="100%" border="0">
	<tr>
		<td valign="top" width="50%">
			<span class="crsMedium" style="font-weight:bold;text-decoration:underline;">My Schools</span>&nbsp;&nbsp;&nbsp;&nbsp;<span style="cursor:default;" onClick="openHelp();"> ? </span>
			<span id="spnMySchoolsList">
<?php echo $mySchoolsList; ?>
			</span>
			<br>
		</td>
		<td valign="top">
			<span class="crsMedium" style="font-weight:bold;text-decoration:underline;">Add Schools</span>&nbsp;&nbsp;&nbsp;&nbsp;<span style="cursor:default;" onClick="openHelp();"> ? </span>
			<br>
			<input type="text" name="txtSearchSchoolName" id="txtSearchSchoolName" size="20" maxlength="100" onKeyUp="txtSearchSchoolName_onkeyup();">&nbsp;&nbsp;<input type="button" class="crsDAButton" name="btnClearSchools" id="btnClearSchools" value="Clear" onClick="btnClearSchools_onclick();">
			<br>
			<span id="spnSchoolButtons" style="border:solid 1px black;position:absolute;background-color:#FFFFCA;z-index:50;display:none;">
				<input type="button" name="btnAddSchool1" id="btnAddSchool1" class="crsDASchoolButton" onClick="addSchool(1);" value="">
				<input type="button" name="btnAddSchool2" id="btnAddSchool2" class="crsDASchoolButton" onClick="addSchool(2);" value="">
				<input type="button" name="btnAddSchool3" id="btnAddSchool3" class="crsDASchoolButton" onClick="addSchool(3);" value="">
				<input type="button" name="btnAddSchool4" id="btnAddSchool4" class="crsDASchoolButton" onClick="addSchool(4);" value="">
				<input type="button" name="btnAddSchool5" id="btnAddSchool5" class="crsDASchoolButton" onClick="addSchool(5);" value="">
				<input type="button" name="btnAddSchool6" id="btnAddSchool6" class="crsDASchoolButton" onClick="addSchool(6);" value="">
				<input type="button" name="btnAddSchool7" id="btnAddSchool7" class="crsDASchoolButton" onClick="addSchool(7);" value="">
				<input type="button" name="btnAddSchool8" id="btnAddSchool8" class="crsDASchoolButton" onClick="addSchool(8);" value="">
				<input type="button" name="btnAddSchool9" id="btnAddSchool9" class="crsDASchoolButton" onClick="addSchool(9);" value="">
				<input type="button" name="btnAddSchool10" id="btnAddSchool10" class="crsDASchoolButton" onClick="addSchool(10);" value="">
			</span>
		</td>
	</tr>
</table>
<hr width="90%" style="text-align:center;">
<br>
<table width="100%" border="0">
	<tr>
		<td valign="bottom" width="10%" nowrap><span class="crsMedium" style="font-weight:bold;text-decoration:underline;">Deadline List</span>&nbsp;&nbsp;&nbsp;&nbsp;<span style="cursor:default;" onClick="openHelp();"> ? </span></td>
		<td valign="bottom"><span id="spnDeadlineListInstructions" class="crsSmall">Click on a school to expand/contract</span></td>
		<td valign="bottom" align="right" width="10%" nowrap>
			<table style="border-style:outset;border-width:1px;border-color:#7F9DB9;border-collapse:collapse;background-color:white;">
				<tr>
					<td align="right" style="border-style:inset;border-width:1px;border-color:#7F9DB9;" nowrap>View By:&nbsp;&nbsp;<input type="radio" name="radViewBy" id="radViewBy" value="S" onClick="filterViewByShow();" checked>School&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="radViewBy" id="radViewBy" value="D" onClick="filterViewByShow();">Deadline&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="radViewBy" id="radViewBy" value="A" onClick="filterViewByShow();">Date</td>
				</tr>
				<tr>
					<td align="right" style="border-style:inset;border-width:1px;border-color:#7F9DB9;" nowrap>Show:&nbsp;&nbsp;<input type="radio" name="radShow" id="radShow" value="A" onClick="filterViewByShow();" checked>All&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="radShow" id="radShow" value="P" onClick="filterViewByShow();">Pending&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="radShow" id="radShow" value="C" onClick="filterViewByShow();">Complete</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<span id="spnDeadlineTable">
<?php echo $deadlineList; ?>
</span>

<input type="hidden" name="hidDeleteSchool" id="hidDeleteSchool" value="">
<input type="hidden" name="hidSortBy" id="hidSortBy" value="name">
<input type="hidden" name="hidSchool1" id="hidSchool1" value="">
<input type="hidden" name="hidSchool2" id="hidSchool2" value="">
<input type="hidden" name="hidSchool3" id="hidSchool3" value="">
<input type="hidden" name="hidSchool4" id="hidSchool4" value="">
<input type="hidden" name="hidSchool5" id="hidSchool5" value="">
<input type="hidden" name="hidSchool6" id="hidSchool6" value="">
<input type="hidden" name="hidSchool7" id="hidSchool7" value="">
<input type="hidden" name="hidSchool8" id="hidSchool8" value="">
<input type="hidden" name="hidSchool9" id="hidSchool9" value="">
<input type="hidden" name="hidSchool10" id="hidSchool10" value="">
</form>

<br>

</div>

<!--</div>-->

</body>

</html>