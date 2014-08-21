<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

$username=$_SESSION["username"];
$collegeList="";
$selectedColleges="";
//$collegeIds=$_SESSION["collegeids"];
//$collegeIdArray=explode(",", $collegeIds);

//print_r($_SESSION);

include("../../commonPhp/mySqlConnect.php");

$sql="SELECT * FROM TUSER A, TUSER_COLLEGECHOICE_DATA B WHERE USERNAME='$username' AND A.USER_ID=B.USER_ID";
$result=mysql_query($sql);

$row=mysql_fetch_array($result);

$_SESSION["familyname"]=$row["FAMILY_NAME"];
$_SESSION["studentname"]=$row["STUDENT_NAME"];
$_SESSION["stateofresidence"]=$row["STATE_OF_RESIDENCE"];
$_SESSION["gpa"]=$row["GPA"];
$_SESSION["satmath"]=$row["SAT_MATH"];
$_SESSION["satverbal"]=$row["SAT_VERBAL"];
$_SESSION["satwriting"]=$row["SAT_WRITING"];
$_SESSION["act"]=$row["ACT"];
//if ($row["EFC_FM"] != 0 && $row["EFC_FM"] != "")
//	$_SESSION["efcfm"]=$row["EFC_FM"];
//if ($row["EFC_IM"] != 0 && $row["EFC_IM"] != "")
//	$_SESSION["efcim"]=$row["EFC_IM"];
$collegeIds=$row["COLLEGES"];
$_SESSION["collegeids"]=$collegeIds;
$collegeIdArray=explode(",", $collegeIds);

$sql="SELECT COLLEGE_ID, COLLEGE_NAME FROM TCOLLEGE ORDER BY COLLEGE_NAME ASC";
$result=mysql_query($sql);

function getCurldata($url) {
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //Set curl to return the data instead of printing it to the browser.
    curl_setopt($ch, CURLOPT_URL, $url);

    $data = curl_exec($ch);
    curl_close($ch);

    return $data;
}

$db_conn = pg_connect("host=localhost port=5432 user=postgres dbname=gma");
if (!$db_conn) {
  echo "Failed connecting to postgres database gma\n";
  exit;
}

$qu = pg_query($db_conn, "Select unitid,instnm from colleges_college where active = 'y' Order by instnm");


$data = pg_fetch_object($qu);
echo json_encode($data);

// Request a list of all colleges from the API.
$colleges_json = getCurldata('http://api.getmoreaid.com/colleges.json?limit=-1');

// Load the colleges into an array.
$colleges_array = json_decode($colleges_json, true);

for ($college_count=0; $college_count < count($colleges_array['colleges']); $college_count++) {

	$college_id = $colleges_array['colleges'][$college_count]['cb_id'];
	$college_name = $colleges_array['colleges'][$college_count]['cb_name'];

	// Add the college to the selectable colleges.
	$collegeList.="<option value=\"" . $college_id . "\">" . $college_name . "</option>\n";

	// Add the college to the selected colleges if it was in the student's college list.
	if (in_array($college_id, $collegeIdArray)) {
		$selectedColleges.="<option value=\"" . $college_id . "\">" . $college_name . "</option>\n";
	}

}

include("../../commonPhp/mySqlClose.php");
include_once '../../commonPhp/csrNewHeader.php';
?>

<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">

<script language="JavaScript" type="text/javascript">
<!--
function addCollege()
{
	var collAvail=document.frmCollegeChoiceStudentData.lstCollegeChoices;
	var collSel=document.frmCollegeChoiceStudentData.lstCollegeSelected;

	if (collSel.length>14)
	{
		alert("You can not have more than 15 schools selected.  Please remove a school in order to add more.");
	}
	else
	{
		for (var i=0; i<collAvail.length; i++)
		{
			if (collAvail.options[i].selected)
			{
				bool=false;
				theValue=collAvail.options[i].value;
				theText=collAvail.options[i].text;

				for (var j=0; j<collSel.length; j++)
				{
					if (collSel.options[j].value==theValue)
					{
						bool=true;
						break;
					}
				}
				if (!bool)
					document.frmCollegeChoiceStudentData.lstCollegeSelected.options[document.frmCollegeChoiceStudentData.lstCollegeSelected.length]=new Option(theText, theValue);
			}

		}

		sortList();
	}
}

function sortList()
{
	var collSel=document.frmCollegeChoiceStudentData.lstCollegeSelected;
	tempArray=new Array();

	for (i=0; i<collSel.length; i++)
	{
		tempArray[i]=new Array();
		tempArray[i][0]=collSel.options[i].text;
		tempArray[i][1]=collSel.options[i].value;
	}

	tempArray.sort();

	for(i=0; i<collSel.length; i++)
	{
		collSel.options[i].text=tempArray[i][0];
		collSel.options[i].value=tempArray[i][1];
	}
}

function removeCollege()
{
	var collSel=document.frmCollegeChoiceStudentData.lstCollegeSelected;

	for (var i=collSel.length; i>0; i--)
	{
		if (collSel.options[i-1].selected)
			collSel.options[i-1]=null;
	}
}

