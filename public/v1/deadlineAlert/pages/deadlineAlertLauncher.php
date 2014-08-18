<?php
session_start();
//print_r($_SESSION);
print_r($_COOKIE);
$alert=$_GET["login"];

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT USER_ID, USERNAME FROM TUSER";
$result=mysql_query($sql);

while($row=mysql_fetch_array($result))
{
	$usernameList.="<option value=\"" . $row["USER_ID"] . "^" . $row["USERNAME"] . "\">" . $row["USERNAME"] . "</option>";
}

include("../../commonPhp/mySqlClose.php");
?>
<html>
<head>
<title>College & Retirement Solutions - Deadline Alerts</title>
</head>
<body <?php if ($alert=="session") echo "onload=\"alert('Your session has timed out.');\""; ?>>
<form name="frmDeadlineAlertsLauncher" action="deadlineAlert.php" method="POST">
<select name="userIdUsername">
<?php echo $usernameList; ?>
</select>
<br><br>
<input type="submit" value="Submit">
</form>
</body>
</head>