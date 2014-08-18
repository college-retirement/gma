<?php
session_start();

//if (!isset($_SESSION["username"]))
//	header("location:collegeChoiceLogin.php?login=session");

include("../../commonPhp/mySqlConnect.php");
include("../../commonPhp/getHtml.php");
include("deadlineAlertHelper.php");

//$userId="1";
//$username="jopremcak";
$userIdUsername=$_POST["userIdUsername"];

if ($userIdUsername==null)
{
	$userId="1";
	$username="jopremcak";
}
else
{
	$userArray=explode("^", $userIdUsername);
	$userId=$userArray[0];
	$username=$userArray[1];
}

$_SESSION["userid"]=$userId;
$_SESSION["username"]=$username;

//$collegeList="";
//$selectedColleges="";
$deadlineList="";
$schoolIds="";
$checkCollegeBoardDays=90;  //check database for number of days in future release

//$sql1="SELECT COLLEGE_ID, COLLEGEBOARD_ID, COLLEGE_NAME FROM TCOLLEGE WHERE COLLEGE_ID IN (SELECT DISTINCT(COLLEGE_ID) FROM TUSER_COLLEGE_DEADLINES WHERE USER_ID=$userId) ORDER BY COLLEGE_NAME";
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

$sql="SELECT D.COLLEGE_ID, D.COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY COLLEGE_NAME, B.ALERT_ID+0";
$deadlineList=createDeadlineTable($sql, true, true);

