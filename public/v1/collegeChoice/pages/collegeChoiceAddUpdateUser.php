<?php
session_start();

$username=$_SESSION["username"];
$action=$_POST["hidAction"];

include("../../commonPhp/mySqlConnect.php");


if ($action=="A")
{
	$newUsername=$_POST["txtNewUsername"];

	$sql="SELECT COUNT(*) USERCOUNT FROM TUSER WHERE USERNAME='$newUsername'";
	$result=mysql_query($sql);
	$row=mysql_fetch_array($result);

	if ($row["USERCOUNT"]>0)
	{
		include("../../commonPhp/mySqlClose.php");
		header("location:collegeChoiceUserMaintenance.php?add=2");
	}
	else
	{
		$newPassword=$_POST["txtNewPassword"];
		$newUserType=$_POST["lstNewUserType"];
		//$newUserStartDate=$_POST["txtNewSubscriptionStartYear"] . "-" . $_POST["txtNewSubscriptionStartMonth"] . "-" . $_POST["txtNewSubscriptionStartDay"];
		//$newUserEndDate=$_POST["txtNewSubscriptionEndYear"] . "-" . $_POST["txtNewSubscriptionEndMonth"] . "-" . $_POST["txtNewSubscriptionEndDay"];
		//$newStudentFirstName=addslashes($_POST["txtNewStudentFirstName"]);
		//$newStudentLastName=addslashes($_POST["txtNewStudentLastName"]);
		
		//$sql="INSERT INTO TUSER (USERNAME, PASSWORD, USER_TYPE, LAST_LOGIN, SUBSCRIPTION_START, SUBSCRIPTION_END, FAMILY_NAME, STUDENT_NAME, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ('$newUsername', '$newPassword', '$newUserType', NOW(), '$newUserStartDate', '$newUserEndDate', '$newStudentLastName', '$newStudentFirstName', NOW(), '$username', NOW(), '$username')";
		$sql="INSERT INTO TUSER (USERNAME, PASSWORD, USER_TYPE, LAST_LOGIN, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ('$newUsername', '$newPassword', '$newUserType', NOW(), NOW(), '$username', NOW(), '$username')";
		$result=mysql_query($sql);

		if ($result)
		{
			$sql="SELECT USER_ID FROM TUSER WHERE USERNAME='$newUsername'";
			$result=mysql_query($sql);
			$row=mysql_fetch_array($result);
			$userId=$row["USER_ID"];
			$newUserProducts=$_POST["hidNewProducts"];
			$newUserProductArray=explode(",",$newUserProducts);

			for ($i=0; $i<count($newUserProductArray); $i++)
			{
				if ($newUserProductArray[$i]!="")
				{
					$productId=$newUserProductArray[$i];
					$newUserStartDate=$_POST["txtNewSubscriptionStartYear".$productId] . "-" . $_POST["txtNewSubscriptionStartMonth".$productId] . "-" . $_POST["txtNewSubscriptionStartDay".$productId];
					$newUserEndDate=$_POST["txtNewSubscriptionEndYear".$productId] . "-" . $_POST["txtNewSubscriptionEndMonth".$productId] . "-" . $_POST["txtNewSubscriptionEndDay".$productId];
					
					//$sql="INSERT INTO TUSER_COLLEGECHOICE_DATA (USER_ID, SUBSCRIPTION_START, SUBSCRIPTION_END, FAMILY_NAME, STUDENT_NAME, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ('$userId', '$newUserStartDate', '$newUserEndDate', '$newStudentLastName', '$newStudentFirstName', NOW(), '$username', NOW(), '$username')";
					//$sql="INSERT INTO TUSER_COLLEGECHOICE_DATA (USER_ID, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ('$userId', NOW(), '$username', NOW(), '$username')";
					$sql="INSERT INTO TUSER_PRODUCTS (USER_ID, PRODUCT_ID, SUBSCRIPTION_START, SUBSCRIPTION_END, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($userId, '$productId', '$newUserStartDate', '$newUserEndDate', '$username', NOW(), '$username', NOW())";
					$result=mysql_query($sql);
					
					if (!$result)
					{
						echo "error in collegeChoiceAddUpdateUser.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
						include("../../commonPhp/mySqlClose.php");
					}
				}
			}

			include("../../commonPhp/mySqlClose.php");
			header("location:collegeChoiceUserMaintenance.php?add=1");
		}
		else
		{
			echo "error in collegeChoiceAddUpdateUser.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
			include("../../commonPhp/mySqlClose.php");
		}
	}
}
else if ($action=="U")
{
	$currentUsername=$_POST["hidUsername"];
	$newUsername=$_POST["txtUsername"];
	$userId=$_POST["lstUsername"];
	
	if ($currentUsername!=$newUsername)
	{
		$sql="SELECT COUNT(*) USERCOUNT FROM TUSER WHERE USERNAME='$newUsername'";
		$result=mysql_query($sql);
		$row=mysql_fetch_array($result);

		if ($row["USERCOUNT"]>0)
		{
			include("../../commonPhp/mySqlClose.php");
			header("location:collegeChoiceUserMaintenance.php?userId=" . $userId . "&update=2");
		}
	}

	$newPassword=$_POST["txtPassword"];
	$userType=$_POST["lstUserType"];
	//$userStartDate=$_POST["txtSubscriptionStartYear"] . "-" . $_POST["txtSubscriptionStartMonth"] . "-" . $_POST["txtSubscriptionStartDay"];
	//$userEndDate=$_POST["txtSubscriptionEndYear"] . "-" . $_POST["txtSubscriptionEndMonth"] . "-" . $_POST["txtSubscriptionEndDay"];
	//$studentFirstName=addslashes($_POST["txtStudentFirstName"]);
	//$studentLastName=addslashes($_POST["txtStudentLastName"]);
	
	//$sql="UPDATE TUSER SET USERNAME='$newUsername', PASSWORD='$newPassword', USER_TYPE='$userType', SUBSCRIPTION_START='$userStartDate', SUBSCRIPTION_END='$userEndDate', FAMILY_NAME='$studentLastName', STUDENT_NAME='$studentFirstName', DATE_UPDATED=NOW(), USER_UPDATED='$username' WHERE USERNAME='$currentUsername'";
	//$sql="UPDATE TUSER A, TUSER_COLLEGECHOICE_DATA B SET USERNAME='$newUsername', PASSWORD='$newPassword', USER_TYPE='$userType', SUBSCRIPTION_START='$userStartDate', SUBSCRIPTION_END='$userEndDate', FAMILY_NAME='$studentLastName', STUDENT_NAME='$studentFirstName', A.DATE_UPDATED=NOW(), A.USER_UPDATED='$username', B.DATE_UPDATED=NOW(), B.USER_UPDATED='$username' WHERE USERNAME='$currentUsername' AND A.USER_ID=B.USER_ID";
	$sql="UPDATE TUSER SET USERNAME='$newUsername', PASSWORD='$newPassword', USER_TYPE='$userType', DATE_UPDATED=NOW(), USER_UPDATED='$username' WHERE USERNAME='$currentUsername'";
	$result=mysql_query($sql);

	if ($result)
	{
		$sql="DELETE FROM TUSER_PRODUCTS WHERE USER_ID=$userId";
		$result=mysql_query($sql);
		
		$userProducts=$_POST["hidUserProducts"];
		$userProductArray=explode(",",$userProducts);

		for ($i=0; $i<count($userProductArray); $i++)
		{
			if ($userProductArray[$i]!="")
			{
				$productId=$userProductArray[$i];
				$userStartDate=$_POST["txtSubscriptionStartYear".$productId] . "-" . $_POST["txtSubscriptionStartMonth".$productId] . "-" . $_POST["txtSubscriptionStartDay".$productId];
				$userEndDate=$_POST["txtSubscriptionEndYear".$productId] . "-" . $_POST["txtSubscriptionEndMonth".$productId] . "-" . $_POST["txtSubscriptionEndDay".$productId];
				
				//$sql="INSERT INTO TUSER_COLLEGECHOICE_DATA (USER_ID, SUBSCRIPTION_START, SUBSCRIPTION_END, FAMILY_NAME, STUDENT_NAME, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ('$userId', '$newUserStartDate', '$newUserEndDate', '$newStudentLastName', '$newStudentFirstName', NOW(), '$username', NOW(), '$username')";
				//$sql="INSERT INTO TUSER_COLLEGECHOICE_DATA (USER_ID, DATE_CREATED, USER_CREATED, DATE_UPDATED, USER_UPDATED) VALUES ('$userId', NOW(), '$username', NOW(), '$username')";
				$sql="INSERT INTO TUSER_PRODUCTS (USER_ID, PRODUCT_ID, SUBSCRIPTION_START, SUBSCRIPTION_END, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ('$userId', '$productId', '$userStartDate', '$userEndDate', '$username', NOW(), '$username', NOW())";

				$result=mysql_query($sql);

				if (!$result)
				{
					echo "error in collegeChoiceAddUpdateUser.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
					include("../../commonPhp/mySqlClose.php");
				}
			}
		}

		include("../../commonPhp/mySqlClose.php");
		header("location:collegeChoiceUserMaintenance.php?userId=" . $userId . "&update=1");
	}
	else
	{
		echo "error in collegeChoiceAddUpdateUser.php: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
		include("../../commonPhp/mySqlClose.php");
	}
}
else
	echo "No action (e.g., Add, Update) set...nothing to do.";
?>
