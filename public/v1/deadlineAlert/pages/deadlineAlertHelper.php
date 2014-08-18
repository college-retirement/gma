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
			
			$selectedSchools.="\t\t\t\t<tr id=\"mySchools" . $schoolId . "\" class=\"tr" . ($i%2==0 ? "1" : "2") . "\">\n";
			$selectedSchools.="\t\t\t\t\t<td class=\"deadlineAlertSchool\">" . $schoolName . "</td>\n";
			$selectedSchools.="\t\t\t\t\t<td align=\"center\" valign=\"middle\"><a href=\"javascript:filterSchool('" . $schoolId . "');\"><img src=\"../images/filter.gif\" id=\"imgFilter" . $schoolId . "\" border=\"0\" width=\"26\" height=\"15\" alt=\"Filter your Deadline Alerts for " . $schoolName . "\"></a>&nbsp;&nbsp;<a href=\"javascript:removeSchool('" . $schoolId . "', '" . $schoolName . "');\"><img src=\"../images/remove.gif\" border=\"0\" width=\"15\" height=\"15\" alt=\"Remove " . $schoolName . " from your Deadline Alerts\"></a></td>\n";
			$selectedSchools.="\t\t\t\t</tr>\n";
			
			$i++;
		}

		$selectedSchools.="\t\t\t</table>\n\t\t\t</div>\n";
	}
	
	return $selectedSchools;
}

