<?php
session_start();

if (!isset($_SESSION["username"]))
	header("location:collegeChoiceLogin.php?login=session");

include("../../commonPhp/mySqlConnect.php");
include("../../commonPhp/getHtml.php");

$userType=$_SESSION["usertype"];
$familyName=$_SESSION["familyname"];
$studentName=$_SESSION["studentname"];
if ($studentName==null)
	$studentName="Student";
//$fatherName=$_SESSION["fatherName"];
//$motherName=$_SESSION["motherName"];
$residenceState=$_SESSION["stateofresidence"];
$studentGpa=$_SESSION["gpa"];
if ($studentGpa==null)
	$studentGpa="&nbsp;";
$studentSatMath=$_SESSION["satmath"];
$studentSatVerbal=$_SESSION["satverbal"];
$studentSatWriting=$_SESSION["satwriting"];
$studentActScore=$_SESSION["act"];
$federalEfc=$_SESSION["efcfm"];
if ($federalEfc==null)
	$federalEfc=0;
$institutionalEfc=$_SESSION["efcim"];
if ($institutionalEfc==null)
	$institutionalEfc=0;
$minorityStudent=($_SESSION["studentminority"]=="Y" ? true : false);


$mode=$_GET["mode"];
if ($mode=="miniReport")
	$collegeIds=$_GET["collegeId"];
else
	$collegeIds=$_SESSION["collegeids"];

$collegeIdArray=explode(",", $collegeIds);

// Add selected competing colleges.
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	// Check if the posted item is a selected college.
	foreach ($collegeIdArray as $value) {
		if ($value != null) {  // PHP Nuances
			if (is_array($_POST['chk' . $value])) {  // PHP Nuances
				foreach ($_POST['chk' . $value] as $kaboom) {
					$name_id_array = explode("^", $kaboom);
					array_push($collegeIdArray, $name_id_array[1]);
				}
			}
		}
	}
}

$actSatEquiv=array(530,590,640,690,740,790,830,870,910,950,990,1030,1070,1110,1150,1190,1220,1260,1300,1340,1380,1420,1460,1510,1560,1600);

function getSatBasedOnAct($actScore)
{
	global $actSatEquiv;

	if ($actScore<11)
		$actScore=11;

	return $actSatEquiv[(int)$actScore-11];
}

function getActBasedOnSat($satScore)
{
	global $actSatEquiv;

	for ($i=0; $i<count($actSatEquiv); $i++)
	{
		if ($satScore<$actSatEquiv[$i])
			break;
	}

	return (int)$i+10;
}

function calculatePercentage($highLow, $val)
{
	if ($highLow=="-" || $highLow=="Not reported")
		return $highLow;
	//Z-Scores are constant when calculating percentage using low, high, mean, and standard deviation
	$zScores=array(-2.326,-2.054,-1.881,-1.751,-1.645,-1.555,-1.476,-1.405,-1.341,-1.282,-1.227,-1.175,-1.126,-1.08,-1.036,-0.994,-0.954,-0.915,-0.878,-0.842,-0.806,-0.772,-0.739,-0.706,-0.674,-0.643,-0.613,-0.583,-0.553,-0.524,-0.496,-0.468,-0.44,-0.412,-0.385,-0.358,-0.332,-0.305,-0.279,-0.253,-0.228,-0.202,-0.176,-0.151,-0.126,-0.1,-0.075,-0.05,-0.025,0,0.025,0.05,0.075,0.1,0.126,0.151,0.176,0.202,0.228,0.253,0.279,0.305,0.332,0.358,0.385,0.412,0.44,0.468,0.496,0.524,0.553,0.583,0.613,0.643,0.674,0.706,0.739,0.772,0.806,0.842,0.878,0.915,0.954,0.994,1.036,1.08,1.126,1.175,1.227,1.282,1.341,1.405,1.476,1.555,1.645,1.751,1.881,2.054,2.326);
	$highLowArray=explode(" - ", $highLow);
	$lowVal=(int)$highLowArray[0];
	$highVal=(int)$highLowArray[1];
	$meanVal=($highVal+$lowVal)/2;
	$stdDev=($highVal-$meanVal)/.67448975;  //.67448975 = NORMSINV(0.75) in Excel from old Award Evaluator spreadsheet
	if ($stdDev==0)
		return "-";
	$zScore=((int)$val-$meanVal)/$stdDev;
	for ($i=0; $i<count($zScores); $i++)
	{
		if ($zScore<$zScores[$i])
			break;
	}
	return $i;
}

function createGraphHtml($percentage, $studentScore, $lowScore, $highScore, $avgHighLow)
{
	$browser=$_SERVER['HTTP_USER_AGENT'];
	$firefox=false;
	if (strpos(strtolower($browser), 'firefox')!==false)  //FireFox does not display the spans like Internet Explorer, Safari, and Chrome, so check which browser is being used
		$firefox=true;

	if (strlen($lowScore)==1)
		$lowScore="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" . $lowScore;
	if (strlen($highScore)==2)
		$highScore=$highScore . "&nbsp;&nbsp;&nbsp;";

	$position=(200*(1-(((int)$highScore-(int)$studentScore)/((int)$highScore-(int)$lowScore))))-2.5;
	$theHtml="\n\t\t\t\t\t\t<span class=\"crsTiny\">" . $lowScore . "</span>\n\t\t\t\t\t\t<span style=\"position:relative;\">\n";
	//$theHtml.="\t\t\t\t\t\t\t<div style=\"width:200px;height:20px;background-image:url(../images/RainbowBar.jpg);position:absolute;left:2px;top:-2px;border:solid 1px;border-color:white;z-index:1;\"></div>\n";
	//$theHtml.="\t\t\t\t\t\t\t<span style=\"width:200px;height:20px;background-image:url(../images/RainbowBar.jpg);position:absolute;left:2px;top:-2px;border:solid 1px;border-color:white;z-index:1;\"></span>\n";
	$theHtml.="\t\t\t\t\t\t\t<span style=\"width:200px;height:20px;background-image:url(../images/RainbowBar.jpg);position:absolute;left:2px;top:" . ($firefox ? "-15" : "-2") . "px;border:solid 1px;border-color:white;z-index:1;\"></span>\n";

	if ($studentScore!="" && $studentScore!="-" && strtolower($studentScore)!="not reported")
		//$theHtml.="\t\t\t\t\t\t\t<div style=\"position:absolute;left:" . $position . "px;top:-7px;width:5px;height:30px;background-color:#000000;z-index:3;\"></div>\n";
		//$theHtml.="\t\t\t\t\t\t\t<span style=\"position:absolute;left:" . $position . "px;top:-7px;width:5px;height:30px;background-color:#000000;z-index:3;\"></span>\n";
		$theHtml.="\t\t\t\t\t\t\t<span style=\"position:absolute;left:" . $position . "px;top:" . ($firefox ? "-20" : "-7") . "px;width:5px;height:30px;background-color:#000000;z-index:3;\"></span>\n";

	if ($percentage=="" || $percentage=="-" || strtolower($percentage)=="not reported")
		$percentage="";
	else
		$percentage.="%";

	if ($avgHighLow!="-" && $avgHighLow!="Not reported")
	{
		$avgHighLowArray=explode(" - ", $avgHighLow);
		$avgLowVal=(int)$avgHighLowArray[0];
		$avgHighVal=(int)$avgHighLowArray[1];
		$width=(200/($highScore-$lowScore))*($avgHighVal-$avgLowVal);
		$left=(200/($highScore-$lowScore))*($avgLowVal-$lowScore);
		//$theHtml.="\t\t\t\t\t\t\t<div class=\"transparent\" style=\"position:absolute;width:" . $width . "px;height:23px;left:" . $left . "px;top:-3px;background-color:#989898;border:solid 1px;border-color:white;z-index:2;\"></div>\n";
		//$theHtml.="\t\t\t\t\t\t\t<span class=\"transparent\" style=\"position:absolute;width:" . $width . "px;height:23px;left:" . $left . "px;top:-3px;background-color:#989898;border:solid 1px;border-color:white;z-index:2;\"></span>\n";
		$theHtml.="\t\t\t\t\t\t\t<span class=\"transparent\" style=\"position:absolute;width:" . $width . "px;height:23px;left:" . $left . "px;top:" . ($firefox ? "-16" : "-3") . "px;background-color:#989898;border:solid 1px;border-color:white;z-index:2;\"></span>\n";
	}

	//$theHtml.="\t\t\t\t\t\t\t<div style=\"position:absolute;left:202\"><span class=\"crsTiny\">" . $highScore . "</span> " . $percentage . "</div>\n";
	//$theHtml.="\t\t\t\t\t\t\t<span style=\"position:absolute;left:202\"><span class=\"crsTiny\">" . $highScore . "</span> " . $percentage . "</span>\n";
	//$theHtml.="\t\t\t\t\t\t\t<span style=\"position:absolute;left:205;top:5px;\" class=\"crsTiny\">" . $highScore . "</span><span style=\"position:absolute;left:225;\">" . $percentage . "</span>\n";
	$theHtml.="\t\t\t\t\t\t\t<span style=\"position:absolute;left:205;top:" . ($firefox ? "-9" : "5" ) . "px;\" class=\"crsTiny\">" . $highScore . "</span><span style=\"position:absolute;left:225;top:" . ($firefox ? "-13" : "1" ) . "px\">" . $percentage . "</span>\n";
	$theHtml.="\t\t\t\t\t\t</span>\n";
	return $theHtml;
}

function getCurldata($url) {
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //Set curl to return the data instead of printing it to the browser.
    curl_setopt($ch, CURLOPT_URL, $url);

    $data = curl_exec($ch);
    curl_close($ch);

    return $data;
}
include_once '../../commonPhp/csrNewHeader.php';
?>



<link rel="stylesheet" type="text/css" href="../../commonCss/crs.css">
<link rel="stylesheet" type="text/css" href="../../commonCss/subModal.css">
<script type="text/javascript" src="../../commonJs/common.js"></script>
<script type="text/javascript" src="../../commonJs/subModal.js"></script>