/*
if ($result1)
{
	$i=0;
	$idsForJavascript="";

	while ($row1=mysql_fetch_array($result1))
	{
		//$collegeId=$row1["COLLEGE_ID"];
		$collegeboardId=$row1["COLLEGEBOARD_ID"];
		//$collegeName=$row1["COLLEGE_NAME"];
		$collegeIdArray[$i]=$collegeId;
		$idsForJavascript.="\"$collegeId\",";

		$sql2="SELECT DATE_COLLEGEBOARD_CHECKED FROM TDEADLINEALERT_COLLEGES WHERE COLLEGE_ID=$collegeId ORDER BY DATE_COLLEGEBOARD_CHECKED ASC";
		$result2=mysql_query($sql2);
		
		while ($row2=mysql_fetch_array($result2))
		{
			$lastUpdated=strtotime($row2["DATE_COLLEGEBOARD_CHECKED"]);
			$todaysDate=date("Y-m-d");
			$today=strtotime($todaysDate);
			$daysElapsed=($today-$lastUpdated)/(60*60*24);

			if ($daysElapsed>$checkCollegeBoardDays)
			{
				insertDeadlinesInDb($collegeId, $collegeboardId);
				break;
			}
		}

		//$sql3="SELECT ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C WHERE COLLEGE_ID=$collegeId AND USER_ID=$userId AND A.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=C.ALERT_ID ORDER BY B.ALERT_ID";
		$sql3="SELECT B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND C.COLLEGE_ID=$collegeId AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY B.ALERT_ID+0";
		$result3=mysql_query($sql3);
		
		if ($result3)
		{
			$j=0;
			while ($row3=mysql_fetch_array($result3))
			{
				$alertId=$row3["ALERT_ID"];
				$alertDesc=$row3["ALERT_DESCRIPTION"];
				$dueDate=$row3["DATE_DUE"];
				$dateCompleted=$row3["DATE_COMPLETED"];
				$webSite=$row3["WEB_SITE_URL"];

				//$dateCompleted=($dateCompleted==null ? "<input type=\"button\" class=\"crsButtonSmall\" name=\"btnComplete" . $collegeId . "^" . $alertId . "\" id=\"btnComplete" . $collegeId . "^" . $alertId . "\" value=\"Complete\" onclick=\"btnComplete_onclick(this);\">" : $dateCompleted . "<br><input type=\"button\" class=\"crsButtonSmall\" name=\"btnClear" . $collegeId . "^" . $alertId . "\" id=\"btnClear" . $collegeId . "^" . $alertId . "\" value=\"Clear\" onclick=\"btnClear_onclick(this);\">");

				$deadlineList.="\t\t\t\t<tr class=\"tr" . ($j%2==0 ? "1" : "2") . "\">\n";
				$deadlineList.="\t\t\t\t\t<td>" . $collegeName . "</td>\n";
				$deadlineList.="\t\t\t\t\t<td>" . formatDeadline($alertDesc) . "</td>\n";
				//$deadlineList.="\t\t\t\t\t<td>" . ($dueDate=="--" ? "<a href=\"" . $webSite . "\" target=\"_blank\" class=\"crsSmallBlue\">Date unavailable, refer to school web site</a>" : $dueDate) . "</td>\n";
				$deadlineList.="\t\t\t\t\t<td>" . formatDueDate($dueDate, $webSite) . "</td>\n";
				$deadlineList.="\t\t\t\t\t<td align=\"center\"><span id=\"spn" . $collegeId . "^" . $alertId . "\">" . formatDateCompleted($dateCompleted, $collegeId, $alertId) . "</span></td>\n";
				$deadlineList.="\t\t\t\t</tr>\n";
				
				$j++;
			}
		}
		
		$i++;
	}

	$idsForJavascript=substr($idsForJavascript,0,strlen($idsForJavascript)-1);
}

$sql4="SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE ORDER BY COLLEGE_NAME ASC";
$result4=mysql_query($sql4);

$selectedColleges="\t\t\t<div style=\"border:2px black solid;\">\n\t\t\t<table width=\"99%\" border=\"0\">\n";

while($row4=mysql_fetch_array($result4))
{
	$collegeId=$row4["COLLEGE_ID"];
	$collegeName=$row4["COLLEGE_NAME"];
	
	$collegeList.="<option value=\"" . $collegeId . "\">" . $collegeName . "</option>\n";

	if (count($collegeIdArray)>0)
	{
		for ($i=0; $i<count($collegeIdArray); $i++)
		{
			if ($collegeId==$collegeIdArray[$i])
			{
				//$selectedColleges.="\t\t\t<br>\n\t\t\t" . $collegeName . "&nbsp;&nbsp;<a href=\"javascript:removeCollege('" . $collegeIdArray[$i] . "', '" . $collegeName . "');\" class=\"crsBlue\"><img src=\"../images/filter.gif\" border=\"0\" alt=\"Filter your Deadline Alerts for " . $collegeName . "\"><img src=\"../images/remove.gif\" border=\"0\" width=\"10\" height=\"10\" alt=\"Remove " . $collegeName . " from your Deadline Alerts\"></a>\n";
				$selectedColleges.="\t\t\t\t<tr class=\"tr" . ($i%2==0 ? "1" : "2") . "\">\n";
				$selectedColleges.="\t\t\t\t\t<td>" . $collegeName . "</td>\n";
				$selectedColleges.="\t\t\t\t\t<td align=\"center\" valign=\"middle\"><a href=\"javascript:filterCollege('" . $collegeIdArray[$i] . "');\"><img src=\"../images/filter.gif\" id=\"imgFilter" . $collegeIdArray[$i] . "\" border=\"0\" width=\"26\" height=\"15\" alt=\"Filter your Deadline Alerts for " . $collegeName . "\"></a>&nbsp;&nbsp;<a href=\"javascript:removeCollege('" . $collegeIdArray[$i] . "', '" . $collegeName . "');\"><img src=\"../images/remove.gif\" border=\"0\" width=\"15\" height=\"15\" alt=\"Remove " . $collegeName . " from your Deadline Alerts\"></a></td>\n";
				$selectedColleges.="\t\t\t\t</tr>\n";
			}
		}
	}
	else
		$selectedColleges="\t\t\t<table width=\"99%\" border=\"0\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td>No colleges selected</td>\n\t\t\t\t</tr>\n\t\t\t</table>\n";
}

if (count($collegeIdArray)>0)
	$selectedColleges.="\t\t\t</table>\n\t\t\t</div>\n";
*/
include("../../commonPhp/mySqlClose.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>

<head>

<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">

<title>College & Retirement Solutions - Deadline Alert</title>

<script language="JavaScript" type="text/javascript">
<!--
var schoolIds="<?php echo $schoolIds; ?>";
var schoolIdsArray=new Array("<?php echo str_replace(",","\",\"",$schoolIds); ?>");
var url="deadlineAlertUpdate.php";

//function addCollege()
function addSchool(whichButton)
{
	//var schoolId=document.frmDeadlineAlert.lstCollegeChoices.value;
	var schoolId=document.getElementById("hidSchool"+whichButton).value;

	if (schoolId=="")
		alert("Please select a school.");
	else
	{
		for (var i=0; i<schoolIdsArray.length; i++)
		{
			if (schoolIdsArray[i]==schoolId)
			{
				//alert("You already have "+document.frmDeadlineAlert.lstCollegeChoices[document.frmDeadlineAlert.lstCollegeChoices.selectedIndex].text+" in your Deadline Alert list.");
				alert("You already have "+document.getElementById("btnAddSchool"+whichButton).value+" in your Deadline Alert list.");
				return false;
			}
		}

		schoolIds+=","+schoolId;
//		document.frmDeadlineAlert.hidAction.value="A";
//		document.frmDeadlineAlert.submit();
		var params="hidAction=A&schoolId="+schoolId+"&schoolIds="+schoolIds;

		var xmlhttp=new XMLHttpRequest();

		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
				document.getElementById("spnMySchoolsList").innerHTML=xmlhttp.responseText;
		}
		xmlhttp.open("POST", url, true);

		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.setRequestHeader("Content-length", params.length);
		xmlhttp.setRequestHeader("Connection", "close");

		xmlhttp.send(params);
	}
}