function createDeadlineTable($sql, $printHeader, $printFooter, $viewBy)
{
	$result=mysql_query($sql);
	
	if ($result)
	{
		if ($printHeader)
			$deadlineList="<table width=\"100%\" border=\"1\" bordercolor=\"grey\">\n";

		$i=0;
		$j=0;
		$lastMatch="";

		while($row=mysql_fetch_array($result))
		{
			$schoolId=$row["COLLEGE_ID"];
			$schoolName=$row["COLLEGE_NAME"];
			$alertId=$row["ALERT_ID"];
			$alertDesc=$row["ALERT_DESCRIPTION"];
			$dueDate=$row["DATE_DUE"];
			$dateCompleted=$row["DATE_COMPLETED"];
			$webSite=$row["WEB_SITE_URL"];

			switch ($viewBy)
			{
				case "S":
					if ($schoolId!=$lastMatch)
					{
						if ($lastMatch!="")
						{
							$deadlineList.="\t\t\t</span>\n";
							$deadlineList.="\t\t\t</table>\n";
							$deadlineList.="\t\t</td>\n";
							$deadlineList.="\t</tr>\n";
							
							$i=0;
						}
						
						$deadlineList.="\t<tr class=\"tr" . ($j%2==0 ? "1" : "2") . "\">\n";
						$deadlineList.="\t\t<td class=\"deadlineAlertSchool\" style=\"padding-left:12px;\"><span onclick=\"showHide('schools" . $schoolId . "');\" style=\"cursor:default;\">" . $schoolName . "</span>\n";
						$deadlineList.="\t\t\t<span id=\"schools" . $schoolId . "\" style=\"display:none\">\n";
						$deadlineList.="\t\t\t<br>\n";
						$deadlineList.="\t\t\t<table width=\"100%\" border=\"1\" bordercolor=\"grey\">\n";
						$deadlineList.="\t\t\t\t<tr class=\"tr1\">\n";
						$deadlineList.="\t\t\t\t\t<td width=\"50%\" align=\"center\" valign=\"middle\" nowrap><u>Action</u><br><span class=\"crsTiny\">(Mouse over for details)</span></td>\n";
						$deadlineList.="\t\t\t\t\t<td align=\"center\" valign=\"middle\" nowrap><u>Due Date</u></td>\n";
						$deadlineList.="\t\t\t\t</tr>\n";
						
						$j++;
					}
					
					$deadlineList.="\t\t\t\t<tr class=\"tr" . ($i%2==0 ? "2" : "1") . "\">\n";
					$deadlineList.="\t\t\t\t\t<td id=\"td" . $schoolId . "^" . $alertId . "\" valign=\"middle\" class=\"crsSmall\" height=\"50\" style=\"padding-left:12px;\" onmouseover=\"deadline_onmouseover(this);\" onmouseout=\"deadline_onmouseout(this);\">" . formatDeadline($alertDesc) . "<span id=\"spnDeadline" . $schoolId . "^" . $alertId . "\" style=\"position:relative;display:none;\"><br>" . formatActionButtons($dateCompleted, $schoolId, $alertId) . "</span></td>\n";
					$deadlineList.="\t\t\t\t\t<td valign=\"middle\">\n";
					$deadlineList.="\t\t\t\t\t\t<table width=\"100%\" style=\"border-style:none;\">\n";
					$deadlineList.="\t\t\t\t\t\t\t<tr>\n";
					$deadlineList.="\t\t\t\t\t\t\t\t<td width=\"50\"" . formatDueDate1($dueDate) . "</td>\n";
					$deadlineList.="\t\t\t\t\t\t\t\t<td class=\"crsSmall\">" . formatDueDate2($dueDate, $webSite) . "</td>\n";
					$deadlineList.="\t\t\t\t\t\t\t</tr>\n";
					$deadlineList.="\t\t\t\t\t\t</table>\n";
					$deadlineList.="\t\t\t\t\t</td>\n";
					$deadlineList.="\t\t\t\t</tr>\n";

					$i++;
					$lastMatch=$schoolId;
					
					break;
				
				case "D":
					if ($alertId!=$lastMatch)
					{
						if ($lastMatch!="")
						{
							$deadlineList.="\t\t\t</span>\n";
							$deadlineList.="\t\t\t</table>\n";
							$deadlineList.="\t\t</td>\n";
							$deadlineList.="\t</tr>\n";
							
							$i=0;
						}
						
						$deadlineList.="\t<tr class=\"tr" . ($j%2==0 ? "1" : "2") . "\">\n";
						$deadlineList.="\t\t<td style=\"padding-left:12px;\"><span onclick=\"showHide('deadlines" . $alertId . "');\" style=\"cursor:default\">" . formatDeadline($alertDesc) . "</span>\n";
						$deadlineList.="\t\t\t<span id=\"deadlines" . $alertId . "\" style=\"display:none\">\n";
						$deadlineList.="\t\t\t<br>\n";
						$deadlineList.="\t\t\t<table width=\"100%\" border=\"1\" bordercolor=\"grey\">\n";
						$deadlineList.="\t\t\t\t<tr class=\"tr1\">\n";
						$deadlineList.="\t\t\t\t\t<td width=\"50%\" align=\"center\" valign=\"middle\" nowrap><u>School</u><br><span class=\"crsTiny\">(Mouse over for details)</span></td>\n";
						$deadlineList.="\t\t\t\t\t<td align=\"center\" valign=\"middle\" nowrap><u>Due Date</u></td>\n";
						$deadlineList.="\t\t\t\t</tr>\n";
						
						$j++;
					}
					
					$deadlineList.="\t\t\t\t<tr class=\"tr" . ($i%2==0 ? "2" : "1") . "\">\n";
					$deadlineList.="\t\t\t\t\t<td id=\"td" . $schoolId . "^" . $alertId . "\" valign=\"middle\" height=\"50\" style=\"padding-left:12px;\" onmouseover=\"college_onmouseover(this);\" onmouseout=\"college_onmouseout(this);\"><span class=\"deadlineAlertSchool\">" . $schoolName . "</span><span id=\"spnDeadline" . $schoolId . "^" . $alertId . "\" style=\"position:relative;display:none;\">&nbsp;&nbsp;" . formatActionButtons($dateCompleted, $schoolId, $alertId) . "</span></td>\n";
					$deadlineList.="\t\t\t\t\t<td valign=\"middle\">\n";
					$deadlineList.="\t\t\t\t\t\t<table width=\"100%\" style=\"border-style:none;\">\n";
					$deadlineList.="\t\t\t\t\t\t\t<tr>\n";
					$deadlineList.="\t\t\t\t\t\t\t\t<td width=\"50\"" . formatDueDate1($dueDate) . "</td>\n";
					$deadlineList.="\t\t\t\t\t\t\t\t<td class=\"crsSmall\">" . formatDueDate2($dueDate, $webSite) . "</td>\n";
					$deadlineList.="\t\t\t\t\t\t\t</tr>\n";
					$deadlineList.="\t\t\t\t\t\t</table>\n";
					$deadlineList.="\t\t\t\t\t</td>\n";
					$deadlineList.="\t\t\t\t</tr>\n";

					$i++;
					$lastMatch=$alertId;					

					break;
				
				case "A":
					if ($dueDate!=$lastMatch)
					{
						if ($lastMatch!="")
						{
							$deadlineList.="\t\t\t</span>\n";
							$deadlineList.="\t\t\t</table>\n";
							$deadlineList.="\t\t</td>\n";
							$deadlineList.="\t</tr>\n";
							
							$i=0;
						}
						
						$deadlineList.="\t<tr class=\"tr" . ($j%2==0 ? "1" : "2") . "\">\n";
						$deadlineList.="\t\t<td height=\"50\" style=\"padding-left:12px;\">\n";
						$deadlineList.="\t\t\t<span onclick=\"showHide('dates" . $dueDate . "');\" style=\"cursor:default\">\n";
						$deadlineList.=formatDueDate3($dueDate);
						$deadlineList.="\t\t\t</span>\n";
						$deadlineList.="\t\t\t<span id=\"dates" . $dueDate . "\" style=\"display:inline\">\n";
						$deadlineList.="\t\t\t<table width=\"100%\" border=\"1\" bordercolor=\"grey\">\n";
						$deadlineList.="\t\t\t\t<tr class=\"tr1\">\n";
						$deadlineList.="\t\t\t\t\t<td width=\"50%\" align=\"center\" valign=\"middle\" nowrap><u>School</u></td>\n";
						$deadlineList.="\t\t\t\t\t<td align=\"center\" valign=\"middle\" nowrap><u>Action</u><br><span class=\"crsTiny\">(Mouse over for details)</span></td>\n";
						$deadlineList.="\t\t\t\t</tr>\n";
						
						$j++;
					}

					$schoolNameHtml=((strpos(strtolower($dueDate), "--")!==false) ? "<a class=\"deadlineAlertSchool\" href=\"" . $webSite . "\" target=\"_blank\">" . $schoolName . "</a>" : $schoolName);
					
					$deadlineList.="\t\t\t\t<tr class=\"tr" . ($i%2==0 ? "2" : "1") . "\">\n";
					$deadlineList.="\t\t\t\t\t<td valign=\"middle\" height=\"50\" style=\"padding-left:12px;\" class=\"deadlineAlertSchool\">" . $schoolNameHtml . "</td>\n";
					$deadlineList.="\t\t\t\t\t<td id=\"td" . $schoolId . "^" . $alertId . "\" valign=\"middle\" class=\"crsSmall\" height=\"50\" style=\"padding-left:12px;\" onmouseover=\"deadline_onmouseover(this);\" onmouseout=\"deadline_onmouseout(this);\">" . formatDeadline($alertDesc) . "<span id=\"spnDeadline" . $schoolId . "^" . $alertId . "\" style=\"position:relative;display:none;\"><br>" . formatActionButtons($dateCompleted, $schoolId, $alertId) . "</span></td>\n";
					$deadlineList.="\t\t\t\t</tr>\n";

					$i++;
					$lastMatch=$dueDate;

					break;
			}
		}
		
		$deadlineList.="\t\t\t</span>\n";
		$deadlineList.="\t\t\t</table>\n";
		$deadlineList.="\t\t</td>\n";
		$deadlineList.="\t</tr>\n";
		
		if ($printFooter)
			$deadlineList.="</table>\n";
		
		return $deadlineList;
	}
	else
	{
		return "error in dealineAlertHelper.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
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

	$url="";

	if (strpos($tempStr,'target="new">')!==false)
	{
		$start=strpos($tempStr,'target="new">')+13;
		$end=strpos($tempStr,'</a>',$start);
		$url=substr($tempStr,$start,$end-$start);
		$url="http://" . $url . "/";
	}

	$sqlUpdate="UPDATE TCOLLEGE SET WEB_SITE_URL='$url' WHERE COLLEGE_ID=$schoolId";
	$resultUpdate=mysql_query($sqlUpdate);

	if (!$resultUpdate)
	{
		echo "error in dealineAlertHelper.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sqlInsert;
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
			echo "error in dealineAlertHelper.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sqlInsert;
			include("../../commonPhp/mySqlClose.php");
		}
	}
}