<script language="JavaScript" type="text/javascript">
	<!--
	var newWindow;

	function addRemoveSchools()
	{
		if (newWindow!=null && !newWindow.closed)
			newWindow.close();

		document.frmCollegeChoiceReport.submit();
	}

	function showPrintTips()
	{
		var whichBrowser="collegeChoicePrint.html";

		if (navigator.userAgent.toLowerCase().indexOf("msie")>=0)
			whichBrowser="collegeChoicePrintIE.html";
		else if (navigator.userAgent.toLowerCase().indexOf("firefox")>=0)
			whichBrowser="collegeChoicePrintFirefox.html";
		else if (navigator.userAgent.toLowerCase().indexOf("safari")>=0 && navigator.userAgent.toLowerCase().indexOf("chrome")<0)
			whichBrowser="collegeChoicePrintSafari.html";
		else if (navigator.userAgent.toLowerCase().indexOf("chrome")>=0)
			whichBrowser="collegeChoicePrintChrome.html";

		showPopWin(whichBrowser, 450, 350, null);
	}

	function hide(collegeId)
	{
		document.getElementById("divCollege"+collegeId).style.display="none";
	}

	function addCommas(nStr)
	{
		nStr += '';
		x = nStr.split('.');
		x1 = x[0];
		x2 = x.length > 1 ? '.' + x[1] : '';
		var rgx = /(\d+)(\d{3})/;
		while (rgx.test(x1)) {
			x1 = x1.replace(rgx, '$1' + ',' + '$2');
		}
		return x1 + x2;
	}

	function changeAdmLikelihood(collegeId)
	{
		document.getElementById("divAdmLikelihood"+collegeId).style.display="none";
		document.getElementById("divNewAdmLikelihood"+collegeId).style.display="block";
	}

	function btnOkAdm_onclick(whichOkAdmButton)
	{
		var collegeId=whichOkAdmButton.name.substring(8,whichOkAdmButton.name.length);
		var admRadio=document.getElementsByName("radNewAdmLikelihood"+collegeId);

		for (i=0; i<admRadio.length; i++)
		{
			if (admRadio[i].checked)
			{
				whichAdm=admRadio[i].value;
				break;
			}
		}

		var newLikelihood="Not available";
		var bullseyeGif="bullseyeColored.gif";

		switch (whichAdm)
		{
			case "S":
				newLikelihood="<div class=\"crsLarge\">Safety</div><div class=\"crsSmall\">Target<br>Possible<br>Reach<br>Far Reach</div>";
				bullseyeGif="bullseyeSafety.gif";
				break;
			case "T":
				newLikelihood="<div class=\"crsSmall\">Safety</div><div class=\"crsLarge\">Target</div><div class=\"crsSmall\">Possible<br>Reach<br>Far Reach</div>";
				bullseyeGif="bullseyeTarget.gif";
				break;
			case "P":
				newLikelihood="<div class=\"crsSmall\">Safety<br>Target</div><div class=\"crsLarge\">Possible</div><div class=\"crsSmall\">Reach<br>Far Reach</div>";
				bullseyeGif="bullseyePossible.gif";
				break;
			case "R":
				newLikelihood="<div class=\"crsSmall\">Safety<br>Target<br>Possible</div><div class=\"crsLarge\">Reach</div><div class=\"crsSmall\">Far Reach</div>";
				bullseyeGif="bullseyeReach.gif";
				break;
			case "F":
				newLikelihood="<div class=\"crsSmall\">Safety<br>Target<br>Possible<br>Reach</div><div class=\"crsLarge\">Far Reach</div>";
				bullseyeGif="bullseyeFarReach.gif";
				break;
			default:
				newLikelihood="Not available";
				break;
		}

		for (var i=0; i<admRadio.length; i++)
			admRadio[i].checked=false;

		document.getElementById("divAdmLikelihood"+collegeId).style.display="block";
		document.getElementById("divNewAdmLikelihood"+collegeId).style.display="none";
		//document.getElementById("divAdmLikelihood"+collegeId).innerHTML=newLikelihood+"<a href=\"javascript:changeAdmLikelihood(" + collegeId + ");\" class=\"crsTiny\">Change</a>";
		document.getElementById("divAdmLikelihood"+collegeId).innerHTML=newLikelihood+"<a href=\"javascript:changeAdmLikelihood(" + collegeId + ");\" class=\"crsTiny\">Change</a><br><img src=\"../images/" + bullseyeGif + "\" border=\"0\" width=\"150\" height=\"150\">";
	}

	function changeEfcFm(whichEfcFm)
	{
		document.getElementById("spnEfcFm"+whichEfcFm).style.display="none";
		document.getElementById("spnNewEfcFm"+whichEfcFm).style.display="inline";
		document.getElementById("txtNewEfcFm"+whichEfcFm).focus();
	}

	function btnOkEfcFm_onclick(whichCollege)
	{
		var newEfcFm=document.getElementById("txtNewEfcFm"+whichCollege).value.replace(/\,/,"");

		document.getElementById("spnNewEfcFm"+whichCollege).style.display="none";
		document.getElementById("spnEfcFm"+whichCollege).style.display="inline";
		document.getElementById("txtNewEfcFm"+whichCollege).value="";

		for (i=1; i<=howManyEfcs; i++)
			document.getElementById("spnEfcFm"+i).innerHTML=addCommas(newEfcFm) + " <a href=\"javascript:changeEfcFm(" + i + ");\" class=\"crsTiny\">Change</a>";

		efcFM=newEfcFm;

		var collegeIdArray=collegeIds.split(",");

		for (j=0; j<collegeIdArray.length; j++)
		{
			var efcRadio=document.getElementsByName("radEfc"+collegeIdArray[j]);
			var whichEfc="";

			for (k=0; k<efcRadio.length; k++)
			{
				if (efcRadio[k].checked)
				{
					whichEfc=efcRadio[k].value;
					break;
				}
			}

			if (whichEfc=="FM")
				radEfc_onclick("radEfc"+collegeIdArray[j],"FM");
		}
	}

	function changeEfcIm(whichEfcIm)
	{
		document.getElementById("spnEfcIm"+whichEfcIm).style.display="none";
		document.getElementById("spnNewEfcIm"+whichEfcIm).style.display="inline";
		document.getElementById("txtNewEfcIm"+whichEfcIm).focus();
	}

	function btnOkEfcIm_onclick(whichCollege)
	{
		var newEfcIm=document.getElementById("txtNewEfcIm"+whichCollege).value.replace(/\,/,"");

		document.getElementById("spnNewEfcIm"+whichCollege).style.display="none";
		document.getElementById("spnEfcIm"+whichCollege).style.display="inline";
		document.getElementById("txtNewEfcIm"+whichCollege).value="";

		for (i=1; i<=howManyEfcs; i++)
			document.getElementById("spnEfcIm"+i).innerHTML=addCommas(newEfcIm) + " <a href=\"javascript:changeEfcIm(" + i + ");\" class=\"crsTiny\">Change</a>";

		efcIM=newEfcIm;

		var collegeIdArray=collegeIds.split(",");

		for (j=0; j<collegeIdArray.length; j++)
		{
			var efcRadio=document.getElementsByName("radEfc"+collegeIdArray[j]);
			var whichEfc="";

			for (k=0; k<efcRadio.length; k++)
			{
				if (efcRadio[k].checked)
				{
					whichEfc=efcRadio[k].value;
					break;
				}
			}

			if (whichEfc=="IM")
				radEfc_onclick("radEfc"+collegeIdArray[j],"IM");
		}
	}

	function changePctgNeedMet(collegeId)
	{
		document.getElementById("divPctgNeedMet"+collegeId).style.display="none";
		document.getElementById("divNewPctgNeedMet"+collegeId).style.display="block";
		document.getElementById("txtNewPctgNeedMet"+collegeId).focus();
	}

	function btnOk_onclick(whichOkButton)
	{
		var collegeId=whichOkButton.name.substring(5,whichOkButton.name.length);
		var newPctgNeedMet=document.getElementById("txtNewPctgNeedMet"+collegeId).value;
		if (newPctgNeedMet=="")
			newPctgNeedMet="0";

		document.getElementById("divNewPctgNeedMet"+collegeId).style.display="none";
		document.getElementById("divPctgNeedMet"+collegeId).style.display="block";
		document.getElementById("divPctgNeedMet"+collegeId).innerHTML=(newPctgNeedMet==0 ? "Not reported" : newPctgNeedMet+"%")+"<br><a href=\"javascript:changePctgNeedMet(" + collegeId + ");\" class=\"crsTiny\">Change</a>";
		document.getElementById("txtNewPctgNeedMet"+collegeId).value="";

		window["pctgNeedMet"+collegeId]=(Number(newPctgNeedMet))/100;
		calculateNeedAndAid(collegeId);
	}

	function radHousing_onClick(theName,theValue)
	{
		var name=theName;
		var collegeId=name.substring(10,name.length);
		var value=theValue;

		var tuitionPrint="$" + eval("tuition"+value+""+collegeId);
		var tuitionNumber=Number(tuitionPrint.replace(/\$/,"").replace(/\,/,""));
		tuitionNumber=isNaN(tuitionNumber) ? 0 : tuitionNumber;
		if (isNaN(tuitionNumber) || tuitionNumber==0)
			tuitionPrint="Not reported";

		var roomBoardPrint="$" + eval("roomBoard"+value+""+collegeId);
		var roomBoardNumber=Number(roomBoardPrint.replace(/\$/,"").replace(/\,/,""));
		roomBoardNumber=isNaN(roomBoardNumber) ? 0 : roomBoardNumber;
		if (isNaN(roomBoardNumber) || roomBoardNumber==0)
			roomBoardPrint="Not reported";

		var booksSuppliesPrint="$" + eval("booksSupplies"+value+""+collegeId);
		var booksSuppliesNumber=Number(booksSuppliesPrint.replace(/\$/,"").replace(/\,/,""));
		booksSuppliesNumber=isNaN(booksSuppliesNumber) ? 0 : booksSuppliesNumber;
		if (isNaN(booksSuppliesNumber) || booksSuppliesNumber==0)
			booksSuppliesPrint="Not reported";

		var persExpPrint="$" + eval("persExp"+value+""+collegeId);
		var persExpNumber=Number(persExpPrint.replace(/\$/,"").replace(/\,/,""));
		persExpNumber=isNaN(persExpNumber) ? 0 : persExpNumber;
		if (isNaN(persExpNumber) || persExpNumber==0)
			persExpPrint="Not reported";

		var transExpPrint="$" + eval("transExp"+value+""+collegeId);
		var transExpNumber=Number(transExpPrint.replace(/\$/,"").replace(/\,/,""));
		transExpNumber=isNaN(transExpNumber) ? 0 : transExpNumber;
		if (isNaN(transExpNumber) || transExpNumber==0)
			transExpPrint="Not reported";

		var total;

		if (eval("costsFeesNotAvailable"+collegeId)=="1")
		{
			window["need"+collegeId]=0;
			document.getElementById("divTuition"+collegeId).innerHTML=tuitionPrint;
			document.getElementById("divRoomBoard"+collegeId).innerHTML=roomBoardPrint;
			document.getElementById("divBooksSupplies"+collegeId).innerHTML=booksSuppliesPrint;
			document.getElementById("divPersExp"+collegeId).innerHTML=persExpPrint;
			document.getElementById("divTransExp"+collegeId).innerHTML=transExpPrint;
			document.getElementById("divTotalCost"+collegeId).innerHTML="<b>See notes</b>";
			document.getElementById("divCostAtt"+collegeId).innerHTML="Not available";
			document.getElementById("divNeed"+collegeId).innerHTML="= Not available";
		}
		else
		{
			total=tuitionNumber+roomBoardNumber+booksSuppliesNumber+persExpNumber+transExpNumber;

			if (total==0)
			{
				document.getElementById("divTuition"+collegeId).innerHTML=tuitionPrint;
				document.getElementById("divRoomBoard"+collegeId).innerHTML=roomBoardPrint;
				document.getElementById("divBooksSupplies"+collegeId).innerHTML=booksSuppliesPrint;
				document.getElementById("divPersExp"+collegeId).innerHTML=persExpPrint;
				document.getElementById("divTransExp"+collegeId).innerHTML=transExpPrint;
				document.getElementById("divTotalCost"+collegeId).innerHTML="<b>Not reported</b>";
				document.getElementById("divCostAtt"+collegeId).innerHTML="Not available";
				document.getElementById("divNeed"+collegeId).innerHTML="= Not available";
				document.getElementById("divTotalAid"+collegeId).innerHTML="Not available";
				document.getElementById("divGiftAid"+collegeId).innerHTML="Not available";
				document.getElementById("divSelfHelpAid"+collegeId).innerHTML="Not available";
			}
			else
			{
				var efcRadio=document.getElementsByName("radEfc"+collegeId);
				var whichEfc="";

				for (i=0; i<efcRadio.length; i++)
				{
					if (efcRadio[i].checked)
					{
						whichEfc=efcRadio[i].value;
						break;
					}
				}
				var efcValue=Number(eval("efc"+whichEfc));
				window["need"+collegeId]=total-efcValue;

				document.getElementById("divTuition"+collegeId).innerHTML=tuitionPrint;
				if (eval("comprehensiveTuition"+collegeId)=="0")
					document.getElementById("divRoomBoard"+collegeId).innerHTML=roomBoardPrint;
				document.getElementById("divBooksSupplies"+collegeId).innerHTML=booksSuppliesPrint;
				document.getElementById("divPersExp"+collegeId).innerHTML=persExpPrint;
				document.getElementById("divTransExp"+collegeId).innerHTML=transExpPrint;
				document.getElementById("divTotalCost"+collegeId).innerHTML="<b>$"+addCommas(total)+"</b>";
				document.getElementById("divCostAtt"+collegeId).innerHTML="$"+addCommas(total);

				calculateNeedAndAid(collegeId);
			}
		}
	}

	function radEfc_onclick(theName,theValue)
	{
		var collegeId=theName.substring(6,theName.length);
		var whichEfc=theValue;
		var efcValue=Number(eval("efc"+whichEfc));
		document.getElementById("divEfc"+collegeId).innerHTML="$"+addCommas(efcValue);

		if (eval("costsFeesNotAvailable"+collegeId)=="1")
			window["need"+collegeId]=0;
		else
		{
			var costOfAtt=Number(document.getElementById("divCostAtt"+collegeId).innerHTML.replace(/\$/,"").replace(/\,/,""));

			if (!isNaN(costOfAtt))
			{
				window["need"+collegeId]=costOfAtt-efcValue;
				calculateNeedAndAid(collegeId);
			}
		}
	}

	function calculateNeedAndAid(collegeId)
	{
		var need=Number(eval("need"+collegeId));
		var nonNeedAid=Number(eval("nonNeedAid"+collegeId))
		var pctgNeedMet=Number(eval("pctgNeedMet"+collegeId));
		var giftAidPctg=Number(eval("giftAidPctg"+collegeId));
		var selfHelpAidPctg=Number(eval("selfHelpAidPctg"+collegeId));
		var studentAidPctg=Number(eval("aidPctg"+collegeId));
		var totalNeed;
		var projectedAid;
		var giftAidLabel;
		var giftAid;
		var selfHelpAid;
		var selfHelpAidLabel;

		if (need<=0)
		{
			totalNeed="= $0";

			if (pctgNeedMet!=0)
				projectedAid="$"+addCommas(Math.round(studentAidPctg*nonNeedAid))+"<br>(Merit)";
			else
				projectedAid="Not available";

			giftAidLabel="&nbsp;";
			giftAid="&nbsp;";
			selfHelpAidLabel="&nbsp;";
			selfHelpAid="&nbsp;";
		}
		else
		{
			if (pctgNeedMet==1.00)
				projectedAid=need;
			else
				projectedAid=need*pctgNeedMet*studentAidPctg;

			totalNeed="= $"+addCommas(need);
			giftAid=projectedAid*giftAidPctg;
			selfHelpAid=projectedAid*selfHelpAidPctg;

			if (projectedAid==0)
			{
				projectedAid="Not available";
				giftAid="Not available";
				selfHelpAid="Not available";
			}
			else
			{
				projectedAid="$"+addCommas(Math.round(projectedAid));
				giftAid="$"+addCommas(Math.round(giftAid))+"<br><div class=\"crsSmall\">("+projectedAid+" x "+Math.round(giftAidPctg*100)+"%)</div>";
				selfHelpAid="$"+addCommas(Math.round(selfHelpAid))+"<br><div class=\"crsSmall\">("+projectedAid+" x "+Math.round(selfHelpAidPctg*100)+"%)</div>";
			}

			if (giftAidPctg==0)
				giftAid="Not available";

			if (selfHelpAidPctg==0)
				selfHelpAid="Not available";

			giftAidLabel="Gift Aid";
			selfHelpAidLabel="Self-Help Aid";
		}

		//if (pctgNeedMet==1.00 && need>0)
			//projectedAid=need;

		document.getElementById("divNeed"+collegeId).innerHTML=totalNeed;
		document.getElementById("divTotalAid"+collegeId).innerHTML=projectedAid;
		document.getElementById("divGiftAidLabel"+collegeId).innerHTML=giftAidLabel;
		document.getElementById("divGiftAid"+collegeId).innerHTML=giftAid;
		document.getElementById("divSelfHelpAidLabel"+collegeId).innerHTML=selfHelpAidLabel;
		document.getElementById("divSelfHelpAid"+collegeId).innerHTML=selfHelpAid;
	}

	function openMiniReport(collegeId)
	{
		var newWindowWidth=window.screen.width-200;
		var newWindowHeight=window.screen.height-300;
		var newWindowLeft=(window.screen.width-newWindowWidth)/2;
		var newWindowTop=(window.screen.height-newWindowHeight)/2;

		newWindow=window.open("collegeChoiceReport.php?mode=miniReport&collegeId="+collegeId, "miniReport", "width="+newWindowWidth+",height="+newWindowHeight+",resizable=yes,left="+newWindowLeft+",top="+newWindowTop+",status=no,toolbar=no,menubar=no,scrollbars=yes,location=no,directories=no");
		newWindow.focus();
	}

	function body_onbeforeprint()
	{
		document.body.style.backgroundColor="#FFFFFF";
		document.getElementById("crsContent").style.backgroundColor="#FFFFFF";
		document.getElementById("crsContent").style.borderStyle="none";
		document.getElementById("spnCCButtons").style.display="none";
		//document.getElementById("spnCCButtons1").style.display="none";
		//document.getElementById("spnCCButtons2").style.display="none";

		var collegeIdArray=collegeIds.split(",");

		for (i=0; i<collegeIdArray.length; i++)
		{
			var collegeId=collegeIdArray[i];
			var theNote=eval("cbNotes"+collegeId);
			if (theNote!="")
				theNote+="<br><br>";
			theNote+=document.getElementById("txtNotes"+collegeId).value;
			document.getElementById("divNotes"+collegeId).innerHTML=theNote;
			document.getElementById("divNotesTextarea"+collegeId).style.display="none";
			document.getElementById("divNotes"+collegeId).style.display="inline";
		}
	}

	function body_onafterprint()
	{
		document.body.style.backgroundColor="#000000";
		document.getElementById("crsContent").style.backgroundColor="#FFFFCA";
		document.getElementById("crsContent").style.borderStyle="ridge";
		document.getElementById("spnCCButtons").style.display="inline";
		//document.getElementById("spnCCButtons1").style.display="inline";
		//document.getElementById("spnCCButtons2").style.display="inline";

		var collegeIdArray=collegeIds.split(",");

		for (i=0; i<collegeIdArray.length; i++)
		{
			var collegeId=collegeIdArray[i];
			document.getElementById("divNotesTextarea"+collegeId).style.display="inline";
			document.getElementById("divNotes"+collegeId).style.display="none";
		}
	}

	function body_onload()
	{
	<?php
	for ($i=0; $i<count($collegeIdArray); $i++)
	{
		echo "\tradHousing_onClick(\"radHousing$collegeIdArray[$i]\",\"OC\");\n";
		echo "\tradEfc_onclick(\"radEfc$collegeIdArray[$i]\",\"FM\");\n";
	}
	?>
	}
	-->
	if (window.attachEvent) {window.attachEvent('onload', body_onload);}
