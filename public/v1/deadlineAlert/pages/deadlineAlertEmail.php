<?php

include("../../commonPhp/mySqlConnect.php");
include("deadlineAlertHelper.php");

$messageHeader="<html><head></head><body style=\"font-family:Calibri,Arial;text-align:center;\"><div style=\"width:600px;text-align:center;font-family:Calibri,Arial;\"><table style=\"border:rgb(102,102,102) 1px solid;width:600px;font-family:Calibri,Arial;\" cellspacing=\"0\" cellpadding=\"0\"><tbody><tr><td style=\"background-color:rgb(207,225,207)\"><table style=\"width:100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tbody><tr><td style=\"padding-right:0px;padding-left:11px;padding-bottom:0px;padding-top:11px\" valign=\"top\" align=\"left\"><img width=\"150\" height=\"85\" src=\"https://www.college-retirement.com/Images/CRS3.gif\" /></td><td style=\"padding-right:11px;padding-left:0px;padding-bottom:0px;padding-top:11px;font-size:8pt;font-family:Calibri,Arial;\" valign=\"top\" nowrap=\"nowrap\" align=\"right\">College &amp; Retirement Solutions<br />667 Shunpike Rd., Suite 3<br />Chatham, NJ 07928<br />P: 973-514-2002<br />F: 973-514-1101<br /><a href=\"http://www.college-retirement.com/\">www.college-retirement.com</a></td></tr></tbody></table></td></tr><tr><td style=\"border:rgb(229,239,229) 5px solid;background-color:white\"><table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"font-family:Calibri,Arial;\"><tbody><tr><td style=\"border:rgb(204,204,204) 1px solid;padding:5px;background-color:white;\">This is an automated email alerting you about important upcoming deadlines at the schools on your list.<br /><br />Today's Alerts:<br /><table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"100%\" style=\"font-family:Calibri,Arial;\"><tr><td><u>School Name</u></td><td><u>Deadline</u></td><td><u>Date Due</u></td><td><u>Date Completed</u></td></tr>";
$messageFooter="</table><br /><br />Please take the appropriate steps to ensure that you complete the requirements for these deadlines in a timely manner. Once you're done, remember to mark these deadlines complete.<br /><br />College &amp; Retirement Solutions<br />Deadline Alerts</td></tr></tbody></table></td></tr></tbody></table><table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tbody><tr><td style=\"padding-top:5px;padding-right:12px;padding-bottom:0px;padding-left:12px;font-size:5pt;text-transform:uppercase;color:rgb(187,187,187);font-family:Verdana;text-align:center\">If investment, financial, mortgage or insurance planning or products are required, College and Retirement Solutions, LLC (\"CRS\") may refer you to other companies. Any discussion of the tax implications of planning is strictly for general purposes. Neither CRS nor its representatives may give specific tax advice. Advice and counsel should be sought out from your accountant and/or tax advisor for information regarding your own particular situation.</td></tr></tbody></table></div></body></html>";

function validateEmail($email)
{
	$isValid = true;
	$atIndex = strrpos($email, "@");
	if (is_bool($atIndex) && !$atIndex)
	{
		$isValid = false;
	}
	else
	{
		$domain = substr($email, $atIndex+1);
		$local = substr($email, 0, $atIndex);
		$localLen = strlen($local);
		$domainLen = strlen($domain);
		if ($localLen < 1 || $localLen > 64)
		{
			// local part length exceeded
			$isValid = false;
		}
		else if ($domainLen < 1 || $domainLen > 255)
		{
			// domain part length exceeded
			$isValid = false;
		}
		else if ($local[0] == '.' || $local[$localLen-1] == '.')
		{
			// local part starts or ends with '.'
			$isValid = false;
		}
		else if (preg_match('/\\.\\./', $local))
		{
			// local part has two consecutive dots
			$isValid = false;
		}
		else if (!preg_match('/^[A-Za-z0-9\\-\\.]+$/', $domain))
		{
			// character not valid in domain part
			$isValid = false;
		}
		else if (preg_match('/\\.\\./', $domain))
		{
			// domain part has two consecutive dots
			$isValid = false;
		}
		else if (!preg_match('/^(\\\\.|[A-Za-z0-9!#%&`_=\\/$\'*+?^{}|~.-])+$/',str_replace("\\\\","",$local)))
		{
			// character not valid in local part unless local part is quoted
			if (!preg_match('/^"(\\\\"|[^"])+"$/',str_replace("\\\\","",$local)))
			{
				$isValid = false;
			}
		}
		if ($isValid && !(checkdnsrr($domain,"MX") || checkdnsrr($domain,"A")))
		{
			// domain not found in DNS
			$isValid = false;
		}
	}
	return $isValid;
}

