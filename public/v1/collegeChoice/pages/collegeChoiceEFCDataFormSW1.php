<?php
session_start();

$userid=$_SESSION["userid"];

function checkZero($theValue)
{
	return ($theValue==0 ? "" : $theValue);
}

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TCOLLEGECHOICE_SW1 WHERE USER_ID=$userid";
$result=mysql_query($sql);

if ($result)
{
	$row=mysql_fetch_array($result);

	$studentTaxDeferredPensionsSavings=$row["TAX_DEFERRED_PENSIONS"];
	$studentDeductibleIraKeoghPayments=$row["DEDUCTIBLE_PAYMENTS"];
	$studentChildSupportReceived=$row["CHILD_SUPPORT_RECEIVED"];
	$studentTaxExemptInterestIncome=$row["EXEMPT_INTEREST_INCOME"];
	$studentUntaxedIraDistributions=$row["UNTAXED_IRA_DIST"];
	$studentUntaxedPensions=$row["UNTAXED_PENSIONS"];
	$studentHousingFoodLivingAllowance=$row["ALLOWANCES"];
	$studentNonEducationBenefits=$row["NON_EDUCATIONAL_BENEFITS"];
	$studentOtherUntaxedIncome=$row["OTHER_UNTAXED_INCOME"];
	$studentOtherNonReportedMoneyReceived=$row["OTHER_NON_REPORTED_MONEY"];
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
	var pensionsSavings=Number(document.frmCollegeChoiceDataFormSW1.txtStudentTaxDeferredPensionsSavings.value);
	var iraPay=Number(document.frmCollegeChoiceDataFormSW1.txtStudentDeductibleIraKeoghPayments.value);
	var childSupp=Number(document.frmCollegeChoiceDataFormSW1.txtStudentChildSupportReceived.value);
	var interestInc=Number(document.frmCollegeChoiceDataFormSW1.txtStudentTaxExemptInterestIncome.value);
	var iraDist=Number(document.frmCollegeChoiceDataFormSW1.txtStudentUntaxedIraDistributions.value);
	var pensions=Number(document.frmCollegeChoiceDataFormSW1.txtStudentUntaxedPensions.value);
	var allowance=Number(document.frmCollegeChoiceDataFormSW1.txtStudentHousingFoodLivingAllowance.value);
	var nonEd=Number(document.frmCollegeChoiceDataFormSW1.txtStudentNonEducationBenefits.value);
	var other=Number(document.frmCollegeChoiceDataFormSW1.txtStudentOtherUntaxedIncome.value);
	var otherNonRep=Number(document.frmCollegeChoiceDataFormSW1.txtStudentOtherNonReportedMoneyReceived.value);
	
	document.frmCollegeChoiceDataFormSW1.txtStudentTotalUntaxedIncomeBenefits.value=pensionsSavings+iraPay+childSupp+interestInc+iraDist+pensions+allowance+nonEd+other+otherNonRep;
}

function submitForm()
{
	calculateTotal();
	//window.opener.document.frmCollegeChoiceDataForm.txtStudentTotalUntaxedIncomeBenefits.value=document.frmCollegeChoiceDataFormSW1.txtStudentTotalUntaxedIncomeBenefits.value;
	returnVal=document.frmCollegeChoiceDataFormSW1.txtStudentTotalUntaxedIncomeBenefits.value;
	
	if (navigator.userAgent.toLowerCase().indexOf("firefox")>=0)
		window.opener.closeWorksheetSW1(returnVal);

	document.frmCollegeChoiceDataFormSW1.submit();
	//window.top.hidePopWin(true);
	//window.top.main.hidePopWin(true);
}

function body_onload()
{
	calculateTotal();
	document.frmCollegeChoiceDataFormSW1.txtStudentTaxDeferredPensionsSavings.focus();
	document.frmCollegeChoiceDataFormSW1.txtStudentTaxDeferredPensionsSavings.value=document.frmCollegeChoiceDataFormSW1.txtStudentTaxDeferredPensionsSavings.value;
}
-->
if (window.attachEvent) {window.attachEvent('onload', body_onload);}
else if (window.addEventListener) {window.addEventListener('load', body_onload, false);}
else {document.addEventListener('load', body_onload, false);}
</script>
 


<form name="frmCollegeChoiceDataFormSW1" method="POST" action="collegeChoiceSaveWorksheet.php">
<table width="100%" border="0">
	<tr>
		<td align="center" colspan="2"><b>Student - Total Untaxed Income and Benefits</b><br><div class="crsSmall" style="text-align:center;">Please round all numbers to the nearest dollar.<br>Do not include decimal points.</div><br></td>
	</tr>
	<tr class="tr1">
		<td>Payments to Tax-Deferred Pensions and Savings<br><span class="crsSmall">(include 401(k)s, 403(b)s, contributory union plans, etc.)</span></td>
		<td align="right">$<input type="text" name="txtStudentTaxDeferredPensionsSavings" id="txtStudentTaxDeferredPensionsSavings" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentTaxDeferredPensionsSavings ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Deductible IRA/Keogh Payments</td>
		<td align="right">$<input type="text" name="txtStudentDeductibleIraKeoghPayments" id="txtStudentDeductibleIraKeoghPayments" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentDeductibleIraKeoghPayments ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Child Support Received</td>
		<td align="right">$<input type="text" name="txtStudentChildSupportReceived" id="txtStudentChildSupportReceived" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentChildSupportReceived ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Tax Exempt Interest Income</td>
		<td align="right">$<input type="text" name="txtStudentTaxExemptInterestIncome" id="txtStudentTaxExemptInterestIncome" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentTaxExemptInterestIncome ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Untaxed Portions of IRA Distributions</td>
		<td align="right">$<input type="text" name="txtStudentUntaxedIraDistributions" id="txtStudentUntaxedIraDistributions" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentUntaxedIraDistributions ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Untaxed Portions of Pensions</td>
		<td align="right">$<input type="text" name="txtStudentUntaxedPensions" id="txtStudentUntaxedPensions" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentUntaxedPensions ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Housing, Food, and Living Allowances</td>
		<td align="right">$<input type="text" name="txtStudentHousingFoodLivingAllowance" id="txtStudentHousingFoodLivingAllowance" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentHousingFoodLivingAllowance ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Veterans Non-Education Benefits</td>
		<td align="right">$<input type="text" name="txtStudentNonEducationBenefits" id="txtStudentNonEducationBenefits" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentNonEducationBenefits ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Other Untaxed Income or Benefits<br><span class="crsSmall">(include social security, disability, etc.)</span></td>
		<td align="right">$<input type="text" name="txtStudentOtherUntaxedIncome" id="txtStudentOtherUntaxedIncome" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentOtherUntaxedIncome ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Other Non-Reported Money Received</td>
		<td align="right">$<input type="text" name="txtStudentOtherNonReportedMoneyReceived" id="txtStudentOtherNonReportedMoneyReceived" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentOtherNonReportedMoneyReceived ?>"></td>
	</tr>
	<tr class="tr1">
		<td><b>Total</b></td>
		<td align="right">$<input type="text" name="txtStudentTotalUntaxedIncomeBenefits" id="txtStudentTotalUntaxedIncomeBenefits" size="5" maxlength="7" style="background-color:grey;" readonly></td>
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

<input type="hidden" name="hidWorksheetName" value="SW1">

</form>

<?php
include_once '../../commonPhp/crsNewFooter.php';
?>