else if (window.addEventListener) {window.addEventListener('load', body_onload, false);}
else {document.addEventListener('load', body_onload, false);}
if (window.matchMedia) {
                var mediaQueryList = window.matchMedia('print');
                mediaQueryList.addListener(function(mql) {
                    if (mql.matches) {
                        body_onbeforeprint();
                    } else {
                        body_onafterprint();
                    }
                });
            }

            window.onbeforeprint = body_onbeforeprint;
            window.onafterprint = body_onafterprint;
</script>

<!--<div id="crsWrapper">-->

<div id="crsContent">

<form name="frmCollegeChoiceReport" method="POST" action="collegeChoiceAdd.php">

<?php

$sql="SELECT * FROM TCOLLEGECHOICE_CONFIG";
$result=mysql_query($sql);
$row=mysql_fetch_array($result);

$outOfStatePctIncrease=$row["OUT_OF_STATE_PCT_INCREASE"];
$minorityPctIncrease=$row["MINORITY_PCT_INCREASE"];
$safetyPctg=$row["SAFETY_PCTG"];
$targetPctg=$row["TARGET_PCTG"];
$possiblePctg=$row["POSSIBLE_PCTG"];
$reachPctg=$row["REACH_PCTG"];
$testPctg=$row["TEST_PCTG"];
$gpaPctg=$row["GPA_PCTG"];
$scorePctgForAid1=$row["SCORE_PCTG_FOR_AID1"];
$scorePctgForAid2=$row["SCORE_PCTG_FOR_AID2"];
$scorePctgForAid3=$row["SCORE_PCTG_FOR_AID3"];
$scorePctgForAid4=$row["SCORE_PCTG_FOR_AID4"];

