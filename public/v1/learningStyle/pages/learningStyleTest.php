<?php
session_start();

$id=$_GET["ID"];
$random=substr($id,0,8);
$caseId=substr($id,8,strlen($id));
$_SESSION["ID"]=$id;
$_SESSION["random"]=$random;
$_SESSION["caseId"]=$caseId;

include("../../commonPhp/sqlServerConnect.php");

$query="SELECT RANDOM FROM USERS WHERE USERCASE=$caseId"; 
$rs=$sqlServerConn->execute($query);

$validateRandom=$rs->Fields(0);

if ($random!=$validateRandom)
	header("location:invalidId.php?random=$random&id=$caseId");

$query="SELECT APPOINTMENT FROM APPOINTMENTS WHERE CLAIMID=$caseId AND STATUS='Y'";
//$query="SELECT APPOINTMENT FROM APPOINTMENTS WHERE CLAIMID=$caseId";
$rs=$sqlServerConn->execute($query);

$appointmentDate=$rs->Fields(0);
//$_SESSION["appointmentDate"]=substr($appointmentDate,0,(strlen($appointmentDate)-6)) . " " . substr($appointmentDate,(strlen($appointmentDate)-2),strlen($appointmentDate));

include("../../commonPhp/sqlServerClose.php");

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TLEARNING_STYLE WHERE ID=$caseId ORDER BY QUESTION";
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
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html>

<head>

<link rel="stylesheet" type="text/css" href="crs.css">

<title>College & Retirement Solutions - Learning Style and Brain Hemispheric Preference Test</title>

<script language="JavaScript" type="text/javascript">
<!--
function validateForm()
{
	var bool=true;

	return bool;
}
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

<form name="frmLearningStyle" method="POST" action="saveLearningStyle.php" onsubmit="return validateForm();">

