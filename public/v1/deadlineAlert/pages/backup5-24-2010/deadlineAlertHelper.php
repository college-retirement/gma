<?php

function createMySchoolsList($schoolIds)
{
	$selectedSchools="\t\t\t<table width=\"99%\" border=\"0\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td>No schools selected</td>\n\t\t\t\t</tr>\n\t\t\t</table>\n";

	if ($schoolIds!="")
	{
		$selectedSchools="\t\t\t<div style=\"border:2px black solid;\">\n\t\t\t<table width=\"99%\" border=\"0\">\n";
		$i=0;

		$sql="SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE WHERE COLLEGE_ID IN ($schoolIds)";
		$result=mysql_query($sql);
		
		while ($row=mysql_fetch_array($result))
		{
			$schoolId=$row["COLLEGE_ID"];
			$schoolName=$row["COLLEGE_NAME"];
			
			$selectedSchools.="\t\t\t\t<tr class=\"tr" . ($i%2==0 ? "1" : "2") . "\">\n";
			$selectedSchools.="\t\t\t\t\t<td>" . $schoolName . "</td>\n";
			$selectedSchools.="\t\t\t\t\t<td align=\"center\" valign=\"middle\"><a href=\"javascript:filterSchool('" . $schoolId . "');\"><img src=\"../images/filter.gif\" id=\"imgFilter" . $schoolId . "\" border=\"0\" width=\"26\" height=\"15\" alt=\"Filter your Deadline Alerts for " . $schoolName . "\"></a>&nbsp;&nbsp;<a href=\"javascript:removeSchool('" . $schoolId . "', '" . $schoolName . "');\"><img src=\"../images/remove.gif\" border=\"0\" width=\"15\" height=\"15\" alt=\"Remove " . $schoolName . " from your Deadline Alerts\"></a></td>\n";
			$selectedSchools.="\t\t\t\t</tr>\n";
			
			$i++;
		}

		$selectedSchools.="\t\t\t</table>\n\t\t\t</div>\n";
	}
	
	return $selectedSchools;
}

