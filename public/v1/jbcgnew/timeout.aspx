<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
    	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	<script language="C#" runat="server">
		
		public void Page_Load() {
			if(!Page.IsPostBack) {
				//empties out the session
				Session.Clear();

				//this password is used on the add user tool
				Session["defaultpassword"] = "123";
/*
				//location of audits database and connection information
				Session["dbserver"] = "AHQ1004.activehost.com";
				Session["dbusername"] = "madisonfinancialaid_sa";
				Session["dbpassword"] = "Mq3Rth9X";
				Session["database"] = "madisonfinancialaid";
				Session["dbtimeout"] = "300";
				Session["library"] = "DBMSSOCN";
*/
        //location of audits database and connection information
        Session["dbserver"] = "oldcrsdb.db.4264298.hostedresource.com";
        Session["dbusername"] = "oldcrsdb";
        Session["dbpassword"] = "Shunp1ke";
        Session["database"] = "oldcrsdb";
        Session["dbtimeout"] = "300";
        Session["library"] = "DBMSSOCN";
/*
				//IIS server ipaddress and local path information for uploads, downloads, images
				Session["ipaddress"] = "www.madisonfinancialaid.com";
				Session["serverroot"] = @"http://" + Session["ipaddress"] + @"/jbcg/";
				Session["docroot"] = @"http://" + Session["ipaddress"] + @"/jbcg/temp/";
				Session["imagedir"] = @"http://" + Session["ipaddress"] + @"/jbcg/images/";
				Session["userrootdir"] = @"D:\root\madison\madisonfinancialaid.com\www\jbcg\userfolders\";
				message.Text = "** Your session has timed out please login again. **";
*/
        Session["ipaddress"] = "www.college-retirement.com";
        Session["home"] = @"http://" + Session["ipaddress"];
        Session["serverroot"] = @"http://" + Session["ipaddress"] + @"/jbcgnew/";
        Session["docroot"] = @"http://" + Session["ipaddress"] + @"/jbcgnew/temp/";
        Session["imagedir"] = @"http://" + Session["ipaddress"] + @"/jbcgnew/images/";
        Session["userrootdir"] = @"D:\root\madison\college-retirement.com\jbcgnew\userfolders\";

				Session["mainDataTable"] = "mfac_client_data2";
				Session["mainDictTable"] = "mfac_data_dictionary";
				Session["mainLogTable"] = "mfac_status_log";
				Session["mainChoiceTable"] = "mfac_college_choice";
				Session["mainParentTable"] = "mfac_parent_info";
				Session["mainFamilyTable"] = "mfac_family_info";
				Session.Timeout = 300;
			}
			return;
		}
		
		//Generic data access function for querying SQL databases
		private DataSet getMssqlData(string s) {
			//string connStr = "NETWORK LIBRARY=" + Session["library"] + ";DATA SOURCE=" + Session["server"] + ";User ID=" + Session["dbuserid"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
			string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
			//string connStr = "server=" + Session["auditserver"] + ";uid=" + Session["auditusername"] + ";pwd=" + Session["auditpassword"] + ";database=" + Session["auditdatabase"] + ";";
			//Response.Write(connStr);

			SqlDataAdapter adpt = new SqlDataAdapter(s, connStr);
			DataSet dt = new DataSet();
			try {
				adpt.Fill(dt);

			}catch(Exception e) {
				message.Text += "<center>** There was an error accessing " + Session["dbserver"] + ". **</center><br>" + e.Message + "<br>";
			}
			return dt;
		}

		private void loginSubmit(Object obj, EventArgs args) {
			//check form fields
			message.Text = "";
			if(Request["username"] == "" || Request["password"] == "") {
				message.Text = "** Username and password required. **";
				return;
			}

			//check if the user exists and is active
			string sql = "SELECT * FROM users WHERE username='" + Request["username"] + "' AND password='" + Request["password"] + "' AND active='1'";
			//Response.Write(sql);
			DataSet data = new DataSet();
			data = getMssqlData(sql);

			try{
				if(data.Tables[0].Rows.Count == 0) {
					message.Text = "** Invalid username or password **";
					return;
				}else{
					processUserInfo(data);
					return;
				}
			}catch(Exception e) {
				message.Text = "** Invalid username or password **";
				return;				
			}
			return;
		}

		//load all the users information from audits.users, checks to see if the user's password has expired
		private void processUserInfo(DataSet uData) {
			try {
				for(int i = 0; i < uData.Tables[0].Columns.Count; i++) {
					Session[uData.Tables[0].Columns[i].ColumnName] = uData.Tables[0].Rows[0][i];
				}
			}catch(Exception e) {
				message.Text = "** Error loading user settings. **";
				return;
			}
	
			//if expired redirect to the password update page, set a session flag so the user is then 
			//redirected to the home page upon completion of a password update
			if(Convert.ToDateTime(Session["password_expiration_date"]) <= System.DateTime.Now) {
				Session["passwordexpired"] = "1";
				Response.Redirect("./passwordupdate.aspx");
				return;
			}else{

				//otherwise redirect home
				//Response.Redirect("./home.aspx");
				if(Session["account_type"].ToString().ToLower() == "admin"){
					Response.Redirect("./assign_leads.aspx");
				}else if(Session["account_type"].ToString().ToLower() == "intern"){
					Response.Redirect("./add_lead.aspx");
				}else if(Session["account_type"].ToString().ToLower() == "representative"){
					Response.Redirect("./new_leads.aspx");
				}
				return;			
			}
			return;
		}

    	</script>
	</head>
<body>
<!--#include file="./images/login_menu/login.aspx"-->
<form runat="server">
<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Login&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td>
	
	<!-- main body here -->

	<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
	<tr>
		<td align="right" width="50%"><font class="black">Username:</font></td>
		<td align="left" width="50%"><input type="text" size="20" name="username" maxlength="50"></td>
	</tr>
	<tr>
		<td align="right" width="50%"><font class="black">Password:</font></td>
		<td align="left" width="50%"><input type="password" size="20" name="password" maxlength="50"></td>
	</tr>
	<tr>
		<td align="center" colspan="2">
			<asp:Button id="loginsubmit" runat="server" text="Login" onClick="loginSubmit" />
		</td>
	</tr>
	</table>


	</td>
</tr>
</table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>
	