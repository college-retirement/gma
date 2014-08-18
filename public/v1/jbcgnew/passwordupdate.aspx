<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	<script language="C#" runat="server">

	//Default.aspx uses this page for renewing the users password.  If this page is loaded from an expired password
	//the redirection sends a parameter accross so passwordupdate.aspx knows to display the proper message.		
	public void Page_Load() {
		//Check privileges.
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		if(!Page.IsPostBack) {
			try {
				//Check if redirected from password expiration.
				if(Session["passwordexpired"].ToString() == "1") {
					message.Text = "**  " + Session["username"] + ", your password has expired.<br> Please enter a new password. **";
				}else{
					message.Text = "";
				}
			}catch(Exception e) {
				message.Text = "";
			}
		}
	}
	
	//Checks and updates the users password.  Checks to see if the new password matches the current one
	//or if it matches the user's last password.  Shuffles the password values accordingly and resets 
	//the password expiration date and set date.  Uses database table audits.users.
	private void processPassword(Object obj, EventArgs arg) {
		if(Request["password1"] != Request["password2"]) {
			message.Text = "** Passwords do not match. **";
			return;
		}else{
			//Response.Write(Session["password"] + " "  + Request["password1"] + " " + Session["previous_password"] + " " + Session["passwordexpired"] + " " + Session["userid"]);
			if(Session["password"].ToString() == Request["password1"] || Session["previous_password"].ToString() == Request["password1"]) {
				message.Text = "** You must select a new password. **";
				return;
			}else{
				//string connStr = "server=" + Session["auditserver"] + ";uid=" + Session["auditusername"] + ";pwd=" + Session["auditpassword"] + ";database=" + Session["auditdatabase"] + ";";
				string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
				string sql = "UPDATE users SET password='" + Request["password1"] + "', previous_password='" + Session["password"].ToString() + "', password_set_date='" + System.DateTime.Now.ToShortDateString() + "', password_expiration_date='" + System.DateTime.Now.AddMonths(3).ToShortDateString() + "' WHERE userid='" + Session["userid"] + "' AND active='1'";
				SqlConnection activeConn = new SqlConnection(connStr);			
				SqlCommand comm = new SqlCommand(sql, activeConn);
				try	{
					comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
				}catch(Exception e) {
					message.Text = "** Error encountered updating password. **<br>" + e.Message;
					return;
				}
				SqlDataAdapter dAdpt = new SqlDataAdapter();
				dAdpt.SelectCommand = comm;
				try {
					activeConn.Open();
				}catch(Exception e) {
					message.Text = "** Error encountered updating password. **<br>" + e.Message;
					return;				
				}
				DataSet data = new DataSet();
				try {
					dAdpt.Fill(data);
				}catch(Exception e) {
					message.Text = "** Error encountered updating password. **<br>" + e.Message;
					return;				
				}
				activeConn.Close();
				Session["previous_password"] = Session["password"].ToString();
				Session["password"] = Request["password1"];
				Session["password_expiration_date"] = System.DateTime.Now.AddMonths(3).ToShortDateString();
				Session["password_set_date"] = System.DateTime.Now.ToShortDateString(); 
				try {
					if(Session["passwordexpired"].ToString() == "1") {
						Response.Write("sss");
						Session["passwordexpired"] = "0";
						if(Session["account_type"].ToString().ToLower() == "admin"){
							Response.Redirect("./assign_leads.aspx");
						}else if(Session["account_type"].ToString().ToLower() == "intern"){
							Response.Redirect("./add_lead.aspx");
						}else if(Session["account_type"].ToString().ToLower() == "representative"){
							Response.Redirect("./new_leads.aspx");
						}
						//Response.Redirect("./home.aspx");
						return;
					}else{
						message.Text = "** Password updated successfuly. **";
						return;					
					}				
				}catch(Exception e) {
					message.Text = "** Password updated successfuly. **";
					return;
				}
			}
		}
	}

	</script>	
	</head>
<body>
<form runat="server">
<% if(Session["passwordexpired"].ToString() == "0") { %>
	<% if(Session["account_type"].ToString() == "Intern") { %>
		<!--#include file="./images/intern_menu/nav2.aspx"-->
	<% }else if(Session["account_type"].ToString() == "Representative") { %>
		<!--#include file="./images/rep_menu/nav2.aspx"-->
	<% }else if(Session["account_type"].ToString() == "Admin") { %>
		<!--#include file="./images/admin_menu/nav4.aspx"-->
	<% }else{ %>
		<!--#include file="./images/login_menu/login.aspx"-->
	<% } %>
<% }else{ %>
	<!--#include file="./images/login_menu/login.aspx"-->
<% } %>
<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Password Update&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td>

	<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
	<tr>
		<td align="right"><font class="blacksm">Password:</font></td>
		<td><input type="password" size="20" name="password1" maxlength="50"></td>
	</tr>
	<tr>
		<td align="right"><font class="blacksm">Re-Type Password:</font></td>
		<td><input type="password" size="20" name="password2" maxlength="50"></td>
	</tr>
	<tr>
		<td colspan="2" align="center">
		<asp:Button id="passwordsubmit" runat="server" text="Update" onClick="processPassword"/>
		</td>
	</tr>
	</table>
</td></tr>
</table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>