function formatDeadline($description)
{
	return (substr($description,strlen($description)-3,strlen($description))==" by" ? substr($description,0,strlen($description)-3) : $description);
}

function formatDueDate1($theDate)
{
	$formattedDate=">&nbsp;";

	if ($theDate!="--" && strpos($theDate, "-")!==false)
	{
		if (strlen($theDate)>6)
			$theDate=substr($theDate,0,6);
		
		$dueDateArray=explode("-", $theDate);
		$dueDateDay=$dueDateArray[0];
		$dueDateMonth=$dueDateArray[1];
		
		$dueDateDay=(substr($dueDateDay,0,1)=="0" ? substr($dueDateDay,1,2) : $dueDateDay);

		$formattedDate=" height=\"50\" align=\"center\" valign=\"top\" style=\"background:url('../images/calendarDay.gif');background-repeat:no-repeat;\"><span style=\"font-size:13;font-weight:bold;\">" . $dueDateMonth . "&nbsp;</span><br><span style=\"font-size:24;font-weight:bold;\">" . $dueDateDay . "&nbsp;</span>";
	}
	
	return $formattedDate;
}

function formatDueDate2($theDate, $webSite)
{
	if ($theDate=="--")
		$formattedDate="<a href=\"" . $webSite . "\" target=\"_blank\" class=\"deadlineAlertLink\">Date unavailable, refer to school web site</a>";
	else if (strpos($theDate, '-')!==false)
		if (strlen($theDate)>6)
			$formattedDate=substr($theDate,6,strlen($theDate)-1);
		else
			$formattedDate="&nbsp;";
	else
		$formattedDate=$theDate;
	
	return $formattedDate;
}

