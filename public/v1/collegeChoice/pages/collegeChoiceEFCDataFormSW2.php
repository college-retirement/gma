<?php
session_start();

$userid=$_SESSION["userid"];

function checkZero($theValue)
{
	return ($theValue==0 ? "" : $theValue);
}

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TCOLLEGECHOICE_SW2 WHERE USER_ID=$userid";
$result=mysql_query($sql);

if ($result)
{
	$row=mysql_fetch_array($result);

	$studentEducationCredits=$row["EDUCATION_CREDITS"];
	$studentChildSupportPaid=$row["CHILD_SUPPORT_PAID"];
	$studentWorkStudyEarnings=$row["WORK_STUDY_EARNINGS"];
	$studentGrantScholarshipAid=$row["GRANT_SCHOLARSHIP_AID"];
	$studentCombatPay=$row["COMBAT_PAY"];
	$studentCooperativeEducationEarnings=$row["COOPERATIVE_EDUCATION_EARNINGS"];
}

include("../../commonPhp/mySqlClose.php");
include_once '../../commonPhp/csrNewHeader.php';
?>

 
<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">
 

 
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
	var education=Number(document.frmCollegeChoiceDataFormSW2.txtStudentEducationCredits.value);
	var childSupp=Number(document.frmCollegeChoiceDataFormSW2.txtStudentChildSupportPaid.value);
	var workStudy=Number(document.frmCollegeChoiceDataFormSW2.txtStudentWorkStudyEarnings.value);
	var grant=Number(document.frmCollegeChoiceDataFormSW2.txtStudentGrantScholarshipAid.value);
	var combat=Number(document.frmCollegeChoiceDataFormSW2.txtStudentCombatPay.value);
	var coopEducation=Number(document.frmCollegeChoiceDataFormSW2.txtStudentCooperativeEducationEarnings.value);
	
	document.frmCollegeChoiceDataFormSW2.txtStudentAdditionalFinancialInformation.value=education+childSupp+workStudy+grant+combat+coopEducation;
}

function submitForm()
{
	calculateTotal();
	//window.opener.document.frmCollegeChoiceDataForm.txtStudentAdditionalFinancialInformation.value=document.frmCollegeChoiceDataFormSW2.txtStudentAdditionalFinancialInformation.value;
	returnVal=document.frmCollegeChoiceDataFormSW2.txtStudentAdditionalFinancialInformation.value;
	
	if (navigator.userAgent.toLowerCase().indexOf("firefox")>=0)
		window.opener.closeWorksheetSW2(returnVal);

	document.frmCollegeChoiceDataFormSW2.submit();
	//window.top.hidePopWin(true);
	//window.top.main.hidePopWin(true);
}

function body_onload()
{
	calculateTotal();
	document.frmCollegeChoiceDataFormSW2.txtStudentEducationCredits.focus();
	document.frmCollegeChoiceDataFormSW2.txtStudentEducationCredits.value=document.frmCollegeChoiceDataFormSW2.txtStudentEducationCredits.value;
}
-->
if (window.attachEvent) {window.attachEvent('onload', body_onload);}
else if (window.addEventListener) {window.addEventListener('load', body_onload, false);}
else {document.addEventListener('load', body_onload, false);}
</script>
 


<form name="frmCollegeChoiceDataFormSW2" method="POST" action="collegeChoiceSaveWorksheet.php">
<table width="100%" border="0">
	<tr>
		<td align="center" colspan="2"><b>Student - Additional Financial Information</b><br><div class="crsSmall" style="text-align:center;">Please round all numbers to the nearest dollar.<br>Do not include decimal points.</div><br></td>
	</tr>
	<tr class="tr1">
		<td>Education Credits</td>
		<td align="right">$<input type="text" name="txtStudentEducationCredits" id="txtStudentEducationCredits" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentEducationCredits ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Child Support Paid</td>
		<td align="right">$<input type="text" name="txtStudentChildSupportPaid" id="txtStudentChildSupportPaid" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentChildSupportPaid ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Taxable Work-Study Earnings</td>
		<td align="right">$<input type="text" name="txtStudentWorkStudyEarnings" id="txtStudentWorkStudyEarnings" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentWorkStudyEarnings ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Grant and Scholarship Aid</td>
		<td align="right">$<input type="text" name="txtStudentGrantScholarshipAid" id="txtStudentGrantScholarshipAid" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentGrantScholarshipAid ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Combat Pay</td>
		<td align="right">$<input type="text" name="txtStudentCombatPay" id="txtStudentCombatPay" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentCombatPay ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Cooperative Education Earnings</td>
		<td align="right">$<input type="text" name="txtStudentCooperativeEducationEarnings" id="txtStudentCooperativeEducationEarnings" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentCooperativeEducationEarnings ?>"></td>
	</tr>
	<tr class="tr1">
		<td><b>Total</b></td>
		<td align="right">$<input type="text" name="txtStudentAdditionalFinancialInformation" id="txtStudentAdditionalFinancialInformation" size="5" maxlength="7" style="background-color:grey;" readonly></td>
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

<input type="hidden" name="hidWorksheetName" value="SW2">

</form>

<?php
include_once '../../commonPhp/crsNewFooter.php';
?>