function filterSchool(schoolId)
{
	var imgSrc;
	var url="deadlineAlertUpdate.php";

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

	var allPendingCompleteValue="A";
	var allPendingComplete=document.frmDeadlineAlert.radViewAllPendingComplete;

	for (i=0; i<allPendingComplete.length; i++)
	{
		if (allPendingComplete[i].checked)
		{
			allPendingCompleteValue=allPendingComplete[i].value;
			break;
		}
	}

	var sortBy=document.frmDeadlineAlert.hidSortBy.value;
	var params="hidAction=F&schoolIds="+schoolIds+"&viewWhat="+allPendingCompleteValue+"&sortBy="+sortBy;

	filterViewSort(params);

	document.getElementById("imgFilter"+schoolId).src=imgSrc;
}

function removeSchool(schoolId, schoolName)
{
	if (confirm("Are you sure you want to delete "+schoolName+" from your Deadline Alerts?\n\nYou will lose all completed deadlines if you delete this school.\n\nYou can use the filter button to hide deadlines instead of removing the school."))
	{
		//document.frmDeadlineAlert.hidAction.value="D";
		//document.frmDeadlineAlert.hidDeleteSchool.value=schoolId;
		//document.frmDeadlineAlert.submit();

		if (schoolIds.indexOf(schoolId+",")>=0)
			schoolIds=schoolIds.replace(schoolId+",","");
		else if (schoolIds.indexOf(","+schoolId)>=0)
			schoolIds=schoolIds.replace(","+schoolId,"");
		else if (schoolIds.indexOf(schoolId)>=0)
			schoolIds=schoolIds.replace(schoolId,"");

		var params="hidAction=D&schoolId="+schoolId+"&schoolIds="+schoolIds;

		var xmlhttp=new XMLHttpRequest();

		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
				document.getElementById("spnMySchoolsList").innerHTML=xmlhttp.responseText;
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

function clearSchools()
{
	document.getElementById("txtSearchSchoolName").value="";

	for (var i=1; i<=10; i++)
	{
		document.getElementById("hidSchool"+i).value="";
		document.getElementById("btnAddSchool"+i).value="";
		document.getElementById("btnAddSchool"+i).style.display="none";
	}
}

function filterViewSort(params)
{
	var xmlhttp=new XMLHttpRequest();

	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
			document.getElementById("spnDeadlineTable").innerHTML=xmlhttp.responseText;
	}
	xmlhttp.open("POST", url, true);

	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader("Content-length", params.length);
	xmlhttp.setRequestHeader("Connection", "close");

	xmlhttp.send(params);
}

function completeClear(params, buttonId)
{
	var xmlhttp=new XMLHttpRequest();

	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
			document.getElementById("spn"+buttonId).innerHTML=xmlhttp.responseText;
	}
	xmlhttp.open("POST", url, true);

	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader("Content-length", params.length);
	xmlhttp.setRequestHeader("Connection", "close");

	xmlhttp.send(params);
}

