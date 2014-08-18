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

	$subscriptionStartDate=strtotime($row["SUBSCRIPTION_START"]);
	$subscriptionEndDate=strtotime($row["SUBSCRIPTION_END"]);
	
	$todaysDate=date("Y-m-d");
	$today=strtotime($todaysDate);

	if ($subscriptionStartDate>$today || $subscriptionEndDate<$today)
	{
		include("../../commonPhp/mySqlClose.php");
		header("location:collegeChoiceLogin.php?login=expired");
	}

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
	include("../../commonPhp/mySqlClose.php");
	header("location:collegeChoiceLogin.php?login=invalid");
}

?>
