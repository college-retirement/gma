<?php
session_start();

$userid=$_SESSION["userid"];

function checkZero($theValue)
{
	return ($theValue==0 ? "" : $theValue);
}

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TCOLLEGECHOICE_PW2 WHERE USER_ID=$userid";
$result=mysql_query($sql);

if ($result)
{
	$row=mysql_fetch_array($result);

	$parentsEducationCredits=$row["EDUCATION_CREDITS"];
	$parentsChildSupportPaid=$row["CHILD_SUPPORT_PAID"];
	$parentsWorkStudyEarnings=$row["WORK_STUDY_EARNINGS"];
	$parentsGrantScholarshipAid=$row["GRANT_SCHOLARSHIP_AID"];
	$parentsCombatPay=$row["COMBAT_PAY"];
	$parentsCooperativeEducationEarnings=$row["COOPERATIVE_EDUCATION_EARNINGS"];
}

include("../../commonPhp/mySqlClose.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>
 
<head>
 
<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">
 
<title>College & Retirement Solutions</title>
 
<script language="JavaScript" type="text/javascript"> 
<!--
var returnVal=0;

function validateNumber(whichField)
{
	var theNumber=whichField.value;
	if (theNumber=="")
		theNumber="0";
	theNumber=theNumber.replace(/\,/,"");
	
	whichField.value=theNumber;
	
	if (theNumber.indexOf(".")>=0)
	{
		alert("Please round all numbers to the nearest dollar.  Do not include decimal points.");
		whichField.select();
	}
		
	if (isNaN(theNumber))
	{
		alert("Please enter numeric values only.");
		whichField.select();
	}
}

function calculateTotal()
{
	var education=Number(document.frmCollegeChoiceDataFormPW2.txtParentsEducationCredits.value);
	var childSupp=Number(document.frmCollegeChoiceDataFormPW2.txtParentsChildSupportPaid.value);
	var workStudy=Number(document.frmCollegeChoiceDataFormPW2.txtParentsWorkStudyEarnings.value);
	var grant=Number(document.frmCollegeChoiceDataFormPW2.txtParentsGrantScholarshipAid.value);
	var combat=Number(document.frmCollegeChoiceDataFormPW2.txtParentsCombatPay.value);
	var coopEducation=Number(document.frmCollegeChoiceDataFormPW2.txtParentsCooperativeEducationEarnings.value);
	
	document.frmCollegeChoiceDataFormPW2.txtParentsAdditionalFinancialInformation.value=education+childSupp+workStudy+grant+combat+coopEducation;
}

function submitForm()
{
	calculateTotal();
	//window.opener.document.frmCollegeChoiceDataForm.txtParentsAdditionalFinancialInformation.value=document.frmCollegeChoiceDataFormPW2.txtParentsAdditionalFinancialInformation.value;
	returnVal=document.frmCollegeChoiceDataFormPW2.txtParentsAdditionalFinancialInformation.value;
	
	if (navigator.userAgent.toLowerCase().indexOf("firefox")>=0)
		window.opener.closeWorksheetPW2(returnVal);

	document.frmCollegeChoiceDataFormPW2.submit();
	//window.top.hidePopWin(true);
	//window.top.main.hidePopWin(true);
}

function body_onload()
{
	calculateTotal();
	document.frmCollegeChoiceDataFormPW2.txtParentsEducationCredits.focus();
	document.frmCollegeChoiceDataFormPW2.txtParentsEducationCredits.value=document.frmCollegeChoiceDataFormPW2.txtParentsEducationCredits.value;
}
-->
</script>
 
</head>
 
<body class="worksheet" onload="body_onload();">

<form name="frmCollegeChoiceDataFormPW2" method="POST" action="collegeChoiceSaveWorksheet.php">
<table width="100%" border="0">
	<tr>
		<td align="center" colspan="2"><b>Parents - Additional Financial Information</b><br><div class="crsSmall" style="text-align:center;">Please round all numbers to the nearest dollar.<br>Do not include decimal points.</div><br></td>
	</tr>
	<tr class="tr1">
		<td>Education Credits</td>
		<td align="right">$<input type="text" name="txtParentsEducationCredits" id="txtParentsEducationCredits" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsEducationCredits ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Child Support Paid</td>
		<td align="right">$<input type="text" name="txtParentsChildSupportPaid" id="txtParentsChildSupportPaid" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsChildSupportPaid ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Taxable Work-Study Earnings</td>
		<td align="right">$<input type="text" name="txtParentsWorkStudyEarnings" id="txtParentsWorkStudyEarnings" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsWorkStudyEarnings ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Grant and Scholarship Aid</td>
		<td align="right">$<input type="text" name="txtParentsGrantScholarshipAid" id="txtParentsGrantScholarshipAid" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsGrantScholarshipAid ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Combat Pay</td>
		<td align="right">$<input type="text" name="txtParentsCombatPay" id="txtParentsCombatPay" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsCombatPay ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Cooperative Education Earnings</td>
		<td align="right">$<input type="text" name="txtParentsCooperativeEducationEarnings" id="txtParentsCooperativeEducationEarnings" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsCooperativeEducationEarnings ?>"></td>
	</tr>
	<tr class="tr1">
		<td><b>Total</b></td>
		<td align="right">$<input type="text" name="txtParentsAdditionalFinancialInformation" id="txtParentsAdditionalFinancialInformation" size="5" maxlength="7" style="background-color:grey;" readonly></td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="100%">
				<tr>
					<td align="center"><input type="button" class="crsButton" name="btnCalculateTotal" id="btnCalculateTotal" value="Calculate Total" onclick="calculateTotal();">&nbsp;&nbsp;<input type="button" class="crsButton" name="btnSubmit" id="btnSubmit" value="       Submit       " onclick="submitForm();">
				</tr>
			</table>
		</td>
	</tr>
</table>

<input type="hidden" name="hidWorksheetName" value="PW2">

</form>

</body>

</html>