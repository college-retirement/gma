<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net.Mail" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >

<script runat="server">

    //DataSet data;
    string satta = string.Empty;
    public void Page_Load()
    {
        if (Session["userid"].ToString() == "" || Session["userid"] == null)
        {
            Response.Redirect("./timeout.aspx");
        }
        if (Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern")
        {
            Response.Redirect("./nopriv.aspx");
        }
        if (!Page.IsPostBack)
        {
            Session["cancel"] = "";
            Session["view"] = "three";
           
        }
        string sql = "SELECT madison_sysdba.appointments.id as 'ID',madison_sysdba.appointments.appointment as 'Appointment Time',madison_sysdba.users.name as 'Name', madison_sysdba.locations.name as 'Location', madison_sysdba.appointments.apptstatus as 'Status',madison_sysdba.appointments.apptclient as 'Client',madison_sysdba.appointments.note as 'Appointment Notes' FROM madison_sysdba.appointments INNER JOIN madison_sysdba.users on madison_sysdba.users.userid = madison_sysdba.appointments.userid INNER JOIN madison_sysdba.locations ON madison_sysdba.appointments.locationid = madison_sysdba.locations.id WHERE claimid='" + Session["id"] + "' ORDER BY madison_sysdba.appointments.appointment DESC ";
        string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
        SqlDataAdapter sdapt = new SqlDataAdapter(sql, config);
        DataSet ds = new DataSet();
        sdapt.Fill(ds, "temp1");
        GridView1.DataSource = ds.Tables[0].DefaultView;
        GridView1.DataBind();
    }


    private void scheduleAppointment(object obj, EventArgs args)
    {
        message.Text = "";
        string t = Request["date"] + " " + Request["hour"] + ":" + Request["min"] + " " + Request["ap"];
        DataSet tmp = getMssqlData("SELECT * FROM madison_sysdba.appointments WHERE claimid = '" + Session["id"] + "' AND status = 'Y'");
        try
        {
            if (tmp.Tables.Count > 0)
            {
                if (tmp.Tables[0].Rows.Count > 0)
                {
                    message.Text = "** You can only have one active appointment. **";
                    return;
                }
            }
        }
        catch (Exception ex) 
        { 
            message.Text = "" + ex.Message; 
        }
        try
        {
            Convert.ToDateTime(t);
        }
        catch
        {
            message.Text = "** The date/time you submitted is invalid. **";
            return;
        }

        try
        {
            //Date:29/11/2007
            //Implementation to this Code: Here when we r clicking the schedule button the appointment is getting stored in database and also in gridview it is displaying.
            //according to the code on the schedule button while inserting the staus='Y' and while displaying in the grid they have given the status ='N'
            //So when page load at that time i have given in query that status='N' according to that in gridview the data will come and when clicking on schedule button it should show up in the grid 
            //so here i didnt mentioned the status in where condition so newly added appointment will be added to the database and also it will show in the grid.
            string sql = "INSERT INTO madison_sysdba.appointments(claimid,userid,appointment,locationid,status,pending) VALUES('" + Session["id"] + "','" + Session["userid"] + "','" + t + "','" + Request["location"] + "','Y','1')";
            getMssqlData(sql);//////////this commented by me
            //Showing records in the gridview.
            string sql1 = "SELECT madison_sysdba.appointments.id as 'ID',madison_sysdba.appointments.appointment as 'Appointment Time',madison_sysdba.users.name as 'Name', madison_sysdba.locations.name as 'Location', madison_sysdba.appointments.apptstatus as 'Status',madison_sysdba.appointments.apptclient as 'Client',madison_sysdba.appointments.note as 'Appointment Notes' FROM madison_sysdba.appointments INNER JOIN madison_sysdba.users on madison_sysdba.users.userid = madison_sysdba.appointments.userid INNER JOIN madison_sysdba.locations ON madison_sysdba.appointments.locationid = madison_sysdba.locations.id WHERE claimid='" + Session["id"] + "'";
            string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString();
            SqlConnection sconn = new SqlConnection(config);
            SqlDataAdapter sdapt = new SqlDataAdapter(sql1, config);
            DataSet ds = new DataSet();
            sdapt.Fill(ds, "temp1");
            GridView1.DataSource = ds.Tables[0].DefaultView;
            GridView1.DataBind();

            // update appointment and location listing in main record
            sql = "UPDATE " + Session["mainDataTable"] + " SET nextApptDate = '" + t + "', nextApptLocationid = '" + Request["location"] + "' WHERE [id] = " + Session["id"];
            getMssqlData(sql);//////////this commented by me
            //// only change status to Scheduled if not payment authorized
            sql = "UPDATE " + Session["mainDataTable"] + " SET [status] = 'Scheduled' WHERE [id] = " + Session["id"] + " AND [status] != 'Payment Authorized'";
            getMssqlData(sql);//////////this commented by me
            Session["state"] = "list";
            
            //Automatic confirmation mail has been sent to the client.
            //Variables Used for email.
            //claim id,clientname,advisor name,date and time ,loaction name.
            string claimid = Session["id"].ToString();
            string locationid = Request["location"].ToString();
            string sBody1 = "<b>Thank you for scheduling your free no-obligation consultation with ";
            string sBody = "<a href=\"http://www.college-retirement.com/learnmore.html\">Click here</a> to learn more about what you can expect " +
                        "of this evaluation from College and Retirement Solutions.<br><br><b>Attached is the client data form (in two different formats) " +
                        "that must be completed ";
            string sBody2 = "Use whichever one you can open.  Social Security numbers or other sensitive information can be left blank. ";
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
                        "PLEASE EMAIL US AT info@college-retirement.com ***</font><b>";
            DataSet ds_location = getMssqlData("Select name from madison_sysdba.locations where id='" + locationid + "'");
            string location = ds_location.Tables[0].Rows[0]["name"].ToString();
            DataSet ds_client_name = getMssqlData("select col0002 + ' ' + col0004 as [client_name],col0018 FROM " + Session["mainParentTable"] +
                " WHERE id = 1 AND claimid = " + claimid);
            string clientName = ds_client_name.Tables[0].Rows[0]["client_name"].ToString();
            string str = "select * from " + Session["mainDataTable"] + " WHERE id = " + claimid;
            DataSet mfac_data = getMssqlData(str);
            string AdvisorName = "";
            
            //Advisors name
            if (mfac_data.Tables[0].Rows[0]["userid"].ToString() != "")
            {
                string sqlStr = "SELECT name FROM madison_sysdba.users WHERE userid = '" + mfac_data.Tables[0].Rows[0]["userid"] + "'";
                DataSet repdata = getMssqlData(sqlStr);
                AdvisorName = repdata.Tables[0].Rows[0]["name"].ToString();
                if (mfac_data.Tables[0].Rows[0]["userid"].ToString() == "34")
                {
                    AdvisorName = AdvisorName + ", CCPS<br>President";
                }
            }
            MailMessage msg;
            MailAddress To_addr;
            MailAddress From_addr;
            string body = string.Empty;
            
            if (Session["clientemail"].ToString().Trim() == "")
            {
                //if no email ID of client
                To_addr = new MailAddress("info@collegeadvisorsnetwork.com");
                From_addr = new MailAddress("auto-confirm@college-retirement.com");
                msg = new MailMessage(From_addr, To_addr);
                msg.Subject = "Need to send the Appointment Manually :[id=" + claimid + "]";
                msg.Bcc.Add("gurpreet@aspirtek.com");
                //msg.Bcc.Add("shubhangi@aspirtek.com");
                msg.Bcc.Add("avinashpawar@aspirtek.com");
                string str_body = string.Empty;
                
                //string htmlstart = "<html><body>";commented by 
                //string htmlend = "</body></html>";commented by 
                sconn.Open();
                SqlCommand sc = new SqlCommand("select sbodytext,sattach from SBody where sbodynum = 'BodyTextAppointmentNoEmail" + location+"'", sconn);
                
                SqlDataReader sdr = sc.ExecuteReader();
                
                while (sdr.Read())
                {
                    str_body = sdr["sbodytext"].ToString();
                    satta = sdr["sattach"].ToString();
                }
                //following added for retriving names of attachments
                string[] name = null;
                string delimStr = ",";
                char[] delimiter = delimStr.ToCharArray();
                
                name = satta.Split(delimiter);
                if(!satta.Equals(string.Empty))
                {
                 foreach (string s in name)
                 {
                    //ListBox2.Items.Add(s);
                    
                    string path = Server.MapPath("./uploads/" + s);
                    msg.Attachments.Add(new Attachment(path));
                 }
		}
                //upto this added for retriving names of attachments
                sconn.Close();
                
                string str_b = str_body;
                if (str_b.Contains("##ClientName##"))
                {
                    str_b = str_b.Replace("##ClientName##", clientName);
                }
                if (str_b.Contains("##claimid##"))
                {
                    str_b = str_b.Replace("##claimid##", claimid);
                }
                if (str_b.Contains("##AdvisorName##"))
                {
                    str_b = str_b.Replace("##AdvisorName##", AdvisorName);
                }
                if (str_b.Contains("##location##"))
                {
                    str_b = str_b.Replace("##location##", location);
                }
                if (str_b.Contains("##appt##"))
                {
                    str_b = str_b.Replace("##appt##", t);
                }
                //msg.Body = "There is no email in the database for client [" + clientName + "].  The claim id is [" + claimid +
                //    "]. The Representative for this case is [" + AdvisorName + "]. Please get the email so we can send the " +
                //    "client a confirmation email. The appointment is scheduled for " + t + ".  Location = " + location + ".";
///////////from here onwords code is added for no email-id provided
                msg.IsBodyHtml = true;
                msg.Body = str_b;
                //msg.Body = body;
                SmtpClient mail_send = new SmtpClient();
                mail_send.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
                mail_send.Host = "localhost";
                Response.Write("Mail sent");
                mail_send.Send(msg);/////upto this is added for no email-id provided
            }
            else
            {
                string sattach = string.Empty;
                //
                //switch (locationid)
                //{
                //    case "1":
                //        sattach = "CRS_RedBank.pdf";
                //        break;
                    
                //    case "4":
                //        sattach = "CRS_Chatham.pdf";
                //        break;
                //    case "12":
                //        sattach = "CRS_Edison.pdf";
                //        break;
                //    case "13":
                //        sattach = "Forms.pdf";
                //        break;                                                                        
                //}
                
                To_addr = new MailAddress(Session["clientemail"].ToString());
                From_addr = new MailAddress("auto-confirm@college-retirement.com");
                msg = new MailMessage(From_addr, To_addr);
                
                if(sattach != string.Empty)
                {
                    msg.Attachments.Add(new Attachment(Server.MapPath(sattach)));                       
                }
                
                msg.Subject="Appointment Schedule";
                //msg.Bcc.Add("gurpreet@aspirtek.com");
                //msg.Bcc.Add("shubhangi@aspirtek.com");
                msg.Bcc.Add("avinashpawar@aspirtek.com");
                if (locationid == "13")
                {
                    msg.Attachments.Add(new Attachment(Server.MapPath("dataform.xls")));
                    // web meeting email confirm

                    string str_body1 = string.Empty;
                    string htmlstart1 = "<html><body>";
                    string htmlend1 = "</body></html>";
                    //str_body1 should be retrieved from the db it is the body in which we have to replace the client name and other paramenters.
                    string str_b1 = htmlstart1 + str_body1 + htmlend1;
                    if (str_b1.Contains("##ClientName##"))
                    {
                        str_b1 = str_b1.Replace("##ClientName##", clientName);
                    }

                    if (str_b1.Contains("##AdvisorName##"))
                    {
                        str_b1 = str_b1.Replace("##AdvisorName##", AdvisorName);
                    }
                   
                    msg.Body = "Dear " + clientName + ",<br><br>" +
                        sBody1 + "College and Retirement Solutions. " + appt + " on the Web.</font></center></b><br>" +
                        "<b>You will receive a web link and a phone call with instructions on how to access the meeting 1-2 days before " +
                        "your scheduled appointment.</b><br><br>" + sBody +
                        " prior to your meeting.</b> " + sBody2 + "Please fill out the rest of the form and do <i>one</i> of the following: <br>" +
                        "<ul><li>Email them back to us at info@college-retirement.com</li>" +
                        "<li>Fax them to (973) 514-1101.</li>" +
                        "<li>Mail them to 667 Shunpike Rd, Suite 5, Chatham, NJ 07928</li></ul>" +
                        "If you need to reschedule for any reason, " + sBody3 + AdvisorName + sFooter;
                }
                else
                {
                   // msg.Attachments.Add(new Attachment(Server.MapPath("Forms.pdf")));
                   // msg.Attachments.Add(new Attachment(Server.MapPath("dataform.xls")));
                    string str_body2 = string.Empty;
                    string htmlstart2 = "<html><body>";
                    string htmlend2 = "</body></html>";

                    string str_b2 = htmlstart2 + str_body2 + htmlend2;
                    if (str_b2.Contains("##ClientName##"))
                    {
                        str_b2 = str_b2.Replace("##ClientName##", clientName);
                    }

                    if (str_b2.Contains("##AdvisorName##"))
                    {
                        str_b2 = str_b2.Replace("##AdvisorName##", AdvisorName);
                    }

                    if (str_b2.Contains("##location##"))
                    {
                        str_b2 = str_b2.Replace("##location##", location);
                    }
                    msg.Body = "Dear " + clientName + ",<br><br>" +
                         sBody1 + "our college planning specialist at College and Retirement Solutions, LLC. " + appt + " in " + location
                         + ", NJ</font></center></b><br>" +
                        "<i>This appointment will take about an hour, and it is designed to measure your expected college costs. </i>" + sBody +
                        "and brought with you to our meeting. </b> " + sBody2 + "<br><br>Directions to our " + location + " location are also attached. " +
                        "<b> If you have any questions or concerns, or you need to reschedule your appointment, " + sBody3 + AdvisorName + sFooter;
                }
                string str_body = "Select sbodytext from sbody where sbodynum = 'BodyTextAppointmentEmail" + location + "'";
                DataTable dt_body = new DataTable();
                SqlDataAdapter dad_body = new SqlDataAdapter(str_body, config);
                dad_body.Fill(dt_body);
                sconn.Open();
                SqlCommand sc = new SqlCommand("Select sattach from sbody where sbodynum = 'BodyTextAppointmentEmail" + location + "'", sconn);
                SqlDataReader sdr = sc.ExecuteReader(CommandBehavior.CloseConnection);
                while (sdr.Read())
                {
                    //str_body = sdr["sbodytext"].ToString();
                    satta = sdr["sattach"].ToString();
                }
                //follwing has been added
                string[] name = null;
                string delimStr = ",";
                char[] delimiter = delimStr.ToCharArray();
                
                name = satta.Split(delimiter);
                if(!satta.Equals(string.Empty))
                {
                 foreach (string s in name)
                 {
                    //ListBox2.Items.Add(s);
                   
                    string path = Server.MapPath("./uploads/" + s);
                    msg.Attachments.Add(new Attachment(path));
                 }
		}	
                //upto this has been added code
                if(dt_body.Rows.Count > 0)
                {
                    body = dt_body.Rows[0][0].ToString();
                    if (body.Contains("##ClientName##"))
                    {
                        body = body.Replace("##ClientName##", clientName);
                    }
                    if (body.Contains("#location#"))
                    {
                        body = body.Replace("#location#", location);
                    }
                    if (body.Contains("#AdvisorName#"))
                    {
                        body = body.Replace("#AdvisorName#", AdvisorName);
                    }
                    if (body.Contains("#sBody#"))
                    {
                        body = body.Replace("#sBody#", sBody);
                    }
                    if (body.Contains("#sBody1#"))
                    {
                        body = body.Replace("#sBody1#", sBody1);
                    }
                    if (body.Contains("#sBody2#"))
                    {
                        body = body.Replace("#sBody2#", sBody2);
                    }
                    if (body.Contains("#sBody3#"))
                    {
                        body = body.Replace("#sBody3#", sBody3);
                    }
                    if (body.Contains("#sFooter#"))
                    {
                        body = body.Replace("#sFooter#", sFooter);
                    }
                    if (body.Contains("##appt##"))
                    {
                        body = body.Replace("##appt##", appt);
                    }
                }
                else
                {
                    lblMessage.Text = "There is no Email Template defined.";
                    return;
                }
                msg.IsBodyHtml = true;
                msg.Body = body;

                //msg.Body = body;
                SmtpClient mail_send = new SmtpClient();
                mail_send.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
                mail_send.Host = "localhost";
                Response.Write("Mail sent");
                mail_send.Send(msg);
                message.Text = "A confirmation email (" + Session["clientemail"] + ") has been sent to " + clientName + ".";  
                
            }

            message.Text = "A confirmation email (" + Session["clientemail"] + ") has been sent to " + clientName + ".";  


        }
        catch (Exception ex)
        {
            message.Text = "** Could not submit appointment. **<br>" + ex.Message + "<br>" + t;
            return;
        }
    }

    private void cancelAppointment(object obj, EventArgs args)
    {
        Session["cancel"] = Request["cancel"];
        return;            
    }
    private void backAppointment(Object obj, EventArgs args)
    {
        Session["cancel"] = "";
        return;
    }

    private void updateDB(object obj, EventArgs args)
    {
        message.Text = "";
        try
        {
            if (Request["reason"] == null || Request["reason"] == "")
            {
                message.Text = "** You must submit follow up notes to close. **";
                Session["cancel"] = Request["id"];
                return;
            }
            else
            {
                string sql = "UPDATE appointments SET status = 'N', apptstatus='" + Request["apptstatus"] + "', apptclient='" + Request["apptclient"] + "', note = '" + Request["reason"].Replace("'", "''") + "', cancelledBy = '" + Session["userid"] + "' WHERE claimid = '" + Session["id"] + "' AND id = '" + Request["id"] + "'";
                getMssqlData(sql);          // commented by me
                Session["cancel"] = "";
            }
        }
        catch (Exception ex) 
        { 
            message.Text = "" + ex.Message; 
        }
    }
    private void toggleGrid(Object sender, EventArgs e)
    {
        DataSet tmp;
        try
        {
            if (Session["view"].ToString() == "three")
            {
                Session["view"] = "entire";
                tmp = getMssqlData("SELECT appointments.id as 'ID',appointments.appointment as [Appointment Time],users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status],appointments.apptclient as [Client], appointments.note as [Appointment Notes] FROM madison_sysdba.appointments as appointments INNER JOIN madison_sysdba.users as users on users.userid = appointments.userid INNER JOIN madison_sysdba.locations as locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' ORDER BY appointments.appointment DESC");
                GridView1.DataSource = tmp.Tables[0].DefaultView;
                GridView1.DataBind();

            }
            else
            {
                Session["view"] = "three";
                //tmp = getMssqlData("SELECT TOP 3 appointments.appointment [Appointment Time], users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status], appointments.apptclient as [Client], appointments.note as [Appointment Notes] FROM madison_sysdba.appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' AND status='N' ORDER BY appointments.appointment DESC");
                tmp = getMssqlData("SELECT TOP 3 appointments.id as 'ID',appointments.appointment as [Appointment Time],users.name as [Name], locations.name as [Location], appointments.apptstatus as [Status],appointments.apptclient as [Client], appointments.note as [Appointment Notes] FROM madison_sysdba.appointments as appointments INNER JOIN madison_sysdba.users as users on users.userid = appointments.userid INNER JOIN madison_sysdba.locations as locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' ORDER BY appointments.appointment DESC");
                GridView1.DataSource = tmp.Tables[0].DefaultView;
                GridView1.DataBind();

            }
        }
        catch (Exception ex) 
        { 
            message.Text = "" + ex.Message; 
        }
    }      
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
	<title><!--#include file="./title.aspx"--></title>
	<!--#include file="./globalFunctions.aspx"-->
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
  	</head>
  	<body text="#000000" bgColor="#ffffff"  >
<!--#include file="./images/case_review_menu/nav.aspx"-->
<form id="Form2" method="post" runat="server">

<table border="1" cellpadding="0" cellspacing="0" align="center" style="vertical-align:top;" width="772">
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center"  style="vertical-align:top;" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<%

            string sql = "SELECT userid,status,tax_bracket,est_income,col0004 + ',' + col0002 as [student_name],col0007,col0009,col0010,col0011,col0013,col0018,col0020,student_hs_city,student_hs_state,seminar_date FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["id"];
		DataSet data = getMssqlData(sql);
		//data = getMssqlData(sql);

		string Repname;
        
            if (data.Tables[0].Rows[0]["userid"].ToString() != "")
            {
                sql = "SELECT name FROM madison_sysdba.users WHERE userid = '" + data.Tables[0].Rows[0]["userid"] + "'";
                DataSet repdata = getMssqlData(sql);
                Repname = repdata.Tables[0].Rows[0]["name"].ToString();
            }
            else
            {
                Repname = "Lead Not Assigned";
            }
       

		sql = "SELECT col0004 + ',' + col0002 as [client_name],col0015,col0016,col0018,col0024,col0037 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + Session["id"];
		DataSet parent = getMssqlData(sql);
        Session["clientemail"] = parent.Tables[0].Rows[0]["col0018"].ToString();
        Session["clientName"] = parent.Tables[0].Rows[0]["client_name"].ToString();    
		//Response.Write("Clients Email:" +Session["clientemail"].ToString());    

		sql = "SELECT col0015,col0016 FROM " + Session["mainParentTable"] + " WHERE [id] = 2 AND [claimid] = " + Session["id"];
		DataSet parent1 = getMssqlData(sql);

		sql = "SELECT TOP 1 note FROM madison_sysdba.notes WHERE [claimid] = " + Session["id"] + " ORDER BY [id] ASC";
		DataSet note = getMssqlData(sql); 
		%>
		<table border="0" cellpadding="2" cellspacing="2" align="center"  style="vertical-align:top;" width="90%">
		<tr>
			<td width="50%"><font class="red">Client Name:</font>&nbsp;<font class="black"><%= parent.Tables[0].Rows[0]["client_name"] %></font></td>
			<%try
            { %>
			<% if (data.Tables[0].Rows[0]["col0020"].ToString() == "0")
            { %>
				<td width="50%"><font class="red">Student Grad Year:</font>&nbsp;<font class="black"></font></td>
			<% }
            else
            { %>
				<td width="50%"><font class="red">Student Grad Year:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0020"]%></font></td>
			<% } %>
			<%}
            catch (Exception ex) 
            { 
                message.Text = "" + ex.Message; 
            } %>
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
			<%try
            { %>
			<% if (parent1.Tables[0].Rows[0]["col0015"].ToString() == "0")
            { %>
				<td><font class="red">Mother's Work Phone:</font>&nbsp;<font class="black"></font></td>
			<% }
            else
            { %>
				<td><font class="red">Mother's Work Phone:</font>&nbsp;<font class="black"><%= parent1.Tables[0].Rows[0]["col0015"]%>&nbsp;Ext.<%= parent1.Tables[0].Rows[0]["col0016"]%></font></td>
			<% } %>
			<%}
            catch (Exception ex)
            { %>
			<%
                message.Text = "" + ex.Message;
            } %>
		</tr><tr>
			<td><font class="red">Student State:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0010"] %></font></td>
			<%try
            { %>
			<% if (parent.Tables[0].Rows[0]["col0015"].ToString() == "0")
            { %>
				<td><font class="red">Father's Work Phone:</font>&nbsp;<font class="black"></font></td>
			<% }
            else
            { %>
				<td><font class="red">Father's Work Phone:</font>&nbsp;<font class="black"><%= parent.Tables[0].Rows[0]["col0015"]%>&nbsp;Ext.<%= parent.Tables[0].Rows[0]["col0016"]%></font></td>
			<% } %>
			<%}
            catch (Exception ex)
            { %>
			<%message.Text = "" + ex.Message;
            } %>
		</tr><tr>
			<td><font class="red">Student Zip:</font>&nbsp;<font class="black"><%= data.Tables[0].Rows[0]["col0011"] %></font></td>
			<% 
				try
                {
					DateTime dt = Convert.ToDateTime(data.Tables[0].Rows[0]["seminar_date"].ToString());
			%>
					<td><font class="red">Seminar Date:</font>&nbsp;<font class="black"><%= dt.ToShortDateString() %></font></td>
			<%
				}
                catch
                {
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
		<table border="0" cellpadding="4" cellspacing="2" align="center"  style="vertical-align:top;" width="100%">
		<tr height="20">
			<td colspan="2"></td>
		</tr>
		<%
		if(data.Tables[0].Rows[0]["status"].ToString() != "New Lead") {

		DataSet tmp = getMssqlData("SELECT appointments.*,users.name,locations.name as lname FROM madison_sysdba.appointments INNER JOIN users on users.userid = appointments.userid INNER JOIN locations ON appointments.locationid = locations.id WHERE claimid='" + Session["id"] + "' AND status='Y'");
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
						<% 
                            try
                            {
                                tmp = getMssqlData("SELECT * FROM madison_sysdba.locations");
                                for (int i = 0; i < tmp.Tables[0].Rows.Count; i++)
                                { %>
							<% if (Request["location"] == tmp.Tables[0].Rows[i]["name"].ToString())
                            { %>
								<option selected value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"]%></option>
							<% }
                            else
                            { %>
								<option value="<%= tmp.Tables[0].Rows[i]["id"] %>"><%= tmp.Tables[0].Rows[i]["name"]%></option>
							<% } %>
						<% }
                        }
                        catch (Exception ex) 
                            { 
                                message.Text = "" + ex.Message; 
                            } %>
						</select>
					</td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<asp:button id="schedule" text="Schedule" runat="server" onClick="scheduleAppointment"/>
					</td>
				</tr>
				<tr>
				    <td align="center" colspan="2" style="color:Red;">
				        <asp:Label ID="lblMessage" runat="Server" Font-Names="arial" Font-Size="9pt"></asp:Label>
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
			
		<tr>
			<td colspan="2" align="center">
				<font class="black">Appointment History</font>
				<%try
                { %>
		            <% if (Session["view"].ToString() == "three")
                    { %>
				        (<asp:LinkButton id="entireButton" class="red" Text="Entire History" Font-Names="Verdana" Font-Size="9pt" onclick="toggleGrid" runat="server"/>
				        )
		            <% }
                    else
                    { %>
				        (<asp:LinkButton id="recentButton" class="red" Text="Recent History" Font-Names ="Verdana" Font-Size="9pt" onclick="toggleGrid" runat="server"/>)
		            <% }
                    }
                    catch (Exception ex) 
                    { 
                        message.Text = "" + ex.Message; 
                    }%>
			</td>
		</tr>
		<tr class="grey">
			<td align="center" colspan="2">

			<table border="0" cellpadding="4" cellspacing="0" align="center"  style="vertical-align:top;" width="100%">
			<tr>
				<td align="center">
			
			<%--	
			Date:29/11/2007
			In this gridview edit link is there by clicking on the edit link popup window opens and all appointment data is shown of that
			particular id and that poup window page name is(case_info_edit.aspx with the id).--%>
			<%try
            { %>
			    <%if (GridView1.Rows.Count > 0)
                { %>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID"  Font-Names="arial" Font-Size="9pt" Width="753px">
                        <Columns>
                         <asp:TemplateField>
                        <ItemTemplate>
                         <%--<asp:LinkButton ID="LinkButton1" runat="server" Text = "Edit" OnClientClick ='<%#String.Format("{0}\"{1}{2}\")", "javascript:window.open(","case_info_edit.aspx?ID=",Eval("ID"),"","resizable=0,width=350,height=250")%>'></asp:LinkButton>--%>
                         
                        <a href="javascript:void(window.open('case_info_edit.aspx?ID=<%# Eval("ID")%>','','scrollbar=no,resizable=no,width=500,height=400,left=300,top=90'))">Edit</a> 
                        </ItemTemplate>
                        </asp:TemplateField>
                        
                            <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                SortExpression="ID" Visible="false" />
                            <asp:BoundField DataField="Appointment Time" HeaderText="Appointment Time" SortExpression="Appointment Time" />
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="Location" HeaderText="Location" SortExpression="Location" />
                            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                            <asp:BoundField DataField="Client" HeaderText="Client" SortExpression="Client" />
                            <asp:BoundField DataField="Appointment Notes" HeaderText="Appointment Notes" SortExpression="Appointment Notes" />
                            <asp:HyperLinkField DataNavigateUrlFields="ID" DataTextFormatString="EDIT" />
                        </Columns>
                        <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                        <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
                        <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                    </asp:GridView>
                    <%}
                      else
                      { %>
					
						<font class="black">No appointment history.</font>
					
		            <%	}%>
		            <%}
                    catch (Exception ex)
                    { 
                        message.Text = "" + ex.Message; 
                    } %>
                    </td>
			</tr>
			</table>
			</td>
			</tr>
			
                    <%--	<%		}else{ %>
					<tr class="grey">
						<td colspan="2" align="center"><font class="black">No appointment history.</font></td>
					</tr>
		<%		}
			}else{  %>
				<tr class="grey">
					<td colspan="2" align="center"><font class="black">No appointment history.</font></td>
				</tr>
		<% 	} --%>


		<%}
		%>		

				
		
		<tr height="20">
			<td colspan="2"></td>
		</tr>
		</table>
	</td>
</tr>
</table>

</form>
<!--#include file="./footer.aspx"-->
</body>
</html>

  	