<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

if ($_SESSION["usertype"]!="A")
	header("location:collegeChoiceLogin.php");

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TCOLLEGECHOICE_CONFIG";
$result=mysql_query($sql);
$row=mysql_fetch_array($result);

$imAppealsPctg=$row["IM_APPEALS_PCTG"];
$outOfStatePercentIncrease=$row["OUT_OF_STATE_PCT_INCREASE"];
$minorityPercentIncrease=$row["MINORITY_PCT_INCREASE"];
$safetyPctg=$row["SAFETY_PCTG"];
$targetPctg=$row["TARGET_PCTG"];
$possiblePctg=$row["POSSIBLE_PCTG"];
$reachPctg=$row["REACH_PCTG"];
$testPctg=$row["TEST_PCTG"];
$gpaPctg=$row["GPA_PCTG"];
$scorePctgForAid1=$row["SCORE_PCTG_FOR_AID1"];
$scorePctgForAid2=$row["SCORE_PCTG_FOR_AID2"];
$scorePctgForAid3=$row["SCORE_PCTG_FOR_AID3"];
$scorePctgForAid4=$row["SCORE_PCTG_FOR_AID4"];

include("../../commonPhp/mySqlClose.php");
include_once '../../commonPhp/csrNewHeader.php';
?>

<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">

<script language="JavaScript">
<!--
function txtReachPctg_onkeyup()
{
	document.getElementById("spnFarReach").innerHTML=document.frmCollegeMaint.txtReachPctg.value;
}

function txtScorePctgForAid4_onkeyup()
{
	document.getElementById("spnScorePctgForAid5").innerHTML=document.frmCollegeMaint.txtScorePctgForAid4.value;
}

function btnSubmit_onclick()
{
	var outOfStateStudentPctg=document.frmCollegeMaint.txtOutOfStatePercentIncrease.value;
	var minorityStudentPctg=document.frmCollegeMaint.txtMinorityPercentIncrease.value;
	var imAppealsPctg=document.frmCollegeMaint.txtImAppealsPctg.value;
	var safety=document.frmCollegeMaint.txtSafetyPctg.value;
	var target=document.frmCollegeMaint.txtTargetPctg.value;
	var possible=document.frmCollegeMaint.txtPossiblePctg.value;
	var reach=document.frmCollegeMaint.txtReachPctg.value;
	var test=document.frmCollegeMaint.txtTestPctg.value;
	var gpa=document.frmCollegeMaint.txtGpaPctg.value;
	var scorePctg1=document.frmCollegeMaint.txtScorePctgForAid1.value;
	var scorePctg2=document.frmCollegeMaint.txtScorePctgForAid2.value;
	var scorePctg3=document.frmCollegeMaint.txtScorePctgForAid3.value;
	var scorePctg4=document.frmCollegeMaint.txtScorePctgForAid4.value;
	
	if (isNaN(outOfStateStudentPctg) || isNaN(minorityStudentPctg) || isNaN(imAppealsPctg) || isNaN(safety) || isNaN(target) || isNaN(possible) || isNaN(reach) || isNaN(test) || isNaN(gpa) || isNaN(scorePctg1) || isNaN(scorePctg2) || isNaN(scorePctg3) || isNaN(scorePctg4))
	{
		alert("Please make sure that all values are numbers.");
		return false;
	}
	
	if (Number(safety)<=Number(target) || Number(safety)<=Number(possible) || Number(safety)<=Number(reach))
	{
		alert("Safety percentage can not be less than or equal to Target, Possible, Reach, or Far Reach percentages.");
		document.frmCollegeMaint.txtSafetyPctg.focus();
		document.frmCollegeMaint.txtSafetyPctg.value=document.frmCollegeMaint.txtSafetyPctg.value;
		return false;
	}
	
	if (Number(target)<=Number(possible) || Number(target)<=Number(reach))
	{
		alert("Target percentage can not be less than or equal to Possible, Reach, or Far Reach percentages.");
		document.frmCollegeMaint.txtTargetPctg.focus();
		document.frmCollegeMaint.txtTargetPctg.value=document.frmCollegeMaint.txtTargetPctg.value;
		return false;
	}
	
	if (Number(possible)<=Number(reach))
	{
		alert("Possible percentage can not be less than or equal to Reach or Far Reach Percentages.");
		document.frmCollegeMaint.txtPossiblePctg.focus();
		document.frmCollegeMaint.txtPossiblePctg.value=document.frmCollegeMaint.txtPossiblePctg.value;
		return false;
	}
	
	if (Number(test)+Number(gpa)!=100)
	{
		alert("Please make sure SAT/ACT percentage and GPA percentage add up to 100%.");
		document.frmCollegeMaint.txtTestPctg.focus();
		document.frmCollegeMaint.txtTestPctg.value=document.frmCollegeMaint.txtTestPctg.value;
		return false;
	}
	
	if (Number(scorePctg1)<=Number(scorePctg2) || Number(scorePctg1)<=Number(scorePctg3) || Number(scorePctg1)<=Number(scorePctg4))
	{
		alert("100% of Aid cutoff can not be less than or equal to 80%, 60%, 40%, or 30% of Aid cutoffs.");
		document.frmCollegeMaint.txtScorePctgForAid1.focus();
		document.frmCollegeMaint.txtScorePctgForAid1.value=document.frmCollegeMaint.txtScorePctgForAid1.value;
		return false;
	}
	
	if (Number(scorePctg2)<=Number(scorePctg3) || Number(scorePctg2)<=Number(scorePctg4))
	{
		alert("80% of Aid cutoff can not be less than or equal to 60%, 40%, or 30% of Aid cutoffs.");
		document.frmCollegeMaint.txtScorePctgForAid2.focus();
		document.frmCollegeMaint.txtScorePctgForAid2.value=document.frmCollegeMaint.txtScorePctgForAid2.value;
		return false;
	}

	if (Number(scorePctg3)<=Number(scorePctg4))
	{
		alert("60% of Aid cutoff can not be less than or equal to 40% or 30% of Aid cutoffs.");
		document.frmCollegeMaint.txtScorePctgForAid3.focus();
		document.frmCollegeMaint.txtScorePctgForAid3.value=document.frmCollegeMaint.txtScorePctgForAid3.value;
		return false;
	}

	document.frmCollegeMaint.submit();
}

