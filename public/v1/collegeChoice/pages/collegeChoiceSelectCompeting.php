<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

include("../../commonPhp/mySqlConnect.php");

$username=$_SESSION["username"];

$collegeIds=$_POST["hidCollegeSelected"];
$_SESSION["collegeids"]=$collegeIds;
$collegeIdArray=explode(",", $collegeIds);

$familyName=$_POST["txtFamilyName"];
$_SESSION["familyname"]=$familyName;

$studentName=$_POST["txtStudentName"];
$_SESSION["studentname"]=$studentName;

$state=$_POST["lstState"];
$_SESSION["stateofresidence"]=$state;

$gpa=$_POST["txtGpa"];
$_SESSION["gpa"]=$gpa;

$satMath=$_POST["txtSatMath"];
$_SESSION["satmath"]=$satMath;

$satVerbal=$_POST["txtSatVerbal"];
$_SESSION["satverbal"]=$satVerbal;

$satWriting=$_POST["txtSatWriting"];
$_SESSION["satwriting"]=$satWriting;

$act=$_POST["txtActComposite"];
$_SESSION["act"]=$act;

$efcFm=$_POST["txtFederalEfc"];
$_SESSION["efcfm"]=$efcFm;

$efcIm=$_POST["txtInstitutionalEfc"];
$_SESSION["efcim"]=$efcIm;

$userid=$_SESSION["userid"];

//$sql="UPDATE TUSER SET FAMILY_NAME='$familyName', STUDENT_NAME='$studentName', STATE_OF_RESIDENCE='$state', GPA='$gpa', SAT_MATH='$satMath', SAT_VERBAL='$satVerbal', SAT_WRITING='$satWriting', ACT='$act', EFC_FM='$efcFm', EFC_IM='$efcIm', COLLEGES='$collegeIds', DATE_UPDATED=NOW(), USER_UPDATED='$username' WHERE USER_ID=$userid";

$sql = "SELECT * FROM TUSER_COLLEGECHOICE_DATA WHERE USER_ID='$userid'";
$doq = mysql_query($sql) or die(mysql_error());
if (mysql_num_rows($doq) > 0)
{
	$sql = "UPDATE TUSER_COLLEGECHOICE_DATA SET FAMILY_NAME='$familyName', STUDENT_NAME='$studentName', STATE_OF_RESIDENCE='$state', GPA='$gpa', SAT_MATH='$satMath', SAT_VERBAL='$satVerbal', SAT_WRITING='$satWriting', ACT='$act', EFC_FM='$efcFm', EFC_IM='$efcIm', COLLEGES='$collegeIds', DATE_UPDATED=NOW(), USER_UPDATED='$username' WHERE USER_ID=$userid";
}
else
{
	$sql = "INSERT INTO TUSER_COLLEGECHOICE_DATA (USER_ID, FAMILY_NAME, STUDENT_NAME, STATE_OF_RESIDENCE, GPA, SAT_MATH, SAT_VERBAL, SAT_WRITING, ACT, EFC_FM, EFC_IM, COLLEGES, DATE_UPDATED, USER_UPDATED, DATE_CREATED) VALUES ('$userid', '$familyName', '$studentName', '$state', '$gpa', '$satMath', '$satVerbal', '$satWriting', '$act', '$efcFm', '$efcIm', '$collegeIds', NOW(), '$username', NOW())";
}

//echo $sql;
$result=mysql_query($sql) or die(mysql_error());
include_once '../../commonPhp/csrNewHeader.php';
?>
<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">



<script language="JavaScript">
<!--
var timer1;
var timer2;

function uncheckAll(whichId)
{
	for (i=0; i<document.frmCompColleges.elements.length; i++)
	{
		if (document.frmCompColleges.elements[i].name.indexOf("chk"+whichId)>=0)
			document.frmCompColleges.elements[i].checked=false;
	}
}

function checkAll(whichId)
{
	for (i=0; i<document.frmCompColleges.elements.length; i++)
	{
		if (document.frmCompColleges.elements[i].name.indexOf("chk"+whichId)>=0)
			document.frmCompColleges.elements[i].checked=true;
	}
}

function compColl_onclick(whichCheckbox)
{
	for (i=0; i<document.frmCompColleges.elements.length; i++)
	{
		if (document.frmCompColleges.elements[i].value.indexOf(whichCheckbox)>=0)
		{
			if (document.frmCompColleges.elements[i].checked)
				document.frmCompColleges.elements[i].checked=false;
			else
				document.frmCompColleges.elements[i].checked=true;
		}
	}
}

function btnSubmit_onclick()
{
	document.getElementById("divChoose").style.display="none";
	document.getElementById("divPleaseWait").style.display="block";
	//document.getElementById("divPleaseWait").innerHTML="<img src=\"../images/CollegeChoiceLogo.gif\"><br><br><br><br>Please wait while your report is being generated...<br><img src=\"../images/ProgressBar.gif\">";
	timer1=setTimeout("change1()", 250);
}