<div class="crsLarge" style="text-align:center;">Learning Style Assessment</div>
<br>
<div style="text-align:center;font-weight:bold;">Your learning style may be the single most important key to improving your grades!</div>
<!--
In this section you will take the learning style preference assessment to find your learning style preference.  We are not going to tell you anything about the learning style preferences until after you take these quizzes because we do not want to color your answers or let you answer in a way that favors the learning style you think you are.  In order for this method to work, you have to be as accurate as possible in answering the questions to determine your learning style preference.  If you do not answer these questions accurately and the results indicate that you are a different learning style than what you really are, you will not be learning in your most effective way.  For each learning style there are different methods to use, and it would be ineffective for you to use the wrong technique.  So be as accurate as you can - as painful as it may be for some!
<br><br>
The key to answering the questions is to select answers or choices that are most natural and comfortable.  Although we may be able to behave in ways described in other choices – and we often have to do that on the job or in other situations – one choice will probably feel best to us if left to our own devices.  Just as we can force ourselves to write with our non-dominant hand, we may also force ourselves to behave in two, three, or four different ways (described in each question) depending on the circumstance.  The question to ask yourself is "Which way feels best and is the least stressful?"  It is in this spirit that you should respond to the questions.  What happens if you truly feel you can select more than one choice?  For some questions, you may know absolutely that two or three choices (or even all the choices, for some people) are equally true for you.  In that case, go ahead and select all those that equally describe you.  First try to settle on one choice, and if you are sure that there is more than one best answer, then select the others also.
-->
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Students learn in many ways, like seeing, hearing, and experiencing things first hand.  But for most students, one of these methods stands out.  A simple explanation of learning styles is this: some students remember best materials they've seen, some remember things they've heard, while others remember things they've experienced.
<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Why is this important?  Research has shown that students can perform better on tests if they change study habits to fit their own personal learning styles.  For example, visual-learning students will sometimes struggle during essay exams, because they can't recall test material that was "heard" in a lecture.  However, if the visual learner uses a visual aid when studying (like a colorful outline of test materials), he or she may retain more information.  For this type of learner, visual tools improve the ability to recall information more completely. 
<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The key to answering the following questions is to select choices that are most natural and comfortable.  What happens if you truly feel you can select more than one choice?  For some questions, you may know absolutely that two or three choices (or even all the choices, for some people) are equally true for you.  In that case, go ahead and select all those that equally describe you.  First try to settle on one choice, and if you are sure that there is more than one best answer, then select the others also.
<br><br><hr width="90%" style="text-align:center;"><br><br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">1.  When you meet a new person, what do you first notice about him or her?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst1[]" id="chkLst1[]" value="A" <?php if (strpos($answers[1], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">What he or she looks like and how he or she dresses</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst1[]" id="chkLst1[]" value="B" <?php if (strpos($answers[1], 'B')!==false) echo "checked" ?>></td>
		<td>How the person talks, what he or she says, or his or her voice</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst1[]" id="chkLst1[]" value="C" <?php if (strpos($answers[1], 'C')!==false) echo "checked" ?>></td>
		<td>How you feel about the person</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst1[]" id="chkLst1[]" value="D" <?php if (strpos($answers[1], 'D')!==false) echo "checked" ?>></td>
		<td>How the person acts or what he or she does</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">2.  Days after you meet someone new, what do you remember the most about that person?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst2[]" id="chkLst2[]" value="B" <?php if (strpos($answers[2], 'B')!==false) echo "checked" ?>></td>
		<td>The person's name<br></td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst2[]" id="chkLst2[]" value="A" <?php if (strpos($answers[2], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">The person's face<br></td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst2[]" id="chkLst2[]" value="C" <?php if (strpos($answers[2], 'C')!==false) echo "checked" ?>></td>
		<td>How you felt being with the person even though you may have forgotten their name or face<br></td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst2[]" id="chkLst2[]" value="D" <?php if (strpos($answers[2], 'D')!==false) echo "checked" ?>></td>
		<td> What you and the person did together even though you may have forgotten their name or face</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">3.  When you enter a new room, what do you notice the most?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst3[]" id="chkLst3[]" value="D" <?php if (strpos($answers[3], 'D')!==false) echo "checked" ?>></td>
		<td>What activities are going on and what you can do in the room</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst3[]" id="chkLst3[]" value="B" <?php if (strpos($answers[3], 'B')!==false) echo "checked" ?>></td>
		<td>The sounds or discussion in the room</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst3[]" id="chkLst3[]" value="C" <?php if (strpos($answers[3], 'C')!==false) echo "checked" ?>></td>
		<td>How comfortable you feel emotionally or physically in the room</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst3[]" id="chkLst3[]" value="A" <?php if (strpos($answers[3], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">How the room looks</td>
	</tr>
	</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">4.  When you learn something new, which way do you need to learn it?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst4[]" id="chkLst4[]" value="C" <?php if (strpos($answers[4], 'C')!==false) echo "checked" ?>></td>
		<td>The teacher lets you write or draw the information, touch hands-on materials, type on a keyboard, or make something with your hands</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst4[]" id="chkLst4[]" value="A" <?php if (strpos($answers[4], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">The teacher gives you something to read on paper or on the board and shows you books, pictures, charts, maps, graphs, or objects, but there is no talking, discussion, or writing</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst4[]" id="chkLst4[]" value="D" <?php if (strpos($answers[4], 'D')!==false) echo "checked" ?>></td>
		<td>The teacher allows you to get up to do projects, simulations, experiments, play games, role-play, act out real-life situations, explore, make discoveries, or do activities that allow you to move around to learn</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst4[]" id="chkLst4[]" value="B" <?php if (strpos($answers[4], 'B')!==false) echo "checked" ?>></td>
		<td>The teacher explains everything by talking or lecturing and allows you to discuss the topic and ask questions, but does not give you anything to look at, read, write, or do</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">5.  When you teach something to others, which of the following do you do?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst5[]" id="chkLst5[]" value="A" <?php if (strpos($answers[5], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">You give them something to look at like an object, picture, or chart, with little or no verbal explanation or discussion</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst5[]" id="chkLst5[]" value="B" <?php if (strpos($answers[5], 'B')!==false) echo "checked" ?>></td>
		<td>You explain it by talking, but do not give them any visual materials</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst5[]" id="chkLst5[]" value="D" <?php if (strpos($answers[5], 'D')!==false) echo "checked" ?>></td>
		<td>You demonstrate by doing it and have them do it with you</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst5[]" id="chkLst5[]" value="C" <?php if (strpos($answers[5], 'C')!==false) echo "checked" ?>></td>
		<td>You draw or write it out for them or use your hands to explain</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">6.  What type of books to you prefer to read?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst6[]" id="chkLst6[]" value="B" <?php if (strpos($answers[6], 'B')!==false) echo "checked" ?>></td>
		<td>Books containing factual information, history, or a lot of dialogue</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst6[]" id="chkLst6[]" value="A" <?php if (strpos($answers[6], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">Books that contain descriptions to help you see what is happening</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst6[]" id="chkLst6[]" value="D" <?php if (strpos($answers[6], 'D')!==false) echo "checked" ?>></td>
		<td>Short books with a lot of action, or books that help you excel at a sport, hobby, or talent</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst6[]" id="chkLst6[]" value="C" <?php if (strpos($answers[6], 'C')!==false) echo "checked" ?>></td>
		<td>Books about characters' feelings and emotions, self-help books, books about emotions and relationships, or books on improving your mind or body</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">7.  Which of the following activities would you prefer to do in your free time?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst7[]" id="chkLst7[]" value="C" <?php if (strpos($answers[7], 'C')!==false) echo "checked" ?>></td>
		<td>Write, draw, type, or make something with your hands</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst7[]" id="chkLst7[]" value="A" <?php if (strpos($answers[7], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">Read a book or look at a magazine</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst7[]" id="chkLst7[]" value="D" <?php if (strpos($answers[7], 'D')!==false) echo "checked" ?>></td>
		<td>Do sports, build something, or play a game using body movement</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst7[]" id="chkLst7[]" value="B" <?php if (strpos($answers[7], 'B')!==false) echo "checked" ?>></td>
		<td>Listen to an audiobook, a radio talk show, or listen to or perform music</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">8.  Which of the following describes how you can read or study best?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst8[]" id="chkLst8[]" value="A" <?php if (strpos($answers[8], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">You can study with music, noise, or talking going on because you can tune it out</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst8[]" id="chkLst8[]" value="D" <?php if (strpos($answers[8], 'D')!==false) echo "checked" ?>></td>
		<td>You need to be comfortable, stretched out, and can work with or without music, but activity or movement in the room distracts you</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst8[]" id="chkLst8[]" value="C" <?php if (strpos($answers[8], 'C')!==false) echo "checked" ?>></td>
		<td>You need to be comfortable, stretched out, and can work with or without music, but negative feelings of others distract you</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst8[]" id="chkLst8[]" value="B" <?php if (strpos($answers[8], 'B')!==false) echo "checked" ?>></td>
		<td>You cannot study with music, noise, or talking going on because you cannot tune it out</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">9.  When you talk with someone, which way do your eyes move?  (You can ask someone to observe you to help you answer this question.)</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst9[]" id="chkLst9[]" value="B" <?php if (strpos($answers[9], 'B')!==false) echo "checked" ?>></td>
		<td>You look at the person only for a short time, and then your eyes move from side to side, left and right</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst9[]" id="chkLst9[]" value="A" <?php if (strpos($answers[9], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">You need to look directly at the face of the person who is talking to you, and you need that person to look at your face when you talk</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst9[]" id="chkLst9[]" value="D" <?php if (strpos($answers[9], 'D')!==false) echo "checked" ?>></td>
		<td>You seldom look at the person and mostly look down or away, but if there is movement or activity, you look in the direction of the activity</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst9[]" id="chkLst9[]" value="C" <?php if (strpos($answers[9], 'C')!==false) echo "checked" ?>></td>
		<td>You only look at the person for a short time to see his or her expression, then you look down or away</td>
	</tr>

</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">10.  Which of the following describes you best?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst10[]" id="chkLst10[]" value="D" <?php if (strpos($answers[10], 'D')!==false) echo "checked" ?>></td>
		<td>You have a hard time sitting still in your seat and need to move a lot, and if you do have to sit you will slouch, shift around, tap your feet, or kick or wiggle your legs a lot</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst10[]" id="chkLst10[]" value="A" <?php if (strpos($answers[10], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">You notice colors, shapes, designs, and patterns wherever you go and have a good eye for color and design</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst10[]" id="chkLst10[]" value="C" <?php if (strpos($answers[10], 'C')!==false) echo "checked" ?>></td>
		<td>You are sensitive to other people's feelings, your own feelings get hurt easily, you cannot concentrate when others do not like you, and you need to feel loved and accepted in order to work</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst10[]" id="chkLst10[]" value="B" <?php if (strpos($answers[10], 'B')!==false) echo "checked" ?>></td>
		<td>You cannot stand silence, and when it is too quiet in a place you like to hum, sing, talk aloud, or turn on the radio, television, audiotapes, or CDs to keep an auditory stimulus in the environment</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">11.  Which of the following describes you best?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst11[]" id="chkLst11[]" value="B" <?php if (strpos($answers[11], 'B')!==false) echo "checked" ?>></td>
		<td>You are bothered when someone does not speak well and are sensitive to the sounds of dripping faucets or equipment noise</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst11[]" id="chkLst11[]" value="A" <?php if (strpos($answers[11], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">You notice when people's clothes do not match or their hair is out of place and often want them to fix it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst11[]" id="chkLst11[]" value="C" <?php if (strpos($answers[11], 'C')!==false) echo "checked" ?>></td>
		<td>You cry at the sad parts of movies or books</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst11[]" id="chkLst11[]" value="D" <?php if (strpos($answers[11], 'D')!==false) echo "checked" ?>></td>
		<td>You are restless and uncomfortable when forced to sit still and cannot stay in one place too long</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">12.  What bothers you the most?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst12[]" id="chkLst12[]" value="A" <?php if (strpos($answers[12], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">A place that is messy and disorganized</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst12[]" id="chkLst12[]" value="C" <?php if (strpos($answers[12], 'C')!==false) echo "checked" ?>></td>
		<td>A place that is not comfortable physically or emotionally</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst12[]" id="chkLst12[]" value="B" <?php if (strpos($answers[12], 'B')!==false) echo "checked" ?>></td>
		<td>A place that is too quiet</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst12[]" id="chkLst12[]" value="D" <?php if (strpos($answers[12], 'D')!==false) echo "checked" ?>></td>
		<td>A place where there is no activity allowed or no room to move</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">13.  What bothers you the most when someone is teaching you?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst13[]" id="chkLst13[]" value="C" <?php if (strpos($answers[13], 'C')!==false) echo "checked" ?>></td>
		<td>Not being allowed to draw, doodle, touch anything with your hands, or take written notes, even if you never look at your notes again</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst13[]" id="chkLst13[]" value="A" <?php if (strpos($answers[13], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">Listening to a lecture without any visuals to look at</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst13[]" id="chkLst13[]" value="B" <?php if (strpos($answers[13], 'B')!==false) echo "checked" ?>></td>
		<td>Having to read silently with no verbal explanation or discussion</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst13[]" id="chkLst13[]" value="D" <?php if (strpos($answers[13], 'D')!==false) echo "checked" ?>></td>
		<td>Having to look and listen without being allowed to move</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">14.  Think back to a happy memory from your life.  Take a moment to remember as much as you can about the incident.  After reliving it, what memories stand out in your mind?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst14[]" id="chkLst14[]" value="D" <?php if (strpos($answers[14], 'D')!==false) echo "checked" ?>></td>
		<td>What actions and activites you did, the movements of your body, and your performance</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst14[]" id="chkLst14[]" value="B" <?php if (strpos($answers[14], 'B')!==false) echo "checked" ?>></td>
		<td>What you heard, such as dialogue and conversation, what you said, and the sounds around you</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst14[]" id="chkLst14[]" value="A" <?php if (strpos($answers[14], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">What you saw, such as visual descriptions of people, places, and things</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst14[]" id="chkLst14[]" value="C" <?php if (strpos($answers[14], 'C')!==false) echo "checked" ?>></td>
		<td>Sensation on your skin and body and how you felt physically and emotionally</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">15.  Recall a vacation or trip you took.  For a few moments remember as much as you can about the experience.  After reliving the incident, what memories stand out in your mind?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst15[]" id="chkLst15[]" value="C" <?php if (strpos($answers[15], 'C')!==false) echo "checked" ?>></td>
		<td>Sensation on your skin and body and how you felt physically and emotionally</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst15[]" id="chkLst15[]" value="D" <?php if (strpos($answers[15], 'D')!==false) echo "checked" ?>></td>
		<td>What actions and activities you did, the movements of your body, and your performance</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst15[]" id="chkLst15[]" value="A" <?php if (strpos($answers[15], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">What you saw, such as visual descriptions of people, places, and things</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst15[]" id="chkLst15[]" value="B" <?php if (strpos($answers[15], 'B')!==false) echo "checked" ?>></td>
		<td>What you heard, such as dialogue and conversation, what you said, and the sounds around you</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">16.  Pretend you have to spend all your time in one of the following places where different activities are going on.  In which one would you feel the most comfortable?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst16[]" id="chkLst16[]" value="D" <?php if (strpos($answers[16], 'D')!==false) echo "checked" ?>></td>
		<td>A place where you can do sports, play ball or action games that involve moving your body, or act out parts in a play or show; do projects in which you can get up and move around; do experiments or explore and discover new things; build things or put together mechanical things; or participate in competitive team activities</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst16[]" id="chkLst16[]" value="C" <?php if (strpos($answers[16], 'C')!==false) echo "checked" ?>></td>
		<td>A place where you can draw, paint, sculpt, or make crafts; do creative writing or type on a computer; do activities that involve your hands, such as playing an instrument, games such as chess, checkers, or board games, or build models</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst16[]" id="chkLst16[]" value="B" <?php if (strpos($answers[16], 'B')!==false) echo "checked" ?>></td>
		<td>A place where you can listen to audio taped stories, music, radio, or television talk shows or news; play an instrument or sing; play word games out loud, debate, or pretend to be a disc jockey; read aloud or recite speeches or parts from a play or movie; or read poetry or stories aloud</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst16[]" id="chkLst16[]" value="A" <?php if (strpos($answers[16], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">A place where you can read; look at pictures, artwork, maps, charts, and photographs; do visual puzzles such as mazes, or find the missing portion of a picture; play word games such as Scrabble or Boggle; do interior decoration; or get dressed up</td>
	</tr>
</table>
<br>
<table width="100%" border="0">
	<tr>
		<td colspan="2">17.  If you had to remember a new word, how would you remember it best?</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst17[]" id="chkLst17[]" value="C" <?php if (strpos($answers[17], 'C')!==false) echo "checked" ?>></td>
		<td>By writing it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst17[]" id="chkLst17[]" value="A" <?php if (strpos($answers[17], 'A')!==false) echo "checked" ?>></td>
		<td width="95%">By seeing it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst17[]" id="chkLst17[]" value="B" <?php if (strpos($answers[17], 'B')!==false) echo "checked" ?>></td>
		<td>By hearing it</td>
	</tr>
	<tr>
		<td valign="top"><input type="checkbox" name="chkLst17[]" id="chkLst17[]" value="D" <?php if (strpos($answers[17], 'D')!==false) echo "checked" ?>></td>
		<td>By mentally or physically acting out the word</td>
	</tr>
</table>
<br>
<div style="text-align:center;"><input type="button" class="crsButton" name="btnSubmit" value=" Submit " onclick="document.frmLearningStyle.submit();"></div>

</form>

</div>

</div>

</body>

</html>