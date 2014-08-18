<?php
session_start();
include("../../commonPhp/mySqlConnect.php");

$caseId=$_SESSION["caseId"];
$numQuestions=36;

$sql="SELECT * FROM TBRAIN_HEMISPHERE WHERE ID=$caseId";
$result=mysql_query($sql);
$count=mysql_num_rows($result);

for ($i=1; $i<=$numQuestions; $i++)
{
	$answers=$_POST["chkBhp".$i];
	$answersForDb="";

	for ($j=0; $j<count($answers); $j++)
	{
		$answersForDb.=$answers[$j];
//echo "$i=$answers[$j]<br>";
	}

	if ($count>0)
		$sql="UPDATE TBRAIN_HEMISPHERE SET ANSWERS='$answersForDb' WHERE ID=$caseId AND QUESTION=$i";
	else
		$sql="INSERT INTO TBRAIN_HEMISPHERE VALUES ('$caseId', '$i', '$answersForDb')";

	$result=mysql_query($sql);

	if (!$result)
		echo "error in scoreBrainHemisphere.php<br><br>$sql<br><br>" . mysql_error() . "<br><br><br><br>";

}
include("../../commonPhp/mySqlClose.php");

header("location:learningStyleSubmitted.php");
?>