function createDeadlineTable($sql, $printHeader, $printFooter)
{
	$result=mysql_query($sql);
	//$deadlineList="\t\t\t<table width=\"100%\" border=\"1\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\"><u>School Name</u></td>\n\t\t\t\t\t<td align=\"center\"><u>Deadline</u></td>\n\t\t\t\t\t<td align=\"center\"><u>Due Date</u></td>\n\t\t\t\t\t<td align=\"center\"><u>Date Completed</u></td>\n\t\t\t\t</tr>\n\t\t\t</table>\n";
	
	if ($result)
	{
		if ($printHeader)
		{
			$deadlineList="\t\t\t<table width=\"100%\" border=\"1\">\n";
			$deadlineList.="\t\t\t\t<tr>\n";
			$deadlineList.="\t\t\t\t\t<td align=\"center\" nowrap><a href=\"javascript:sortDeadlines('name');\" class=\"crsBlue\"><u>School Name</u></a></td>\n";
			$deadlineList.="\t\t\t\t\t<td align=\"center\" nowrap><a href=\"javascript:sortDeadlines('deadline');\" class=\"crsBlue\"><u>Action</u></a></td>\n";
			$deadlineList.="\t\t\t\t\t<td align=\"center\" nowrap><a href=\"javascript:sortDeadlines('duedate');\" class=\"crsBlue\"><u>Due Date</u></a></td>\n";
			$deadlineList.="\t\t\t\t\t<td align=\"center\" nowrap><a href=\"javascript:sortDeadlines('datecompleted');\" class=\"crsBlue\"><u>Date Completed</u></a></td>\n";
			$deadlineList.="\t\t\t\t</tr>\n";
		}

		$i=0;

		while($row=mysql_fetch_array($result))
		{
			$schoolId=$row["COLLEGE_ID"];
			$schoolName=$row["COLLEGE_NAME"];
			$alertId=$row["ALERT_ID"];
			$alertDesc=$row["ALERT_DESCRIPTION"];
			$dueDate=$row["DATE_DUE"];
			$dateCompleted=$row["DATE_COMPLETED"];
			$webSite=$row["WEB_SITE_URL"];

			//$dateCompleted=($dateCompleted==null ? "<input type=\"button\" class=\"crsButtonSmall\" name=\"btnComplete" . $collegeId . "^" . $alertId . "\" id=\"btnComplete" . $collegeId . "^" . $alertId . "\" value=\"Complete\" onclick=\"btnComplete_onclick(this);\">" : $dateCompleted . "<br><input type=\"button\" class=\"crsButtonSmall\" name=\"btnClear" . $collegeId . "^" . $alertId . "\" id=\"btnClear" . $collegeId . "^" . $alertId . "\" value=\"Clear\" onclick=\"btnClear_onclick(this);\">");

			$deadlineList.="\t\t\t\t<tr class=\"tr" . ($i%2==0 ? "1" : "2") . "\">\n";
			$deadlineList.="\t\t\t\t\t<td>" . $schoolName . "</td>\n";
			$deadlineList.="\t\t\t\t\t<td>" . formatDeadline($alertDesc) . "</td>\n";
			//$deadlineList.="\t\t\t\t\t<td>" . ($dueDate=="--" ? "<a href=\"" . $webSite . "\" target=\"_blank\" class=\"crsSmallBlue\">Date unavailable, refer to school web site</a>" : $dueDate) . "</td>\n"
			$deadlineList.="\t\t\t\t\t<td>" . formatDueDate($dueDate, $webSite) . "</td>\n";
			$deadlineList.="\t\t\t\t\t<td align=\"center\"><span id=\"spn" . $schoolId . "^" . $alertId . "\">" . formatDateCompleted($dateCompleted, $schoolId, $alertId) . "</span></td>\n";
			$deadlineList.="\t\t\t\t</tr>\n";

			$i++;
		}
		
		if ($printFooter)
			$deadlineList.="\t\t\t</table>";
		
		return $deadlineList;
	}
	else
	{
		return "error in dealineAlertUpdate.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
		include("../../commonPhp/mySqlClose.php");
	}
}

function insertDeadlinesInDb($schoolId, $collegeboardId)
{
	$sqlDelete="DELETE FROM TDEADLINEALERT_COLLEGES WHERE COLLEGE_ID=$schoolId";
	$resultDelete=mysql_query($sqlDelete);

	$newlines=array("\t","\n","\r","\x20\x20","\0","\x0B");

	$url0="http://collegesearch.collegeboard.com/search/CollegeDetail.jsp?collegeId=" . $collegeboardId . "&profileId=0";
	$rawData0=getHtml($url0);
	$content0=str_replace($newlines, "", html_entity_decode($rawData0));	

	$start=strpos($content0,'<td id="main_address">');
	$end=strpos($content0,'</td>',$start)+5;
	$tempStr=substr($content0,$start,$end-$start);

	if (strpos($tempStr,'target="new">')!==false)
	{
		$start=strpos($tempStr,'target="new">')+13;
		$end=strpos($tempStr,'</a>',$start);
		$url=substr($tempStr,$start,$end-$start);
		$url="http://" . $url . "/";
	}
	else
		$url="";

	$sqlUpdate="UPDATE TCOLLEGE SET WEB_SITE_URL='$url' WHERE COLLEGE_ID=$schoolId";
	$resultUpdate=mysql_query($sqlUpdate);

	if (!$resultUpdate)
	{
		echo "error in dealineAlertGetDeadlines.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sqlInsert;
		include("../../commonPhp/mySqlClose.php");
	}

	$url5="http://collegesearch.collegeboard.com/search/CollegeDetail.jsp?collegeId=" . $collegeboardId . "&profileId=5";
	$rawData5=getHtml($url5);
	$content5=str_replace($newlines, "", html_entity_decode($rawData5));

	$sqlSelect="SELECT ALERT_ID, ALERT_DESCRIPTION FROM TDEADLINEALERT_TYPES ORDER BY ALERT_ID";
	$resultSelect=mysql_query($sqlSelect);
	
	while ($rowSelect=mysql_fetch_array($resultSelect))
	{
		$alertId=$rowSelect["ALERT_ID"];
		$deadlineSearchString=$rowSelect["ALERT_DESCRIPTION"];
		
		$start=strpos($content5,$deadlineSearchString)+strlen($deadlineSearchString)+2;
		$end=strpos($content5,'</li>',$start);
		$dueDate=substr($content5,$start,$end-$start);

		$sqlInsert="INSERT INTO TDEADLINEALERT_COLLEGES (COLLEGE_ID, ALERT_ID, DATE_DUE, DATE_COLLEGEBOARD_CHECKED, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($schoolId, '$alertId', '$dueDate', NOW(), '$username', NOW(), '$username', NOW())";
		$resultInsert=mysql_query($sqlInsert);
		
		if (!$resultInsert)
		{
			echo "error in dealineAlertGetDeadlines.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sqlInsert;
			include("../../commonPhp/mySqlClose.php");
		}
	}
}

