<?php
/*****************************************
action codes
A=add
D=delete
F=filter
MC=mark completed
UC=undo completed
*****************************************/
session_start();

if (!isset($_SESSION["username"]))
	header("location:deadlineAlertLauncher.php?login=session");

include("../../commonPhp/mySqlConnect.php");
include("../../commonPhp/getHtml.php");
include("deadlineAlertHelper.php");

$action=$_POST["hidAction"];
$userId=$_SESSION["userid"];
$username=$_SESSION["username"];

if ($action=="A")
{
	//$collegeId=$_POST["lstCollegeChoices"];
	$schoolId=$_POST["schoolId"];
	$schoolIds=$_POST["schoolIds"];
	
	$sql="SELECT ALERT_ID FROM TDEADLINEALERT_COLLEGES WHERE COLLEGE_ID=$schoolId ORDER BY ALERT_ID";
	$result=mysql_query($sql);
	
	if (mysql_num_rows($result)<1)
	{
		$sql="SELECT COLLEGEBOARD_ID FROM TCOLLEGE WHERE COLLEGE_ID=$schoolId";
		$result=mysql_query($sql);
		$row=mysql_fetch_array($result);
		insertDeadlinesInDb($schoolId, $row["COLLEGEBOARD_ID"]);
		
		$sql="SELECT ALERT_ID FROM TDEADLINEALERT_COLLEGES WHERE COLLEGE_ID=$schoolId ORDER BY ALERT_ID";
		$result=mysql_query($sql);
		
		while ($row=mysql_fetch_array($result))
		{
			$alertId=$row["ALERT_ID"];

			$sql="INSERT INTO TUSER_COLLEGE_DEADLINES (USER_ID, COLLEGE_ID, ALERT_ID, DATE_COMPLETED, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($userId, $schoolId, $alertId, NULL, '$username', NOW(), '$username', NOW())";
			$resultInsert=mysql_query($sql);
		}
	}
	else
	{
		while ($row=mysql_fetch_array($result))
		{
			$alertId=$row["ALERT_ID"];

			$sql="INSERT INTO TUSER_COLLEGE_DEADLINES (USER_ID, COLLEGE_ID, ALERT_ID, DATE_COMPLETED, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($userId, $schoolId, $alertId, NULL, '$username', NOW(), '$username', NOW())";
			$resultInsert=mysql_query($sql);
		}
	}

	//header("location:deadlineAlert.php");
	$sql="SELECT D.COLLEGE_ID, D.COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY COLLEGE_NAME, B.ALERT_ID+0";
	echo createMySchoolsList($schoolIds) . "|^|" . createDeadlineTable($sql, true, true);

	include("../../commonPhp/mySqlClose.php");
}
else if ($action=="D")
{
	//$schoolId=$_POST["hidDeleteSchool"];
	$schoolId=$_POST["schoolId"];
	$schoolIds=$_POST["schoolIds"];
	$sql="DELETE FROM TUSER_COLLEGE_DEADLINES WHERE USER_ID=$userId AND COLLEGE_ID=$schoolId";
	$result=mysql_query($sql);

	if ($result)
	{
		//header("location:deadlineAlert.php");
		$sql="SELECT D.COLLEGE_ID, D.COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY COLLEGE_NAME, B.ALERT_ID+0";
		echo createMySchoolsList($schoolIds) . "|^|" . createDeadlineTable($sql, true, true);
		include("../../commonPhp/mySqlClose.php");
	}
	else
	{
		echo "error in dealineAlertUpdate.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
		include("../../commonPhp/mySqlClose.php");
	}
}
else if ($action=="F")
{
	$schoolIds=$_POST["schoolIds"];
	$viewWhat=$_POST["viewWhat"];
	$sortBy=$_POST["sortBy"];
	
	if ($schoolIds=="")
		echo "\t\t\t<table width=\"100%\" border=\"1\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\"><u>School Name</u></td>\n\t\t\t\t\t<td align=\"center\"><u>Deadline</u></td>\n\t\t\t\t\t<td align=\"center\"><u>Due Date</u></td>\n\t\t\t\t\t<td align=\"center\"><u>Date Completed</u></td>\n\t\t\t\t</tr>\n\t\t\t</table>\n";
	else 
	{
		$sql="SELECT D.COLLEGE_ID, COLLEGE_NAME, B.ALERT_ID, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED, WEB_SITE_URL FROM TDEADLINEALERT_COLLEGES A, TDEADLINEALERT_TYPES B, TUSER_COLLEGE_DEADLINES C, TCOLLEGE D WHERE USER_ID=$userId AND C.COLLEGE_ID IN ($schoolIds)";

		switch ($viewWhat)
		{
/*			case "A":
				$sql.=" AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY ";
				break;
*/
			case "P":
				$sql.=" AND DATE_COMPLETED IS NULL";//C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY ";
				break;

			case "C":
				$sql.=" AND DATE_COMPLETED IS NOT NULL";//C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY ";
				break;
		}

		$sql.=" AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID";

		switch ($sortBy)
		{
			case "name":
				$sql.=" ORDER BY COLLEGE_NAME, B.ALERT_ID+0";
				echo createDeadlineTable($sql, true, true);
				break;

			case "deadline":
				$sql.=" ORDER BY ALERT_DESCRIPTION, COLLEGE_NAME";
				echo createDeadlineTable($sql, true, true);
				break;

			case "duedate":
				$sql1=$sql." AND DATE_DUE LIKE('%-%') AND DATE_DUE NOT LIKE ('%--%') AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY STR_TO_DATE(DATE_DUE,'%d-%b'), COLLEGE_NAME";
				echo createDeadlineTable($sql1, true, false);
				$sql2=$sql." AND (DATE_DUE NOT LIKE('%-%') OR DATE_DUE LIKE ('%--%')) AND C.COLLEGE_ID=A.COLLEGE_ID AND A.COLLEGE_ID=D.COLLEGE_ID AND C.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=A.ALERT_ID ORDER BY DATE_DUE, COLLEGE_NAME";
				echo createDeadlineTable($sql2, false, true);
				break;

			case "datecompleted":
				$sql1=$sql." AND DATE_COMPLETED IS NOT NULL ORDER BY DATE_COMPLETED, COLLEGE_NAME";
				echo createDeadlineTable($sql1, true, false);
				$sql2=$sql." AND DATE_COMPLETED IS NULL ORDER BY DATE_COMPLETED, COLLEGE_NAME";
				echo createDeadlineTable($sql2, false, true);
				break;
			
			default:
				$sql.=" ORDER BY COLLEGE_NAME, B.ALERT_ID+0";
				echo createDeadlineTable($sql, true, true);
				break;
		}
	}
	include("../../commonPhp/mySqlClose.php");
}
else if ($action=="MC")
{
	$schoolAndAlertId=$_POST["hidComplete"];
	$schoolAndAlertIdArray=explode("^", $schoolAndAlertId);

	$schoolId=$schoolAndAlertIdArray[0];
	$alertId=$schoolAndAlertIdArray[1];

	$sql="UPDATE TUSER_COLLEGE_DEADLINES SET DATE_COMPLETED=NOW() WHERE USER_ID=$userId AND COLLEGE_ID=$schoolId AND ALERT_ID=$alertId";
	$result=mysql_query($sql);

	if ($result)
	{
		include("../../commonPhp/mySqlClose.php");
		//header("location:deadlineAlert.php");
		$todaysDate=date("F j, Y");
		//echo $todaysDate . "<br><input type=\"button\" class=\"crsDAButtonSmall\" name=\"btnClear" . $schoolId . "^" . $alertId . "\" id=\"btnClear" . $schoolId . "^" . $alertId . "\" value=\"Clear\" onclick=\"btnClear_onclick(this);\">";
		echo $todaysDate;
	}
	else
	{
		echo "error in dealineAlertUpdate.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
		include("../../commonPhp/mySqlClose.php");
	}
}
else if ($action=="UC")
{
	$schoolAndAlertId=$_POST["hidComplete"];
	$schoolAndAlertIdArray=explode("^", $schoolAndAlertId);

	$schoolId=$schoolAndAlertIdArray[0];
	$alertId=$schoolAndAlertIdArray[1];

	$sql="UPDATE TUSER_COLLEGE_DEADLINES SET DATE_COMPLETED=NULL WHERE USER_ID=$userId AND COLLEGE_ID=$schoolId AND ALERT_ID=$alertId";
	$result=mysql_query($sql);

	if ($result)
	{
		include("../../commonPhp/mySqlClose.php");
		//header("location:deadlineAlert.php");
		//echo "<input type=\"button\" class=\"crsDAButtonSmall\" name=\"btnComplete" . $schoolId . "^" . $alertId . "\" id=\"btnComplete" . $schoolId . "^" . $alertId . "\" value=\"Complete\" onclick=\"btnComplete_onclick(this);\">";
		//echo "Not yet completed";
		echo $schoolAndAlertId;
	}
	else
	{
		echo "error in dealineAlertUpdate.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
		include("../../commonPhp/mySqlClose.php");
	}
}

?>