function btnSubmit_onclick()
{
	var collSel=document.frmCollegeChoiceStudentData.lstCollegeSelected;
	var valsToSend="";

	if (document.frmCollegeChoiceStudentData.lstState.selectedIndex==0)
	{
		alert("Please select a state of residence.");
		document.frmCollegeChoiceStudentData.lstState.focus();
		return;
	}

	if (collSel.length<1)
	{
		alert("Please select a college/colleges for the report.");
		return;
	}

	for (var i=0; i<collSel.length; i++)
		valsToSend+=collSel.options[i].value+",";

	document.frmCollegeChoiceStudentData.hidCollegeSelected.value=valsToSend.substring(0,valsToSend.length-1);

	document.frmCollegeChoiceStudentData.submit();
}

function btnClear_onclick()
{
	document.frmCollegeChoiceStudentData.txtFamilyName.value="";
	document.frmCollegeChoiceStudentData.txtStudentName.value="";
	document.frmCollegeChoiceStudentData.lstState.selectedIndex=0;
	document.frmCollegeChoiceStudentData.txtGpa.value="";
	document.frmCollegeChoiceStudentData.txtSatMath.value="";
	document.frmCollegeChoiceStudentData.txtSatVerbal.value="";
	document.frmCollegeChoiceStudentData.txtSatWriting.value="";
	document.frmCollegeChoiceStudentData.txtActComposite.value="";
	//document.frmCollegeChoiceStudentData.txtFederalEfc.value="";
	//document.frmCollegeChoiceStudentData.txtInstitutionalEfc.value="";
	var collSel=document.frmCollegeChoiceStudentData.lstCollegeSelected;
	for (var i=collSel.length; i>0; i--)
		collSel.options[i-1]=null;
	document.frmCollegeChoiceStudentData.txtFamilyName.focus();
}

