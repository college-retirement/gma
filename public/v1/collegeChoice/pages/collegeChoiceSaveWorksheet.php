<?php
session_start();

$username=$_SESSION["username"];
$userid=$_SESSION["userid"];

function checkNull($theValue)
{
	return ($theValue==null ? 0 : $theValue);
}

include("../../commonPhp/mySqlConnect.php");

$whichWorksheet=$_POST["hidWorksheetName"];

switch($whichWorksheet)
{
	case "PW1":
		$parentsPaymentsTaxDeferredPensionsSavings=checkNull($_POST["txtParentsTaxDeferredPensionsSavings"]);
		$parentsDeductibleIraKeoghPayments=checkNull($_POST["txtParentsDeductibleIraKeoghPayments"]);
		$parentsChildSupportReceived=checkNull($_POST["txtParentsChildSupportReceived"]);
		$parentsTaxExemptInterestIncome=checkNull($_POST["txtParentsTaxExemptInterestIncome"]);
		$parentsUntaxedIraDistributions=checkNull($_POST["txtParentsUntaxedIraDistributions"]);
		$parentsUntaxedPensions=checkNull($_POST["txtParentsUntaxedPensions"]);
		$parentsHousingFoodLivingAllowance=checkNull($_POST["txtParentsHousingFoodLivingAllowance"]);
		$parentsNonEducationBenefits=checkNull($_POST["txtParentsNonEducationBenefits"]);
		$parentsOtherUntaxedIncome=checkNull($_POST["txtParentsOtherUntaxedIncome"]);
//		$parentsTotalUntaxedIncomeBenefits=checkNull($_POST["txtParentsTotalUntaxedIncomeBenefits"]);
		$total=checkNull($_POST["txtParentsTotalUntaxedIncomeBenefits"]);
		
		$sql="SELECT * FROM TCOLLEGECHOICE_PW1 WHERE USER_ID=$userid";
		$result=mysql_query($sql);
		$count=mysql_num_rows($result);

		if ($count==1)
			$sql="UPDATE TCOLLEGECHOICE_PW1 SET TAX_DEFERRED_PENSIONS=$parentsPaymentsTaxDeferredPensionsSavings, DEDUCTIBLE_PAYMENTS=$parentsDeductibleIraKeoghPayments, CHILD_SUPPORT_RECEIVED=$parentsChildSupportReceived, EXEMPT_INTEREST_INCOME=$parentsTaxExemptInterestIncome, UNTAXED_IRA_DIST=$parentsUntaxedIraDistributions, UNTAXED_PENSIONS=$parentsUntaxedPensions, ALLOWANCES=$parentsHousingFoodLivingAllowance, NON_EDUCATIONAL_BENEFITS=$parentsNonEducationBenefits, OTHER_UNTAXED_INCOME=$parentsOtherUntaxedIncome, USER_UPDATED='$username', DATE_UPDATED=NOW() WHERE USER_ID=$userid";
		else
			$sql="INSERT INTO TCOLLEGECHOICE_PW1 (USER_ID, TAX_DEFERRED_PENSIONS, DEDUCTIBLE_PAYMENTS, CHILD_SUPPORT_RECEIVED, EXEMPT_INTEREST_INCOME, UNTAXED_IRA_DIST, UNTAXED_PENSIONS, ALLOWANCES, NON_EDUCATIONAL_BENEFITS, OTHER_UNTAXED_INCOME, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($userid, $parentsPaymentsTaxDeferredPensionsSavings, $parentsDeductibleIraKeoghPayments, $parentsChildSupportReceived, $parentsTaxExemptInterestIncome, $parentsUntaxedIraDistributions, $parentsUntaxedPensions, $parentsHousingFoodLivingAllowance, $parentsNonEducationBenefits, $parentsOtherUntaxedIncome, '$username', NOW(), '$username', NOW())";
		
		break;

	case "PW2":
		$parentsEducationCredits=checkNull($_POST["txtParentsEducationCredits"]);
		$parentsChildSupportPaid=checkNull($_POST["txtParentsChildSupportPaid"]);
		$parentsWorkStudyEarnings=checkNull($_POST["txtParentsWorkStudyEarnings"]);
		$parentsGrantScholarshipAid=checkNull($_POST["txtParentsGrantScholarshipAid"]);
		$parentsCombatPay=checkNull($_POST["txtParentsCombatPay"]);
		$parentsCooperativeEducationEarnings=checkNull($_POST["txtParentsCooperativeEducationEarnings"]);
//		$parentsAdditionalFinancialInformation=checkNull($_POST["txtParentsAdditionalFinancialInformation"]);
		$total=checkNull($_POST["txtParentsAdditionalFinancialInformation"]);
		
		$sql="SELECT * FROM TCOLLEGECHOICE_PW2 WHERE USER_ID=$userid";
		$result=mysql_query($sql);
		$count=mysql_num_rows($result);

		if ($count==1)
			$sql="UPDATE TCOLLEGECHOICE_PW2 SET EDUCATION_CREDITS=$parentsEducationCredits, CHILD_SUPPORT_PAID=$parentsChildSupportPaid, WORK_STUDY_EARNINGS=$parentsWorkStudyEarnings, GRANT_SCHOLARSHIP_AID=$parentsGrantScholarshipAid, COMBAT_PAY=$parentsCombatPay, COOPERATIVE_EDUCATION_EARNINGS=$parentsCooperativeEducationEarnings, USER_UPDATED='$username', DATE_UPDATED=NOW() WHERE USER_ID=$userid";
		else
			$sql="INSERT INTO TCOLLEGECHOICE_PW2 (USER_ID, EDUCATION_CREDITS, CHILD_SUPPORT_PAID, WORK_STUDY_EARNINGS, GRANT_SCHOLARSHIP_AID, COMBAT_PAY, COOPERATIVE_EDUCATION_EARNINGS, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($userid, $parentsEducationCredits, $parentsChildSupportPaid, $parentsWorkStudyEarnings, $parentsGrantScholarshipAid, $parentsCombatPay, $parentsCooperativeEducationEarnings, '$username', NOW(), '$username', NOW())";

		break;

	case "SW1":
		$studentPaymentsTaxDeferredPensionsSavings=checkNull($_POST["txtStudentTaxDeferredPensionsSavings"]);
		$studentDeductibleIraKeoghPayments=checkNull($_POST["txtStudentDeductibleIraKeoghPayments"]);
		$studentChildSupportReceived=checkNull($_POST["txtStudentChildSupportReceived"]);
		$studentTaxExemptInterestIncome=checkNull($_POST["txtStudentTaxExemptInterestIncome"]);
		$studentUntaxedIraDistributions=checkNull($_POST["txtStudentUntaxedIraDistributions"]);
		$studentUntaxedPensions=checkNull($_POST["txtStudentUntaxedPensions"]);
		$studentHousingFoodLivingAllowance=checkNull($_POST["txtStudentHousingFoodLivingAllowance"]);
		$studentNonEducationBenefits=checkNull($_POST["txtStudentNonEducationBenefits"]);
		$studentOtherUntaxedIncome=checkNull($_POST["txtStudentOtherUntaxedIncome"]);
		$studentOtherNonReportedMoneyReceived=checkNull($_POST["txtStudentOtherNonReportedMoneyReceived"]);
//		$studentTotalUntaxedIncomeBenefits=checkNull($_POST["txtStudentTotalUntaxedIncomeBenefits"]);
		$total=checkNull($_POST["txtStudentTotalUntaxedIncomeBenefits"]);
		
		$sql="SELECT * FROM TCOLLEGECHOICE_SW1 WHERE USER_ID=$userid";
		$result=mysql_query($sql);
		$count=mysql_num_rows($result);

		if ($count==1)
			$sql="UPDATE TCOLLEGECHOICE_SW1 SET TAX_DEFERRED_PENSIONS=$studentPaymentsTaxDeferredPensionsSavings, DEDUCTIBLE_PAYMENTS=$studentDeductibleIraKeoghPayments, CHILD_SUPPORT_RECEIVED=$studentChildSupportReceived, EXEMPT_INTEREST_INCOME=$studentTaxExemptInterestIncome, UNTAXED_IRA_DIST=$studentUntaxedIraDistributions, UNTAXED_PENSIONS=$studentUntaxedPensions, ALLOWANCES=$studentHousingFoodLivingAllowance, NON_EDUCATIONAL_BENEFITS=$studentNonEducationBenefits, OTHER_UNTAXED_INCOME=$studentOtherUntaxedIncome, OTHER_NON_REPORTED_MONEY=$studentOtherNonReportedMoneyReceived, USER_UPDATED='$username', DATE_UPDATED=NOW() WHERE USER_ID=$userid";
		else
			$sql="INSERT INTO TCOLLEGECHOICE_SW1 (USER_ID, TAX_DEFERRED_PENSIONS, DEDUCTIBLE_PAYMENTS, CHILD_SUPPORT_RECEIVED, EXEMPT_INTEREST_INCOME, UNTAXED_IRA_DIST, UNTAXED_PENSIONS, ALLOWANCES, NON_EDUCATIONAL_BENEFITS, OTHER_UNTAXED_INCOME, OTHER_NON_REPORTED_MONEY, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($userid, $studentPaymentsTaxDeferredPensionsSavings, $studentDeductibleIraKeoghPayments, $studentChildSupportReceived, $studentTaxExemptInterestIncome, $studentUntaxedIraDistributions, $studentUntaxedPensions, $studentHousingFoodLivingAllowance, $studentNonEducationBenefits, $studentOtherUntaxedIncome, $studentOtherNonReportedMoneyReceived, '$username', NOW(), '$username', NOW())";

		break;

	case "SW2":
		$studentEducationCredits=checkNull($_POST["txtStudentEducationCredits"]);
		$studentChildSupportPaid=checkNull($_POST["txtStudentChildSupportPaid"]);
		$studentWorkStudyEarnings=checkNull($_POST["txtStudentWorkStudyEarnings"]);
		$studentGrantScholarshipAid=checkNull($_POST["txtStudentGrantScholarshipAid"]);
		$studentCombatPay=checkNull($_POST["txtStudentCombatPay"]);
		$studentCooperativeEducationEarnings=checkNull($_POST["txtStudentCooperativeEducationEarnings"]);
//		$studentAdditionalFinancialInformation=checkNull($_POST["txtStudentAdditionalFinancialInformation"]);
		$total=checkNull($_POST["txtStudentAdditionalFinancialInformation"]);
		
		$sql="SELECT * FROM TCOLLEGECHOICE_SW2 WHERE USER_ID=$userid";
		$result=mysql_query($sql);
		$count=mysql_num_rows($result);

		if ($count==1)
			$sql="UPDATE TCOLLEGECHOICE_SW2 SET EDUCATION_CREDITS=$studentEducationCredits, CHILD_SUPPORT_PAID=$studentChildSupportPaid, WORK_STUDY_EARNINGS=$studentWorkStudyEarnings, GRANT_SCHOLARSHIP_AID=$studentGrantScholarshipAid, COMBAT_PAY=$studentCombatPay, COOPERATIVE_EDUCATION_EARNINGS=$studentCooperativeEducationEarnings, USER_UPDATED='$username', DATE_UPDATED=NOW() WHERE USER_ID=$userid";
		else
			$sql="INSERT INTO TCOLLEGECHOICE_SW2 (USER_ID, EDUCATION_CREDITS, CHILD_SUPPORT_PAID, WORK_STUDY_EARNINGS, GRANT_SCHOLARSHIP_AID, COMBAT_PAY, COOPERATIVE_EDUCATION_EARNINGS, USER_CREATED, DATE_CREATED, USER_UPDATED, DATE_UPDATED) VALUES ($userid, $studentEducationCredits, $studentChildSupportPaid, $studentWorkStudyEarnings, $studentGrantScholarshipAid, $studentCombatPay, $studentCooperativeEducationEarnings, '$username', NOW(), '$username', NOW())";

		break;
}

if (mysql_query($sql))
{
	$browser=$_SERVER['HTTP_USER_AGENT'];

	if (strpos(strtolower($browser), 'firefox')!==false)
		$javascriptCode="this.close();";
	else
		$javascriptCode="var returnVal=$total;\nwindow.top.main.hidePopWin(true);";

	echo "<html>\n<head>\n<script language=\"JavaScript\" type=\"text/javascript\">\n$javascriptCode\n</script>\n</head>\n<body>\n</body>\n</html>";
}
else
{
	include("../../commonPhp/mySqlClose.php");
	echo "error in collegeChoiceSaveWorksheet.php<br><br>worksheet: $whichWorksheet<br><br>$sql<br><br>" . mysql_error() . "<br><br>";
}

include("../../commonPhp/mySqlClose.php");
?>