function body_onload()
{
	document.frmCollegeMaint.txtOutOfStatePercentIncrease.focus();
	document.frmCollegeMaint.txtOutOfStatePercentIncrease.value=document.frmCollegeMaint.txtOutOfStatePercentIncrease.value;
<?php
if (isset($_GET["update"]) && $_GET["update"]==1)
	echo "\talert(\"Update Successful\");\n";
?>
}
-->
if (window.attachEvent) {window.attachEvent('onload', body_onload);}
else if (window.addEventListener) {window.addEventListener('load', body_onload, false);}
else {document.addEventListener('load', body_onload, false);}

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
		<td align="left" width="20%"><a class="crsBlue" href="collegeChoiceStudentDataForm.php">CollegeChoice</a></td>
		<td align="center"><img src="../images/CollegeChoiceLogo.gif"></td>
		<td align="right" width="20%"><a class="crsBlue" href="collegeChoiceLogout.php">Log Out</a></td>
	</tr>
</table>

<div class="crsLarge" style="text-align:center">Admin Console</div>

<form name="frmCollegeMaint" method="POST" action="collegeChoiceUpdatePercentages.php">
<table width="100%" border="0">
	<tr>
		<td align="center"><b>User Maintenance</b></td>
		<td align="center"><b>Competing Colleges Maintenance</b><td>
	</tr>
	<tr>
		<td align="center"><a class="crsBlue" href="collegeChoiceUserMaintenance.php">Please click here to enter/update user information.</a></td>
		<td align="center"><a class="crsBlue" href="collegeChoiceCompetingMaintenance.php">Please click here to enter/update competing colleges.</a></td>
	</tr>
</table>
<br><br>
<table width="100%" border="0">
	<tr>
		<td width="33%" align="center"><b>Out-of-State Student<br>Percent Increase</b>
			<br>
			<input type="text" name="txtOutOfStatePercentIncrease" size="3" maxlength="3" value="<?php echo $outOfStatePercentIncrease; ?>">%
		</td>
		<td width="34%" align="center"><b>Minority Student<br>Percent Increase</b>
			<br>
			<input type="text" name="txtMinorityPercentIncrease" size="3" maxlength="3" value="<?php echo $minorityPercentIncrease; ?>">%		
		</td>
		<td width="33%" align="center"><b>Institutional Methodology<br>Appeals Percentage</b>
			<br>
			<input type="text" name="txtImAppealsPctg" size="3" maxlength="3" value="<?php echo $imAppealsPctg; ?>">%
		</td>
	</tr>
