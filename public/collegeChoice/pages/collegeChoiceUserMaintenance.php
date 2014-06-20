<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

if ($_SESSION["usertype"]!="A")
	header("location:collegeChoiceLogin.php");

$userId=$_GET["userId"];

function getMonth($theDate)
{
	$theDateArray=explode("-",$theDate);
	return $theDateArray[1];	
}

function getDay($theDate)
{
	$theDateArray=explode("-",$theDate);
	return $theDateArray[2];
}

function getYear($theDate)
{
	$theDateArray=explode("-",$theDate);
	return $theDateArray[0];
}

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT USER_ID, USERNAME FROM TUSER ORDER BY USERNAME";
$result=mysql_query($sql);
$usernameList="";
while ($row=mysql_fetch_array($result))
{
	$usernameList.="<option value=\"" . $row["USER_ID"] . "\"";
	if ($userId==$row["USER_ID"])
		$usernameList.=" selected";
	$usernameList.=">" . $row["USERNAME"] . "</option>\n";
}

$sql="SELECT PRODUCT_ID, PRODUCT_DESCRIPTION FROM TPRODUCT ORDER BY PRODUCT_ID";
$result=mysql_query($sql);
$newProductHtml="";
$newProductJavascript="";
$productIdArray="";
$productDescriptionArray="";
$i=0;
while ($row=mysql_fetch_array($result))
{
	$productId=$row["PRODUCT_ID"];
	$productDescription=$row["PRODUCT_DESCRIPTION"];
	
	$productIdArray[$i]=$productId;
	$productDescriptionArray[$i]=$productDescription;
	
	$newProductHtml.="\t<tr>\n";
	$newProductHtml.="\t\t<td><br><input type=\"checkbox\" name=\"chkNewUserProduct" . $productId . "\" id=\"chkNewUserProduct" . $productId . "\" onclick=\"chkNewUserProduct_onclick(this);\">" . $productDescription . "</td>\n";
	$newProductHtml.="\t\t<td>Subscription Start Date<br><input type=\"text\" name=\"txtNewSubscriptionStartMonth" . $productId . "\" size=\"2\" maxlength=\"2\" value=\"" . date("m") . "\">/<input type=\"text\" name=\"txtNewSubscriptionStartDay" . $productId . "\" size=\"2\" maxlength=\"2\" value=\"" . date("d") . "\">/<input type=\"text\" name=\"txtNewSubscriptionStartYear" . $productId . "\" size=\"4\" maxlength=\"4\" value=\"" . date("Y") . "\"></td>\n";
	$newProductHtml.="\t\t<td>Subscription End Date<br><input type=\"text\" name=\"txtNewSubscriptionEndMonth" . $productId . "\" size=\"2\" maxlength=\"2\" value=\"" . date("m") . "\">/<input type=\"text\" name=\"txtNewSubscriptionEndDay" . $productId . "\" size=\"2\" maxlength=\"2\" value=\"" . date("d") . "\">/<input type=\"text\" name=\"txtNewSubscriptionEndYear" . $productId . "\" size=\"4\" maxlength=\"4\" value=\"" . (date("Y")+1) . "\"></td>\n";
	$newProductHtml.="\t</tr>\n";
	
	$newProductJavascript.="\telse if (document.frmUserMaintenance.chkNewUserProduct" . $productId . ".checked==true && !isDate(document.frmUserMaintenance.txtNewSubscriptionStartMonth" . $productId . ".value+\"/\"+document.frmUserMaintenance.txtNewSubscriptionStartDay" . $productId . ".value+\"/\"+document.frmUserMaintenance.txtNewSubscriptionStartYear" . $productId . ".value))\n";
	$newProductJavascript.="\t{\n";
	$newProductJavascript.="\t\talert(\"Please enter a valid subscription start date.\");\n";
	$newProductJavascript.="\t\tdocument.frmUserMaintenance.txtNewSubscriptionStartMonth" . $productId . ".focus();\n";
	$newProductJavascript.="\t\tdocument.frmUserMaintenance.txtNewSubscriptionStartMonth" . $productId . ".value=document.frmUserMaintenance.txtNewSubscriptionStartMonth" . $productId . ".value;\n";
	$newProductJavascript.="\t}\n";
	$newProductJavascript.="\telse if (document.frmUserMaintenance.chkNewUserProduct" . $productId . ".checked==true && !isDate(document.frmUserMaintenance.txtNewSubscriptionEndMonth" . $productId . ".value+\"/\"+document.frmUserMaintenance.txtNewSubscriptionEndDay" . $productId . ".value+\"/\"+document.frmUserMaintenance.txtNewSubscriptionEndYear" . $productId . ".value))\n";
	$newProductJavascript.="\t{\n";
	$newProductJavascript.="\t\talert(\"Please enter a valid subscription end date.\");\n";
	$newProductJavascript.="\t\tdocument.frmUserMaintenance.txtNewSubscriptionEndMonth" . $productId . ".focus();\n";
	$newProductJavascript.="\t\tdocument.frmUserMaintenance.txtNewSubscriptionEndMonth" . $productId . ".value=document.frmUserMaintenance.txtNewSubscriptionEndMonth" . $productId . ".value;\n";
	$newProductJavascript.="\t}\n";
	
	$i++;
}

