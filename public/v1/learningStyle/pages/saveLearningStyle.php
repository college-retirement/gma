<?php
session_start();
include("../../commonPhp/mySqlConnect.php");

$caseId=$_SESSION["caseId"];
$numQuestions=17;

$sql="SELECT * FROM TLEARNING_STYLE WHERE ID=$caseId";
$result=mysql_query($sql);
$count=mysql_num_rows($result);

for ($i=1; $i<=$numQuestions; $i++)
{
	$answers=$_POST["chkLst".$i];
	$answersForDb="";

	for ($j=0; $j<count($answers); $j++)
	{
		$answersForDb.=$answers[$j];
//echo "$i=$answers[$j]<br>";
	}

	if ($count>0)
		$sql="UPDATE TLEARNING_STYLE SET ANSWERS='$answersForDb' WHERE ID=$caseId AND QUESTION=$i";
	else
		$sql="INSERT INTO TLEARNING_STYLE VALUES ('$caseId', '$i', '$answersForDb')";

	$result=mysql_query($sql);

	if (!$result)
		echo "error in scoreLearningStyle.php<br><br>$sql<br><br>" . mysql_error() . "<br><br><br><br>";

}
include("../../commonPhp/mySqlClose.php");

header("location:brainHemispherePref.php");
?>