function formatDeadline($description)
{
	return (substr($description,strlen($description)-3,strlen($description))==" by" ? substr($description,0,strlen($description)-3) : $description);
}

function formatDueDate($theDate, $webSite)
{
	$restOfTheDate="";

	if ($theDate=="--")
		$formattedDate="<a href=\"" . $webSite . "\" target=\"_blank\" class=\"crsSmallBlue\">Date unavailable, refer to school web site</a>";
	else if (strpos($theDate, '-')!==false)
	{
		if (strlen($theDate)>6)
		{
			$tempDate=substr($theDate,0,6);
			$restOfTheDate=substr($theDate,6,strlen($theDate)-1);
			$theDate=$tempDate;
		}
		
		$dueDateArray=explode("-", $theDate);
		$dueDateDay=$dueDateArray[0];
		$dueDateMonth=$dueDateArray[1];
		
		$dueDateDay=(substr($dueDateDay,0,1)=="0" ? substr($dueDateDay,1,2) : $dueDateDay);
				
		switch ($dueDateMonth)
		{
			case "JAN":
				$formattedDate="January " . $dueDateDay;
				break;
			case "FEB":
				$formattedDate="February " . $dueDateDay;
				break;
			case "MAR":
				$formattedDate="March " . $dueDateDay;
				break;
			case "APR":
				$formattedDate="April " . $dueDateDay;
				break;
			case "MAY":
				$formattedDate="May " . $dueDateDay;
				break;
			case "JUN":
				$formattedDate="June " . $dueDateDay;
				break;
			case "JUL":
				$formattedDate="July " . $dueDateDay;
				break;
			case "AUG":
				$formattedDate="August " . $dueDateDay;
				break;
			case "SEP":
				$formattedDate="September " . $dueDateDay;
				break;
			case "OCT":
				$formattedDate="October " . $dueDateDay;
				break;
			case "NOV":
				$formattedDate="November " . $dueDateDay;
				break;
			case "DEC":
				$formattedDate="December " . $dueDateDay;
				break;
		}
	}
	else
		$formattedDate=$theDate;
	
	return $formattedDate . $restOfTheDate;
}

function formatDateCompleted($theDate, $schoolId, $alertId)
{
	if ($theDate==null)
		return "<input type=\"button\" class=\"crsButtonSmall\" name=\"btnComplete" . $schoolId . "^" . $alertId . "\" id=\"btnComplete" . $schoolId . "^" . $alertId . "\" value=\"Complete\" onclick=\"btnComplete_onclick(this);\">";
	else
		return date("F j, Y",strtotime($theDate)) . "<br><input type=\"button\" class=\"crsButtonSmall\" name=\"btnClear" . $schoolId . "^" . $alertId . "\" id=\"btnClear" . $schoolId . "^" . $alertId . "\" value=\"Clear\" onclick=\"btnClear_onclick(this);\">";
}

function formatDateCompletedForEmail($theDate)
{
	return ($theDate==null ? "" : date("F j, Y",strtotime($theDate)));
}

?>