function radViewAllPendingComplete_onclick(viewWhat)
{
	var sortBy=document.frmDeadlineAlert.hidSortBy.value;
	var params="hidAction=F&schoolIds="+schoolIds+"&viewWhat="+viewWhat+"&sortBy="+sortBy;

	filterViewSort(params);
}

function btnComplete_onclick(whichButton)
{
	var buttonId=whichButton.id.substring(11,whichButton.id.length);
	//var url="deadlineAlertUpdate.php";
	var params="hidAction=MC&hidComplete="+buttonId;
/*
	var xmlhttp=new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
			document.getElementById("spn"+buttonId).innerHTML=xmlhttp.responseText;
	}
	xmlhttp.open("POST", url, true);

	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader("Content-length", params.length);
	xmlhttp.setRequestHeader("Connection", "close");

	xmlhttp.send(params);
*/
	completeClear(params, buttonId);
}

function btnClear_onclick(whichButton)
{
	if (confirm("Are you sure you want to clear the date completed for this deadline?"));
	{
		var buttonId=whichButton.id.substring(8,whichButton.id.length);
		//var url="deadlineAlertUpdate.php";
		var params="hidAction=UC&hidComplete="+buttonId;
/*
		var xmlhttp=new XMLHttpRequest();
		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState==4 && xmlhttp.status==200)
				document.getElementById("spn"+buttonId).innerHTML=xmlhttp.responseText;
		}
		xmlhttp.open("POST", url, true);

		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.setRequestHeader("Content-length", params.length);
		xmlhttp.setRequestHeader("Connection", "close");

		xmlhttp.send(params);
*/
		completeClear(params, buttonId);
	}
}

function sortDeadlines(sortBy)
{
	document.frmDeadlineAlert.hidSortBy.value=sortBy;

	var allPendingCompleteValue="A";
	var allPendingComplete=document.frmDeadlineAlert.radViewAllPendingComplete;

	for (i=0; i<allPendingComplete.length; i++)
	{
		if (allPendingComplete[i].checked)
		{
			allPendingCompleteValue=allPendingComplete[i].value;
			break;
		}
	}

	var params="hidAction=F&schoolIds="+schoolIds+"&viewWhat="+allPendingCompleteValue+"&sortBy="+sortBy;

	filterViewSort(params);
}
-->
</script>

</head>

<body>

<!--<div id="crsWrapper">-->

<div id="crsContent">

<table width="100%" border="0">
	<tr>
		<td align="left" width="20%">&nbsp;<!--<?php if ($_SESSION["usertype"]=="A") echo "<a class=\"crsBlue\" href=\"collegeChoiceAdminConsole.php\">Admin Console</a>"; else echo "&nbsp;"; ?>--></td>
		<td align="center" class="crsLarge">Deadline Alert</td>
		<td align="right" width="20%">&nbsp;<!--<a class="crsBlue" href="collegeChoiceLogout.php">Log Out</a>--></td>
	</tr>
</table>

<form name="frmDeadlineAlert" method="POST" action="deadlineAlertUpdate.php">
<table width="100%" border="0">
	<tr>
		<td valign="top" width="50%">
			<span class="crsMedium" style="font-weight:bold;text-decoration:underline;">My Schools</span>
<!--<?php //echo $selectedColleges; ?>-->
			<span id="spnMySchoolsList"><?php echo $mySchoolsList; ?></span>
			<br>
		</td>
		<td valign="top">
			<span class="crsMedium" style="font-weight:bold;text-decoration:underline;">Add Schools</span><!-- <span class="crsSmall">(Double-click on a school, or click "Add College" below)</span>-->
			<br>
			<input type="text" name="txtSearchSchoolName" id="txtSearchSchoolName" size="20" maxlength="100" onkeyup="txtSearchSchoolName_onkeyup();">&nbsp;&nbsp;<input type="button" class="crsButton" name="btnClearSchools" id="btnClearSchools" value="Clear" onclick="clearSchools();">
			<input type="button" name="btnAddSchool1" id="btnAddSchool1" class="crsDASchoolButton" onclick="addSchool(1);" value="">
			<input type="button" name="btnAddSchool2" id="btnAddSchool2" class="crsDASchoolButton" onclick="addSchool(2);" value="">
			<input type="button" name="btnAddSchool3" id="btnAddSchool3" class="crsDASchoolButton" onclick="addSchool(3);" value="">
			<input type="button" name="btnAddSchool4" id="btnAddSchool4" class="crsDASchoolButton" onclick="addSchool(4);" value="">
			<input type="button" name="btnAddSchool5" id="btnAddSchool5" class="crsDASchoolButton" onclick="addSchool(5);" value="">
			<input type="button" name="btnAddSchool6" id="btnAddSchool6" class="crsDASchoolButton" onclick="addSchool(6);" value="">
			<input type="button" name="btnAddSchool7" id="btnAddSchool7" class="crsDASchoolButton" onclick="addSchool(7);" value="">
			<input type="button" name="btnAddSchool8" id="btnAddSchool8" class="crsDASchoolButton" onclick="addSchool(8);" value="">
			<input type="button" name="btnAddSchool9" id="btnAddSchool9" class="crsDASchoolButton" onclick="addSchool(9);" value="">
			<input type="button" name="btnAddSchool10" id="btnAddSchool10" class="crsDASchoolButton" onclick="addSchool(10);" value="">
