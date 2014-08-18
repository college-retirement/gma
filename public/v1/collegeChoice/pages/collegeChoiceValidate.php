<?php
session_start();

include("../../commonPhp/mySqlConnect.php");

$username=$_POST["txtUsername"]; 
$password=$_POST["txtPassword"];
$comingFromCrs=$_POST["crs"];

//$sql="SELECT * FROM TUSER WHERE USERNAME='$username' AND PASSWORD='$password';";
//$sql="SELECT * FROM TUSER WHERE USERNAME='$username';";
//$sql="SELECT * FROM TUSER A, TUSER_PRODUCTS B, TUSER_COLLEGECHOICE_DATA C WHERE USERNAME='$username' AND PRODUCT_ID='CC' AND A.USER_ID=B.USER_ID AND B.USER_ID=C.USER_ID";
if ($comingFromCrs=="true")
	$sql="SELECT * FROM TUSER A, TUSER_PRODUCTS B WHERE USERNAME='$username' AND PRODUCT_ID='CC' AND A.USER_ID=B.USER_ID";
else
	$sql="SELECT * FROM TUSER A, TUSER_PRODUCTS B WHERE USERNAME='$username' AND PASSWORD='$password' AND PRODUCT_ID='CC' AND A.USER_ID=B.USER_ID";

$result=mysql_query($sql);
$count=mysql_num_rows($result);

if($count==1)
{
	$row=mysql_fetch_array($result);

/*	$subscriptionStartDate=strtotime($row["SUBSCRIPTION_START"]);
	$subscriptionEndDate=strtotime($row["SUBSCRIPTION_END"]);
	
	$todaysDate=date("Y-m-d");
	$today=strtotime($todaysDate);

	if ($subscriptionStartDate>$today || $subscriptionEndDate<$today)
	{
		include("../../commonPhp/mySqlClose.php");
		header("location:collegeChoiceLogin.php?login=expired");
	}
*/
	$userid=$row["USER_ID"];
	$_SESSION["userid"]=$userid;
	$_SESSION["username"]=$username;
	$_SESSION["usertype"]=$row["USER_TYPE"];
/*	$_SESSION["familyname"]=$row["FAMILY_NAME"];
	$_SESSION["studentname"]=$row["STUDENT_NAME"];
	$_SESSION["stateofresidence"]=$row["STATE_OF_RESIDENCE"];
	$_SESSION["gpa"]=$row["GPA"];
	$_SESSION["satmath"]=$row["SAT_MATH"];
	$_SESSION["satverbal"]=$row["SAT_VERBAL"];
	$_SESSION["satwriting"]=$row["SAT_WRITING"];
	$_SESSION["act"]=$row["ACT"];
	$_SESSION["efcfm"]=$row["EFC_FM"];
	$_SESSION["efcim"]=$row["EFC_IM"];
	$_SESSION["collegeids"]=$row["COLLEGES"];
*/
	$sql="UPDATE TUSER SET LAST_LOGIN=NOW() WHERE USER_ID=$userid";

	if (mysql_query($sql))
	{
		$sql="SELECT EFC_FM, EFC_IM FROM TUSER_COLLEGECHOICE_DATA WHERE USER_ID=$userid";
		$result=mysql_query($sql);
		$row=mysql_fetch_array($result);
		
		$efcFm=$row["EFC_FM"];
		$efcIm=$row["EFC_IM"];

		include("../../commonPhp/mySqlClose.php");

		if ($efcFm==null || $efcIm==null)
			$location="collegeChoiceEFCDataForm.php";
		else
			$location="collegeChoiceSplash.php";
		
		if ($comingFromCrs=="true")
			echo "<html>\n<title>College & Retirement Solutions - CollegeChoice</title>\n<frameset rows=\"120,*\" border=\"0\" framespacing=\"0\">\n\t<frame src=\"../../commonPhp/crsHeader.php\" id=\"header\" frameborder=\"0\" marginwidth=\"0\" marginheight=\"0\" noresize>\n\t<frame src=\"" . $location . "\" id=\"main\" frameborder=\"0\" marginwidth=\"0\" marginheight=\"0\" noresize>\n</frameset>\n</html>";
		else
			header("location:".$location);
	}
	else
	{
		include("../../commonPhp/mySqlClose.php");
		echo "error in collegeChoiceValidate.php<br><br>$sql<br><br>" . mysql_error();
	}
}
else
{


$myServer = "oldcrsdb.db.4264298.hostedresource.com";
$myUser = "oldcrsdb";
$myPass = "Shunp1ke";
$myDB = "oldcrsdb";

//connection to the database
$dbhandle = mssql_connect($myServer, $myUser, $myPass)
  or die("Couldn't connect to SQL Server on $myServer");

//select a database to work with
$selected = mssql_select_db($myDB, $dbhandle)
  or die("Couldn't open database $myDB");

//$query="select username,password from users";
$query1="SELECT * FROM users WHERE USERNAME='$username' AND PASSWORD='$password';";

$result1 = mssql_query($query1);

$numRows = mssql_num_rows($result1);

//close the connection
mssql_close($dbhandle);


if($numRows==1)
{
	$row=mssql_fetch_array($result1);

		$userid1=$row["userid"];
		$uname=$row["username"];
		$pwd=$row["password"];
		$userid1=$row["userid"];
		$userid1=$row["userid"];
		$date_created=$row["account_creation_date"];

           $date_array = split(" ", $date_created);
//$month = $date_array[0];
//$day = $date_array[1];
//$year = $date_array[2];
//$time = $date_array[3];
//$ts = mktime(0,0,0,$month,$day,$year);
//$dateVal = date("y-m-d", $ts);

$year=date("Y", strtotime($row['account_creation_date']));
$mon=date("m", strtotime($row['account_creation_date']));
$day=date("d", strtotime($row['account_creation_date']));
$hour=date("H", strtotime($row['account_creation_date']));
$min=date("i", strtotime($row['account_creation_date']));
$sec=date("s", strtotime($row['account_creation_date']));


$dateVal =$year."-".$mon."-".$day." ".$hour.":".$min.":".$sec;

	$_SESSION["userid"]=$userid1;
	$_SESSION["username"]=$username;
	$_SESSION["usertype"]=$row["USER_TYPE"];

   

$sql123="SELECT * FROM TUSER";
$result123=mysql_query($sql123);
$numRows1234 = mysql_num_rows($result123);

$userid11=$numRows1234+1;
mysql_query("INSERT INTO TUSER (USER_ID, USERNAME, PASSWORD, USER_TYPE, DATE_CREATED, USER_CREATED) VALUES ('$userid11', '$uname', '$pwd', 'C', '$dateVal', 'ADMIN')");

mysql_query("INSERT INTO TUSER_PRODUCTS (USER_ID, PRODUCT_ID, DATE_CREATED, USER_CREATED) VALUES ('$userid11', 'CC', '$dateVal', 'ADMIN')");

	mysql_query("UPDATE TUSER SET LAST_LOGIN=NOW() WHERE USER_ID=$userid11");
header("location:collegeChoiceSplash.php");

} 
else {


	include("../../commonPhp/mySqlClose.php");
	header("location:collegeChoiceLogin.php?login=invalid");

}
}

?>
