<?php
include "includes/sessions.php";
include "includes/mysql.php";
include "includes/header.php";
include "includes/sidebar.php";

if(!isset($_GET[direct])) {
	if($_SESSION['t_sessionuser'] == "") {
        	header("Location: index.php?timeout=yes");
	}else{
        	$sql = "UPDATE member SET lastaction_time = now() WHERE id = '$_SESSION[t_sessionuser]'";
        	mysql_query($sql,$db);
	}
}

function genreferno($length){
    srand((double)microtime()*1000000);
    for($i = 0; $i < $length; $i++){
        $password .= rand(0,9);
    }
    return substr($password, 0, $length);
}

function message_user($database) {
	$package = "";

	$checkexist = "SELECT messagekey FROM message WHERE messagekey = '$id'";
	if(! $docheckexist = mysql_query($checkexist, $database) ) {
		$package = "Error in initial message key check.";
		return $package;
	}else{
		$idexist = mysql_num_rows($docheckexist);
	}

	while ($idexist > 0) {
		$id = genreferno(15);
		$checkexist = "SELECT messagekey FROM message WHERE messagekey = '$id'";
		if(! $docheckexist = mysql_query($checkexist, $database) ) {
			$package = "Error in subsequent message key check.";
			return $package;
		}else{
			$idexist = mysql_num_rows($docheckexist);
		}
	}
	
	if (empty($_POST['to'])) { 
		$package .= "Missing 'To' field.<br>"; 
	}
	if (empty($_POST['subj'])) { 
		$package .= "Missing subject.<br>"; 
	}
	if (empty($_POST['msgbody'])) { 
		$package .= "Missing message.<br>"; 
	}
	if ($_SESSION[t_username] == $_POST[to]) {
		$package .= "You can't message yourself.<br>\n";
	}
	if($package != "") {
		return $package;
	}
	
	$sendMessage = "INSERT INTO message set to_username='$_POST[to]', from_username='$_SESSION[t_username]',timestamp=now(), messagekey='$id', subject='$_POST[subj]'";
	$checkExist = "SELECT * FROM member WHERE username='$_POST[to]' AND active='Y'";
	if(! $checkResult = mysql_query($checkExist,$database) ) {
		$package = "Error checking user id.";
		return $package;
	}else{
	 	$check = mysql_num_rows($checkResult);
	}

	if ($check == 0) { 
		$package = "User doesn't exist or is no longer active.";
		return $package;
	}

	$info = mysql_fetch_array($checkResult);
	if($info[allow_public_messaging] != "Y") { 
		$package = "User does not allow public messaging.";
		return $package;
	}

      if($package != "") { 
		return $package; 
	}

      $messageResult = mysql_query($sendMessage, $database);
	if($messageResult != "1") {
		$package .= "Could not insert transaction record.";
		return $package;
	}
		
	//+++++++++++++ Send Message Email +++++++++++++++++++++++
	$theemail = $info[email];
	$subject = "$_SESSION[t_username]:$_POST[subj]";

	$message = "$info[username],\n\n
$_POST[msgbody]\n\n
$_SESSION[t_username]

Direct Reply: http://www.globalgamester.com/messageuser.php?direct=$id&subj=RE:$_POST[subj]


If this email is offensive in any way
Please contact us at info@globalgamester.com";

	$headers = "From: info@globalgamester.com";
	if(mail($theemail, $subject, $message, $headers)) {
		if(mail($info[cc_email], $subject, $message, $headers)) {
			$package = "pass";
			return $package;
		}else{
			$package = "Mail delivery failure.";
			return $package;
		}
	}else{
		$package = "Mail delivery failure.";
		return $package;
	}
}

?>
<html>
	<head>
	<title>globalgamester.com: Message User</title>
		<link rel="stylesheet" href="./css/site.css" type="text/css">

		<script language="javascript" type="text/javascript">
                	function limitText(limitField, limitCount, limitNum) {
                        if (limitField.value.length > limitNum) {
                                limitField.value = limitField.value.substring(0, limitNum);
                                limitCount.value = limitNum;
                        } else {
                                limitCount.value = limitNum - limitField.value.length;
                        }
                	}

			function SetMemberField(name) {
				document.form.to.value = name;
			}

			function PopupMemberSearch(theurl, winName, features) {
				theurl += '?qusername=' + document.form.to.value;
				window.open(theurl,winName,features);
			}

		</script>
	</head>
