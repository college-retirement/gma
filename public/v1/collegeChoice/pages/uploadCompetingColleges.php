<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

if ($_SESSION["usertype"]!="A")
	header("location:collegeChoiceLogin.php");

 include_once '../../commonPhp/csrNewHeader.php';
?>


<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">



<script language="JavaScript">
<!--
function validateForm()
{
	var spreadsheetName=document.frmLoadCompeting.spreadsheetUpload.value;
	
	if (spreadsheetName=="")
		alert("Please choose a spreadsheet to upload.");
	else if (spreadsheetName.substr(spreadsheetName.length-4,spreadsheetName.length)=="xlsx")
		alert("You must upload a spreadsheet in .xls format - NOT .xlsx (Office 2007).");
	else if (spreadsheetName.substr(spreadsheetName.length-3,spreadsheetName.length)!="xls")
		alert("You can only upload an Excel spreadsheet (in .xls format).");
	else
	{
		if (document.frmLoadCompeting.radTable[0].checked==true && !confirm("Please click OK to verify that you want to insert into TCOLLEGE_COMPETE."))
			return false;

		document.frmLoadCompeting.submit();
	}
}
-->
</script>


<!--<div id="crsWrapper">-->

<div id="crsContent">

<table width="100%" border="0">
	<tr>
		<td align="left" width="20%"><?php if ($_SESSION["usertype"]=="A") echo "<a class=\"crsBlue\" href=\"collegeChoiceAdminConsole.php\">Admin Console</a>"; else echo "&nbsp;"; ?></td>
		<td align="center"><img src="../images/CollegeChoiceLogo.gif"></td>
		<td align="right" width="20%"><a class="crsBlue" href="collegeChoiceLogout.php">Log Out</a></td>
	</tr>
</table>

<div class="crsLarge" style="text-align:center">Upload Competing Colleges</div>

<form name="frmLoadCompeting" enctype="multipart/form-data" action="loadCompetingColleges.php" method="POST">

<table width="100%" border="0">
	<tr>
		<td valign="top" width="50%">1.  Choose a spreadsheet to upload
			<br><br>
			<input type="file" name="spreadsheetUpload">
		</td>
		<td valign="top">2.  Choose a table to upload to
			<br>
			&nbsp;&nbsp;&nbsp;<input type="radio" name="radTable" id="radTable" value="TCOLLEGE_COMPETE">TCOLLEGE_COMPETE
			<br>
			&nbsp;&nbsp;&nbsp;<input type="radio" name="radTable" id="radTable" value="TCOLLEGE_COMPETE_TEMP" checked>TCOLLEGE_COMPETE_TEMP
			<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(temporary "staging" table for testing and verification)
		</td>
	</tr>
	<tr>
		<td align="center" colspan="2"><br><input type="button" name="btnUpload" class="crsButton" value="Upload File" onclick="return validateForm();"></td>
	</tr>
</table>

<input type="hidden" name="MAX_FILE_SIZE" value="100000">

</form>
<br>
<?php
include_once '../../commonPhp/crsNewFooter.php';
?>
