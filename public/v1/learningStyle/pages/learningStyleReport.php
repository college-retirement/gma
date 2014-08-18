<?php
session_start();

$caseId=$_GET["ID"];

include("../../commonPhp/sqlServerConnect.php");

$query="SELECT COL0002, COL0004 FROM MFAC_CLIENT_DATA2 WHERE ID=$caseId";
$rs=$sqlServerConn->execute($query);

$studentFirstName=$rs->Fields(0);
$studentLastName=$rs->Fields(1);
$studentName=$studentFirstName . " " . $studentLastName;

include("../../commonPhp/sqlServerClose.php");

include("../../commonPhp/mySqlConnect.php");

$learningStyleA=0;
$learningStyleB=0;
$learningStyleC=0;
$learningStyleD=0;
$brainHemisphereA=0;
$brainHemisphereB=0;
$brainHemisphereAB=0;

$sql="SELECT ANSWERS FROM TLEARNING_STYLE WHERE ID=$caseId ORDER BY QUESTION";
$result=mysql_query($sql);

while($row=mysql_fetch_array($result))
{
	$answers=$row["ANSWERS"];

	if (strpos($answers, 'A')!==false)
		$learningStyleA++;
	if (strpos($answers, 'B')!==false)
		$learningStyleB++;
	if (strpos($answers, 'C')!==false)
		$learningStyleC++;
	if (strpos($answers, 'D')!==false)
		$learningStyleD++;
}

$sql="SELECT ANSWERS FROM TBRAIN_HEMISPHERE WHERE ID=$caseId ORDER BY QUESTION";
$result=mysql_query($sql);

while($row=mysql_fetch_array($result))
{
	$answers=$row["ANSWERS"];

	if (strpos($answers, 'AB')!==false || strpos($answers, 'BA')!==false)
		$brainHemisphereAB++;
	else
	{
		if (strpos($answers, 'A')!==false)
			$brainHemisphereA++;
		if (strpos($answers, 'B')!==false)
			$brainHemisphereB++;
	}
}

include("../../commonPhp/mySqlClose.php");

if (($learningStyleA==0 && $learningStyleB==0 && $learningStyleC==0 && $learningStyleD==0) || ($brainHemisphereAB==0 && $brainHemisphereA==0 && $brainHemisphereB==0))
{
	if ($learningStyleA==0 && $learningStyleB==0 && $learningStyleC==0 && $learningStyleD==0 && $brainHemisphereAB==0 && $brainHemisphereA==0 && $brainHemisphereB==0)
		$urlString="missing=3";
	else if ($learningStyleA==0 && $learningStyleB==0 && $learningStyleC==0 && $learningStyleD==0)
		$urlString="missing=1";
	else
		$urlString="missing=2";

	header("location:noLearningStyleReport.php?".$urlString);
}	

$learningStylePreference="";
$learningBrain="";
$learningStyleMax=max($learningStyleA, $learningStyleB, $learningStyleC, $learningStyleD);

if ($learningStyleA==$learningStyleMax)
{
	$learningStylePreference.="Visual, ";
	$learningBrain.="V";
}
if ($learningStyleB==$learningStyleMax)
{
	$learningStylePreference.="Auditory, ";
	$learningBrain.="A";
}
if ($learningStyleC==$learningStyleMax)
{
	$learningStylePreference.="Tactile, ";
	$learningBrain.="T";
}
if ($learningStyleD==$learningStyleMax)
{
	$learningStylePreference.="Kinesthetic, ";
	$learningBrain.="K";
}

$learningStylePreference=substr($learningStylePreference,0,(strlen($learningStylePreference)-2));

$brainHemispherePreference="";
$brainHemisphereMax=max($brainHemisphereAB, $brainHemisphereA, $brainHemisphereB);

if ($brainHemisphereAB==$brainHemisphereMax)
{
	$brainHemispherePreference="Integrated";
	$learningBrain.="I";
}
if ($brainHemisphereA==$brainHemisphereMax)
{
	$brainHemispherePreference="Left Hemisphere";
	$learningBrain.="L";
}
if ($brainHemisphereB==$brainHemisphereMax)
{
	$brainHemispherePreference="Right Hemisphere";
	$learningBrain.="R";
}
if (abs($brainHemisphereA-$brainHemisphereB)<=4)
{
	$brainHemispherePreference="Mixed";
	$learningBrain.="M";
}

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>

