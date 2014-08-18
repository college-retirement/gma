<?php
 include_once '../../commonPhp/csrNewHeader.php';
 ?>
<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">
<script language="JavaScript">
<!--
function validateForm()
{
	var bool=true;

	if (document.frmLogin.txtPassword.value=="")
	{
		document.frmLogin.txtPassword.className="invalid";
		document.frmLogin.txtPassword.focus();
		bool=false;
	}
	else
		document.frmLogin.txtPassword.className="";

	if (document.frmLogin.txtUsername.value=="")
	{
		document.frmLogin.txtUsername.className="invalid";
		document.frmLogin.txtUsername.focus();
		bool=false;
	}
	else
		document.frmLogin.txtUsername.className="";

	return bool;

}
-->
</script>



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
<form name="frmLogin" method="POST" action="collegeChoiceValidate.php" onsubmit="return validateForm();">
<div class="crsLarge" style="text-align:center;">
<img src="../images/CollegeChoiceLogo.gif">
<br><br>
Login
</div>
<br>

<table border="0" width="100%">
	<tr>
		<td align="center">Username: <input type="text" name="txtUsername" id="txtUsername" size="20" maxlength="50">
			<br><br>
			Password: <input type="password" name="txtPassword" id="txtPassword" size="20" maxlength="50" style="font-family:Arial;">
			<br><br>
<?php
if (isset($_GET["login"]) && $_GET["login"]=="invalid")
	echo "<font color=\"red\">Invalid username and/or password.<br>Please contact College & Retirement Solutions<br>at 973-514-2002 if you need assistance.</font><br><br>";
else if (isset($_GET["login"]) && $_GET["login"]=="expired")
	echo "<font color=\"red\">Your subscription is expired.<br>Please contact College & Retirement Solutions<br>at 973-514-2002 to extend your subscription.</font><br><br>";
?>
			<input type="submit" name="btnSubmit" value="  Log In  " class="crsButton">
		</td>
	</tr>
</table>

</form>

</div>

<!--</div>-->
<?php
 include_once '../../commonPhp/crsNewFooter.php';
?>