if ($userId!=null)
{
	//$sql="SELECT USERNAME, PASSWORD, USER_TYPE, SUBSCRIPTION_START, SUBSCRIPTION_END, STUDENT_NAME, FAMILY_NAME FROM TUSER A, TUSER_COLLEGECHOICE_DATA B WHERE A.USER_ID=$userId AND A.USER_ID=B.USER_ID";
	//$sql="SELECT USERNAME, PASSWORD, USER_TYPE, STUDENT_NAME, FAMILY_NAME FROM TUSER A, TUSER_COLLEGECHOICE_DATA B WHERE A.USER_ID=$userId AND A.USER_ID=B.USER_ID";
	$sql="SELECT USERNAME, PASSWORD, USER_TYPE FROM TUSER WHERE USER_ID=$userId";
	$result=mysql_query($sql);
	$row=mysql_fetch_array($result);

	$username=$row["USERNAME"];
	$password=$row["PASSWORD"];
	$userType=$row["USER_TYPE"];
	//$studentName=$row["STUDENT_NAME"];
	//$familyName=$row["FAMILY_NAME"];

	$sql="SELECT PRODUCT_ID, SUBSCRIPTION_START, SUBSCRIPTION_END FROM TUSER_PRODUCTS WHERE USER_ID=$userId";
	$result=mysql_query($sql);

	$userProductHtml="";
	$userProductJavascript="";
	$userProducts="";
	$userProductIdArray="";
	$userStartArray="";
	$userEndArray="";
	$j=0;

	while ($row=mysql_fetch_array($result))
	{
		$userProductIdArray[$j]=$row["PRODUCT_ID"];
		$userProducts.=$row["PRODUCT_ID"] . ",";
		$userStartArray[$j]=$row["SUBSCRIPTION_START"];
		$userEndArray[$j]=$row["SUBSCRIPTION_END"];

		$j++;
	}
	
	for ($k=0; $k<count($productIdArray); $k++)
	{
		$userProductHtml.="\t<tr>\n";
		$userProductHtml.="\t\t<td><br><input type=\"checkbox\" name=\"chkUserProduct" . $productIdArray[$k] . "\" id=\"chkUserProduct" . $productIdArray[$k] . "\"";

		for ($l=0; $l<count($userProductIdArray); $l++)
		{
			$userStartMonth="";
			$userStartDay="";
			$userStartYear="";
			$userEndMonth="";
			$userEndDay="";
			$userEndYear="";
			
			if ($userProductIdArray[$l]==$productIdArray[$k])
			{
				$userProductHtml.=" checked";
				
				$userStartMonth=getMonth($userStartArray[$l]);
				$userStartDay=getDay($userStartArray[$l]);
				$userStartYear=getYear($userStartArray[$l]);
				$userEndMonth=getMonth($userEndArray[$l]);
				$userEndDay=getDay($userEndArray[$l]);
				$userEndYear=getYear($userEndArray[$l]);
				break;
			}		
		}

		$userProductHtml.=" onclick=\"chkUserProduct_onclick(this);\">" . $productDescriptionArray[$k] . "</td>\n";
		$userProductHtml.="\t\t<td>Subscription Start Date<br><input type=\"text\" name=\"txtSubscriptionStartMonth" . $productIdArray[$k] . "\" size=\"2\" maxlength=\"2\" value=\"" . $userStartMonth . "\">/<input type=\"text\" name=\"txtSubscriptionStartDay" . $productIdArray[$k] . "\" size=\"2\" maxlength=\"2\" value=\"" . $userStartDay . "\">/<input type=\"text\" name=\"txtSubscriptionStartYear" . $productIdArray[$k] . "\" size=\"4\" maxlength=\"4\" value=\"" . $userStartYear . "\"></td>\n";
		$userProductHtml.="\t\t<td>Subscription End Date<br><input type=\"text\" name=\"txtSubscriptionEndMonth" . $productIdArray[$k] . "\" size=\"2\" maxlength=\"2\" value=\"" . $userEndMonth . "\">/<input type=\"text\" name=\"txtSubscriptionEndDay" . $productIdArray[$k] . "\" size=\"2\" maxlength=\"2\" value=\"" . $userEndDay . "\">/<input type=\"text\" name=\"txtSubscriptionEndYear" . $productIdArray[$k] . "\" size=\"4\" maxlength=\"4\" value=\"" . $userEndYear . "\"></td>\n";
		$userProductHtml.="\t</tr>\n";

		$userProductJavascript.="\telse if (document.frmUserMaintenance.chkUserProduct" . $productIdArray[$k] . ".checked==true && !isDate(document.frmUserMaintenance.txtSubscriptionStartMonth" . $productIdArray[$k] . ".value+\"/\"+document.frmUserMaintenance.txtSubscriptionStartDay" . $productIdArray[$k] . ".value+\"/\"+document.frmUserMaintenance.txtSubscriptionStartYear" . $productIdArray[$k] . ".value))\n";
		$userProductJavascript.="\t{\n";
		$userProductJavascript.="\t\talert(\"Please enter a valid subscription start date.\");\n";
		$userProductJavascript.="\t\tdocument.frmUserMaintenance.txtSubscriptionStartMonth" . $productIdArray[$k] . ".focus();\n";
		$userProductJavascript.="\t\tdocument.frmUserMaintenance.txtSubscriptionStartMonth" . $productIdArray[$k] . ".value=document.frmUserMaintenance.txtSubscriptionStartMonth" . $productIdArray[$k] . ".value;\n";
		$userProductJavascript.="\t}\n";
		$userProductJavascript.="\telse if (document.frmUserMaintenance.chkUserProduct" . $productIdArray[$k] . ".checked==true && !isDate(document.frmUserMaintenance.txtSubscriptionEndMonth" . $productIdArray[$k] . ".value+\"/\"+document.frmUserMaintenance.txtSubscriptionEndDay" . $productIdArray[$k] . ".value+\"/\"+document.frmUserMaintenance.txtSubscriptionEndYear" . $productIdArray[$k] . ".value))\n";
		$userProductJavascript.="\t{\n";
		$userProductJavascript.="\t\talert(\"Please enter a valid subscription end date.\");\n";
		$userProductJavascript.="\t\tdocument.frmUserMaintenance.txtSubscriptionEndMonth" . $productIdArray[$k] . ".focus();\n";
		$userProductJavascript.="\t\tdocument.frmUserMaintenance.txtSubscriptionEndMonth" . $productIdArray[$k] . ".value=document.frmUserMaintenance.txtSubscriptionEndMonth" . $productIdArray[$k] . ".value;\n";
		$userProductJavascript.="\t}\n";
	}
}