function sendEmail($emailAddressTo, $message)
{
	if (!validateEmail($emailAddressTo))
	{
		$emailAddressFailureTo="jopremcak@college-retirement.com,info@college-retirement.com";
		$emailAddressFrom="DeadlineAlerts@college-retirement.com";
		$emailSubject="Deadline Alert Failure - Invalid Email Address";
		
		$headers="From: " . $emailAddressFrom . "\r\n";
		$headers.="MIME-Version: 1.0\r\n";
		$headers.="Content-type: text/html; charset=iso-8859-1\r\n";
		
		$message="Deadline Alerts could not be sent to $emailAddressTo.  The email address is in an invalid format.  Please correct the email address and resend.";

		mail($emailAddressFailureTo, $emailSubject, $message, $headers)
	}
	else
	{
		//$emailAddressTo="jopremcak@college-retirement.com";
		$emailAddressFrom="DeadlineAlerts@college-retirement.com";
		$emailSubject="Deadline Alert";
		
		$headers="From: " . $emailAddressFrom . "\r\n";
		$headers.="MIME-Version: 1.0\r\n";
		$headers.="Content-type: text/html; charset=iso-8859-1\r\n";

		//mail($emailAddressTo, $emailSubject, $message, $headers);

		if (mail($emailAddressTo, $emailSubject, $message, $headers))
			//header("location:");
			echo "mail sent";
		else
			//header("location:");
			echo "mail not sent";
	}
}

$sql1="SELECT DISTINCT(USER_ID) FROM TUSER_COLLEGE_DEADLINES ORDER BY USER_ID";
$result1=mysql_query($sql1);

if ($result1)
{
	while ($row1=mysql_fetch_array($result1))
	{
		$userId=$row1["USER_ID"];

		$sql2="SELECT COLLEGE_NAME, WEB_SITE_URL, ALERT_DESCRIPTION, DATE_DUE, DATE_COMPLETED FROM TCOLLEGE A, TDEADLINEALERT_COLLEGES B, TDEADLINEALERT_TYPES C, TUSER_COLLEGE_DEADLINES D WHERE D.USER_ID=$userId AND D.COLLEGE_ID=B.COLLEGE_ID AND B.COLLEGE_ID=A.COLLEGE_ID AND D.ALERT_ID=B.ALERT_ID AND B.ALERT_ID=C.ALERT_ID AND ((DATE_FORMAT(STR_TO_DATE(DATE_DUE,'%d-%b'),'%m')-DATE_FORMAT(NOW(),'%m')>0) OR (DATE_FORMAT(STR_TO_DATE(DATE_DUE,'%d-%b'),'%m')-DATE_FORMAT(NOW(),'%m')=0 AND DATE_FORMAT(STR_TO_DATE(DATE_DUE,'%d-%b'),'%d')-DATE_FORMAT(NOW(),'%d')>=0)) ORDER BY STR_TO_DATE(DATE_DUE,'%d-%b'), COLLEGE_NAME";
		$result2=mysql_query($sql2);

		while ($row2=mysql_fetch_array($result2))
		{
			$collegeName=$row2["COLLEGE_NAME"];
			$webSite=$row2["WEB_SITE_URL"];
			$alertDescription=$row2["ALERT_DESCRIPTION"];
			$dateDue=$row2["DATE_DUE"];
			$dateCompleted=$row2["DATE_COMPLETED"];
			
			$message.="<tr><td valign=\"top\">$collegeName</td><td valign=\"top\">" . formatDeadline($alertDescription) . "</td><td valign=\"top\">" . formatDueDate($dateDue, $webSite) . "</td><td valign=\"top\">" . formatDateCompletedForEmail($dateCompleted) . "</td></tr>";
		}

		$message=$messageHeader . $message . $messageFooter;

		//sendEmail($to, $message);
		sendEmail("jopremcak@college-retirement.com", $message);
		echo $message;
	}

	include("../../commonPhp/mySqlClose.php");
}
else
{
	include("../../commonPhp/mySqlClose.php");
}

?>