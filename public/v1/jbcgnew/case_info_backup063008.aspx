<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>

<%@ Import Namespace="System.Net.Mail" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<html>
  <head>
	<title><!--#include file="./title.aspx"--></title>
	<!--#include file="./globalFunctions.aspx"-->
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	<script language="C#" runat="server">
	DataSet data;
	
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern") {
			Response.Redirect("./nopriv.aspx");
		}
		//only runs the following code the first time this page loads
		if(!Page.IsPostBack) {
			Session["cancel"] = "";
			Session["view"] = "three";
		}
	}

    private void sendInfo()
    {
        string crlf = "<br>";
        string t = Request["date"] + " " + Request["hour"] + ":" + Request["min"] + " " + Request["ap"];
        string claimid = Session["id"].ToString();
        string locationid = Request["location"];
        DataSet l = getMssqlData("SELECT name FROM locations WHERE id = '" + locationid + "'");
        locationid = l.Tables[0].Rows[0]["name"].ToString();
        /* table:   parent
         * cols:        client_name
         *              col0015
         *              col0018
         * 
         * parent:  parent1
         * cols:        col0015
         * 
         * parent:  data
         * cols:        col0007
         *              col0009
         *              col0010
         *              col0011
         *              col0013
         *              student_name
         *              col0018
         *              col0020
         * 
         */
        string sql = "SELECT col0002 + ' ' + col0004 as [student_name],col0007,col0009,col0010,col0011,col0013,col0018,col0020 FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["id"];
        DataSet data = getMssqlData(sql);
        
        sql = "SELECT col0002 + ' ' + col0004 as [client_name],col0015,col0018 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + Session["id"];
        DataSet parent = getMssqlData(sql);

        sql = "SELECT col0015 FROM " + Session["mainParentTable"] + " WHERE [id] = 2 AND [claimid] = " + Session["id"];
        DataSet parent1 = getMssqlData(sql);

        string mailBody = "Appointment Info:" + crlf +
            crlf + "Client Name = " + parent.Tables[0].Rows[0]["client_name"] +
            crlf + "Parent's Email Address = " + parent.Tables[0].Rows[0]["col0018"] +
            crlf + "Student Address = " + data.Tables[0].Rows[0]["col0007"] +
            crlf + "Student City = " + data.Tables[0].Rows[0]["col0009"] +
            crlf + "Student State = " + data.Tables[0].Rows[0]["col0010"] +
            crlf + "Student Zip = " + data.Tables[0].Rows[0]["col0011"] +
            crlf + "Home Phone = " + data.Tables[0].Rows[0]["col0013"] +
            crlf + "Father's Work Phone = " + parent.Tables[0].Rows[0]["col0015"] +
            crlf + "Mother's Work Phone = " + parent1.Tables[0].Rows[0]["col0015"] +
            crlf + "Appointment Time = " + t + " " + locationid +
            crlf + "ID = " + claimid +
            crlf + "Student Name = " + data.Tables[0].Rows[0]["student_name"] +
            crlf + "Student's High School = " + data.Tables[0].Rows[0]["col0018"] +            
            crlf + "Student Grad Year = " + data.Tables[0].Rows[0]["col0020"];
        
        //MailMessage msg = new MailMessage();
        //msg.To = "info@college-retirement.com";
        //msg.From = "info@college-retirement.com";
        //msg.Subject = "Contact Info For " + parent.Tables[0].Rows[0]["client_name"] + " ID # " + claimid;
        //msg.BodyFormat = MailFormat.Html;
        //msg.Body = mailBody;
        //SmtpMail.Send(msg);
        ExecuteHtmlSendMail("info@college-retirement.com", "info@college-retirement.com", "Contact Info For " + parent.Tables[0].Rows[0]["client_name"] + " ID # " + claimid, mailBody, "");
    }

    private static void ExecuteHtmlSendMail(string FromAddress, string ToAddress, string Subject, string BodyText, string BCC)
    {
        MailMessage mailMsg = new MailMessage();

        mailMsg.From = new MailAddress(FromAddress);
        mailMsg.To.Add(new MailAddress(ToAddress));
        mailMsg.Subject = Subject;
        if (BCC != null && BCC != "")
            mailMsg.Bcc.Add(BCC);
        mailMsg.BodyEncoding = System.Text.Encoding.GetEncoding("utf-8");

        System.Net.Mail.AlternateView plainView = System.Net.Mail.AlternateView.CreateAlternateViewFromString
        (System.Text.RegularExpressions.Regex.Replace(BodyText, @"<(.|\n)*?>", string.Empty), null, "text/plain");
        System.Net.Mail.AlternateView htmlView = System.Net.Mail.AlternateView.CreateAlternateViewFromString(BodyText, null, "text/html");

        mailMsg.AlternateViews.Add(plainView);
        mailMsg.AlternateViews.Add(htmlView);

        // Smtp configuration
        SmtpClient smtp = new SmtpClient();
        smtp.Host = "mail.college-retirement.com";

        smtp.Send(mailMsg);
    }      
	        	
	private void scheduleAppointment(Object obj, EventArgs args) {
        message.Text = "";
		string t = Request["date"] + " " + Request["hour"] + ":" + Request["min"] + " " + Request["ap"];
		DataSet tmp = getMssqlData("SELECT * FROM appointments WHERE claimid = '" + Session["id"] + "' AND status = 'Y'");
		if(tmp.Tables.Count > 0) {
			if(tmp.Tables[0].Rows.Count > 0) {
				message.Text = "** You can only have one active appointment. **";
				return;
			}
		}
		try{
			Convert.ToDateTime(t);
		}catch{
			message.Text = "** The date/time you submitted is invalid. **";
			return;
		}
		try {
			string sql = "INSERT INTO appointments (claimid,userid,appointment,locationid,status,pending) VALUES('" + Session["id"] + "','" + Session["userid"] + "','" + t + "','" + Request["location"] + "','Y','1');";
			getMssqlData(sql);

//			sql = "UPDATE " + Session["mainDataTable"] + " SET [status] = 'Scheduled' WHERE [id] = " + Session["id"];
//			sql = "UPDATE " + Session["mainDataTable"] + " SET [status] = 'Scheduled', nextApptDate = '" + t + "', nextApptLocationid = '" + Request["location"] + "' WHERE [id] = " + Session["id"];

			// update appointment and location listing in main record
			sql = "UPDATE " + Session["mainDataTable"] + " SET nextApptDate = '" + t + "', nextApptLocationid = '" + Request["location"] + "' WHERE [id] = " + Session["id"];
			getMssqlData(sql);
			// only change status to Scheduled if not payment authorized
			sql = "UPDATE " + Session["mainDataTable"] + " SET [status] = 'Scheduled' WHERE [id] = " + Session["id"] + " AND [status] != 'Payment Authorized'";
			getMssqlData(sql);
			Session["state"] = "list";
          
            // Set variables
            string clientName, email, location, AdvisorName = null;
            string sqlStr = null;
            string sAttach = null;
            string claimid = Session["id"].ToString();
            string locationid = Request["location"];
            int hour = Convert.ToInt32(Request["hour"]);
            string emailFrom = "auto-confirm@college-retirement.com";
            string sBody1 = "<b>Thank you for scheduling your free no-obligation consultation with "; 
            string sBody = "<a href=\"http://www.college-retirement.com/learnmore.html\">Click here</a> to learn more about what you can expect " +
                        "of this evaluation from College and Retirement Solutions.<br><br><b>Below is the link to our Data Form. Please complete it and return it to us no less than one day in advance of your meeting, so that an analyst may have time to properly prepare for your meeting and make the best use of your time.</b> ";
            string sBody2 = "Sensitive information can be left blank.<br>" + 
                        "<br><center><font size=5>&raquo; <b><a href=\"http://www.college-retirement.com/onlinedataform/DataForm.aspx?ID=" + claimid + "\">Data Form for your Evaluation</a></b> &laquo;</font></center><br>";
/*            
            string sBody = "<a href=\"http://www.college-retirement.com/learnmore.html\">Click here</a> to learn more about what you can expect " +
                        "of this evaluation from College and Retirement Solutions.<br><br><b>Attached is the client data form (in two different formats) " +
                        "that must be completed ";
            string sBody2 = "Use whichever one you can open.  Social Security numbers or other sensitive information can be left blank. ";   
*/            
            string sBody3 = "please contact us at 973-514-2002 at least 48 hours in advance.</b><br><br>We look forward to meeting with you! " +
                        " <br><br>Sincerely, <br>";
            string appt = "Your evaluation is set for: <br><br><center><font size=5 color=CC6666> " + t;
            string sFooter = "<br>---------------------------------------------------------------------------------------------- <br>" +
                        "<font size=1>If investment, financial or insurance planning or products are required, College and Retirement " +
                        "Solutions, LLC (CRS) may refer you to one of its affiliates, including The Ziering Insurance Agency.  Any " +
                        "discussion of the tax implications of planning is strictly for general purposes.  Neither CRS nor its " +
                        "representatives may give specific tax advice.  Advice and counsel should be sought out from their accountant " +
                        "and/or tax advisor for information regarding their own particular situation.</font><br><br>" +
                        "<font color=red><b>*** DO NOT REPLY TO THIS MESSAGE.  THIS IS AN AUTOMATIC EMAIL NOTIFICATION. IF YOU NEED TO CONTACT US, " +
                        "PLEASE EMAIL US AT info@college-retirement.com TO ENSURE YOUR MESSAGE IS DELIVERED ***</font><b>";
            
            sqlStr = "SELECT * FROM " + Session["mainDataTable"] + " WHERE id = " + claimid;
            DataSet mfac_data = getMssqlData(sqlStr);
            
            // Advisor Name
		    if (mfac_data.Tables[0].Rows[0]["userid"].ToString() != "") {
			    sqlStr = "SELECT name FROM users WHERE userid = '" + mfac_data.Tables[0].Rows[0]["userid"] + "'";
			    DataSet repdata = getMssqlData(sqlStr);
			    AdvisorName = repdata.Tables[0].Rows[0]["name"].ToString();
                if (mfac_data.Tables[0].Rows[0]["userid"].ToString() == "34") 
                {
                    AdvisorName = AdvisorName + ", CCPS<br>President";
                }
            }
                       
            sqlStr = "SELECT col0002 + ' ' + col0004 as [client_name],col0018 FROM " + Session["mainParentTable"] + " WHERE id = 1 AND claimid = " + claimid;
            DataSet parent = getMssqlData(sqlStr);
            // Parent Name and Email
            clientName = parent.Tables[0].Rows[0]["client_name"].ToString();
            email = parent.Tables[0].Rows[0]["col0018"].ToString();

            // Location
            DataSet l = getMssqlData("SELECT name FROM locations WHERE id = '" + locationid + "'");
            location = l.Tables[0].Rows[0]["name"].ToString();
             
            // 12-13-06 Sending email confirmation out automatically
            //MailMessage msg = new MailMessage();
            string msgTo, msgFrom, msgSubject, msgBody = null;
            
            
            if (email == "")
            {
                msgTo = "info@college-retirement.com";
                msgFrom = emailFrom;
                msgSubject = "Need to Schedule Appt Manually: [id = " + claimid + "]";
                msgBody = "There is no email in the database for client [" + clientName + "].  The claim id is [" + claimid +
                    "]. The Representative for this case is [" + AdvisorName + "]. Please get the email so we can send the " +
                    "client a confirmation email. The appointment is scheduled for " + t + ".  Location = " + location + ".";
            }
            else
            {
//                switch (locationid)
//                {
//                    case "1":
//                        sAttach = "CRS_RedBank.pdf";
//                        break;
//                    case "3":
//                        /* sAttach = "MFAC_Saddlebrook.pdf"; */
//                        break;
//                    case "4":
//                        sAttach = "CRS_Chatham.pdf";
//                        break;
//                    case "7":
//                        /* sAttach = "MFAC_Mahwah.pdf"; */
//                        break;
//                    case "12":
//                        sAttach = "CRS_Edison.pdf";
//                        break;
//                    //case "13":
//                        // 12-7-06 For appointment via web
//                        //sAttach = "Forms.pdf";     
//                        //break;
//                }
//                MailAttachment myAttachment = new MailAttachment(Server.MapPath(sAttach));
//                msg.Attachments.Add(myAttachment);
                switch (locationid)
                {
                    case "1":
                        sAttach = "<a href=\"http://www.college-retirement.com/Files/Directions/CRS_RedBank.pdf\">Click Here</a> for directions to our Red Bank office.";
                        break;
                    case "4":
                        sAttach = "<a href=\"http://www.college-retirement.com/Files/Directions/CRS_Chatham.pdf\">Click Here</a> for directions to our Chatham office.";
                        break;
                    case "12":
                        sAttach = "<a href=\"http://www.college-retirement.com/Files/Directions/CRS_Edison.pdf\">Click Here</a> for directions to our Edison office.";
                        break;
                }
                
                msgTo = email;
                //msg.Bcc = "info@college-retirement.com";
                msgFrom = emailFrom;
                msgSubject = "Appointment Confirmation on " + t;
                //msg.BodyFormat = MailFormat.Html;
                if (locationid == "13")
                {
                    // msg.Attachments.Add (new MailAttachment(Server.MapPath("dataform.xls")));
                    // web meeting email confirm
                    msgBody = "Dear " + clientName + ",<br><br>" +
                        sBody1 + "College and Retirement Solutions. " + appt + " on the Web.</font></center></b><br>" +
                        "<b>You will receive a web link and a phone call with instructions on how to access the meeting 1-2 days before " +
                        "your scheduled appointment.</b><br><br>" + sBody +
                        sBody2 + "In the mean time, please fill out the data form. " +
                        "If you need to reschedule for any reason, " + sBody3 + AdvisorName + sFooter;
                }
                else
                {
//                    msg.Attachments.Add(new MailAttachment(Server.MapPath("Forms.pdf")));
//                    msg.Attachments.Add (new MailAttachment(Server.MapPath("dataform.xls")));
                    msgBody = "Dear " + clientName + ",<br><br>" +
                         sBody1 + "our college planning specialist at College and Retirement Solutions, LLC. " + appt + " in " + location 
                         + ", NJ</font></center></b><br>" +
                        "<i>This appointment will take about an hour, and it is designed to measure your expected college costs. </i>" + sBody +
                        sBody2 + sAttach + " " +
                        "<b> If you have any questions or concerns, or you need to reschedule your appointment, " + sBody3 + AdvisorName + sFooter;
                }

            } 
            //SmtpMail.Send(msg);
            ExecuteHtmlSendMail(msgFrom, msgTo, msgSubject, msgBody, "info@college-retirement.com");
            sendInfo();
            message.Text = "A confirmation email (" + email + ") has been sent to " + clientName + ".";   
		}catch(Exception e){
			message.Text = "** Could not submit appointment. **<br>" + e.Message + "<br>" + t;
			return;
		}
	}

	private void cancelAppointment(Object obj, EventArgs args) {
		Session["cancel"] = Request["cancel"];
		return;
	}

	private void backAppointment(Object obj, EventArgs args) {
		Session["cancel"] = "";
		return;
	}

	private void updateDB(Object obj, EventArgs args) {
		message.Text = "";
		if(Request["reason"] == null || Request["reason"] == "") {
			message.Text = "** You must submit follow up notes to close. **";
			Session["cancel"] = Request["id"];
			return;
		}else{
			string sql = "UPDATE appointments SET status = 'N', apptstatus='" + Request["apptstatus"] + "', apptclient='" + Request["apptclient"] + "', note = '" + Request["reason"].Replace("'","''") + "', cancelledBy = '" + Session["userid"] + "' WHERE claimid = '" + Session["id"] + "' AND id = '" + Request["id"] + "';";
			getMssqlData(sql);
			Session["cancel"] = "";
		}
	}

	private void toggleGrid(Object sender, EventArgs e) {

		if(Session["view"].ToString() == "three") {
			Session["view"] = "entire";
		}else{
			Session["view"] = "three";
		}
	}
    	</script>
  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/case_review_menu/nav.aspx"-->
