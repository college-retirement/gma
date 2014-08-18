<?php
//session_start();
$outOfStatePctg=$_POST["txtOutOfStatePercentIncrease"];
$minorityPctg=$_POST["txtMinorityPercentIncrease"];
$imAppealsPctg=$_POST["txtImAppealsPctg"];
$safetyPctg=$_POST["txtSafetyPctg"];
$targetPctg=$_POST["txtTargetPctg"];
$possiblePctg=$_POST["txtPossiblePctg"];
$reachPctg=$_POST["txtReachPctg"];
$testPctg=$_POST["txtTestPctg"];
$gpaPctg=$_POST["txtGpaPctg"];
$scorePctgForAid1=$_POST["txtScorePctgForAid1"];
$scorePctgForAid2=$_POST["txtScorePctgForAid2"];

include("../../commonPhp/mySqlConnect.php");

$sql="UPDATE TCOLLEGECHOICE_CONFIG SET IM_APPEALS_PCTG=$imAppealsPctg, OUT_OF_STATE_PCT_INCREASE=$outOfStatePctg, MINORITY_PCT_INCREASE=$minorityPctg, SAFETY_PCTG=$safetyPctg, TARGET_PCTG=$targetPctg, POSSIBLE_PCTG=$possiblePctg, REACH_PCTG=$reachPctg, TEST_PCTG=$testPctg, GPA_PCTG=$gpaPctg, SCORE_PCTG_FOR_AID1=$scorePctgForAid1, SCORE_PCTG_FOR_AID2=$scorePctgForAid2";
$result=mysql_query($sql);

if ($result)
{
	include("../../commonPhp/mySqlClose.php");
	header("location:collegeChoiceAdminConsole.php?update=1");
}
else
{
	//echo "error in updateCollege.php INSERT/UPDATE TCOLLEGE: "  . mysql_error();
	echo "error in collegeChoiceUpdatePercentages.php UPDATE TCOLLEGECHOICE_CONFIG: "  . mysql_error() . "<br><br>SQL:<br>" . $sql;
	include("../../commonPhp/mySqlClose.php");
}
?>