</table>
<br><br>
<div style="text-align:center;"><b>Percentage Cutoffs</b></div>
<table width="100%" border="1">
	<tr>
		<td width="33%" align="center"><u>Admission Likelihood</u></td>
		<td width="34%" align="center"><u>SAT/ACT and GPA Percentages</u></td>
		<td width="33%" align="center"><u>Aid Percentage Cutoffs</u></td>
	</tr>
	<tr>
		<td valign="top" align="center">
			<table border="0">
				<tr>
					<td>Safety</td>
					<td>>=<input type="text" name="txtSafetyPctg" size="3" maxlength="3" value="<?php echo $safetyPctg; ?>">%</td>
				</tr>
				<tr>
					<td>Target</td>
					<td>>=<input type="text" name="txtTargetPctg" size="3" maxlength="3" value="<?php echo $targetPctg; ?>">%</td>
				</tr>
				<tr>
					<td>Possible</td>
					<td>>=<input type="text" name="txtPossiblePctg" size="3" maxlength="3" value="<?php echo $possiblePctg; ?>">%</td>
				</tr>
				<tr>
					<td>Reach</td>
					<td>>=<input type="text" name="txtReachPctg" size="3" maxlength="3" value="<?php echo $reachPctg; ?>" onkeyup="txtReachPctg_onkeyup();">%</td>
				</tr>
				<tr>
					<td>Far Reach</td>
					<td>&nbsp;<&nbsp;<span id="spnFarReach"><?php echo $reachPctg; ?></span>%</td>
				</tr>
			</table>
		</td>
		<td valign="top" align="center">
			<table border="0">
				<tr>
					<td>SAT/ACT Percentage</td>
					<td><input type="text" name="txtTestPctg" size="3" maxlength="3" value="<?php echo $testPctg; ?>">%</td>
				</tr>
				<tr>
					<td>GPA Percentage</td>
					<td><input type="text" name="txtGpaPctg" size="3" maxlength="3" value="<?php echo $gpaPctg; ?>">%</td>
				</tr>
<!--				<tr>
					<td align="center" colspan="2"><br>These percentages determine how the student's estimated percentile is calculated.</td>
				</tr>
-->			</table>		
			<br><br>These percentages determine how the student's estimated percentile is calculated.
		</td>
		<td valign="top" align="center">
			<table border="0">
				<tr>
					<td>100% of Aid</td>
					<td>>=<input type="text" name="txtScorePctgForAid1" size="3" maxlength="3" value="<?php echo $scorePctgForAid1; ?>">%</td>
				</tr>
				<tr>
					<td>80% of Aid</td>
					<td>>=<input type="text" name="txtScorePctgForAid2" size="3" maxlength="3" value="<?php echo $scorePctgForAid2; ?>">%</td>
				</tr>
				<tr>
					<td>60% of Aid</td>
					<td>>=<input type="text" name="txtScorePctgForAid3" size="3" maxlength="3" value="<?php echo $scorePctgForAid3; ?>">%</td>
				</tr>
				<tr>
					<td>40% of Aid</td>
					<td>>=<input type="text" name="txtScorePctgForAid4" size="3" maxlength="3" value="<?php echo $scorePctgForAid4; ?>" onkeyup="txtScorePctgForAid4_onkeyup();">%</td>
				</tr>
				<tr>
					<td>30% of Aid</td>
					<td>&nbsp;<&nbsp;<span id="spnScorePctgForAid5"><?php echo $scorePctgForAid4; ?></span>%</td>
				</tr>
				<!--<tr>
					<td align="center" colspan="2"><br>These percentages determine how the student's projected aid is calculated.</td>
				</tr>
-->			</table>
			<br>These percentages determine how the student's projected aid is calculated.
		</td>
	</tr>
</table>
<br>
<div style="text-align:center;">
<input type="button" class="crsButton" name="btnSubmit" value=" Submit " onclick="btnSubmit_onclick();">
</div>
</form>

</div>

<!--</div>-->

<?php
include_once '../../commonPhp/crsNewFooter.php';
?>