<!--
			<br>
			<select name="lstCollegeChoices" class="multSelect" size="5" ondblclick="addCollege();" onkeydown="if (event.keyCode==13) addCollege();" onchange="document.getElementById('divCollegeChoicesText').innerHTML=this[selectedIndex].text;">
<?php //echo $collegeList; ?>
			</select>
			<br>
			<div id="divCollegeChoicesText">&nbsp;</div>
			<div style="text-align:center;"><input type="button" class="crsButton" name="btnAddCollege" id="btnAddCollege" value="Add College" onclick="addCollege();"></div>
			<br>
-->		</td>
	</tr>
	<tr>
		<td valign="bottom"><span class="crsMedium" style="font-weight:bold;text-decoration:underline;">Deadline List</span>&nbsp;&nbsp;<span class="crsSmall">Click on a column heading to sort by that column</span></td>
		<!--<td align="right"><input type="button" class="crsButton" name="btnViewPending" id="btnViewPending" value="  View Pending  " onclick="btnViewPending_onclick();">&nbsp;&nbsp;		<input type="button" class="crsButton" name="btnViewCompleted" id="btnViewCompleted" value="View Completed" onclick="btnViewCompleted_onclick();"></td>-->
		<td valign="bottom" align="right">View:&nbsp;&nbsp;<input type="radio" name="radViewAllPendingComplete" id="radViewAllPendingComplete" value="A" onclick="radViewAllPendingComplete_onclick(this.value);" checked>All&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="radViewAllPendingComplete" id="radViewAllPendingComplete" value="P" onclick="radViewAllPendingComplete_onclick(this.value);">Pending&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="radViewAllPendingComplete" id="radViewAllPendingComplete" value="C" onclick="radViewAllPendingComplete_onclick(this.value);">Complete</td>
	</tr>
	<tr>
		<td colspan="2"><span id="spnDeadlineTable">
<!--		<table width="100%" border="1">
				<tr>
					<td align="center" nowrap><?php //if ($deadlineList!="") echo "<a href=\"javascript:sortDeadlines('name');\" class=\"crsBlue\">"; ?><u>School Name</u><?php //if ($deadlineList!="") echo "</a>"; ?></td>
					<td align="center" nowrap><?php //if ($deadlineList!="") echo "<a href=\"javascript:sortDeadlines('deadline');\" class=\"crsBlue\">"; ?><u>Action</u><?php //if ($deadlineList!="") echo "</a>"; ?></td>
					<td align="center" nowrap><?php //if ($deadlineList!="") echo "<a href=\"javascript:sortDeadlines('duedate');\" class=\"crsBlue\">"; ?><u>Due Date</u><?php //if ($deadlineList!="") echo "</a>"; ?></td>
					<td align="center" nowrap><?php //if ($deadlineList!="") echo "<a href=\"javascript:sortDeadlines('datecompleted');\" class=\"crsBlue\">"; ?><u>Date Completed</u><?php //if ($deadlineList!="") echo "</a>"; ?></td>
				</tr>
-->
<?php echo $deadlineList; ?>
			</table>
			</span>
		</td>
	</tr>
</table>
<input type="hidden" name="hidAction" id="hidAction" value="">
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