function formatDueDate3($theDate)
{
	if ($theDate!="--" && strpos($theDate, "-")!==false)
	{
		$restOfTheDate="&nbsp;";

		if (strlen($theDate)>6)
		{
			$tempDate=substr($theDate,0,6);
			$restOfTheDate=substr($theDate,6,strlen($theDate)-1);
		}
		else
			$tempDate=$theDate;
	
		$dueDateArray=explode("-", $tempDate);
		$dueDateDay=$dueDateArray[0];
		$dueDateMonth=$dueDateArray[1];
		
		$dueDateDay=(substr($dueDateDay,0,1)=="0" ? substr($dueDateDay,1,2) : $dueDateDay);

		$formattedDate="\t\t\t\t<table style=\"border-style:none;\">\n";
		$formattedDate.="\t\t\t\t\t<tr>\n";
		$formattedDate.="\t\t\t\t\t\t<td height=\"50\" width=\"50\" align=\"center\" valign=\"top\" style=\"background:url('../images/calendarDay.gif');background-repeat:no-repeat;\"><span style=\"font-size:13;font-weight:bold;\">" . $dueDateMonth . "&nbsp;</span><br><span style=\"font-size:24;font-weight:bold;\">" . $dueDateDay . "&nbsp;</span></td>\n";
		$formattedDate.="\t\t\t\t\t\t<td>" . $restOfTheDate . "</td>\n";
		$formattedDate.="\t\t\t\t\t</tr>\n";
		$formattedDate.="\t\t\t\t</table>\n";
	}
	else if ($theDate=="--")
		$formattedDate="Date unavailable, refer to school web site";
	else
		$formattedDate=$theDate;
	
	return $formattedDate;
}

function formatActionButtons($theDate, $schoolId, $alertId)
{
	if ($theDate==null)
		return "<input type=\"button\" class=\"crsDAButtonSmall\" name=\"btnComplete" . $schoolId . "^" . $alertId . "\" id=\"btnComplete" . $schoolId . "^" . $alertId . "\" value=\"Mark as Complete\" onclick=\"btnComplete_onclick(this);\">";
	else
		return "<span class=\"crsTiny\">Completed " . date("F j, Y",strtotime($theDate)) . "</span>&nbsp;&nbsp;<a class=\"crsTinyBlue\" href=\"javascript:lnkClear_onclick('" . $schoolId . "^" . $alertId . "');\">Clear</a>";
}

function formatDateCompleted($theDate)
{
	if ($theDate==null)
		return "Not yet completed";
	else
		return date("F j, Y",strtotime($theDate));
}

function formatDateCompletedForEmail($theDate)
{
	return ($theDate==null ? "" : date("F j, Y",strtotime($theDate)));
}

?>