function change1()
{
	document.getElementById("span1").style.color="#000000";
	document.getElementById("span2").style.color="#699858";
	document.getElementById("span3").style.color="#000000";
	document.getElementById("span4").style.color="#699858";
	document.getElementById("span5").style.color="#000000";
	document.getElementById("span6").style.color="#699858";
	document.getElementById("span7").style.color="#000000";
	document.getElementById("span8").style.color="#699858";
	document.getElementById("span9").style.color="#000000";

	clearTimeout(timer1);
	timer2=setTimeout("change2()", 250);
}

function change2()
{
	document.getElementById("span1").style.color="#699858";
	document.getElementById("span2").style.color="#000000";
	document.getElementById("span3").style.color="#699858";
	document.getElementById("span4").style.color="#000000";
	document.getElementById("span5").style.color="#699858";
	document.getElementById("span6").style.color="#000000";
	document.getElementById("span7").style.color="#699858";
	document.getElementById("span8").style.color="#000000";
	document.getElementById("span9").style.color="#699858";

	clearTimeout(timer2);
	timer1=setTimeout("change1()", 250);
}
-->
</script>



<!--<div id="crsWrapper">-->

<div id="crsContent">

<form name="frmCompColleges" method="POST" action="collegeChoiceReport.php">
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

<div id="divChoose">
<div class="crsLarge" style="text-align:center">
Select Competing Schools
</div>
<br>
<div style="text-align:center;"><input type="submit" class="crsButton" name="btnSubmit" value=" Submit " onClick="btnSubmit_onclick();"></div>
<?php

function getCurldata($cb_id) {
    $url = 'http://api.getmoreaid.com/colleges/'. $cb_id .'.json';
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //Set curl to return the data instead of printing it to the browser.
    curl_setopt($ch, CURLOPT_URL, $url);

    $data = curl_exec($ch);
    curl_close($ch);

    return $data;
}

for ($i=0; $i<count($collegeIdArray); $i++) {
	$collegeId=$collegeIdArray[$i];

	// Get the college's profile.
	$college_json = getCurldata($collegeId);
	$college_array = json_decode($college_json, true);

	// Get the college's name.
	$collegeName = $college_array['college']['cb_name'];

	// And their competing colleges.
	$competing_colleges = $college_array['college']['competing_colleges'];

	echo '<table width="100%" border="0" class="collSelRepInfo"><tr><td valign="top"><div class="crsLarge"><b>' . $collegeName . '</b></div></td>';

	// Count the competing colleges.
	$howManySchools = count($competing_colleges);

	if ($howManySchools > 0) {
		$j=0;
		if ($howManySchools%2==0)
			$howManyInColumn1=$howManySchools/2;
		else
			$howManyInColumn1=round($howManySchools/2);

		echo "\t\t<td align=\"right\"><input type=\"button\" class=\"crsButton\" name=\"btnCheckAll" . $collegeId . "\" onclick=\"checkAll('" . $collegeId . "');\" value=\"  Check All  \"> <input type=\"button\" class=\"crsButton\" name=\"btnUncheckAll" . $collegeId . "\" onclick=\"uncheckAll('" . $collegeId . "');\" value=\"Uncheck All\"></td>\n\t</tr>\n";
		echo "<tr>\n\t\t<td width=\"50%\" valign=\"top\">\n\t\t\t<table width=\"100%\" border=\"0\">\n";

		// while($row=mysql_fetch_array($result))
		foreach($competing_colleges as $competing_college) {

			$compCollName=$competing_college['cb_name'];
			$compCollId=$competing_college['cb_id'];

			if ($j==$howManyInColumn1)
				echo "\t\t\t</table>\n\t\t</td>\n\t\t<td width=\"50%\" valign=\"top\">\n\t\t\t<table width=\"100%\" border=\"0\">\n";

			echo "\t\t\t\t<tr>\n\t\t\t\t\t<td valign=\"top\"><input type=\"checkbox\" name=\"chk" . $collegeId . "[]\" value=\"" . $compCollName . "^" . $compCollId . "\" checked></td>\n\t\t\t\t\t<td><span onclick=\"compColl_onclick('" . str_replace("'","\'",$compCollName) . "^" . $compCollId . "');\">" . $compCollName . "</span></td>\n\t\t\t\t</tr>\n";

			$j++;
		}
	}
	else
		echo "\t\t<td>&nbsp;</td>\n\t</tr>\n\t<tr>\n\t\t<td>None available";

	echo "\t\t\t</table>\n\t\t</td>\n\t</tr>\n</table>\n<br><br>\n";

}

include("../../commonPhp/mySqlClose.php");
?>

<div style="text-align:center;"><input type="submit" class="crsButton" name="btnSubmit" value=" Submit " onClick="btnSubmit_onclick();"></div>
</form>
</div>
<div id="divPleaseWait" class="crsLarge" style="text-align:center;display:none;">
<br><br><br><br>
<span id="span1" style="color:#699858;">Please</span> <span id="span2" style="color:#000000;">wait</span> <span id="span3" style="color:#699858;">while</span> <span id="span4" style="color:#000000;">your</span> <span id="span5" style="color:#699858;">report</span> <span id="span6" style="color:#000000;">is</span> <span id="span7" style="color:#699858;">being</span> <span id="span8" style="color:#000000;">generated</span><span id="span9" style="color:#699858;">...</span>
<br><br><br><br><br><br>
</div>

</div>

<!--</div>-->

<?php
include_once '../../commonPhp/crsNewFooter.php';
?>