<body bgcolor="#000000">
	<table align="center" valign="top" border="0" cellpadding="0" cellspacing="0" width="800">
	<tr>
                <td bgcolor="#000000" colspan="2" align="left" valign="top">
			<?= print_header2($db) ?>
                </td>
	
	</tr>
	<tr>
		<td bgcolor="#ffffff" width="127" align="left" valign="top" background=./images/gradient.gif>
			<?= print_sidebar2() ?>
		</td>
		<td bgcolor="#ffffff" width="673" align="left" valign="top">

			<table border=0 align=left width=100% cellpadding=0 cellspacing=0>
			<tr>
			<td width=600 valign=top>

			<table border=0 align=left width=100% cellpadding=0 cellspacing=0>
			<tr height=25><td></td></tr>
			<tr><td>
				<div class=section><font class=sitefont color=#ffffff><b>Send a Message</b></font></div>
			</td></tr>
			<tr>
				<td align=center>
		
                        <form method="post" action="messageuser.php" id="form" name="form">
				<?
		        	if(isset($_POST[domessageuser])) {
					$temp_msg = message_user($db);
				}
				if(!isset($_POST[domessageuser])) { ?>

                        <table border=0 cellpadding=4 cellspacing=0 align=center valign=top width=60%>
	                        <tr>
      	                 		<td colspan=2>
                                	<font class=sitefont color=red><b>* All required fields are prefixed by a red asterix. *</b></font>
                               	</td>
            	            </tr>
					<? if(isset($_GET[direct])) {
						$sql = "SELECT * FROM message WHERE messagekey='$_GET[direct]'";
						$result = mysql_query($sql,$db);
						$info = mysql_fetch_array($result);
						$to = $info[from_username]; ?>
						<tr bgcolor=#eeeeee>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>To </b></span></td>
							<td><input class=sitefont type="text" name="to" value="<?= $to ?>" size="40" maxlength="40">&nbsp; <input type=button onclick="PopupMemberSearch('findmember.php','membersearch','width=420,height=450');" class=sitefont value=To></td>
						</tr>
						<tr>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Subject </b></span></td>
							<td><input class=sitefont type="text" name="subj" value="<?= $_GET[subj] ?>" size="40" maxlength="40"></td>
						</tr>  
					<? }else{
						$to = $_POST['to'];
				   		if ($_GET['to'] != '') {
							$to = $_GET['to'];
						} ?>
						<tr bgcolor=#eeeeee>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>To </b></span></td>
							<td><input class=sitefont type="text" name="to" value="<?= $to ?>" size="40" maxlength="40">&nbsp; <input type=button onclick="PopupMemberSearch('findmember.php','membersearch','width=420,height=450');" class=sitefont value='Send To'></td>
						</tr>
						<tr>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Subject </b></span></td>
                	                        <td><input class=sitefont type="text" name="subj" value="<?= $_POST[subj] ?>" size="40" maxlength="40"></td>
                        	       </tr>  
					<? } ?>
					<tr bgcolor=#eeeeee>
						<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Message</b></span></td>
						<td>
							<font size="1">(Maximum characters: 300)<br>
							<input type="hidden" name="pos" value="300">
							You have <input class=sitefont readonly type="text" name="countdown" size="3" value="300"> characters left.</font><br>
							<textarea class=sitefont name="msgbody" cols="60" rows="8" onKeyDown="limitText(this.form.msgbody,this.form.countdown,300);" onKeyUp="limitText(this.form.msgbody,this.form.countdown,300);"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan=2 align=center>
							<input type=hidden name=domessageuser value=yes>
                                        	<input class=sitefont type=submit name="messageuser" value="Send">
						</td>
					</tr>   
				</table>
				<? }
			   	if($temp_msg == "pass") { ?>

                        <table border=0 cellpadding=4 cellspacing=0 align=center valign=top width=75%>
				<tr>
					<td colspan=2 align=center>
					<font class=sitefontsm><b>Your message has been sent.</b></font>
					</td>
				</tr>
					<? if(isset($_GET[direct])) {
						$sql = "SELECT * FROM message WHERE messagekey='$_GET[direct]'";
						$result = mysql_query($sql,$db);
						$info = mysql_fetch_array($result);
						$to = $info[from_username]; ?>
						<tr bgcolor=#eeeeee>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>To </b></span></td>
							<td><input class=sitefont type="text" name="to" value="<?= $to ?>" size="40" maxlength="40">&nbsp; <input type=button onclick="PopupMemberSearch('findmember.php','membersearch','width=420,height=450');" class=sitefont value=To></td>
						</tr>
						<tr>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Subject </b></span></td>
							<td><input class=sitefont type="text" name="subj" value="<?= $_GET[subj] ?>" size="40" maxlength="40"></td>
						</tr>  
					<? }else{ ?>
						<tr bgcolor=#eeeeee>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>To </b></span></td>
							<td><input class=sitefont type="text" name="to" value="<?= $_GET[to] ?>" size="40" maxlength="40">&nbsp; <input type=button onclick="PopupMemberSearch('findmember.php','membersearch','width=420,height=450');" class=sitefont value='Send To'></td>
						</tr>
						<tr>
							<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Subject </b></span></td>
							<td><input class=sitefont type="text" name="subj" value="<?= $_POST[subj] ?>" size="40" maxlength="40"></td>
						</tr>
					<? } ?>
				<tr bgcolor=#eeeeee>
					<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Message</b></span></td>
					<td>
						<font size="1">(Maximum characters: 300)<br>
						<input type="hidden" name="pos">
						You have <input class=sitefont readonly type="text" name="countdown" size="3" value="<?= $_POST[countdown] ?>"> characters left.</font>
						<br>
						<textarea class=sitefont name="msgbody" cols="60" rows="7" onKeyDown="limitText(this.form.msgbody,this.form.countdown,300);" onKeyUp="limitText(this.form.msgbody,this.form.countdown,300);"><?= stripslashes($_POST[msgbody]) ?></textarea>
					</td>
				</tr>
				<tr>
					<td colspan=2 align=center>
						<input type=hidden name=domessageuser value=yes>
						<input class=sitefont type=submit name="messageuser" value="Send">
					</td>
				</tr>
				</table>
				<? }
			   	if($temp_msg != "pass" && isset($_POST[domessageuser])) { ?> 

                        <table border=0 cellpadding=4 cellspacing=0 align=center valign=top width=75%>
				<tr>
					<td colspan=2 align=center>
						<font class=sitefontsm color=red><b>
						<br>
						<!-- ** The information you provided is invalid. **<br> -->
						<?= $temp_msg ?></b>
						</font>
					</td>
				</tr>
				<? if(isset($_GET[direct])) {
					$sql = "SELECT * FROM message WHERE messagekey='$_GET[direct]'";
					$result = mysql_query($sql,$db);
					$info = mysql_fetch_array($result);
					$to = $info[from_username];
					?>
					<tr bgcolor=#eeeeee>
						<td align="left"><span class="sitefontsm"><b><font color=red>*</font>To </b></span></td>
						<td><input class=sitefont type="text" name="to" value="<?= $to ?>" size="40" maxlength="40">&nbsp; <input type=button onclick="PopupMemberSearch('findmember.php','membersearch','width=420,height=450');" class=sitefont value=To></td>
					</tr>
					<tr>
						<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Subject </b></span></td>
						<td><input class=sitefont type="text" name="subj" value="<?= $_GET[subj] ?>" size="40" maxlength="40"></td>
					</tr>  
				<? }else{ ?>
					<tr bgcolor=#eeeeee>
						<td align="left"><span class="sitefontsm"><b><font color=red>*</font>To </b></span></td>
						<td><input class=sitefont type="text" name="to" value="<?= $_GET[to] ?>" size="40" maxlength="40">&nbsp; <input type=button onclick="PopupMemberSearch('findmember.php','membersearch','width=420,height=450');" class=sitefont value='Send To'></td>
					</tr>
					<tr>
						<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Subject </b></span></td>
						<td><input class=sitefont type="text" name="subj" value="<?= $_POST[subj] ?>" size="40" maxlength="40"></td>
					</tr>  
				<? } ?>
				<tr bgcolor=#eeeeee>
					<td align="left"><span class="sitefontsm"><b><font color=red>*</font>Message</b></span></td>
					<td>
					<font size="1">(Maximum characters: 300)<br>
					<input type="hidden" name="pos">
					You have <input class=sitefont readonly type="text" name="countdown" size="3" value="<?= $_POST[countdown] ?>"> characters left.</font>
					<br>
					<textarea class=verdana name="msgbody" cols="60" rows="7" onKeyDown="limitText(this.form.msgbody,this.form.countdown,300);" onKeyUp="limitText(this.form.msgbody,this.form.countdown,300);"><?= stripslashes($_POST[msgbody]) ?></textarea></td>
				</tr>
				<tr>
					<td colspan=2 align=center>
					<input type=hidden name=domessageuser value=yes>
					<input class=verdana type=submit name="messageuser" value="Send">
					</td>
				</tr>
				</table>
				<? } ?>
                        </form> 
			
			</td></tr></table>

			</td>
			<td align=right>
                                <?
                                        include "includes/rightadds.php";
                                ?>
			</td></tr>
			</table>
		</td>
	</tr>
	</table>
<?
include "includes/footer.php";
?>

</body>
</html>