function body_onload()
{
	document.frmCollegeChoiceStudentData.lstState.value="<?php echo $_SESSION["stateofresidence"] ?>";
	document.frmCollegeChoiceStudentData.txtFamilyName.focus();
	document.frmCollegeChoiceStudentData.txtFamilyName.value=document.frmCollegeChoiceStudentData.txtFamilyName.value;
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

<div class="crsLarge" style="text-align:center">Student Data</div>

<form name="frmCollegeChoiceStudentData" method="POST" action="collegeChoiceSelectCompeting.php">
<table width="100%" border="0">
	<tr>
		<td valign="top">
			Family Name<br><input type="text" name="txtFamilyName" size="30" maxlength="100" value="<?php echo $_SESSION["familyname"] ?>">
			<br><br>
			Student's Name<br><input type="text" name="txtStudentName" size="30" maxlength="50" value="<?php echo $_SESSION["studentname"] ?>">
			<br><br>
			State of Residence<br><select name="lstState" value="">
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
		<td valign="top">
			GPA<br><input type="text" name="txtGpa" size="5" maxlength="4" value="<?php echo $_SESSION["gpa"]; ?>">
			<br><br>
			ACT Composite<br><input type="text" name="txtActComposite" size="5" maxlength="2" value="<?php echo $_SESSION["act"]; ?>">
		</td>
		<td>
			SAT Math<br><input type="text" name="txtSatMath" size="5" maxlength="3" value="<?php echo $_SESSION["satmath"]; ?>">
			<br><br>
			SAT Verbal<br><input type="text" name="txtSatVerbal" size="5" maxlength="3" value="<?php echo $_SESSION["satverbal"]; ?>">
			<br><br>
			SAT Writing<br><input type="text" name="txtSatWriting" size="5" maxlength="3" value="<?php echo $_SESSION["satwriting"]; ?>">
		</td>
		<td valign="top">
			Federal EFC<br>$<input type="text" name="txtFederalEfc" size="10" maxlength="10" value="<?php echo isset($_SESSION["efcfm"]) ? $_SESSION["efcfm"] : ''; ?>" <?php if ($_SESSION["usertype"]!="A") echo "style=\"background-color:#A3A3A3;\" readonly"; ?>>
			<br><br>
			Institutional EFC<br>$<input type="text" name="txtInstitutionalEfc" size="10" maxlength="10" value="<?php echo isset($_SESSION["efcim"]) ? $_SESSION["efcim"] : ''; ?>" <?php if ($_SESSION["usertype"]!="A") echo "style=\"background-color:#A3A3A3;\" readonly"; ?>>
			<br><br>
			<a class="crsBlue" href="collegeChoiceEFCDataForm.php">Recalculate EFCs</a>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center">
			<input type="button" class="crsButton" name="btnClear" value="   Clear   " onClick="btnClear_onclick();">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" class="crsButton" name="btnSubmit" value=" Submit " onClick="btnSubmit_onclick();">
		</td>
	</tr>
</table>
<div id="divOpenSearchTool" style="text-align:center;color:blue;text-decoration:underline;" onMouseOver="document.body.style.cursor='pointer';" onMouseOut="document.body.style.cursor='default';" onClick="document.getElementById('divSearchTool').style.display='block';document.getElementById('divOpenSearchTool').style.display='none';"><br>Click Here to Search for Colleges<br></div>
<br>
<div id="divSearchTool" style="text-align:center;display:none;">
<div class="crsMedium">Search for Colleges</div>
<br>
Use these tools to find colleges based on your search criteria.
<br>
<div class="crsSmall">Results will open in a new tab/window.</div>
<br>
<u>Schools For Special Consideration</u>
<br>
<select name="lstCollegeLists">
	<option value="">Please select a document</option>
	<option value="Catholic Colleges.pdf">Catholic Colleges</option>
	<option value="High Acceptance to Medical Schools.pdf">High Acceptance to Medical Schools</option>
	<option value="Decent Schools.pdf">Decent Schools</option>
	<option value="Generous Schools.pdf">Generous Schools</option>
	<option value="Big Colleges Play Small.pdf">Big Colleges Play Small</option>
    <option value="Caring Colleges.pdf">Caring Colleges</option>
    <option value="Culturally Friendly Colleges For Asian Students.pdf">Culturally Friendly Colleges For Asian Students</option>
    <option value="High Rank-Low Board Scores.pdf">High Rank-Low Board Scores</option>
    <option value="Jewish Students Find Cultural Interests.pdf">Jewish Students Find Cultural Interests</option>
    <option value="Schools that will accept Late Applications.pdf">Schools that will accept Late Applications</option>
    <option value="Turn a Shaky Kid Around.pdf">Turn a Shaky Kid Around</option>
    <option value="LD Schools.pdf">LD Schools</option>
</select>
&nbsp;&nbsp;
<input type="button" class="crsButton" value="View" name="btnViewCollegeList" id="btnViewCollegeList" onClick="if (document.frmCollegeChoiceStudentData.lstCollegeLists.selectedIndex==0) alert ('Please select a document to view.'); else window.open('../documents/'+document.frmCollegeChoiceStudentData.lstCollegeLists[document.frmCollegeChoiceStudentData.lstCollegeLists.selectedIndex].value,'_blank');">
<br><br>
<u>CollegeView.com's College Search Tool</u>
<script type="text/javascript" src="http://widgets.clearspring.com/o/496e1790cce6cf39/4bcef569b9b269b0/496e1790cce6cf39/a0a923b6/-cpid/97eb2a22db9543d0/widget.js"></script>
<div class="crsTiny">CollegeView.com<sup></sup>, Hobsons' fully interactive College Search Tool, provides<br>a wealth of information about more than 4,000 accredited colleges and<br>universities in the United States.  The school search offers navigational<br>features that allow you to customize your search by region, states,<br>major, and school to find the right college for your needs.</div>
<br>
<a href="http://collegesearch.collegeboard.com/search/adv_typeofschool.jsp" target="_blank" class="crsBlue">College MatchMaker</a>
<br>
<div class="crsSmall">Powered by CollegeBoard</div>
<div class="crsTiny">College MatchMaker will help generate a list of colleges<br>that match your preferences.  Search by location, majors,<br>cost, and more to find colleges that fit -- from a database<br>of 3,800+ schools.</div>
<br>
<a href="http://nces.ed.gov/collegenavigator/" target="_blank" class="crsBlue">View Graduation Rates</a>
<br>
<div class="crsSmall">Provided by the National Center for Education Statistics</div>
<div class="crsTiny">Although these statistics appear to be out of date, the<br>information is meaningful and should still be considered<br>when making college selection decisions.  This is the most<br>current validated information available to the general public.</div>
<br>
</div>
<div class="crsLarge" style="text-align:center;">Choose Schools</div>
<table width="100%" border="0">
	<tr>
		<td align="center" valign="top">
			Available Schools
			<br>
			<select name="lstCollegeChoices" class="multSelect" size="15" ondblclick="addCollege();" onkeydown="if (event.keyCode==13) addCollege();" onChange="document.getElementById('divCollegeChoicesText').innerHTML=this[selectedIndex].text;" multiple>
<?php
echo $collegeList;
?>
			</select>
			<span id="divCollegeChoicesText">&nbsp;</span>
		</td>
		<td align="center" valign="top"><br><br><br><input type="button" class="crsButton" name="btnAdd" value="  --Add-->  " onClick="addCollege();"><br><br><br><span class="crsSmall">or<br>double-click<br>or<br>press Enter</span><br><br><br><input type="button" class="crsButton" name="btnRemove" value="<--Remove--" onClick="removeCollege();"></td>
		<td align="center" valign="top">
			Selected Schools
			<br>
			<select name="lstCollegeSelected" class="multSelect" size="15" ondblclick="removeCollege();" onChange="document.getElementById('divCollegeSelectedText').innerHTML=this[selectedIndex].text;" multiple>
<?php
echo $selectedColleges;
?>
			</select>
			<span id="divCollegeSelectedText">&nbsp;</span>
		</td>
	</tr>
</table>
<div style="text-align:center;"><input type="button" class="crsButton" name="btnSubmit" value=" Submit " onClick="btnSubmit_onclick();"></div>
<input type="hidden" name="hidCollegeSelected" value="">
</form>

<br>

</div>

<!--</div>-->
<?php
include_once '../../commonPhp/crsNewFooter.php';
?>