if ($mode!="miniReport")
	include("collegeChoiceReportHeader.php");

$jsForCosts="var howManyEfcs=" . count($collegeIdArray) . ";\nvar efcFM=" . $federalEfc . ";\nvar efcIM=" . $institutionalEfc . ";\n";

for ($i=0; $i<count($collegeIdArray); $i++)
{
	$currentCollegeId=$collegeIdArray[$i];

	$sql="SELECT COLLEGE_NAME, COLLEGEBOARD_ID, REQUEST_INFO_URL, APPLY_ONLINE_URL FROM TCOLLEGE WHERE COLLEGE_ID=$currentCollegeId";
	$result=mysql_query($sql);
	$row=mysql_fetch_array($result);
	$collegeName=$row["COLLEGE_NAME"];
	$collegeBoardId=$row["COLLEGEBOARD_ID"];
	$requestInfoUrl=$row["REQUEST_INFO_URL"];
	$applyOnlineUrl=$row["APPLY_ONLINE_URL"];

	$college_json = getCurldata('http://api.getmoreaid.com/colleges/' . $currentCollegeId . '.json');
	$college_data = json_decode($college_json, true);
	$college = $college_data['college'];

	$collegeName = $college['cb_name'];
	$collegeBoardId = $college['cb_id'];

	$newlines=array("\t","\n","\r","\x20\x20","\0","\x0B");

	$content0=str_replace($newlines, "", html_entity_decode($rawData0));
	$content2=str_replace($newlines, "", html_entity_decode($rawData2));
	$content6=str_replace($newlines, "", html_entity_decode($rawData6));

	//URL
	//get url
	$url = $college['contact_info']['main']['url'];

	//City, State
	//get city, state
	$college_city = $college['contact_info']['main']['address']['locality'];
	$collState = $college['contact_info']['main']['address']['region'];
	$cityState = $college_city . ', '. $collState;

	//Public or Private
	if($college['type_of']['is_public']) {
		$privatePublic = 'public';
	}
	else {
		$privatePublic = 'private';
	}

	//GPA
	$gpaPercentile="";
	$gpa="&nbsp;";
	if (count($college['gpa']) == 0) {
		$gpa="Not reported";
	}
	else if ($studentGpa!="&nbsp;")
	{
		$gpa="0%";
		$floatStudentGpa=(float)$studentGpa;
		$gpaPercentile=0;

		$gpaArray = $college['gpa'];

		for ($k=0; $k<count($gpaArray); $k++)
		{
			$gpaText=$gpaArray[$k];
			$percent[$k] = $gpaArray[$k]['percent'];

			$lowGpa[$k]=$gpaArray[$k]['low'];
			$highGpa[$k]=$gpaArray[$k]['high'];

			if ($floatStudentGpa >= (float)$lowGpa[$k]) {
				$gpa=$percent[$k] . "% had H.S. GPA" . ($k==0 ? " of " : " between ") . $lowGpa[$k] . " and " . $highGpa[$k];
				break;
			}

			$gpaPercentile=(int)$percent[$k] + $gpaPercentile;
		}

		$gpaPercentile=100-$gpaPercentile;
	}

	$inState=false;
	if (strtoupper($collState)==strtoupper($residenceState))
		$inState=true;

	$costsFeesNotAvailable=false;
	$comprehensiveTuition=false;
	$notes="";

	if ($college['costs']['off_campus']['in_state_tuition'] && null and $college['costs']['off_campus']['comprehensive_fee'] == null)
	{
		$costsFeesNotAvailable=true;

		$jsForCosts.="var tuitionOC" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var tuitionAH" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var tuitionCO" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var roomBoardOC" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var roomBoardAH" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var roomBoardCO" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var costsFeesNotAvailable" . $currentCollegeId . "=\"1\";\n";
		$jsForCosts.="var comprehensiveTuition" . $currentCollegeId . "=\"0\";\n";
		$jsForCosts.="var booksSuppliesOC" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var booksSuppliesAH" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var booksSuppliesCO" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var persExpOC" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var persExpAH" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var persExpCO" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var transExpOC" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var transExpAH" . $currentCollegeId . "=\"See notes\";\n";
		$jsForCosts.="var transExpCO" . $currentCollegeId . "=\"See notes\";\n";

		$start=strpos($content2,'Annual College Costs');
		$end=strpos($content2,'<!-- NEW CROSS-SELL -->',$start);
		$notes=substr($content2,$start,$end-$start);
		$notes=str_replace("<!-- (Fall 2003) -->","",$notes);
		$notes=str_replace("</h3>","",$notes);
	}
	else
	{
		$jsForCosts.="var costsFeesNotAvailable" . $currentCollegeId . "=\"0\";\n";

		if ($college['costs']['off_campus']['comprehensive_fee'] != null)
		{
			$comprehensiveTuition=true;

			//Comprehensive Fee On Campus
			$fee = $college['costs']['on_campus']['comprehensive_fee'];
			$jsForCosts.="var tuitionOC" . $currentCollegeId . "=\"" . $fee . "\";\n";

			//Comprehensive Fee At Home and Commuting are the same
			$fee = $college['costs']['at_home']['comprehensive_fee'];
			$jsForCosts.="var tuitionAH" . $currentCollegeId . "=\"" . $fee . "\";\n";

			$fee = $college['costs']['off_campus']['comprehensive_fee'];
			$jsForCosts.="var tuitionCO" . $currentCollegeId . "=\"" . $fee . "\";\n";

			//Room and Board are included in Comprehensive Fee
			$jsForCosts.="var roomBoardOC" . $currentCollegeId . "=\"0\";\n";
			$jsForCosts.="var roomBoardAH" . $currentCollegeId . "=\"0\";\n";
			$jsForCosts.="var roomBoardCO" . $currentCollegeId . "=\"0\";\n";

			//set up javascript variable for comprehensive tuition
			$jsForCosts.="var comprehensiveTuition" . $currentCollegeId . "=\"1\";\n";
		}
		else
		{
			if ($inState) {
				//Tuition On Campus
				$jsForCosts.="var tuitionOC" . $currentCollegeId . "=\"" . $college['costs']['on_campus']['in_state_tuition'] . "\";\n";
				//Tuition At Home
				$jsForCosts.="var tuitionAH" . $currentCollegeId . "=\"" . $college['costs']['at_home']['in_state_tuition'] . "\";\n";
				//Tuition Commuting
				$jsForCosts.="var tuitionCO" . $currentCollegeId . "=\"" . $college['costs']['off_campus']['in_state_tuition'] . "\";\n";
			}
			else {
				// Tuition On Campus
				$jsForCosts.="var tuitionOC" . $currentCollegeId . "=\"" . $college['costs']['on_campus']['out_of_state_tuition'] . "\";\n";
				//Tuition At Home
				$jsForCosts.="var tuitionAH" . $currentCollegeId . "=\"" . $college['costs']['at_home']['out_of_state_tuition'] . "\";\n";
				//Tuition Commuting
				$jsForCosts.="var tuitionCO" . $currentCollegeId . "=\"" . $college['costs']['off_campus']['in_state_tuition'] . "\";\n";
			}


			//Room and Board On Campus
			$jsForCosts.="var roomBoardOC" . $currentCollegeId . "=\"" . $college['costs']['on_campus']['room_and_board'] . "\";\n";

			//Room and Board At Home
			$jsForCosts.="var roomBoardAH" . $currentCollegeId . "=\"" . $college['costs']['at_home']['room_and_board'] . "\";\n";

			//Room and Board Commuting
			$jsForCosts.="var roomBoardCO" . $currentCollegeId . "=\"" . $college['costs']['off_campus']['room_and_board'] . "\";\n";
			$jsForCosts.="var comprehensiveTuition" . $currentCollegeId . "=\"0\";\n";
		}

		//Books and Supplies On Campus
		$jsForCosts.="var booksSuppliesOC" . $currentCollegeId . "=\"" . $college['costs']['on_campus']['books_and_supplies'] . "\";\n";

		//Books and Supplies At Home
		$jsForCosts.="var booksSuppliesAH" . $currentCollegeId . "=\"" . $college['costs']['at_home']['books_and_supplies'] . "\";\n";

		//Books and Supplies Commuting
		$jsForCosts.="var booksSuppliesCO" . $currentCollegeId . "=\"" . $college['costs']['off_campus']['books_and_supplies'] . "\";\n";

		//Personal Expenses On Campus
		$jsForCosts.="var persExpOC" . $currentCollegeId . "=\"" . $college['costs']['on_campus']['estimated_personal_expenses'] . "\";\n";

		//Personal Expenses At Home
		$jsForCosts.="var persExpAH" . $currentCollegeId . "=\"" . $college['costs']['at_home']['estimated_personal_expenses'] . "\";\n";

		//Personal Expenses Commuting
		$jsForCosts.="var persExpCO" . $currentCollegeId . "=\"" . $college['costs']['off_campus']['estimated_personal_expenses'] . "\";\n";

		//Transportation Expenses On Campus
		$jsForCosts.="var transExpOC" . $currentCollegeId . "=\"" . $college['costs']['on_campus']['estimated_transportation_expenses'] . "\";\n";

		//Transportation Expenses At Home
		$jsForCosts.="var transExpAH" . $currentCollegeId . "=\"" . $college['costs']['at_home']['estimated_transportation_expenses'] . "\";\n";

		//Transportation Expenses Commuting
		$jsForCosts.="var transExpCO" . $currentCollegeId . "=\"" . $college['costs']['off_campus']['estimated_transportation_expenses'] . "\";\n";
	}

	//Average percent of need met
	$pctgNeedMet = $college['financial_aid']['stats']['percent_of_need_met'];
	if ($pctgNeedMet == null)
		$jsForCosts.="var pctgNeedMet" . $currentCollegeId . "=0;\n";
	else
		$jsForCosts.="var pctgNeedMet" . $currentCollegeId . "=" . (int)$pctgNeedMet / 100 . ";\n";

	//Average financial aid package
	$avgFinAidPkg = $college['financial_aid']['stats']['average_1st_year_financial_aid_package'];

	//Average need-based loan
	$avgNeedBasedLoan = $college['financial_aid']['stats']['avg_need_based_loan'];

	//Average need-based scholarship or grant
	$avgNeedBasedSchol = $college['financial_aid']['stats']['avg_need_based_scholarship_or_grant_award'];

	//Average non-need award
	$avgNonNeed = $college['financial_aid']['stats']['avg_non_need_based_aid'];
	if ($avgNonNeed == null)
		$jsForCosts.="var nonNeedAid" . $currentCollegeId . "=0;\n";
	else
		$jsForCosts.="var nonNeedAid" . $currentCollegeId . "=" . $avgNonNeed . ";\n";

	//Scholarships/Grants
	$scholarshipsGrants = $college['financial_aid']['stats']['percent_of_scholarship_grants'];
	if ($scholarshipsGrants == null)
		$jsForCosts.="var giftAidPctg" . $currentCollegeId . "=0;\n";
	else
		$jsForCosts.="var giftAidPctg" . $currentCollegeId . "=" . $scholarshipsGrants / 100 . ";\n";

	//Loans/Work-Study
	$loansWorkStudy = $college['financial_aid']['stats']['percent_of_loans_jobs'];
	if ($loansWorkStudy == null)
		$jsForCosts.="var selfHelpAidPctg" . $currentCollegeId . "=0;\n";
	else
		$jsForCosts.="var selfHelpAidPctg" . $currentCollegeId . "=" . $loansWorkStudy / 100 . ";\n";

	//SAT Math

	$satMath = $college['median_scores']['sat']['math']['low'] . " - " . $college['median_scores']['sat']['math']['high'];
	if ($college['median_scores']['sat']['math']['low'] == null || $college['median_scores']['sat']['math']['high'] == null)
		$satMath="Not reported";

	//SAT Verbal
	$satVerbal = $college['median_scores']['sat']['reading']['low'] . " - " . $college['median_scores']['sat']['reading']['high'];
	if ($college['median_scores']['sat']['reading']['low'] == null || $college['median_scores']['sat']['reading']['high'] == null)
		$satVerbal="Not reported";

	//SAT Writing
	$satWriting = $college['median_scores']['sat']['writing']['low'] . " - " . $college['median_scores']['sat']['writing']['high'];
	if ($college['median_scores']['sat']['writing']['low'] == null || $college['median_scores']['sat']['writing']['high'] == null)
		$satWriting="Not reported";

	//ACT
	$act = $college['median_scores']['act']['composite']['low'] . " - " . $college['median_scores']['act']['composite']['high'];
	if ($college['median_scores']['act']['composite']['low'] == null || $college['median_scores']['act']['composite']['high'] == null)
		$act="Not reported";

	//calculate percentages
	if ($studentSatMath==null)
	{
		$studentSatMathPctg="";
		$studentSatMathPrint="&nbsp;";
	}
	else
	{
		$studentSatMathPctg=calculatePercentage($satMath,$studentSatMath);
		$studentSatMathPrint=$studentSatMath;
	}

	if ($studentSatVerbal==null)
	{
		$studentSatVerbalPctg="";
		$studentSatVerbalPrint="&nbsp;";
	}
	else
	{
		$studentSatVerbalPctg=calculatePercentage($satVerbal,$studentSatVerbal);
		$studentSatVerbalPrint=$studentSatVerbal;
	}

	if ($studentSatWriting==null)
	{
		$studentSatWritingPctg="";
		$studentSatWritingPrint="&nbsp;";
	}
	else
	{
		$studentSatWritingPctg=calculatePercentage($satWriting,$studentSatWriting);
		$studentSatWritingPrint=$studentSatWriting;
	}

	if ($studentActScore==null)
	{
		$studentActPctg="";
		$studentActScorePrint="&nbsp;";
	}
	else
	{
		$studentActPctg=calculatePercentage($act,$studentActScore);
		$studentActScorePrint=$studentActScore;
	}

	//$studentSatMathPctg=calculatePercentage($satMath,$studentSatMath);
	//$studentSatVerbalPctg=calculatePercentage($satVerbal,$studentSatVerbal);
	//$studentSatWritingPctg=calculatePercentage($satWriting,$studentSatWriting);
	//$studentActPctg=calculatePercentage($act,$studentActScore);
	$satScorePctg=($studentSatMathPctg+$studentSatVerbalPctg)/2;

	if (($studentSatMath==null || $studentSatVerbal==null) && ($satMath!="Not reported" && $satVerbal!="Not reported") && ($studentActScore!=null && $act=="Not reported"))
	{
		$satMathArray=explode(" - ", $satMath);
		$satMathLow=$satMathArray[0];
		$satMathHigh=$satMathArray[1];
		$satVerbalArray=explode(" - ", $satVerbal);
		$satVerbalLow=$satVerbalArray[0];
		$satVerbalHigh=$satVerbalArray[1];
		$satHighLow=((int)$satMathLow+(int)$satVerbalLow) . " - " . ((int)$satMathHigh+(int)$satVerbalHigh);

		$convertedSatScore=getSatBasedOnAct($studentActScore);
		$scorePctg=calculatePercentage($satHighLow, $convertedSatScore);
		$scorePctgPrint=$scorePctg . "%";
		$printBasedOn="(Based on ACT score of $studentActScore<br>conversion to SAT score of $convertedSatScore";
	}
	else if ($studentActScore==null && $act!="Not reported" && (($studentSatMath!=null && $studentSatVerbal!=null) && ($satMath=="Not reported" && $satVerbal=="Not reported")))
	{
		$combinedSat=((int)$studentSatMath+(int)$studentSatVerbal);
		$convertedActScore=getActBasedOnSat($combinedSat);
		$scorePctg=calculatePercentage($act, $convertedActScore);
		$scorePctgPrint=$scorePctg . "%";
		$printBasedOn="(Based on SAT score of $combinedSat<br>conversion to ACT score of $convertedActScore";
	}
	//if (($satScorePctg=="0" || strtolower($satScorePctg)=="not reported") && ($studentActPctg=="0" || strtolower($studentActPctg)=="not reported"))
	else if (($satScorePctg=="0" || $satScorePctg=="" || $satScorePctg=="Not reported") && ($studentActPctg=="0" || $studentActPctg=="" || $studentActPctg=="Not reported"))
	{
		$scorePctg="0";
		$scorePctgPrint="Not available";
		$printBasedOn="";
	}
	else
	{
		if ($satScorePctg>$studentActPctg)
		{
			$scorePctg=$satScorePctg;
			$scorePctgPrint=$scorePctg . "%";
			$printBasedOn="(Based on SAT Scores";
		}
		else
		{
			$scorePctg=$studentActPctg;
			$scorePctgPrint=$scorePctg . "%";
			$printBasedOn="(Based on ACT Score";
		}
	}

	if ($gpaPercentile!="" && $gpa!="Not reported" && $gpa!="&nbsp;")
	{
		//$scorePctg=($scorePctg*.6)+($gpaPercentile*.4);
		$scorePctg=($scorePctg*($testPctg/100))+($gpaPercentile*($gpaPctg/100));
		$scorePctgPrint=$scorePctg . "%";
		$printBasedOn.="<br>and GPA";
	}

	if ($scorePctg!="0")
	{
		$scorePctg=($inState ? $scorePctg : ($privatePublic=="public" ? $scorePctg+$outOfStatePctIncrease : $scorePctg));
		$scorePctg=($minorityStudent ? $scorePctg+$minorityPctIncrease : $scorePctg);
		if ($scorePctg>100)
			$scorePctg=100;
		$scorePctgPrint=$scorePctg . "%";
	}

	if ($printBasedOn!="")
		$printBasedOn.=")";

	if ($scorePctg==0)
		$jsForCosts.="var aidPctg" . $currentCollegeId . "=0;\n";
	else if ($scorePctg>=$scorePctgForAid1)
		$jsForCosts.="var aidPctg" . $currentCollegeId . "=1;\n";
	else if ($scorePctg>=$scorePctgForAid2)
		$jsForCosts.="var aidPctg" . $currentCollegeId . "=.8;\n";
	else if ($scorePctg>=$scorePctgForAid3)
		$jsForCosts.="var aidPctg" . $currentCollegeId . "=.6;\n";
	else if ($scorePctg>=$scorePctgForAid4)
		$jsForCosts.="var aidPctg" . $currentCollegeId . "=.4;\n";
	else if ($scorePctg<$scorePctgForAid4)
		$jsForCosts.="var aidPctg" . $currentCollegeId . "=.3;\n";

	$admLikelihood="<div class=\"crsSmall\">Safety<br>Target<br>Possible<br>Reach<br>Far Reach</div>";
	$bullseyeGif="bullseyeColored.gif";
	if ($scorePctg!=0)
	{
		//if ($scorePctg>=85)
		if ($scorePctg>=$safetyPctg)
		{
			$admLikelihood="<div class=\"crsLarge\">Safety</div><div class=\"crsSmall\">Target<br>Possible<br>Reach<br>Far Reach</div>";
			$bullseyeGif="bullseyeSafety.gif";
		}
		//else if ($scorePctg>=73)
		else if ($scorePctg>=$targetPctg)
		{
			$admLikelihood="<div class=\"crsSmall\">Safety</div><div class=\"crsLarge\">Target</div><div class=\"crsSmall\">Possible<br>Reach<br>Far Reach</div>";
			$bullseyeGif="bullseyeTarget.gif";
		}
		//else if ($scorePctg>=52)
		else if ($scorePctg>=$possiblePctg)
		{
			$admLikelihood="<div class=\"crsSmall\">Safety<br>Target</div><div class=\"crsLarge\">Possible</div><div class=\"crsSmall\">Reach<br>Far Reach</div>";
			$bullseyeGif="bullseyePossible.gif";
		}
		//else if ($scorePctg>=40)
		else if ($scorePctg>=$reachPctg)
		{
			$admLikelihood="<div class=\"crsSmall\">Safety<br>Target<br>Possible</div><div class=\"crsLarge\">Reach</div><div class=\"crsSmall\">Far Reach</div>";
			$bullseyeGif="bullseyeReach.gif";
		}
		else
		{
			$admLikelihood="<div class=\"crsSmall\">Safety<br>Target<br>Possible<br>Reach</div><div class=\"crsLarge\">Far Reach</div>";
			$bullseyeGif="bullseyeFarReach.gif";
		}
	}
	else
		$admLikelihood="<div class=\"crsLarge\">Not available</div>";

	$links="";
	if ($requestInfoUrl!="" && $applyOnlineUrl!="")
		$links="<br><a class=\"crsWhite\" href=\"" . $requestInfoUrl . "\" target=\"_blank\">Request More Info</a> | <a class=\"crsWhite\" href=\"" . $applyOnlineUrl . "\" target=\"_blank\">Apply Online</a>";
	else
	{
		if ($requestInfoUrl!="")
			$links="<br><a class=\"crsWhite\" href=\"" . $requestInfoUrl . "\" target=\"_blank\">Request More Info</a>";
		if ($applyOnlineUrl!="")
			$links="<br><a class=\"crsWhite\" href=\"" . $applyOnlineUrl . "\" target=\"_blank\">Apply Online</a>";
	}



	$onclickFunction="hide(" . $currentCollegeId . ");";
	if ($mode=="miniReport")
		$onclickFunction="window.open('','_self');window.close();";

	//Header Section
	if ($mode!="miniReport")
		echo "<div id=\"divCollege" . $currentCollegeId . "\" style=\"page-break-before:always;\">\n";
	echo "<table width=\"100%\" border=\"0\" class=\"collSelRepHeader\">\n\t<tr>\n";
	//echo "\t\t<td align=\"left\" valign=\"top\" class=\"crsLargeWhite\">" . $collegeName . "</td>\n";
	echo "\t\t<td align=\"left\" valign=\"top\" width=\"67%\"><div class=\"crsLargeWhite\">" . $collegeName . "</div><div class=\"crsSmallWhite\">" . $cityState . "</td></td>\n";
	//echo "\t\t<td align=\"right\" class=\"crsSmallWhite\">" . $cityState . "<br><a class=\"crsWhite\" href=\"http://" . $url . "/\" target=\"_blank\">" . $url . "</a>" . $links . "</td>\n";
	//echo "\t\t<td align=\"right\" class=\"crsSmallWhite\">" . $cityState . $url . $links . "</td>\n";
	echo "\t\t<td align=\"right\" valign=\"top\" class=\"crsSmallWhite\">" . $url . $links . "</td>\n";
	echo "\t\t<td align=\"right\" valign=\"top\" width=\"1%\" class=\"crsLargeWhite\"><input type=\"button\" name=\"btnClose" . $currentCollegeId . "\" id=\"btnClose" . $currentCollegeId . "\" class=\"crsCloseButton\" value=\" X \" onclick=\"" . $onclickFunction . "\"></td>\n";
	echo "\t</tr>\n</table>\n";

	//Report Section
	echo "<table width=\"100%\" border=\"0\" class=\"collSelRepInfo\">\n\t<tr>\n\t\t<td>\n";

	//Test Score Breakdown Sub-Section
	echo "\t\t\t<table width=\"100%\" border=\"1\">\n";
	echo "\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t<td>&nbsp;</td>\n\t\t\t\t\t<td align=\"center\"><b>Average Freshman Profile</b></td>\n\t\t\t\t\t<td align=\"center\"><b>" . $studentName . "'s Profile</b></td>\n\t\t\t\t\t<td align=\"center\" width=\"275\"><b>Percentile</b></td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t<td height=\"30\">SAT Math</td>\n\t\t\t\t\t<td align=\"center\">" . $satMath . "</td>\n\t\t\t\t\t<td align=\"center\">" . $studentSatMathPrint . "</td>\n\t\t\t\t\t<td width=\"275\">" . createGraphHtml($studentSatMathPctg, $studentSatMath, 200, 800, $satMath) . "\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t<td height=\"30\">SAT Verbal</td>\n\t\t\t\t\t<td align=\"center\">" . $satVerbal . "</td>\n\t\t\t\t\t<td align=\"center\">" . $studentSatVerbalPrint . "</td>\n\t\t\t\t\t<td width=\"275\">" . createGraphHtml($studentSatVerbalPctg, $studentSatVerbal, 200, 800, $satVerbal) . "\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t<td height=\"30\">SAT Writing</td>\n\t\t\t\t\t<td align=\"center\">" . $satWriting . "</td>\n\t\t\t\t\t<td align=\"center\">" . $studentSatWritingPrint . "</td>\n\t\t\t\t\t<td width=\"275\">" . createGraphHtml($studentSatWritingPctg, $studentSatWriting, 200, 800, $satWriting) . "\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t<td height=\"30\">ACT</td>\n\t\t\t\t\t<td align=\"center\">" . $act . "</td>\n\t\t\t\t\t<td align=\"center\">" . $studentActScorePrint . "</td>\n\t\t\t\t\t<td width=\"275\">" . createGraphHtml($studentActPctg, $studentActScore, 0, 36, $act) . "\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t<td height=\"30\">GPA</td>\n\t\t\t\t\t<td align=\"center\">" . $gpa . "</td>\n\t\t\t\t\t<td align=\"center\">" . $studentGpa . "</td>\n\t\t\t\t\t<td width=\"275\" align=\"center\">" . ($gpaPercentile==0 ? "&nbsp;" : ("<a href=\"http://collegesearch.collegeboard.com/search/CollegeDetail.jsp?collegeId=" . $collegeBoardId . "&profileId=0\" class=\"crsBlue\" target=\"_blank\">" . $gpaPercentile . "%</a>")) . "</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t</table>\n\t\t</td>\n\t</tr>\n";

	//Reported Costs Sub-Section
	$inOutState="-State Tuition";
	if ($inState==true)
		$inOutState="In" . $inOutState;
	else
		$inOutState="Out-of" . $inOutState;

	echo "\t<tr>\n\t\t<td align=\"left\">\n";
	//echo "\t\t\t<table border=\"0\" width=\"100%\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\" valign=\"top\">Housing Status\n\t\t\t\t\t<br>\n\t\t\t\t\t<select name=\"lstHousing" . $currentCollegeId . "\" onchange=\"lstHousing_onChange(this.name,this.value)\">\n\t\t\t\t\t\t<option value=\"OC\">Living On-Campus</option>\n\t\t\t\t\t\t<option value=\"AH\">Living at Home</option>\n\t\t\t\t\t\t<option value=\"CO\">Commuting, Not Living at Home</option>\n\t\t\t\t\t\t</select>\n\t\t\t\t\t</td>\n";
	//echo "\t\t\t<table border=\"0\" width=\"100%\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\" valign=\"top\">\n\t\t\t\t\t\t<table border=\"0\">\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td align=\"left\" valign=\"top\">\n\t\t\t\t\t\t\t\t\t<u>Housing Status</u><br>\n\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"radHousing" . $currentCollegeId . "\" id=\"radHousing" . $currentCollegeId . "\" onclick=\"radHousing_onClick(this.name,this.value)\" value=\"OC\" checked>Living On-Campus<br>\n\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"radHousing" . $currentCollegeId . "\" id=\"radHousing" . $currentCollegeId . "\" onclick=\"radHousing_onClick(this.name,this.value)\" value=\"AH\">Living at Home<br>\n\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"radHousing" . $currentCollegeId . "\" id=\"radHousing" . $currentCollegeId . "\" onclick=\"radHousing_onClick(this.name,this.value)\" value=\"CO\">Commuting, Not Living at Home\n\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t</table>\n\t\t\t\t\t</td>\n";
	echo "\t\t\t<table border=\"0\" width=\"100%\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td align=\"center\" valign=\"top\">\n\t\t\t\t\t\t<u>Housing Status</u>\n\t\t\t\t\t\t<table border=\"0\">\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td align=\"left\" valign=\"top\">\n\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"radHousing" . $currentCollegeId . "\" id=\"radHousing" . $currentCollegeId . "\" onclick=\"radHousing_onClick(this.name,this.value)\" value=\"OC\" checked>Living On-Campus<br>\n\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"radHousing" . $currentCollegeId . "\" id=\"radHousing" . $currentCollegeId . "\" onclick=\"radHousing_onClick(this.name,this.value)\" value=\"AH\">Living at Home<br>\n\t\t\t\t\t\t\t\t\t<input type=\"radio\" name=\"radHousing" . $currentCollegeId . "\" id=\"radHousing" . $currentCollegeId . "\" onclick=\"radHousing_onClick(this.name,this.value)\" value=\"CO\">Commuting, Not Living at Home\n\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t</table>\n";
	//echo "\t\t\t\t\t<td align=\"center\" valign=\"top\">\n\t\t\t\t\t<br>\n\t\t\t\t\t\t<table border=\"1\">\n\t\t\t\t\t\t\t<tr>\n";
	echo "\t\t\t\t\t\t<table border=\"1\">\n\t\t\t\t\t\t\t<tr class=\"tr1\">\n";

	if ($comprehensiveTuition)
		echo "\t\t\t\t\t\t\t\t<td align=\"right\" valign=\"bottom\">Comprehensive Fee<br>(tuition, fees, room and board)</td>\n\t\t\t\t\t\t\t\t<td align=\"right\" valign=\"bottom\" width=\"100\"><div id=\"divTuition" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n";
	else
	{
		echo "\t\t\t\t\t\t\t\t<td align=\"right\" valign=\"bottom\">" . $inOutState . "</td>\n\t\t\t\t\t\t\t\t<td align=\"right\" valign=\"bottom\" width=\"100\"><div id=\"divTuition" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n";
		echo "\t\t\t\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t\t\t\t<td align=\"right\">Room and Board</td>\n\t\t\t\t\t\t\t\t<td align=\"right\"><div id=\"divRoomBoard" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n";
	}
	echo "\t\t\t\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t\t\t\t<td align=\"right\">Books and Supplies</td>\n\t\t\t\t\t\t\t\t<td align=\"right\"><div id=\"divBooksSupplies" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n";
	echo "\t\t\t\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t\t\t\t<td align=\"right\">Estimated Personal Expenses</td>\n\t\t\t\t\t\t\t\t<td align=\"right\"><div id=\"divPersExp" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n";
	echo "\t\t\t\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t\t\t\t<td align=\"right\">Transportation Expense</td>\n\t\t\t\t\t\t\t\t<td align=\"right\"><div id=\"divTransExp" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n";
	echo "\t\t\t\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t\t\t\t<td align=\"right\"><b>Total Cost</b></td>\n\t\t\t\t\t\t\t\t<td align=\"right\"><div id=\"divTotalCost" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t</table>\n\t\t\t\t\t</td>\n";
	//echo "\t\t\t\t\t</td>\n\t\t\t\t<td valign=\"top\"><table width=\"100%\" border=\"0\"><tr><td align=\"center\" valign=\"top\">Estimated Percentile<br><div class=\"crsLarge\">$scorePctgPrint</div>$printBasedOn<br><br>Admission Likelihood<br><div class=\"crsLarge\">$admLikelihood</div></td></tr></table></td>\t\t\t\t</tr>\n";
	//echo "\t\t\t\t\t</td>\n\t\t\t\t<td valign=\"top\" align=\"center\">Estimated Percentile<br><div class=\"crsLarge\">$scorePctgPrint</div>$printBasedOn<br><br>Admission Likelihood<br><div class=\"crsLarge\">$admLikelihood</div></td>\t\t\t\t</tr>\n";
	//echo "\t\t\t\t\t</td>\n\t\t\t\t\t<td valign=\"top\" align=\"center\">\n\t\t\t\t\t\t<u>Estimated Percentile</u><br>\n\t\t\t\t\t\t<div class=\"crsLarge\">$scorePctgPrint</div>$printBasedOn<br><br>\n\t\t\t\t\t\t<u>Admission Likelihood</u><br>\n\t\t\t\t\t\t<div id=\"divAdmLikelihood" . $currentCollegeId . "\">$admLikelihood";
	echo "\t\t\t\t\t<td valign=\"top\" align=\"center\">\n\t\t\t\t\t\t<u>Estimated Percentile</u><br>\n\t\t\t\t\t\t<div class=\"crsLarge\">$scorePctgPrint</div>$printBasedOn\n\t\t\t\t\t</td>\n";
	echo "\t\t\t\t\t<td valign=\"top\" align=\"center\">\n\t\t\t\t\t\t<u>Admission Likelihood</u><br>\n\t\t\t\t\t\t<div id=\"divAdmLikelihood" . $currentCollegeId . "\">$admLikelihood";

	if ($userType=="A")
		echo "<a href=\"javascript:changeAdmLikelihood(" . $currentCollegeId . ");\" class=\"crsTiny\">Change</a>";

	//echo "</div><div id=\"divNewAdmLikelihood" . $currentCollegeId . "\" style=\"display:none;\"><input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"S\">Safety<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"T\">Target<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"P\">Possible<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"R\">Reach<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"F\">Far Reach<br>\n\t\t\t\t\t\t<input type=\"button\" name=\"btnOkAdm" . $currentCollegeId . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOkAdm_onclick(this);\"></div>\n\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
	//echo "</div><div id=\"divNewAdmLikelihood" . $currentCollegeId . "\" style=\"display:none;\"><input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"S\">Safety<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"T\">Target<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"P\">Possible<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"R\">Reach<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"F\">Far Reach<br>\n\t\t\t\t\t\t<input type=\"button\" name=\"btnOkAdm" . $currentCollegeId . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOkAdm_onclick(this);\"></div>\n\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
	echo "<br><img src=\"../images/" . $bullseyeGif . "\" border=\"0\" width=\"150\" height=\"150\"></div><div id=\"divNewAdmLikelihood" . $currentCollegeId . "\" style=\"display:none;\"><input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"S\">Safety<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"T\">Target<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"P\">Possible<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"R\">Reach<br>\n\t\t\t\t\t\t<input type=\"radio\" id=\"radNewAdmLikelihood" . $currentCollegeId . "\" name=\"radNewAdmLikelihood" . $currentCollegeId . "\" value=\"F\">Far Reach<br>\n\t\t\t\t\t\t<input type=\"button\" name=\"btnOkAdm" . $currentCollegeId . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOkAdm_onclick(this);\"></div>\n\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t</table>\n";
	echo "\t\t</td>\n\t</tr>\n";

	//Cost of Attendance
	//$sql="SELECT PROFILE, NONCUSTODIAL, IDOC FROM TPROFILE_COLLEGE WHERE COLLEGE_ID=$currentCollegeId";
	$sql="SELECT PROFILE, NONCUSTODIAL, IDOC FROM TCOLLEGE_PROFILE_SCHOOLS WHERE COLLEGE_ID=$currentCollegeId";
	$result=mysql_query($sql);

	$profile = $college['financial_aid']['requirements']['css_profile'];
	$noncustodial = $college['financial_aid']['requirements']['noncustodial_profile'];
	$idoc = $college['financial_aid']['requirements']['idoc'];

	//EFC
	//echo "\t<tr>\n\t\t<td width=\"5%\" valign=\"top\">EFC:</td>\n\t\t<td><input type=\"radio\" name=\"radEfc" . $currentCollegeId . "\" id=\"radEfc" . $currentCollegeId . "\" onclick=\"radEfc_onclick(this.name, this.value);\" value=\"FM\" checked>Federal: $<span id=\"spnEfcFm" . ($i+1) . "\">" . number_format($federalEfc) . " <a href=\"javascript:changeEfcFm(" . ($i+1) . ");\" class=\"crsTiny\">Change</a></span><span id=\"spnNewEfcFm" . ($i+1) . "\" style=\"display:none;\"><input type=\"text\" name=\"txtNewEfcFm" . ($i+1) . "\" id=\"txtNewEfcFm" . ($i+1) . "\" size=\"6\" maxlength=\"7\"> <input type=\"button\" name=\"btnOkEfcFm" . ($i+1) . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOkEfcFm_onclick(" . ($i+1) . ");\"></span>\n</td>\n\t\t</tr>\n";
	echo "<tr><td><table width=\"100%\" border=\"0\"><tr><td width=\"5%\">&nbsp;</td><td width=\"5%\" valign=\"top\"><u>EFC:</u></td>\n\t\t\t\t\t<td valign=\"top\"><input type=\"radio\" name=\"radEfc" . $currentCollegeId . "\" id=\"radEfc" . $currentCollegeId . "\" onclick=\"radEfc_onclick(this.name, this.value);\" value=\"FM\" checked>Federal: $<span id=\"spnEfcFm" . ($i+1) . "\">" . number_format($federalEfc) . " <a href=\"javascript:changeEfcFm(" . ($i+1) . ");\" class=\"crsTiny\">Change</a></span><span id=\"spnNewEfcFm" . ($i+1) . "\" style=\"display:none;\"><input type=\"text\" name=\"txtNewEfcFm" . ($i+1) . "\" id=\"txtNewEfcFm" . ($i+1) . "\" size=\"6\" maxlength=\"7\"> <input type=\"button\" name=\"btnOkEfcFm" . ($i+1) . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOkEfcFm_onclick(" . ($i+1) . ");\"></span>\n";
	//echo "\t<tr>\n\t\t<td>&nbsp;</td>\n\t\t<td><input type=\"radio\" name=\"radEfc" . $currentCollegeId . "\" id=\"radEfc" . $currentCollegeId . "\" onclick=\"radEfc_onclick(this.name, this.value);\" value=\"IM\">Institutional: $<span id=\"spnEfcIm" . ($i+1) . "\">" . number_format($institutionalEfc) . " <a href=\"javascript:changeEfcIm(" . ($i+1) . ");\" class=\"crsTiny\">Change</a></span><span id=\"spnNewEfcIm" . ($i+1) . "\" style=\"display:none;\"><input type=\"text\" name=\"txtNewEfcIm" . ($i+1) . "\" id=\"txtNewEfcIm" . ($i+1) . "\" size=\"6\" maxlength=\"7\"> <input type=\"button\" name=\"btnOkEfcIm" . ($i+1) . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOkEfcIm_onclick(" . ($i+1) . ");\"></span>";
	echo "<br><input type=\"radio\" name=\"radEfc" . $currentCollegeId . "\" id=\"radEfc" . $currentCollegeId . "\" onclick=\"radEfc_onclick(this.name, this.value);\" value=\"IM\">Institutional: $<span id=\"spnEfcIm" . ($i+1) . "\">" . number_format($institutionalEfc) . " <a href=\"javascript:changeEfcIm(" . ($i+1) . ");\" class=\"crsTiny\">Change</a></span><span id=\"spnNewEfcIm" . ($i+1) . "\" style=\"display:none;\"><input type=\"text\" name=\"txtNewEfcIm" . ($i+1) . "\" id=\"txtNewEfcIm" . ($i+1) . "\" size=\"6\" maxlength=\"7\"> <input type=\"button\" name=\"btnOkEfcIm" . ($i+1) . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOkEfcIm_onclick(" . ($i+1) . ");\"></span>\n";

	echo "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"crsSmall\"><b>Required Forms: ";

	if ($profile==true && $noncustodial==true && $idoc==true)
		echo "FAFSA, CSS Profile, Non-Custodial Profile, IDOC";
	else if ($profile==true && $noncustodial==true && $idoc==false)
		echo "FAFSA, CSS Profile, Non-Custodial Profile";
	else if ($profile==false && $noncustodial==true && $idoc==true)
		echo "FAFSA, Non-Custodial Profile, IDOC";
	else if ($profile==true && $noncustodial==false && $idoc==true)
		echo "FAFSA, CSS Profile, IDOC";
	else if ($profile==true && $noncustodial==false && $idoc==false)
		echo "FAFSA, CSS Profile";
	else if ($profile==false && $noncustodial==true && $idoc==false)
		echo "FAFSA, Non-Custodial Profile";
	else if ($profile==false && $noncustodial==false && $idoc==true)
		echo "FAFSA, IDOC";
	else
		echo "FAFSA";

	echo "</b></span>";

	//echo "</td>\n\t</tr>\n";
	echo "\n\t\t\t\t\t</td>\n";
	//echo "\t<tr>\n\t\t<td colspan=\"2\">\n\t\t\t<table border=\"0\">\n";
	echo "\t\t\t\t\t<td valign=\"top\">\n\t\t\t\t\t\t<table border=\"0\">\n";
	echo "\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td align=\"right\">Cost of Attendance</td>\n\t\t\t\t\t\t\t\t<td align=\"center\">-</td>\n\t\t\t\t\t\t\t\t<td align=\"center\">EFC</td>\n\t\t\t\t\t\t\t\t<td align =\"left\">= Need</td>\n\t\t\t\t\t\t\t</tr>\n";
	echo "\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td align=\"right\"><div id=\"divCostAtt" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t\t<td align=\"center\">-</td>\n\t\t\t\t\t\t\t\t<td align=\"left\"><div id=\"divEfc" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t\t<td align=\"left\"><div id=\"divNeed" . $currentCollegeId . "\"</div></td>\n\t\t\t\t\t\t\t</tr>\n";
	echo "\t\t\t\t\t\t</table>\n\t\t\t\t\t</td>\n\t\t\t\t\t<td width=\"5%\">&nbsp;</td>\n\t\t\t\t</tr>\n\t\t\t</table>\n\t\t</td>\n\t</tr>\n";

	//Aid Package
	echo "\t<tr>\n\t\t<td>\n\t\t\t<table width=\"100%\" border=\"1\">\n";
	echo "\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t<td>&nbsp;</td>\n\t\t\t\t\t<td align=\"center\"><b>Average Aid</b></td>\n";
	//echo "\t\t\t\t\t<td rowspan=\"8\" valign=\"center\" align=\"center\">";
	echo "\t\t\t\t\t<td rowspan=\"8\" align=\"center\">\n\t\t\t\t\t\t<b>Estimated Projected Aid<br><div class=\"crsSmall\">(based on applicant pool)</div></b>\n\t\t\t\t\t\t<div id=\"divTotalAid" . $currentCollegeId . "\" style=\"font-weight:bold;\">&nbsp;</div><br>\n";
	echo "\t\t\t\t\t\t<table width=\"100%\" border=\"0\">\n\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t<td width=\"50%\" align=\"center\"><div id=\"divGiftAidLabel" . $currentCollegeId . "\" style=\"font-weight:bold;\">Gift Aid</div><div id=\"divGiftAid" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t\t<td width=\"50%\" align=\"center\"><div id=\"divSelfHelpAidLabel" . $currentCollegeId . "\" style=\"font-weight:bold;\">Self-Help Aid</div><div id=\"divSelfHelpAid" . $currentCollegeId . "\">&nbsp;</div></td>\n\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t</table>\n";
	echo "\t\t\t\t\t</td>\n\t\t\t\t</tr>";
	echo "\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t<td>Total Aid Package</td>\n\t\t\t\t\t<td align=\"center\">$$avgFinAidPkg</td>\n";
	echo "\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t<td>Non-Need-Based Aid</td>\n\t\t\t\t\t<td align=\"center\">$$avgNonNeed</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t<td>Need-Based Loans</td>\n\t\t\t\t\t<td align=\"center\">$$avgNeedBasedLoan</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t<td>Need-Based Grant/Scholarship</td>\n\t\t\t\t\t<td align=\"center\">$$avgNeedBasedSchol</td>\n";
	echo "\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t<td>Percent of Need Met</td>\n\t\t\t\t\t<td align=\"center\"><div id=\"divPctgNeedMet" . $currentCollegeId . "\">$pctgNeedMet";

	if ($userType=="A")
		echo "<br><a href=\"javascript:changePctgNeedMet(" . $currentCollegeId . ");\" class=\"crsTiny\">Change</a>";

	echo "</div><div id=\"divNewPctgNeedMet" . $currentCollegeId . "\" style=\"display:none;\"><input type=\"text\" id=\"txtNewPctgNeedMet" . $currentCollegeId . "\" name=\"txtNewPctgNeedMet" . $currentCollegeId . "\" size=\"2\" maxlength=\"3\">% <input type=\"button\" name=\"btnOk" . $currentCollegeId . "\" class=\"crsButton\" value=\"OK\" onclick=\"btnOk_onclick(this);\"></div></td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr1\">\n\t\t\t\t\t<td>Percent of Gift Aid (Scholarships/Grants)</td>\n\t\t\t\t\t<td align=\"center\">$scholarshipsGrants</td>\n\t\t\t\t</tr>\n";
	echo "\t\t\t\t<tr class=\"tr2\">\n\t\t\t\t\t<td>Percent of Self-Help Aid (Loans/Work-Study)</td>\n\t\t\t\t\t<td align=\"center\">$loansWorkStudy</td>\n\t\t\t\t</tr>\n\t\t\t</table>\n";
	echo "\t\t</td>\n\t</tr>\n";

	if ($mode!="miniReport")
	{
		//Comparable Schools
		echo "\t<tr>\n\t\t<td valign=\"top\" class=\"crsLarge\">Comparable Schools to Consider for Aid Opportunities:</td>\n\t</tr>\n\t<tr>\n\t\t<td>\n";
		echo "\t\t\t<table width=\"100%\">\n\t\t\t\t<tr>\n\t\t\t\t\t<td width=\"50%\" valign=\"top\">\n";

		$checkBoxes="chk".$currentCollegeId;
		$compSchools=$_POST[$checkBoxes];

		if ($compSchools!=null)
		{
			echo "\t\t\t\t\t\t<ul>\n";

			$howManySchools=count($compSchools);
			$howManyInColumn1=1;

			if ($howManySchools%2==0)
				$howManyInColumn1=$howManySchools/2;
			else
				$howManyInColumn1=round($howManySchools/2);

			for ($j=0; $j<$howManySchools; $j++)
			{
				$compSchoolArray=explode("^", $compSchools[$j]);
				$compSchoolName=$compSchoolArray[0];
				$compSchoolId=$compSchoolArray[1];

				if ($j==$howManyInColumn1)
					echo "\t\t\t\t\t\t</ul>\n\t\t\t\t\t</td>\n\t\t\t\t\t<td width=\"50%\" valign=\"top\">\n\t\t\t\t\t\t<ul>\n";

				echo "\t\t\t\t\t\t\t<li><a href=\"javascript:openMiniReport('" . $compSchoolId . "');\" class=\"crsBlue\">" . $compSchoolName . "</a></li>\n";
			}

			echo "\t\t\t\t\t\t</ul>\n";
		}
		else
			echo "\t\t\t\t\t\tNone Selected\n";

		echo "\t\t\t\t\t</td>\n\t\t\t\t</tr>\n";
		echo "\t\t\t</table>\n";
		echo "\t\t</td>\n\t</tr>\n";

		//Notes
		//echo "\t<tr>\n\t\t<td align=\"center\"><hr width=\"90%\">Notes<br><textarea name=\"txtNotes" . $currentCollegeId . "\" rows=\"5\" cols=\"75\">" . $_SESSION["notes".$currentCollegeId] . "</textarea></td>\n\t</tr>\n";
		//echo "\t<tr>\n\t\t<td align=\"center\">Notes<br><textarea name=\"txtNotes" . $currentCollegeId . "\" rows=\"15\" cols=\"75\">" . $_SESSION["notes".$currentCollegeId] . "</textarea></td>\n\t</tr>\n";
		echo "\t<tr>\n\t\t<td align=\"center\"><span class=\"crsMedium\">Notes</span><br><div id=\"divNotesTextarea" . $currentCollegeId . "\">" . ($notes=="" ? "" : "<div style=\"text-align:left;margin-left:100px;margin-right:100px;\">") . $notes . ($notes=="" ? "" : "</div>") . "<textarea name=\"txtNotes" . $currentCollegeId . "\" id=\"txtNotes" . $currentCollegeId . "\" rows=\"15\" cols=\"75\">" . $_SESSION["notes".$currentCollegeId] . "</textarea></div></td>\n\t</tr>";
		echo "\t<tr>\n\t\t<td><div id=\"divNotes" . $currentCollegeId . "\" style=\"background-color:#FFFFFF;padding:10px;width:100%;display:none;border:2px black solid;\"></div></td>\n\t</tr>\n";
	}

	echo "</table>\n";

	if ($mode!="miniReport")
		echo "</div>";

	$jsForCosts.="var need" . $currentCollegeId . "=0;\n";
	$jsForCosts.="var cbNotes" . $currentCollegeId . "=\"" . $notes . "\";\n";
}
if ($mode!="miniReport")
	echo "<input type=\"hidden\" name=\"hidCollegeNotes\" value=\"" . $collegeIds . "\">";

if ($mode!="miniReport")
	include("collegeChoiceReportFooter.php");

include("../../commonPhp/mySqlClose.php");
?>


</form>

</div>

<!--</div>-->

<script language="JavaScript" type="text/javascript">
<!--
<?php
$jsForCosts.="var collegeIds=\"" . $collegeIds . "\";\n";
echo $jsForCosts;
?>
-->
</script>

<?php
include_once '../../commonPhp/crsNewFooter.php';
?>
