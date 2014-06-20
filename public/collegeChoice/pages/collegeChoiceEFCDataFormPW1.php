<?php
session_start();

$userid=$_SESSION["userid"];

function checkZero($theValue)
{
	return ($theValue==0 ? "" : $theValue);
}

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TCOLLEGECHOICE_PW1 WHERE USER_ID=$userid";
$result=mysql_query($sql);

if ($result)
{
	$row=mysql_fetch_array($result);

	$parentsPaymentsTaxDeferredPensionsSavings=$row["TAX_DEFERRED_PENSIONS"];
	$parentsDeductibleIraKeoghPayments=$row["DEDUCTIBLE_PAYMENTS"];
	$parentsChildSupportReceived=$row["CHILD_SUPPORT_RECEIVED"];
	$parentsTaxExemptInterestIncome=$row["EXEMPT_INTEREST_INCOME"];
	$parentsUntaxedIraDistributions=$row["UNTAXED_IRA_DIST"];
	$parentsUntaxedPensions=$row["UNTAXED_PENSIONS"];
	$parentsHousingFoodLivingAllowance=$row["ALLOWANCES"];
	$parentsNonEducationBenefits=$row["NON_EDUCATIONAL_BENEFITS"];
	$parentsOtherUntaxedIncome=$row["OTHER_UNTAXED_INCOME"];
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
	var pensionsSavings=Number(document.frmCollegeChoiceDataFormPW1.txtParentsTaxDeferredPensionsSavings.value);
	var iraPay=Number(document.frmCollegeChoiceDataFormPW1.txtParentsDeductibleIraKeoghPayments.value);
	var childSupp=Number(document.frmCollegeChoiceDataFormPW1.txtParentsChildSupportReceived.value);
	var interestInc=Number(document.frmCollegeChoiceDataFormPW1.txtParentsTaxExemptInterestIncome.value);
	var iraDist=Number(document.frmCollegeChoiceDataFormPW1.txtParentsUntaxedIraDistributions.value);
	var pensions=Number(document.frmCollegeChoiceDataFormPW1.txtParentsUntaxedPensions.value);
	var allowance=Number(document.frmCollegeChoiceDataFormPW1.txtParentsHousingFoodLivingAllowance.value);
	var nonEd=Number(document.frmCollegeChoiceDataFormPW1.txtParentsNonEducationBenefits.value);
	var other=Number(document.frmCollegeChoiceDataFormPW1.txtParentsOtherUntaxedIncome.value);
	
	document.frmCollegeChoiceDataFormPW1.txtParentsTotalUntaxedIncomeBenefits.value=pensionsSavings+iraPay+childSupp+interestInc+iraDist+pensions+allowance+nonEd+other;
}

function submitForm()
{
	calculateTotal();
	//window.opener.document.frmCollegeChoiceDataForm.txtParentsTotalUntaxedIncomeBenefits.value=document.frmCollegeChoiceDataFormPW1.txtParentsTotalUntaxedIncomeBenefits.value;
	returnVal=document.frmCollegeChoiceDataFormPW1.txtParentsTotalUntaxedIncomeBenefits.value;
	
	if (navigator.userAgent.toLowerCase().indexOf("firefox")>=0)
		window.opener.closeWorksheetPW1(returnVal);

	document.frmCollegeChoiceDataFormPW1.submit();
	//window.top.hidePopWin(true);
	//window.top.main.hidePopWin(true);
}

function body_onload()
{
	calculateTotal();
	document.frmCollegeChoiceDataFormPW1.txtParentsTaxDeferredPensionsSavings.focus();
	document.frmCollegeChoiceDataFormPW1.txtParentsTaxDeferredPensionsSavings.value=document.frmCollegeChoiceDataFormPW1.txtParentsTaxDeferredPensionsSavings.value;
}
-->
</script>
 
</head>
 
<body class="worksheet" onload="body_onload();">

<form name="frmCollegeChoiceDataFormPW1" method="POST" action="collegeChoiceSaveWorksheet.php">
<table width="100%" border="0">
	<tr>
		<td align="center" colspan="2"><b>Parents - Total Untaxed Income and Benefits</b><br><div class="crsSmall" style="text-align:center;">Please round all numbers to the nearest dollar.<br>Do not include decimal points.</div><br></td>
	</tr>
	<tr class="tr1">
		<td>Payments to Tax-Deferred Pension and Savings<br><span class="crsSmall">(include 401(k)s, 403(b)s, contributory union plans, etc.)</span></td>
		<td align="right">$<input type="text" name="txtParentsTaxDeferredPensionsSavings" id="txtParentsTaxDeferredPensionsSavings" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsPaymentsTaxDeferredPensionsSavings ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Deductible IRA/Keogh Payments</td>
		<td align="right">$<input type="text" name="txtParentsDeductibleIraKeoghPayments" id="txtParentsDeductibleIraKeoghPayments" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsDeductibleIraKeoghPayments ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Child Support Received</td>
		<td align="right">$<input type="text" name="txtParentsChildSupportReceived" id="txtParentsChildSupportReceived" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsChildSupportReceived ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Tax Exempt Interest Income</td>
		<td align="right">$<input type="text" name="txtParentsTaxExemptInterestIncome" id="txtParentsTaxExemptInterestIncome" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsTaxExemptInterestIncome ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Untaxed Portions of IRA Distributions</td>
		<td align="right">$<input type="text" name="txtParentsUntaxedIraDistributions" id="txtParentsUntaxedIraDistributions" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsUntaxedIraDistributions ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Untaxed Portions of Pensions</td>
		<td align="right">$<input type="text" name="txtParentsUntaxedPensions" id="txtParentsUntaxedPensions" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsUntaxedPensions ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Housing, Food, and Living Allowances</td>
		<td align="right">$<input type="text" name="txtParentsHousingFoodLivingAllowance" id="txtParentsHousingFoodLivingAllowance" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsHousingFoodLivingAllowance ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Veterans Non-Education Benefits</td>
		<td align="right">$<input type="text" name="txtParentsNonEducationBenefits" id="txtParentsNonEducationBenefits" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsNonEducationBenefits ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Other Untaxed Income or Benefits<br><span class="crsSmall">(include social security, disability, etc.)</span></td>
		<td align="right">$<input type="text" name="txtParentsOtherUntaxedIncome" id="txtParentsOtherUntaxedIncome" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsOtherUntaxedIncome ?>"></td>
	</tr>
	<tr class="tr2">
		<td><b>Total</b></td>
		<td align="right">$<input type="text" name="txtParentsTotalUntaxedIncomeBenefits" id="txtParentsTotalUntaxedIncomeBenefits" size="5" maxlength="7" style="background-color:grey;" readonly></td>
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

<input type="hidden" name="hidWorksheetName" value="PW1">

</form>

</body>

</html>