include("../../commonPhp/mySqlClose.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>

<head>

<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">

<title>College & Retirement Solutions - CollegeChoice</title>

<script language="JavaScript">
<!--
function isDate(txtDate)
{
	var objDate;
	var mSeconds;

	if (txtDate.length!=10)
		return false;

	var day=txtDate.substring(3,5)-0;
	var month=txtDate.substring(0,2)-1;
	var year=txtDate.substring(6,10)-0;

	if (txtDate.substring(2,3)!='/')
		return false;
	if (txtDate.substring(5,6)!='/')
		return false;

	if (year<999 || year>3000)
		return false;

	mSeconds=(new Date(year, month, day)).getTime();

	objDate=new Date();
	objDate.setTime(mSeconds);

	if (objDate.getFullYear()!=year)
		return false;
	if (objDate.getMonth()!=month)
		return false;
	if (objDate.getDate()!=day)
		return false;

	return true;
}

function chkNewUserProduct_onclick(whichCheckbox)
{
	var whichProduct=whichCheckbox.id.substring(whichCheckbox.id.length-2,whichCheckbox.id.length);

	if (whichCheckbox.checked==true)
		document.frmUserMaintenance.hidNewProducts.value=document.frmUserMaintenance.hidNewProducts.value+","+whichProduct;
	else
		document.frmUserMaintenance.hidNewProducts.value=document.frmUserMaintenance.hidNewProducts.value.replace(whichProduct,"");
}

function chkUserProduct_onclick(whichCheckbox)
{
	var whichProduct=whichCheckbox.id.substring(whichCheckbox.id.length-2,whichCheckbox.id.length);

	if (whichCheckbox.checked==true)
		document.frmUserMaintenance.hidUserProducts.value=document.frmUserMaintenance.hidUserProducts.value+","+whichProduct;
	else
		document.frmUserMaintenance.hidUserProducts.value=document.frmUserMaintenance.hidUserProducts.value.replace(whichProduct,"");
}

function btnSubmitNewUser_onclick()
{
	if (document.frmUserMaintenance.txtNewUsername.value=="")
	{
		alert("Please enter a username.");
		document.frmUserMaintenance.txtNewUsername.focus();
	}
	else if (document.frmUserMaintenance.txtNewPassword.value=="")
	{
		alert("Please enter a password.");
		document.frmUserMaintenance.txtNewPassword.focus();
	}
<?php echo $newProductJavascript; ?>
	else
	{
		document.frmUserMaintenance.hidAction.value="A";
		document.frmUserMaintenance.submit();
	}
}

function btnRetrieve_onclick()
{
	var userId=document.frmUserMaintenance.lstUsername.value;
	document.location.href="collegeChoiceUserMaintenance.php?userId="+userId;
}

function btnUpdateUser_onclick()
{
	if (document.frmUserMaintenance.lstUsername.selectedIndex==0)
	{
		alert("Please select a user to edit first.");
		document.frmUserMaintenance.lstUsername.focus();
	}
	else if (document.frmUserMaintenance.txtUsername.value=="")
	{
		alert("Please enter a username.");
		document.frmUserMaintenance.txtUsername.focus();
	}
	else if (document.frmUserMaintenance.txtPassword.value=="")
	{
		alert("Please enter a password.");
		document.frmUserMaintenance.txtPassword.focus();
	}
	else if (document.frmUserMaintenance.lstUserType.selectedIndex==0)
	{
		alert("Please select a user type.");
		document.frmUserMaintenance.lstUserType.focus();
	}
<?php echo $userProductJavascript; ?>
	else
	{
		document.frmUserMaintenance.hidAction.value="U";
		document.frmUserMaintenance.hidUsername.value=document.frmUserMaintenance.lstUsername[document.frmUserMaintenance.lstUsername.selectedIndex].text;
		document.frmUserMaintenance.submit();
	}
}

function body_onload()
{
	
<?php
if ($userId!=null)
{
	echo "\tdocument.frmUserMaintenance.txtUsername.focus();\n";
	echo "\tdocument.frmUserMaintenance.txtUsername.value=document.frmUserMaintenance.txtUsername.value;\n";
}
else
	echo "\tdocument.frmUserMaintenance.txtNewUsername.focus();\n";

$add=$_GET["add"];
$update=$_GET["update"];

if ($add==2 || $update==2)
	echo "\talert('That username already exists.');";
else if ($add==1)
	echo "\talert('User created.');";
else if ($update==1)
	echo "\talert('User updated.');";
?>
}

-->
</script>

</head>

<body onload="body_onload();">

<!--<div id="crsWrapper">-->

<div id="crsContent">
<!--
<table width="100%" border="0">
	<tr>
		<td class="crsLarge" align="left"><img src="../../jbcgnew/images/logo.gif" width="128" height="74"></td>
		<td align="center" valign="top" class="crsLarge">College & Retirement Solutions<br><img src="../images/CollegeChoiceLogo.gif"></td>
		<td class="crsSmall" align="right" valign="top" width="5%" nowrap>
			College & Retirement Solutions<br>
			667 Shunpike Rd., Suite 3<br>
			Chatham, NJ 07928<br>
			973-514-2002<br>
			www.college-retirement.com
		</td>
	</tr>
</table>
<hr width="90%" style="text-align:center;">
-->
<table width="100%" border="0">
	<tr>
		<td align="left" width="20%"><?php if ($_SESSION["usertype"]=="A") echo "<a class=\"crsBlue\" href=\"collegeChoiceAdminConsole.php\">Admin Console</a>"; else echo "&nbsp;"; ?></td>
		<td align="center"><img src="../images/CollegeChoiceLogo.gif"></td>
		<td align="right" width="20%"><a class="crsBlue" href="collegeChoiceLogout.php">Log Out</a></td>
	</tr>
</table>

<div class="crsLarge" style="text-align:center">User Maintenance</div>

<form name="frmUserMaintenance" method="POST" action="collegeChoiceAddUpdateUser.php">
<b>Create New User</b>
<table width="100%" border="0">
	<tr>
		<td>Username<br><input type="text" name="txtNewUsername" size="30" maxlength="50"></td>
		<td>Password<br><input type="text" name="txtNewPassword" size="30" maxlength="50"></td>
		<td>User Type<br><select name="lstNewUserType">
				<option value="C">Client</option>
				<option value="A">Administrator</option>
			</select>
		</td>
	</tr>
<!--	<tr>
		<td>Student First Name<br><input type="text" name="txtNewStudentFirstName" size="20" maxlength="50"></td>
		<td>Student Last Name<br><input type="text" name="txtNewStudentLastName" size="30" maxlength="50"></td>
	</tr>
	<tr>
		<td>Subscription Start Date<br><input type="text" name="txtNewSubscriptionStartMonth" size="2" maxlength="2">/<input type="text" name="txtNewSubscriptionStartDay" size="2" maxlength="2">/<input type="text" name="txtNewSubscriptionStartYear" size="4" maxlength="4"></td>
		<td>Subscription End Date<br><input type="text" name="txtNewSubscriptionEndMonth" size="2" maxlength="2">/<input type="text" name="txtNewSubscriptionEndDay" size="2" maxlength="2">/<input type="text" name="txtNewSubscriptionEndYear" size="4" maxlength="4"></td>
	</tr>
-->
<?php echo $newProductHtml; ?>
	<tr>
		<td colspan="3" align="center"><br><input type="button" class="crsButton" name="btnSubmitNewUser" value="  Save  " onclick="btnSubmitNewUser_onclick();"></td>
	</tr>
</table>
<br><br>
<a name="editUser"></a><b>Edit Existing User</b>
<br>
<div style="text-align:center;">Username: <select name="lstUsername">
<option value="">Please select a username</option>
<?php
echo $usernameList;
?>
</select>&nbsp;&nbsp;<input type="button" class="crsButton" name="btnRetrieve" value="Get Data" onclick="btnRetrieve_onclick();">
</div>
<br>
<table width="100%" border="0">
	<tr>
		<td align="left" valign="top">Username<br><input type="text" name="txtUsername" size="30" maxlength="50" value="<?php echo $username; ?>"></td>
		<td align="left" valign="top">Password<br><input type="text" name="txtPassword" size="30" maxlength="50" value="<?php echo $password; ?>"></td>
		<td align="left" valign="top">User Type<br>
			<select name="lstUserType">
				<option value=""></option>
				<option value="C" <?php if ($userType=="C") echo "selected"; ?>>Client</option>
				<option value="A" <?php if ($userType=="A") echo "selected"; ?>>Administrator</option>
			</select>
		</td>
	</tr>
<!--
	<tr>
		<td align="left" valign="top">Student First Name<br><input type="text" name="txtStudentFirstName" size="20" maxlength="50" value="<?php echo $studentName; ?>"></td>
		<td align="left" valign="top">Student Last Name<br><input type="text" name="txtStudentLastName" size="30" maxlength="50" value="<?php echo $familyName; ?>"></td>
	</tr>
	<tr>
		<td>Subscription Start Date<br><input type="text" name="txtSubscriptionStartMonth" size="2" maxlength="2" value="<?php echo $userStartMonth; ?>">/<input type="text" name="txtSubscriptionStartDay" size="2" maxlength="2" value="<?php echo $userStartDay; ?>">/<input type="text" name="txtSubscriptionStartYear" size="4" maxlength="4" value="<?php echo $userStartYear; ?>"></td>
		<td>Subscription End Date<br><input type="text" name="txtSubscriptionEndMonth" size="2" maxlength="2" value="<?php echo $userEndMonth; ?>">/<input type="text" name="txtSubscriptionEndDay" size="2" maxlength="2" value="<?php echo $userEndDay; ?>">/<input type="text" name="txtSubscriptionEndYear" size="4" maxlength="4" value="<?php echo $userEndYear; ?>"></td>
	</tr>
-->
<?php echo $userProductHtml; ?>
	<tr>
		<td colspan="3" align="center"><br><input type="button" class="crsButton" name="btnUpdateUser" value=" Update " onclick="btnUpdateUser_onclick();"></td>
	</tr>
</table>
<input type="hidden" name="hidAction" value="">
<input type="hidden" name="hidUsername" value="">
<input type="hidden" name="hidNewProducts" value="">
<input type="hidden" name="hidUserProducts" value="<?php echo $userProducts; ?>">
</form>

</div>

<!--</div>-->

</body>

</html>