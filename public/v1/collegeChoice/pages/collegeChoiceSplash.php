<?php
session_start();
 include_once '../../commonPhp/csrNewHeader.php';

?>


<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">



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
<div class="crsMedium" style="text-align:center;">
<img src="../images/CollegeChoiceLogo.gif">
<br><br>
Where would you like to go?
<br><br>
<!--<input type="button" class="crsButton" name="btnGoToEfc" value="         Go To EFC&#010;(Expected Family&#010;Contribution)&#010;Calculator         " onclick="document.location.href='collegeChoiceEFCDataForm.php';">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="crsButton" name="btnGoToStudent" value="&#010;Go To Student Data&#010;and Select Colleges&#010; " onclick="document.location.href='collegeChoiceStudentDataForm.php';">-->
<table width="100%">
	<tr>
		<td align="right"><button type="button" class="crsButton" name="btnGoToEfc" style="width:200px;height:75px;" onclick="document.location.href='collegeChoiceEFCDataForm.php';">Go To EFC<br><span class="crsSmallWhite">(Expected Family Contribution)</span><br>Calculator</button>&nbsp;&nbsp;</td>
		<td align="left">&nbsp;&nbsp;<button type="button" class="crsButton" name="btnGoToStudent" style="width:200px;height:75px;" onclick="document.location.href='collegeChoiceStudentDataForm.php';">Go To Student Data<br>and Select Colleges</button></td>
	</tr>
</table>
</div>
<br><br><br><br>

</div>

<!--</div>-->
<?php
include_once '../../commonPhp/crsNewFooter.php';
?>