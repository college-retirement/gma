<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

$userid=$_SESSION["userid"];

function checkZero($theValue)
{
	return ($theValue==0 ? "" : $theValue);
}

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TCOLLEGECHOICE_PARENT WHERE USER_ID=$userid";
$result=mysql_query($sql);

if ($result)
{
	$row=mysql_fetch_array($result);

	$parentsMaritalWorkingStatus=$row["MARITAL_WORKING_STATUS"];
	$fatherAge=$row["FATHER_AGE"];
	$motherAge=$row["MOTHER_AGE"];
	$stateOfResidence=$row["STATE_OF_RESIDENCE"];
	$parentsHouseholdSize=$row["HOUSEHOLD_SIZE"];
	$parentsNumberInCollege=$row["NUMBER_IN_COLLEGE"];
	$parentsTaxFilingStatus=$row["TAX_FILING_STATUS"];
	$parentsAgi=$row["AGI"];
	$fatherIncomeEarned=$row["FATHER_INCOME_EARNED"];
	$motherIncomeEarned=$row["MOTHER_INCOME_EARNED"];
	$parentsTotalUntaxedIncomeBenefits=$row["UNTAXED_INCOME"];
	$parentsAdditionalFinancialInformation=$row["ADDITIONAL_FINANCIAL_INFO"];
	$parentsIncomeTax=$row["INCOME_TAX"];
	$parentsCashSavingsChecking=$row["CASH_SAVINGS_CHECKING"];
	$parentsHomeCurrentMarketValue=$row["HOME_CURRENT_MARKET_VALUE"];
	$parentsFirstMortgage=$row["FIRST_MORTGAGE"];
	$parentsSecondMortgage=$row["SECOND_MORTGAGE"];
	$parentsHomeEquityLineOfCredit=$row["HOME_EQUITY_LINE_OF_CREDIT"];
	$parentsNetWorthInvestments=$row["NET_WORTH_INVESTMENTS"];
	$parentsNetWorthBusinessInvestmentFarm=$row["NET_WORTH_BUSINESS"];
}

$sql="SELECT * FROM TCOLLEGECHOICE_STUDENT WHERE USER_ID=$userid";
$result=mysql_query($sql);

if ($result)
{
	$row=mysql_fetch_array($result);

	$studentTaxFilingStatus=$row["TAX_FILING_STATUS"];
	$studentAgi=$row["AGI"];
	$studentIncomeEarned=$row["INCOME_EARNED"];
	$studentTotalUntaxedIncomeBenefits=$row["UNTAXED_INCOME"];
	$studentAdditionalFinancialInformation=$row["ADDITIONAL_FINANCIAL_INFO"];
	$studentIncomeTax=$row["INCOME_TAX"];
	$studentCashSavingsChecking=$row["CASH_SAVINGS_CHECKING"];
	$studentNetWorthInvestments=$row["NET_WORTH_INVESTMENTS"];
	$studentNetWorthBusinessInvestmentFarm=$row["NET_WORTH_BUSINESS"];
	$studentMinority=$row["MINORITY"];
}

include("../../commonPhp/mySqlClose.php");
include_once '../../commonPhp/csrNewHeader.php';
?>


<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">
<link rel="stylesheet" type="text/css" href="../../commonCss/subModal.css">
<script type="text/javascript" src="../../commonJs/common.js"></script>
<script type="text/javascript" src="../../commonJs/subModal.js"></script>



<script language="JavaScript" type="text/javascript">
<!--
var newWindow;

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

function validateAge(whichField)
{
	var theNumber=whichField.value;

	if (isNaN(theNumber))
	{
		alert("Please enter numeric values only.");
		whichField.select();
	}
}

function openWorksheet(whichWorksheet, whichFunction)
{
	var newWindowWidth=450;
	var newWindowHeight=350;

	if (navigator.userAgent.toLowerCase().indexOf("firefox")>=0)
	{
		var newWindowLeft=(window.screen.width-newWindowWidth)/2;
		var newWindowTop=(window.screen.height-newWindowHeight)/2;
		newWindow=window.open(whichWorksheet, "worksheet", "width="+newWindowWidth+",height="+newWindowHeight+",resizable=yes,left="+newWindowLeft+",top="+newWindowTop+",status=no,toolbar=no,menubar=no,scrollbars=yes,location=no,directories=no");
		newWindow.focus();
	}
	else
		showPopWin(whichWorksheet, newWindowWidth, newWindowHeight, whichFunction);
}