<head>

<link rel="stylesheet" type="text/css" href="crs.css">

<title>College & Retirement Solutions - Learning Style and Brain Hemispheric Preference Test</title>

<script language="JavaScript" type="text/javascript">
<!--

-->
</script>

</head>

<body>

<div id="crsWrapper">

<div id="crsContent">

<table width="100%" border="0">
	<tr>
		<td class="crsLarge" align="left" valign="top">Learning Style and<br>Brain Hemispheric<br>Preference Assessments</td>
		<td align="right" valign="top" class="crsSmall"><img src="../../jbcgnew/images/logo.gif" width="128" height="74"></td>
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
<br><br>
<div class="crsLarge" style="text-align:center">College & Retirement Solutions<br><br>Learning Style Report for<br><u><?php echo $studentName; ?></u>
<br><br>
<img src="../images/brainHemisphere.png" border="0">
</div>
<br><br>
<table width="100%" border="0">
	<tr>
		<td width="50%" align="center" valign="top" class="crsLarge">
			<u>Learning Style Preference</u>
			<br>
			<?php echo $learningStylePreference; ?>
		</td>
		<td width="50%" align="center" valign="top" class="crsLarge">
			<u>Brain Hemisphere Preference</u>
			<br>
			<?php echo $brainHemispherePreference; ?>
		</td>
	</tr>
	<tr>
		<td align="center" valign="top">
			Visual = <?php echo $learningStyleA; ?>
			<br>
			Auditory = <?php echo $learningStyleB; ?>
			<br>
			Tactile = <?php echo $learningStyleC; ?>
			<br>
			Kinesthetic = <?php echo $learningStyleD; ?>
		</td>
		<td align="center" valign="top">
			Left = <?php echo $brainHemisphereA; ?>
			<br>
			Right = <?php echo $brainHemisphereB; ?>
			<br>
			Integrated = <?php echo $brainHemisphereAB; ?>
		</td>
	</tr>
</table>
<?php
if (strpos($learningBrain, 'M')!==false)
	include("mixedBrain.php");

if (strpos($learningBrain, 'V')!==false && (strpos($learningBrain, 'L')!==false || strpos($learningBrain, 'I')!==false))
	include("visualLeftBrain.php");
if (strpos($learningBrain, 'V')!==false && (strpos($learningBrain, 'R')!==false || strpos($learningBrain, 'I')!==false))
	include("visualRightBrain.php");
if (strpos($learningBrain, 'V')!==false)
	include("visualTips.php");
	
if (strpos($learningBrain, 'A')!==false && (strpos($learningBrain, 'L')!==false || strpos($learningBrain, 'I')!==false))
	include("auditoryLeftBrain.php");
if (strpos($learningBrain, 'A')!==false && (strpos($learningBrain, 'R')!==false || strpos($learningBrain, 'I')!==false))
	include("auditoryRightBrain.php");
if (strpos($learningBrain, 'A')!==false)
	include("auditoryTips.php");
	
if (strpos($learningBrain, 'T')!==false && (strpos($learningBrain, 'L')!==false || strpos($learningBrain, 'I')!==false))
	include("tactileLeftBrain.php");
if (strpos($learningBrain, 'T')!==false && (strpos($learningBrain, 'R')!==false || strpos($learningBrain, 'I')!==false))
	include("tactileRightBrain.php");
if (strpos($learningBrain, 'T')!==false)
	include("tactileTips.php");

if (strpos($learningBrain, 'K')!==false && (strpos($learningBrain, 'L')!==false || strpos($learningBrain, 'I')!==false))
	include("kinestheticLeftBrain.php");
if (strpos($learningBrain, 'K')!==false && (strpos($learningBrain, 'R')!==false || strpos($learningBrain, 'I')!==false))
	include("kinestheticRightBrain.php");
if (strpos($learningBrain, 'K')!==false)
	include("kinestheticTips.php");
?>
</div>

</div>

</body>

</html>