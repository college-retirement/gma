<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

if ($_SESSION["usertype"]!="A")
	header("location:collegeChoiceLogin.php");

$collId=$_GET["id"];
$collegeList="";
$compCollegeAvailList="";
$compCollegeList="";
$collegeName="";

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE ORDER BY COLLEGE_NAME ASC";
$result=mysql_query($sql);

while($row=mysql_fetch_array($result))
{
	$collegeList.="<option value=\"" . $row["COLLEGE_ID"] . "\"";
	if ($collId==$row["COLLEGE_ID"])
		$collegeList.=" selected";
	$collegeList.=">" . $row["COLLEGE_NAME"] . "</option>\n";

	$compCollegeAvailList.="<option value=\"" . $row["COLLEGE_ID"] . "\">" . $row["COLLEGE_NAME"] . "</option>\n";
}

if ($collId!=null)
{
	$sql="SELECT COLLEGE_NAME, COLLEGEBOARD_ID, WEB_SITE_URL, REQUEST_INFO_URL, APPLY_ONLINE_URL FROM TCOLLEGE WHERE COLLEGE_ID=$collId";
	$result=mysql_query($sql);
	$row=mysql_fetch_array($result);

	$collegeName=$row["COLLEGE_NAME"];
	$collegeBoardId=$row["COLLEGEBOARD_ID"];
	$webSite=$row["WEB_SITE_URL"];
	$requestInfo=$row["REQUEST_INFO_URL"];
	$applyOnline=$row["APPLY_ONLINE_URL"];

	$sql="SELECT A.COLLEGE_NAME, A.COLLEGE_ID FROM TCOLLEGE A, TCOLLEGE_COMPETE B WHERE B.COLLEGE_ID=$collId AND B.COMPETE_COLLEGE_ID=A.COLLEGE_ID ORDER BY A.COLLEGE_NAME";
	$result=mysql_query($sql);

	while($row=mysql_fetch_array($result))
		$compCollegeList.="<option value=\"" . $row["COLLEGE_ID"] . "\">" . $row["COLLEGE_NAME"] . "</option>\n";
}

include("../../commonPhp/mySqlClose.php");
include_once '../../commonPhp/csrNewHeader.php';
?>

<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">


<script language="JavaScript">
<!--
function btnRetrieve_onclick()
{
	var collId=document.frmCollegeMaint.lstCollege.value;
	document.location.href="collegeChoiceCompetingMaintenance.php?id="+collId;
}

function addCollege()
{
	var collAvail=document.frmCollegeMaint.lstCollegeChoices;
	var collSel=document.frmCollegeMaint.lstCollegeCompeting;
	
	for (var i=0; i<collAvail.length; i++)
	{
		if (collAvail.options[i].selected)
		{
			bool=false;
			theValue=collAvail.options[i].value;
			theText=collAvail.options[i].text;

			for (var j=0; j<collSel.length; j++)
			{
				if (collSel.options[j].value==theValue)
				{
					bool=true;
					break;
				}
			}
			if (!bool)
				document.frmCollegeMaint.lstCollegeCompeting.options[document.frmCollegeMaint.lstCollegeCompeting.length]=new Option(theText, theValue);
		}
	
	}
	
	sortList();
}

function sortList()
{
	var collSel=document.frmCollegeMaint.lstCollegeCompeting;
	tempArray=new Array();

	for (i=0; i<collSel.length; i++)
	{
		tempArray[i]=new Array();
		tempArray[i][0]=collSel.options[i].text;
		tempArray[i][1]=collSel.options[i].value;
	}

	tempArray.sort();

	for(i=0; i<collSel.length; i++)
	{
		collSel.options[i].text=tempArray[i][0];
		collSel.options[i].value=tempArray[i][1];
	}
}

function removeCollege()
{
	var collSel=document.frmCollegeMaint.lstCollegeCompeting;

	for (var i=collSel.length; i>0; i--)
	{
		if (collSel.options[i-1].selected)
			collSel.options[i-1]=null;
	}
}

function btnSubmit_onclick()
{
	var collSel=document.frmCollegeMaint.lstCollegeCompeting;
	var valsToSend="";
	
	for (var i=0; i<collSel.length; i++)
		valsToSend+=collSel.options[i].value+",";

	document.frmCollegeMaint.hidCollegeNameSelected.value=valsToSend.substring(0,valsToSend.length-1);

	document.frmCollegeMaint.submit();
}
-->

</script>

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

<div class="crsLarge" style="text-align:center">Competing Colleges</div>

<form name="frmCollegeMaint" method="POST" action="collegeChoiceUpdateCompeting.php">

<div style="text-align:center;">
<a class="crsBlue" href="uploadCompetingColleges.php">Click here to upload a spreadsheet of competing colleges</a>
<br><br>
College: <select name="lstCollege">
<option value="0">Please select a college</option>
<?php
echo $collegeList;
?>
</select>&nbsp;&nbsp;<input type="button" class="crsButton" name="btnRetrieve" value="Get Data" onclick="btnRetrieve_onclick();">
</div>
<br>
<table width="100%" border="0">
	<tr>
		<td align="left" valign="top">Name<br><input type="text" name="txtCollegeName" size="50" maxlength="100" style="background-color:grey;" value="<?php echo $collegeName; ?>" readonly></td>
		<td align="left" valign="top" nowrap>&nbsp;&nbsp;CollegeBoard ID<br>&nbsp;&nbsp;<input type="text" name="txtCollegeBoardId" size="5" maxlength="5" style="background-color:grey;" value="<?php echo isset($collegeBoardId) ? $collegeBoardId : ''; ?>" readonly></td>
	</tr>
	<tr>
		<td align="left" valign="top" colspan="2">Web Site<br><input type="text" name="txtWebSite" size="75" maxlength="500" value="<?php echo isset($webSite) ? $webSite: ''; ?>"></td>
	</tr>
	<tr>
		<td align="left" valign="top" colspan="2">Request More Information Link<br><input type="text" name="txtRequestInfo" size="75" maxlength="500" value="<?php echo isset($requestInfo) ? $requestInfo : ''; ?>"></td>
	</tr>
	<tr>
		<td align="left" valign="top" colspan="2">Apply Online Link<br><input type="text" name="txtApplyOnline" size="75" maxlength="500" value="<?php echo isset($applyOnline) ? $applyOnline : ''; ?>"></td>
	</tr>
</table>
<table border="0" width="100%">
	<tr>
		<td colspan="3" align="center">Competes With</td>
	</tr>
	<tr>
		<td width="45%" align="right">
			<select name="lstCollegeChoices" class="multSelect" size="20" ondblclick="addCollege();" multiple>
<?php
echo $compCollegeAvailList;
?>
			</select>
		</td>
		<td width="10%" align="center"><input type="button" class="crsButton" name="btnAdd" value="  --Add-->  " onclick="addCollege();"><br><br><br><br><input type="button" class="crsButton" name="btnRemove" value="<--Remove--" onclick="removeCollege();"></td>
		<td width="45%" align="left">
			<select name="lstCollegeCompeting" class="multSelect" size="20" ondblclick="removeCollege();" multiple>
<?php
echo $compCollegeList;
?>
			</select>
		</td>
	</tr>
</table>
<br>
<div style="text-align:center;"><input type="button" class="crsButton" name="btnSubmit" value=" Submit " onclick="btnSubmit_onclick();"></div>
<input type="hidden" name="hidCollegeNameSelected" value="">
</form>

</div>

<!--</div>-->

<?php
include_once '../../commonPhp/crsNewFooter.php';
?>