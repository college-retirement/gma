<?php
session_start();
die('test');
include("../../commonPhp/mySqlConnect.php");

$caseId=$_SESSION["caseId"];

$sql="SELECT * FROM TBRAIN_HEMISPHERE WHERE ID=$caseId ORDER BY QUESTION";
$result=mysql_query($sql);
$count=mysql_num_rows($result);

if ($count>0)
{
	$i=1;
	while ($row=mysql_fetch_array($result))
	{
		$answers[$i]=$row["ANSWERS"];
		$i++;
	}	
}

include("../../commonPhp/mySqlClose.php");
include_once '../../commonPhp/csrNewHeader.php';
?>


<link rel="stylesheet" type="text/css" href="crs.css">

<script language="JavaScript" type="text/javascript">
<!--
function validateForm()
{
	var bool=true;

	return bool;
}
-->
</script>





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

<form name="frmBrainHemisphere" method="POST" action="saveBrainHemisphere.php" onsubmit="return validateForm();">

<div class="crsLarge" style="text-align:center">Brain Hemispheric Preference Assessment</div>
<br>
In this section you will be taking the brain hemispheric preference assessment to find out which brain hemisphere you prefer to use for understanding and storing new information. Just as in the learning style preference assessment, you will be selecting the choice that is most natural and comfortable for you. If you are absolutely sure that both answers equally describe you, then select both. Make sure you do not choose both to take the easy way out and rush through the assessment. If you have to choose both answers, do it because you have given it full consideration and are certain that both describe you equally well.
<br><br><hr width="90%" style="text-align:center;"><br><br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">1.  Close your eyes.  See red.  What do you see?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp1[]" id="chkBhp1[]" value="A" <?php if (strpos($answers[1], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">the letters "r-e-d" or nothing because you could not visualize it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp1[]" id="chkBhp1[]" value="B" <?php if (strpos($answers[1], 'B')!==false) echo "checked" ?>></td>
		<td>the color red or a red object</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">2. Close your eyes.  See three.  What do you see?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp2[]" id="chkBhp2[]" value="B" <?php if (strpos($answers[2], 'B')!==false) echo "checked" ?>></td>
		<td>three animals, people, or objects</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp2[]" id="chkBhp2[]" value="A" <?php if (strpos($answers[2], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">the letters "t-h-r-e-e", the number 3, or perhaps nothing because you could not visualize it</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">3.  If you play music or sing:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp3[]" id="chkBhp3[]" value="B" <?php if (strpos($answers[3], 'B')!==false) echo "checked" ?>></td>
		<td>you can play by ear if you need to</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp3[]" id="chkBhp3[]" value="A" <?php if (strpos($answers[3], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you cannot play by ear and must read notes</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">4.  When you put something together:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp4[]" id="chkBhp4[]" value="B" <?php if (strpos($answers[4], 'B')!==false) echo "checked" ?>></td>
		<td>you can use pictures and diagrams or just jump in and do it without using directions</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp4[]" id="chkBhp4[]" value="A" <?php if (strpos($answers[4], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you need to read and follow written directions</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">5.  When someone is talking to you:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp5[]" id="chkBhp5[]" value="A" <?php if (strpos($answers[5], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you pay more attention to words and tune out their non-verbal communication</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp5[]" id="chkBhp5[]" value="B" <?php if (strpos($answers[5], 'B')!==false) echo "checked" ?>></td>
		<td>you pay more attention to nonverbal communication, such as facial expressions, body language, and tones of voice</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">6.  You are better at:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp6[]" id="chkBhp6[]" value="B" <?php if (strpos($answers[6], 'B')!==false) echo "checked" ?>></td>
		<td>working with color, shapes, pictures, and objects</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp6[]" id="chkBhp6[]" value="A" <?php if (strpos($answers[6], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">working with letters, numbers, and words</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">7.  When you read fiction, you:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp7[]" id="chkBhp7[]" value="A" <?php if (strpos($answers[7], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">hear the words being read aloud in your head</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp7[]" id="chkBhp7[]" value="B" <?php if (strpos($answers[7], 'B')!==false) echo "checked" ?>></td>
		<td>see the book played as a movie in your head</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">8.  Which hand do you write with?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp8[]" id="chkBhp8[]" value="A" <?php if (strpos($answers[8], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">right hand</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp8[]" id="chkBhp8[]" value="B" <?php if (strpos($answers[8], 'B')!==false) echo "checked" ?>></td>
		<td>left hand</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">9.  When doing a math problem, which way is easiest for you?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp9[]" id="chkBhp9[]" value="B" <?php if (strpos($answers[9], 'B')!==false) echo "checked" ?>></td>
		<td>to draw it out, work it out using hands-on materials, or use your fingers</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp9[]" id="chkBhp9[]" value="A" <?php if (strpos($answers[9], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">to work it out in the form of numbers and words</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">10.  You prefer to:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp10[]" id="chkBhp10[]" value="A" <?php if (strpos($answers[10], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">talk about your ideas</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp10[]" id="chkBhp10[]" value="B" <?php if (strpos($answers[10], 'B')!==false) echo "checked" ?>></td>
		<td>do something with real objects</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">11.  How do you keep your room or your desk?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp11[]" id="chkBhp11[]" value="A" <?php if (strpos($answers[11], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">neat and organized</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp11[]" id="chkBhp11[]" value="B" <?php if (strpos($answers[11], 'B')!==false) echo "checked" ?>></td>
		<td>messy or disorganized to others, but you know where everything is</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">12.  If no one is telling you what to do, which is more like you?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp12[]" id="chkBhp12[]" value="A" <?php if (strpos($answers[12], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you do things on a schedule and stick to it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp12[]" id="chkBhp12[]" value="B" <?php if (strpos($answers[12], 'B')!==false) echo "checked" ?>></td>
		<td>you do things at the last minute or in your own time, and/or want to keep working even when time is up</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">13.  If no one were telling you what to do:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp13[]" id="chkBhp13[]" value="B" <?php if (strpos($answers[13], 'B')!==false) echo "checked" ?>></td>
		<td>you would often be late</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp13[]" id="chkBhp13[]" value="A" <?php if (strpos($answers[13], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you would usually be on time</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">14.  You like to read a book or magazine:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp14[]" id="chkBhp14[]" value="B" <?php if (strpos($answers[14], 'B')!==false) echo "checked" ?>></td>
		<td>from back to front or by skipping around</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp14[]" id="chkBhp14[]" value="A" <?php if (strpos($answers[14], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">from front to back</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">15.  Which describes you best?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp15[]" id="chkBhp15[]" value="A" <?php if (strpos($answers[15], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you like to tell and hear about events with all the details told in order</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp15[]" id="chkBhp15[]" value="B" <?php if (strpos($answers[15], 'B')!==false) echo "checked" ?>></td>
		<td>you like to tell the main point of an event, and when others are telling you about an event you get restless if they do not get to the main idea quickly</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">16.  When you do a puzzle or project, you:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp16[]" id="chkBhp16[]" value="B" <?php if (strpos($answers[16], 'B')!==false) echo "checked" ?>></td>
		<td>need to see the finished product before you can do it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp16[]" id="chkBhp16[]" value="A" <?php if (strpos($answers[16], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">do it well without seeing the finished product first</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">17. Which method of organizing notes do you like best:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp17[]" id="chkBhp17[]" value="A" <?php if (strpos($answers[17], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">outlining or listing things in order</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp17[]" id="chkBhp17[]" value="B" <?php if (strpos($answers[17], 'B')!==false) echo "checked" ?>></td>
		<td>making a mind map, or web, with connected circles</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">18.  When you are given instructions to make something, if given the choice, you:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp18[]" id="chkBhp18[]" value="B" <?php if (strpos($answers[18], 'B')!==false) echo "checked" ?>></td>
		<td>prefer to think of new ways to do it and try it a different way</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp18[]" id="chkBhp18[]" value="A" <?php if (strpos($answers[18], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">prefer to follow the instructions</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">19.  When you sit at a desk, you:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp19[]" id="chkBhp19[]" value="A" <?php if (strpos($answers[19], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">sit up straight</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp19[]" id="chkBhp19[]" value="B" <?php if (strpos($answers[19], 'B')!==false) echo "checked" ?>></td>
		<td>slouch or lean over your desk, lean back in your chair to be comfortable, or stay partly out of the seat</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">20.  Which describes you best?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp20[]" id="chkBhp20[]" value="A" <?php if (strpos($answers[20], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you spell words and write numbers correctly most of the time</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp20[]" id="chkBhp20[]" value="B" <?php if (strpos($answers[20], 'B')!==false) echo "checked" ?>></td>
		<td>you sometimes mix up letters or numbers or write some words, letters, or numbers in reverse order or backward</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">21.  Which is more like you?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp21[]" id="chkBhp21[]" value="B" <?php if (strpos($answers[21], 'B')!==false) echo "checked" ?>></td>
		<td>you sometimes mix up words in a sentence or say a different one than what you mean, but you know what you mean</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp21[]" id="chkBhp21[]" value="A" <?php if (strpos($answers[21], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you speak words correctly and in the right order</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">22.  You usually:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp22[]" id="chkBhp22[]" value="B" <?php if (strpos($answers[22], 'B')!==false) echo "checked" ?>></td>
		<td>change the topic to something else you thought of related to it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp22[]" id="chkBhp22[]" value="A" <?php if (strpos($answers[22], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">stick to a topic when talking to people</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">23.  You like to:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp23[]" id="chkBhp23[]" value="A" <?php if (strpos($answers[23], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">make plans and stick to them</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp23[]" id="chkBhp23[]" value="B" <?php if (strpos($answers[23], 'B')!==false) echo "checked" ?>></td>
		<td>decide things at the last minute, go with the flow, or do what you feel like at the moment</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">24.  You like to do:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp24[]" id="chkBhp24[]" value="A" <?php if (strpos($answers[24], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">art projects in which you follow directions or step-by-step instructions</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp24[]" id="chkBhp24[]" value="B" <?php if (strpos($answers[24], 'B')!==false) echo "checked" ?>></td>
		<td>art projects that give you freedom to create what you want</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">25.  You like:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp25[]" id="chkBhp25[]" value="A" <?php if (strpos($answers[25], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">to play music or sing based on written music or what you learned from others</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp25[]" id="chkBhp25[]" value="B" <?php if (strpos($answers[25], 'B')!==false) echo "checked" ?>></td>
		<td>create your own music, tunes, or songs</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">26.  You like:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp26[]" id="chkBhp26[]" value="B" <?php if (strpos($answers[26], 'B')!==false) echo "checked" ?>></td>
		<td>sports that allow you to move freely without rules</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp26[]" id="chkBhp26[]" value="A" <?php if (strpos($answers[26], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">sports that have step-by-step instructions or rules</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">27.  You like to:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp27[]" id="chkBhp27[]" value="A" <?php if (strpos($answers[27], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">work step-by-step, in order, until you get to the end product</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp27[]" id="chkBhp27[]" value="B" <?php if (strpos($answers[27], 'B')!==false) echo "checked" ?>></td>
		<td>see the whole picture or end product first and then go back and work the steps</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">28.  Which describes you the best?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp28[]" id="chkBhp28[]" value="A" <?php if (strpos($answers[28], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you think about facts and events that really happened</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp28[]" id="chkBhp28[]" value="B" <?php if (strpos($answers[28], 'B')!==false) echo "checked" ?>></td>
		<td>you think in an imaginative and inventive way about what could happen or what could be created in the future</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">29.  You know things because:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp29[]" id="chkBhp29[]" value="B" <?php if (strpos($answers[29], 'B')!==false) echo "checked" ?>></td>
		<td>you know them intuitively, and you can't explain how or why you know</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp29[]" id="chkBhp29[]" value="A" <?php if (strpos($answers[29], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">you learn from the world, other people, or reading</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">30.  You like to:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp30[]" id="chkBhp30[]" value="B" <?php if (strpos($answers[30], 'B')!==false) echo "checked" ?>></td>
		<td>imagine what could be</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp30[]" id="chkBhp30[]" value="A" <?php if (strpos($answers[30], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">stick to facts</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">31.  You usually:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp31[]" id="chkBhp31[]" value="B" <?php if (strpos($answers[31], 'B')!==false) echo "checked" ?>></td>
		<td>lose track of time</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp31[]" id="chkBhp31[]" value="A" <?php if (strpos($answers[31], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">keep track of time</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">32.  You are:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp32[]" id="chkBhp32[]" value="B" <?php if (strpos($answers[32], 'B')!==false) echo "checked" ?>></td>
		<td>not good at reading nonverbal communication</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp32[]" id="chkBhp32[]" value="A" <?php if (strpos($answers[32], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">good at reading nonverbal communication</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">33.  You are:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp33[]" id="chkBhp33[]" value="A" <?php if (strpos($answers[33], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">better at directions given verbally or in writing</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp33[]" id="chkBhp33[]" value="B" <?php if (strpos($answers[33], 'B')!==false) echo "checked" ?>></td>
		<td>better at directions given with pictures or maps</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">34.  You are better at:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp34[]" id="chkBhp34[]" value="B" <?php if (strpos($answers[34], 'B')!==false) echo "checked" ?>></td>
		<td>inventing or producing what is new and never existed</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp34[]" id="chkBhp34[]" value="A" <?php if (strpos($answers[34], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">being creative with existing materials and putting them together in a new way</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">35.  You usually work on:</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp35[]" id="chkBhp35[]" value="A" <?php if (strpos($answers[35], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">one project at a time, in order</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp35[]" id="chkBhp35[]" value="B" <?php if (strpos($answers[35], 'B')!==false) echo "checked" ?>></td>
		<td>many projects at the same time</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">36.  In which of the following environments would you prefer to work?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp36[]" id="chkBhp36[]" value="B" <?php if (strpos($answers[36], 'B')!==false) echo "checked" ?>></td>
		<td>an unstructured environment where you have freedom of choice and movement to work on what you want, where you can be as creative and imaginative as you want, keep your belongings any way you want, and do as many projects as you wish simultaneously, without any set time schedule</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkBhp36[]" id="chkBhp36[]" value="A" <?php if (strpos($answers[36], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">a structured environment where everything is orderly, someone is telling you what to do, a time schedule is kept, and you do one project at a time, step-by-step, and in order</td>
	</tr>
</table>
<br>
<div style="text-align:center;"><input type="button" class="crsButton" name="btnSubmit" value=" Submit " onclick="document.frmBrainHemisphere.submit();"></div>
<input type="hidden" name="hidId" value="<?php echo $id ?>">
</form>

</div>

</div>

<?php
   include_once '../../commonPhp/crsNewFooter.php';
?>