<form method="post" runat="server">

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<%

		//string sql = "SELECT tax_bracket, estimated_income, parents_own_home, self_employed, father_work_phone_ext, mother_work_phone_ext,sibling_information, client_last_name + ',' + client_first_name as client_name, parent_email_address as pea, student_last_name + ',' + student_first_name as student_name,";
		//sql += " student_street_address, student_city, student_state, student_zip, home_phone, student_high_school,";
		//sql += " student_grad_year, student_high_school_city, student_high_school_state, father_work_phone, mother_work_phone, cast(month(seminar_date) as varchar) + '/' + cast(day(seminar_date) as varchar) + '/' + cast(year(seminar_date) as varchar) as [seminar_date], seminar_interest FROM mfac_client_data WHERE id='" + Session["id"] + "'";
		//DataSet data = getMssqlData(sql);
	

		string sql = "SELECT userid,status,tax_bracket,est_income,col0004 + ',' + col0002 as [student_name],col0007,col0009,col0010,col0011,col0013,col0018,col0020,student_hs_city,student_hs_state,seminar_date FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["id"];
		//DataSet data = getMssqlData(sql);
		data = getMssqlData(sql);

		string Repname;
		if (data.Tables[0].Rows[0]["userid"].ToString() != "") {
			sql = "SELECT name FROM users WHERE userid = '" + data.Tables[0].Rows[0]["userid"] + "'";
			DataSet repdata = getMssqlData(sql);
			Repname = repdata.Tables[0].Rows[0]["name"].ToString();
		} else {
			Repname = "Lead Not Assigned";
		}

		sql = "SELECT col0004 + ',' + col0002 as [client_name],col0015,col0016,col0018,col0024,col0037 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + Session["id"];
		DataSet parent = getMssqlData(sql);
		

		sql = "SELECT col0015,col0016 FROM " + Session["mainParentTable"] + " WHERE [id] = 2 AND [claimid] = " + Session["id"];
		DataSet parent1 = getMssqlData(sql);

		sql = "SELECT TOP 1 note FROM notes WHERE [claimid] = " + Session["id"] + " ORDER BY [id] ASC";
		DataSet note = getMssqlData(sql); 
		%>
		<table border="0" cellpadding="2" cellspacing="2" align="center" valign="top" width="70%">
		<tr>
			<td width="50%"><font class="red">Client Name:</font>&nbsp;<font class="black"><%= parent.Tables[0].Rows[0]["client_name"] %></font></td>
			<% if(data.Tables[0].Rows[0]["col0020"].ToString() == "0") { %>
				<td width="50%"><font class="red">Student Grad Year:</font>&nbsp;<font class="black"></font></td>
			<% }else{ %>
				<td width="50%"><font class="red">Student Grad Year:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0020"] %></font></td>
			<% } %>
		</tr><tr>
			<td><font class="red">Student Name:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["student_name"] %></font></td>
			<td><font class="red">Student's High School:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0018"] %></font></td>
		</tr><tr>
			<td><font class="red">Parent's Email Address:</font>&nbsp;<font class="black"><%= parent.Tables[0].Rows[0]["col0018"] %></font></td>
			<td><font class="red">Student High School City:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["student_hs_city"] %></font></td>
		</tr><tr>
			<td><font class="red">Student Address:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0007"] %></font></td>
			<td><font class="red">Student High School State:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["student_hs_state"] %></font></td>
		</tr><tr>
			<td><font class="red">Student City:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0009"] %></font></td>
			<% if(parent1.Tables[0].Rows[0]["col0015"].ToString() == "0") { %>
				<td><font class="red">Mother's Work Phone:</font>&nbsp;<font class="black"></font></td>
			<% }else{ %>
				<td><font class="red">Mother's Work Phone:</font>&nbsp;<font class="black"><%= parent1.Tables[0].Rows[0]["col0015"] %>&nbsp;Ext.<%= parent1.Tables[0].Rows[0]["col0016"] %></font></td>
			<% } %>
		</tr><tr>
			<td><font class="red">Student State:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0010"] %></font></td>
			<% if(parent.Tables[0].Rows[0]["col0015"].ToString() == "0") { %>
				<td><font class="red">Father's Work Phone:</font>&nbsp;<font class="black"></font></td>
			<% }else{ %>
				<td><font class="red">Father's Work Phone:</font>&nbsp;<font class="black"><%= parent.Tables[0].Rows[0]["col0015"] %>&nbsp;Ext.<%= parent.Tables[0].Rows[0]["col0016"] %></font></td>
			<% } %>
		</tr><tr>
			<td><font class="red">Student Zip:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0011"] %></font></td>
			<% 
				try {
					DateTime dt = Convert.ToDateTime(data.Tables[0].Rows[0]["seminar_date"].ToString());
			%>
					<td><font class="red">Seminar Date:</font>&nbsp;<font class="black"><%= dt.ToShortDateString() %></font></td>
			<%
				}catch{
			%>
					<td><font class="red">Seminar Date:</font>&nbsp;<font class="black"></font></td>
			<%
				}
			%>
		</tr><tr>
			<td><font class="red">Home Phone:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0013"] %></font></td>
			<td><font class="red">Own Home:</font>&nbsp;<font class="black"><%= parent.Tables[0].Rows[0]["col0024"] %></font></td>
		</tr><tr>
			<td><font class="red">Self Employed:</font>&nbsp;<font class="black"><%= parent.Tables[0].Rows[0]["col0024"] %></font></td>
			<td><font class="red">Estimated Income:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["est_income"] %></font></td>
		</tr><tr>
			<td><font class="red">Tax Bracket:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["tax_bracket"] %></font></td>
			<td><font class="red">Assigned To:</font>&nbsp;<font class="black"><%= Repname %></font></td>
		</tr>
		<% if(note.Tables[0].Rows[0]["note"].ToString() != "") { %>
		<tr>
			<td colspan="2" align="center"><font class="black">Sibling Information</font></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><font class="black"><%= note.Tables[0].Rows[0]["note"] %></font></td>
		</tr>
		<% } %>
		</table>
		
		<br>
		<table border="0" cellpadding="4" cellspacing="2" align="center" valign="top" width="100%">
		<tr height="20">
			<td colspan="2"></td>
		</tr>
		<%
		if(data.Tables[0].Rows[0]["status"].ToString() != "New Lead") {

		DataSet tmp = getMssqlData("SELECT appointments.*,users.name,locations.name as lname FROM appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' AND status='Y'");
		if(tmp.Tables.Count > 0) {
			if(tmp.Tables[0].Rows.Count > 0) {
				if(Session["cancel"].ToString() != "") {
					Session["cancel"] = "";
					Session["state"] = "cancel";
				}else{
					Session["state"] = "list";
				}
			}else{
				Session["state"] = "new";
			}
		}else{
			Session["state"] = "new";
		}
		
		if(Session["state"].ToString() == "list") { %>
			<tr>
				<td colspan="2" align="center"><font class="black">Upcoming Appointment</font></td>
			</tr>
			<tr class="grey">
				<td colspan="2" align="center">

				<table cellspacing="0" cellpadding="3" align="center" bordercolor="Black" border="1" bgcolor="White" width="100%">
				<tr bgcolor="#4A3C8C">
					<td><font class="white">Appointment Time</font></td>
					<td><font class="white">Scheduled By</font></td>
					<td><font class="white">Location</font></td>
					<td><font class="white">Status</font></td>
					<td><font class="white">Client</font></td>
					<td>&nbsp;</td>
				</tr>
				<tr bgcolor="#E7E7FF">
					<td><font class="blacksm"><%= tmp.Tables[0].Rows[0]["appointment"] %></font></td>
					<td><font class="blacksm"><%= tmp.Tables[0].Rows[0]["name"] %></font></td>
					<td><font class="blacksm"><%= tmp.Tables[0].Rows[0]["lname"] %></font></td>
					<td><select name=apptstatus><%= selectBox(Request["apptstatus"],"apptstatus") %></select></td>
					<td><select name=apptclient><%= selectBox(Request["apptclient"],"apptclient") %></select></td>
					<td align="center">
						<input type="hidden" name="id" value="<%= tmp.Tables[0].Rows[0]["id"] %>">
						<asp:button id="Cancel" text="Close" runat="server" onClick="cancelAppointment"/>
					</td>
				</tr>
				</table>
		<% }else if(Session["state"].ToString() == "new") { %>
			<tr>
				<td colspan="2" align="center"><font class="black">Schedule Appointment</font></td>
			</tr>
			<tr>
				<td colspan="2" align="center">

				<table border="0" cellpadding="4" cellspacing="0" align="center" width="70%">	
				<tr>
					<td width="25%"><font class="black">Date</font></td>
					<td><input type="text" name="date" size="10" maxlength="10" value="<%= Request["date"] %>"> &nbsp;&nbsp;&nbsp;&nbsp;<font class="black">MM / DD / YYYY</font></td>
				</tr>
				<tr>
					<td><font class="black">Time</font></td>
					<td>
						<select name="hour">
						<% if(Request["hour"] == "1") { %>
							<option value="1" selected>1</option>
						<% }else{ %>
							<option value="1">1</option>
						<% } %>

						<% if(Request["hour"] == "2") { %>
							<option value="2" selected>2</option>
						<% }else{ %>
							<option value="2">2</option>
						<% } %>

						<% if(Request["hour"] == "3") { %>
							<option value="3" selected>3</option>
						<% }else{ %>
							<option value="3">3</option>
						<% } %>

						<% if(Request["hour"] == "4") { %>
							<option value="4" selected>4</option>
						<% }else{ %>
							<option value="4">4</option>
						<% } %>

						<% if(Request["hour"] == "5") { %>
							<option value="5" selected>5</option>
						<% }else{ %>
							<option value="5">5</option>
						<% } %>

						<% if(Request["hour"] == "6") { %>
							<option value="6" selected>6</option>
						<% }else{ %>
							<option value="6">6</option>
						<% } %>

						<% if(Request["hour"] == "7") { %>
							<option value="7" selected>7</option>
						<% }else{ %>
							<option value="7">7</option>
						<% } %>

						<% if(Request["hour"] == "8") { %>
							<option value="8" selected>8</option>
						<% }else{ %>
							<option value="8">8</option>
						<% } %>

						<% if(Request["hour"] == "9") { %>
							<option value="9" selected>9</option>
						<% }else{ %>
							<option value="9">9</option>
						<% } %>

						<% if(Request["hour"] == "10") { %>
							<option value="10" selected>10</option>
						<% }else{ %>
							<option value="10">10</option>
						<% } %>

						<% if(Request["hour"] == "11") { %>
							<option value="11" selected>11</option>
						<% }else{ %>
							<option value="11">11</option>
						<% } %>

						<% if(Request["hour"] == "12") { %>
							<option value="12" selected>12</option>
						<% }else{ %>
							<option value="12">12</option>
						<% } %>
						</select>
						&nbsp;
						<select name="min">
						<% if(Request["min"] == "00") { %>
							<option value="00" selected>00</option>
						<% }else{ %>
							<option value="00">00</option>
						<% } %>

						<% if(Request["min"] == "15") { %>
							<option value="15" selected>15</option>
						<% }else{ %>
							<option value="15">15</option>
						<% } %>

						<% if(Request["min"] == "30") { %>
							<option value="30" selected>30</option>
						<% }else{ %>
							<option value="30">30</option>
						<% } %>

						<% if(Request["min"] == "45") { %>
							<option value="45" selected>45</option>
						<% }else{ %>
							<option value="45">45</option>
						<% } %>
						</select>
						&nbsp;
						<select name="ap">
						<% if(Request["ap"] == "AM") { %>
							<option value="AM" selected>AM</option>
							<option value="PM">PM</option>
						<% }else{ %>
							<option value="AM">AM</option>
							<option value="PM" selected>PM</option>
						<% } %>
						</select>
						&nbsp;
						<select name="location">
						<% tmp = getMssqlData("SELECT * FROM locations");
						for(int i = 0; i < tmp.Tables[0].Rows.Count; i++) { %>
							<% if(Request["location"] == tmp.Tables[0].Rows[i]["name"].ToString()) { %>
								<option selected value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"] %></option>
							<% }else{ %>
								<option value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"] %></option>
							<% } %>
						<% } %>
						</select>
					</td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<asp:button id="schedule" text="Schedule" runat="server" onClick="scheduleAppointment"/>
					</td>
				</tr>
				</table>
		<% }else if(Session["state"].ToString() == "cancel") { %>
			<tr>
				<td colspan="2" align="center"><font class="black">Close Appointment</font></td>
			</tr>
			<tr class="grey">
				<td colspan="2" align="center">

				<table border="1" cellpadding="4" cellspacing="0" align="center" width="95%">
				<tr bgcolor="#4A3C8C">
					<td><font class="white">Time</font></td>
					<td><font class="white">Scheduled By</font></td>
					<td><font class="white">Location</font></td>
					<td><font class="white">Status</font></td>
					<td><font class="white">Client</font></td>
				</tr>
				<tr bgcolor="#E7E7FF">
					<td><font class="blacksm"><%= tmp.Tables[0].Rows[0]["appointment"] %></font></td>
					<td><font class="blacksm"><%= tmp.Tables[0].Rows[0]["name"] %></font></td>
					<td>
						<font class="blacksm"><%= tmp.Tables[0].Rows[0]["lname"] %></font>
						<input type="hidden" name="id" value="<%= tmp.Tables[0].Rows[0]["id"] %>">
					</td>
					<td><select name=apptstatus><%= selectBox(Request["apptstatus"],"apptstatus") %></select></td>
					<td><select name=apptclient><%= selectBox(Request["apptclient"],"apptclient") %></select></td>

				</tr>
				<tr bgcolor="#FFFFFF">
					<td colspan="5" align="center">
						<font class="black">Appointment Notes:</font>&nbsp;
						<input type="text" name="reason" size="35" maxlength="255">
					</td>
				</tr>
				<tr bgcolor="#E7E7FF">
					<td colspan="5" align="center">
						<asp:button id="backdb" text="Back" runat="server" onClick="backAppointment"/>
						<asp:button id="canceldb" text="Confirm" runat="server" onClick="updateDB"/>
					</td>
				</tr>
				</table>
		<% } %>

			</td>
		</tr>
		<tr height="20">
			<td colspan="2"></td>
		</tr>
		<%
			if(Session["view"].ToString() == "three") {
				tmp = getMssqlData("SELECT TOP 3 appointments.appointment [Appointment Time], users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status], appointments.apptclient as [Client], appointments.note as [Appointment Notes] FROM appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' AND status='N' ORDER BY appointments.appointment DESC;");
			}else{
				tmp = getMssqlData("SELECT appointments.appointment [Appointment Time], users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status], appointments.apptclient as [Client], appointments.note as [Appointment Notes] FROM appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' AND status='N' ORDER BY appointments.appointment DESC;");
			}

			if(tmp.Tables.Count > 0) {
				if(tmp.Tables[0].Rows.Count > 0) {
					dataView.DataSource = tmp.Tables[0].DefaultView;
					dataView.DataBind();
		%>			
		<tr>
			<td colspan="2" align="center">
				<font class="black">Appointment History</font>
		<% if(Session["view"].ToString() == "three") { %>
				(<asp:LinkButton id="entireButton" class="red" Text="Entire History" Font-Name="Verdana" Font-Size="9pt" onclick="toggleGrid" runat="server"/>)
		<% }else{ %>
				(<asp:LinkButton id="recentButton" class="red" Text="Recent History" Font-Name="Verdana" Font-Size="9pt" onclick="toggleGrid" runat="server"/>)
		<% } %>
			</td>
		</tr>
		<tr class="grey">
			<td align="center" colspan="2">

			<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
			<tr>
				<td>

				<ASP:Datagrid 
				id="dataView" 
				runat="server" 
				align="center"
				width="100%"
				allowsorting="true" 
				AllowPaging="true" 
				PageSize="25" 
				PagerStyle-Visible="true" 
				HeaderStyle-BackColor="Blue" 
				HeaderStyle-ForeColor="White" 
				BorderColor="#000000" 
				BorderStyle="None" 
				BorderWidth="1px" 
				BackColor="White" 
				CellPadding="3"
				Font-Size = "9pt"
				Font-Name = "Arial"
				>
				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>

				</td>
			</tr>
			</table>

			</td>
		</tr>
		<%		}else{ %>
					<tr class="grey">
						<td colspan="2" align="center"><font class="black">No appointment history.</font></td>
					</tr>
		<%		}
			}else{  %>
				<tr class="grey">
					<td colspan="2" align="center"><font class="black">No appointment history.</font></td>
				</tr>
		<% 	} 

		}
		%>
		<tr height="20">
			<td colspan="2"></td>
		</tr>
		</table></td>
</tr>
</table>

		<center><a href="http://www.college-retirement.com/adminCalendar2.aspx">
        Go to Admin Calendar</a></center>
</form>
<!--#include file="./footer.aspx"-->
</body>
</html>