function closeWorksheetPW1(theValue)
{
	document.frmCollegeChoiceDataForm.txtParentsTotalUntaxedIncomeBenefits.value=theValue;
}

function closeWorksheetPW2(theValue)
{
	document.frmCollegeChoiceDataForm.txtParentsAdditionalFinancialInformation.value=theValue;
}

function closeWorksheetSW1(theValue)
{
	document.frmCollegeChoiceDataForm.txtStudentTotalUntaxedIncomeBenefits.value=theValue;
}

function closeWorksheetSW2(theValue)
{
	document.frmCollegeChoiceDataForm.txtStudentAdditionalFinancialInformation.value=theValue;
}

function validateForm()
{
	var message="";
	var bool=true;

	if (document.frmCollegeChoiceDataForm.lstStudentTaxFilingStatus.selectedIndex==0)
	{
		document.frmCollegeChoiceDataForm.lstStudentTaxFilingStatus.focus();
		message="Please select the student's tax filing status.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.selectedIndex==1 && (document.frmCollegeChoiceDataForm.txtFatherIncomeEarned.value=="0" || document.frmCollegeChoiceDataForm.txtFatherIncomeEarned.value=="" || document.frmCollegeChoiceDataForm.txtMotherIncomeEarned.value=="0" || document.frmCollegeChoiceDataForm.txtMotherIncomeEarned.value==""))
	{
		document.frmCollegeChoiceDataForm.txtFatherIncomeEarned.focus();
		message="Please enter earned income for both parents if Marital/Working Status is Married/Two Working Parents.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.selectedIndex==3 && (document.frmCollegeChoiceDataForm.txtFatherIncomeEarned.value!="0" && document.frmCollegeChoiceDataForm.txtFatherIncomeEarned.value!="") && (document.frmCollegeChoiceDataForm.txtMotherIncomeEarned.value!="0" && document.frmCollegeChoiceDataForm.txtMotherIncomeEarned.value!=""))
	{
		document.frmCollegeChoiceDataForm.txtFatherIncomeEarned.focus();
		message="Please enter earned income for only one parent if Marital/Working Status is One-Parent Family.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstParentsTaxFilingStatus.selectedIndex==0)
	{
		document.frmCollegeChoiceDataForm.lstParentsTaxFilingStatus.focus();
		message="Please select the parents' tax filing status.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstParentsHouseholdSize.value<document.frmCollegeChoiceDataForm.lstParentsNumberInCollege.value)
	{
		document.frmCollegeChoiceDataForm.lstParentsHouseholdSize.focus();
		message="The number in college can not be greater than the number in household.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstStateOfResidence.selectedIndex==0)
	{
		document.frmCollegeChoiceDataForm.lstStateOfResidence.focus();
		message="Please select a state of residence.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.selectedIndex==3 && (document.frmCollegeChoiceDataForm.txtFatherAge.value!="" && document.frmCollegeChoiceDataForm.txtMotherAge.value!=""))
	{
		document.frmCollegeChoiceDataForm.txtFatherAge.focus();
		message="Please enter an age for only one parent if Marital/Working Status is One-Parent Family.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.selectedIndex!=3 && (document.frmCollegeChoiceDataForm.txtFatherAge.value=="" || document.frmCollegeChoiceDataForm.txtFatherAge.value=="0" || document.frmCollegeChoiceDataForm.txtMotherAge.value=="" || document.frmCollegeChoiceDataForm.txtMotherAge.value=="0"))
	{
		document.frmCollegeChoiceDataForm.txtFatherAge.focus();
		message="Please enter an age for both parents if Marital/Working Status is Married.";
		bool=false;
	}

	if (document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.selectedIndex==0)
	{
		document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.focus();
		message="Please select a marital/working status.";
		bool=false;
	}

	if (!bool)
		alert(message);
	else
	{
		if (newWindow!=null && !newWindow.closed)
		{
			alert("You still have a worksheet open.  Please submit the worksheet before proceeding.");
			newWindow.focus();
		}
		else
			document.frmCollegeChoiceDataForm.submit();
	}
}

function body_onload()
{
	
	document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.value="<?php echo $parentsMaritalWorkingStatus; ?>";
	document.frmCollegeChoiceDataForm.lstStateOfResidence.value="<?php echo $stateOfResidence; ?>";
	document.frmCollegeChoiceDataForm.lstParentsHouseholdSize.value="<?php echo $parentsHouseholdSize; ?>";
	document.frmCollegeChoiceDataForm.lstParentsNumberInCollege.value="<?php echo $parentsNumberInCollege; ?>";
	document.frmCollegeChoiceDataForm.lstParentsTaxFilingStatus.value="<?php echo $parentsTaxFilingStatus; ?>";
	document.frmCollegeChoiceDataForm.lstStudentTaxFilingStatus.value="<?php echo $studentTaxFilingStatus; ?>";
	document.frmCollegeChoiceDataForm.lstStudentMinority.value="<?php echo $studentMinority; ?>";
	document.frmCollegeChoiceDataForm.lstParentsMaritalWorkingStatus.focus();
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
		<td align="left" width="20%"><?php if ($_SESSION["usertype"]=="A") echo "<a class=\"crsBlue\" href=\"collegeChoiceAdminConsole.php\">Admin Console</a>"; else echo "&nbsp;"; ?></td>
		<td align="center"><img src="../images/CollegeChoiceLogo.gif"></td>
		<td align="right" width="20%"><a class="crsBlue" href="collegeChoiceLogout.php">Log Out</a></td>
	</tr>
</table>

<div class="crsLarge" style="text-align:center;">EFC (Expected Family Contribution) Calculator</div>
<div class="crsSmall" style="text-align:center;">Please round all numbers to the nearest dollar.  Do not include decimal points.</div>

<form name="frmCollegeChoiceDataForm" action="collegeChoiceCalculateEFC.php" method="POST">
<div style="text-align:center;"><input type="button" class="crsButton" name="btnSubmit" value=" Submit " onclick="return validateForm();"></div>
<br>
<table width="100%" border="0">
	<tr class="tr1">
		<td colspan="2"><b>Parents</b></td>
	</tr>
	<tr class="tr2">
		<td>Marital/Working Status</td>
		<td align="right" valign="top"><select name="lstParentsMaritalWorkingStatus">
				<option value="">Please select a status</option>
				<option value="1">Married/Two Working Parents</option>
				<option value="2">Married/One Working Parent</option>
				<option value="3">One-Parent Family</option>
			</select>
		</td>
	</tr>
	<tr class="tr1">
		<td>Father/Stepfather's Age</td>
		<td align="right" valign="top"><input type="text" name="txtFatherAge" id="txtFatherAge" size="3" maxlength="2" onblur="validateAge(this);" value="<?php echo $fatherAge; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Mother/Stepmother's Age</td>
		<td align="right" valign="top"><input type="text" name="txtMotherAge" id="txtMotherAge" size="3" maxlength="2" onblur="validateAge(this);" value="<?php echo $motherAge; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>State of Residence</td>
		<td align="right" valign="top"><select name="lstStateOfResidence">
				<option value="AL">Alabama</option>
				<option value="AK">Alaska</option>
				<option value="AS">American Samoa</option>
				<option value="AZ">Arizona</option>
				<option value="AR">Arkansas</option>
				<option value="AF">Armed Forces Africa</option>
				<option value="AA">Armed Forces Americas</option>
				<option value="AC">Armed Forces Canada</option>
				<option value="AE">Armed Forces Europe</option>
				<option value="AM">Armed Forces Middle East</option>
				<option value="AP">Armed Forces Pacific</option>
				<option value="CA">California</option>
				<option value="CO">Colorado</option>
				<option value="CT">Connecticut</option>
				<option value="DE">Delaware</option>
				<option value="DC">District of Columbia</option>
				<option value="FM">Federated States Of Micronesia</option>
				<option value="FL">Florida</option>
				<option value="GA">Georgia</option>
				<option value="GU">Guam</option>
				<option value="HI">Hawaii</option>
				<option value="ID">Idaho</option>
				<option value="IL">Illinois</option>
				<option value="IN">Indiana</option>
				<option value="IA">Iowa</option>
				<option value="KS">Kansas</option>
				<option value="KY">Kentucky</option>
				<option value="LA">Louisiana</option>
				<option value="ME">Maine</option>
				<option value="MH">Marshall Islands</option>
				<option value="MD">Maryland</option>
				<option value="MA">Massachusetts</option>
				<option value="MI">Michigan</option>
				<option value="MN">Minnesota</option>
				<option value="MS">Mississippi</option>
				<option value="MO">Missouri</option>
				<option value="MT">Montana</option>
				<option value="NE">Nebraska</option>
				<option value="NV">Nevada</option>
				<option value="NH">New Hampshire</option>
				<option value="NJ">New Jersey</option>
				<option value="NM">New Mexico</option>
				<option value="NY">New York</option>
				<option value="NC">North Carolina</option>
				<option value="ND">North Dakota</option>
				<option value="MP">Northern Mariana Islands</option>
				<option value="OH">Ohio</option>
				<option value="OK">Oklahoma</option>
				<option value="OR">Oregon</option>
				<option value="PW">Palau</option>
				<option value="PA">Pennsylvania</option>
				<option value="PR">Puerto Rico</option>
				<option value="RI">Rhode Island</option>
				<option value="SC">South Carolina</option>
				<option value="SD">South Dakota</option>
				<option value="TN">Tennessee</option>
				<option value="TX">Texas</option>
				<option value="UT">Utah</option>
				<option value="VT">Vermont</option>
				<option value="VI">Virgin Islands</option>
				<option value="VA">Virginia</option>
				<option value="WA">Washington</option>
				<option value="WV">West Virginia</option>
				<option value="WI">Wisconsin</option>
				<option value="WY">Wyoming</option>
			</select>
		</td>
	</tr>
	<tr class="tr2">
		<td>Number in Household</td>
		<td align="right" valign="top">&nbsp;&nbsp;<select name="lstParentsHouseholdSize">
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
			</select>
		</td>
	</tr>
	<tr class="tr1">
		<td>Number in College During Upcoming School Year</td>
		<td align="right" valign="top"><select name="lstParentsNumberInCollege">
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
			</select>
		</td>
	</tr>
	<tr class="tr2">
		<td>Tax Filing Status</td>
		<td align="right" valign="top"><select name="lstParentsTaxFilingStatus">
				<option value="">Please select a status</option>
				<option value="0">Non-tax filers</option>
				<option value="1">Tax filers</option>
			</select>
		</td>
	</tr>
	<tr class="tr1">
		<td>Adjusted Gross Income (Form 1040, Line 37)</td>
		<td align="right" valign="top">$<input type="text" name="txtParentsAgi" id="txtParentsAgi" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsAgi; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Father's/Stepfather's Income Earned From Work (Form W-2, Box 1)</td>
		<td align="right" valign="top">$<input type="text" name="txtFatherIncomeEarned" id="txtFatherIncomeEarned" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $fatherIncomeEarned; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Mother's/Stepmother's Income Earned From Work (Form W-2, Box 1)</td>
		<td align="right" valign="top">$<input type="text" name="txtMotherIncomeEarned" id="txtMotherIncomeEarned" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $motherIncomeEarned; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Total Untaxed Income and Benefits <a class="crsBlue" href="javascript:openWorksheet('collegeChoiceEFCDataFormPW1.php',closeWorksheetPW1);">(please click here for the worksheet)</a><br><span class="crsSmall">(Use Form 1040, Lines 8 - 21;<br>include retirement plan contributions, taxable interest, dividends, business income, etc.)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtParentsTotalUntaxedIncomeBenefits" id="txtParentsTotalUntaxedIncomeBenefits" size="5" maxlength="7" style="background-color:#A3A3A3;" readonly value="<?php echo $parentsTotalUntaxedIncomeBenefits; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Additional Financial Information <a class="crsBlue" href="javascript:openWorksheet('collegeChoiceEFCDataFormPW2.php',closeWorksheetPW2);">(please click here for the worksheet)</a></td>
		<td align="right" valign="top">$<input type="text" name="txtParentsAdditionalFinancialInformation" id="txtParentsAdditionalFinancialInformation" size="5" maxlength="7" style="background-color:#A3A3A3;" readonly value="<?php echo $parentsAdditionalFinancialInformation; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>U.S. Income Tax Paid (Form 1040, Line 60)</td>
		<td align="right" valign="top">$<input type="text" name="txtParentsIncomeTax" id="txtParentsIncomeTax" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsIncomeTax; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Cash, Savings, and Checking</td>
		<td align="right" valign="top">$<input type="text" name="txtParentsCashSavingsChecking" id="txtParentsCashSavingsChecking" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsCashSavingsChecking; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Current Market Value of Home <span class="crsSmall">(required to calculate Institutional EFC)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtParentsHomeCurrentMarketValue" id="txtParentsHomeCurrentMarketValue" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsHomeCurrentMarketValue; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>1<sup>st</sup> Mortgage <span class="crsSmall">(balance only)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtParentsFirstMortgage" id="txtParentsFirstMortgage" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsFirstMortgage; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>2<sup>nd</sup> Mortgage <span class="crsSmall">(balance only)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtParentsSecondMortgage" id="txtParentsSecondMortgage" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsSecondMortgage; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Home Equity Line of Credit <span class="crsSmall">(balance only)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtParentsHomeEquityLineOfCredit" id="txtParentsHomeEquityLineOfCredit" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsHomeEquityLineOfCredit; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Net Worth of Investments<br><span class="crsSmall">(include all siblings' assets and student 529 plans only;<br>DO NOT include retirement assets such as IRAs, 401(k)s, pensions, retirement/union annuities, etc.)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtParentsNetWorthInvestments" id="txtParentsNetWorthInvestments" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsNetWorthInvestments; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Net Worth Business and/or Investment Farm</td>
		<td align="right" valign="top">$<input type="text" name="txtParentsNetWorthBusinessInvestmentFarm" id="txtParentsNetWorthBusinessInvestmentFarm" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $parentsNetWorthBusinessInvestmentFarm; ?>"></td>
	</tr>
	<tr>
		<td colspan="2" class="tr2">&nbsp;</td>
	</tr>
	<tr class="tr1">
		<td colspan="2"><b>Student</b></td>
	</tr>
	<tr class="tr2">
		<td>Tax Filing Status</td>
		<td align="right" valign="top"><select name="lstStudentTaxFilingStatus">
				<option value="">Please select a status</option>
				<option value="0">Non-tax filer</option>
				<option value="1">Tax filer</option>
			</select>
		</td>
	</tr>
	<tr class="tr1">
		<td>Adjusted Gross Income (Form 1040, Line 37)</td>
		<td align="right" valign="top">$<input type="text" name="txtStudentAgi" id="txtStudentAgi" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentAgi; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Income Earned From Work (Form W-2, Box 1)</td>
		<td align="right" valign="top">$<input type="text" name="txtStudentIncomeEarned" id="txtStudentIncomeEarned" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentIncomeEarned; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Total Untaxed Income and Benefits <a class="crsBlue" href="javascript:openWorksheet('collegeChoiceEFCDataFormSW1.php',closeWorksheetSW1);">(please click here for the worksheet)</a><br><span class="crsSmall">(Use Form 1040, Lines 8 - 21;<br>include retirement plan contributions, taxable interest, dividends, business income, etc.)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtStudentTotalUntaxedIncomeBenefits" id="txtStudentTotalUntaxedIncomeBenefits" size="5" maxlength="7" style="background-color:#A3A3A3;" readonly value="<?php echo $studentTotalUntaxedIncomeBenefits; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Additional Financial Information <a class="crsBlue" href="javascript:openWorksheet('collegeChoiceEFCDataFormSW2.php',closeWorksheetSW2);">(please click here for the worksheet)</a></td>
		<td align="right" valign="top">$<input type="text" name="txtStudentAdditionalFinancialInformation" id="txtStudentAdditionalFinancialInformation" size="5" maxlength="7" style="background-color:#A3A3A3;" readonly value="<?php echo $studentAdditionalFinancialInformation; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>U.S. Income Tax Paid</td>
		<td align="right" valign="top">$<input type="text" name="txtStudentIncomeTax" id="txtStudentIncomeTax" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentIncomeTax; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Cash, Savings, and Checking</td>
		<td align="right" valign="top">$<input type="text" name="txtStudentCashSavingsChecking" id="txtStudentCashSavingsChecking" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentCashSavingsChecking; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Net Worth of Investments<br><span class="crsSmall">(include all assets EXCEPT 529 plans - see Parents' Net Worth of Investments above)</span></td>
		<td align="right" valign="top">$<input type="text" name="txtStudentNetWorthInvestments" id="txtStudentNetWorthInvestments" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentNetWorthInvestments; ?>"></td>
	</tr>
	<tr class="tr2">
		<td>Net Worth Business and/or Investment Farm</td>
		<td align="right" valign="top">$<input type="text" name="txtStudentNetWorthBusinessInvestmentFarm" id="txtStudentNetWorthBusinessInvestmentFarm" size="5" maxlength="7" onblur="validateNumber(this);" value="<?php echo $studentNetWorthBusinessInvestmentFarm; ?>"></td>
	</tr>
	<tr class="tr1">
		<td>Are you Hispanic, Native American, or African-American?<br><span class="crsSmall">A "yes" answer may affect your admission likelihood.</span><br><span class="crsTiny">This question is optional.</span></td>
		<td align="right" valign="top">
			<select name="lstStudentMinority" id="lstStudentMinority">
				<option value="N">No</option>
				<option value="Y">Yes</option>
			</select>
		</td>
	</tr>
</table>
<br>
<div style="text-align:center;"><input type="button" class="crsButton" name="btnSubmit" value=" Submit " onclick="return validateForm();"></div>

</form>

</div>

<!--</div>-->

<?php
include_once '../../commonPhp/crsNewFooter.php';
?>
