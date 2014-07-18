<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.Mail" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script runat="server" language="C#">	
	//gets run every time the screen refreshes on this page
	public void Page_Load() {
		if(!Page.IsPostBack) {
			Session["state"] = "entry";
		}
	}
	

	//adds the user to audits.users
	private void sendPassword(Object obj, EventArgs args) {
		string sql = "SELECT emailaddress,password FROM users where username = '" + Request["username"] + "'";
		DataSet data = getMssqlData(sql);
		try {
			if(data.Tables[0].Rows[0]["emailaddress"].ToString() ==  Request["email"]) {
				string strTo = data.Tables[0].Rows[0]["emailaddress"].ToString();
				string strFrom = "webmaster@madisonfinancialaid.com";
				string strSubject = "auto response";

				SmtpMail.Send(strFrom, strTo, strSubject, "Your password is " + data.Tables[0].Rows[0]["password"].ToString());
			}
		}catch(Exception e) {
			message.Text = "*Information is incorrect.*";
		}
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
			throw(e);
		}
		return dt;
	}
	</script>
<body>
<form enctype="multipart/form-data" runat="server">
<!--#include file="./images/login_menu/login.aspx"-->

<table border="1" cellpadding="0" cellspacing="1" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Forgot Password?&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td>
<% if(Session["state"] == "entry") { %>


	<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
	<tr>
		<td align="right" width="50%">
		<font class="blacksm">Email Address (must match account email address)</font>
		</tD>
		<td><input type="text" name="email" size="30" maxlength="50"></td>
	</tr>
	<tr>
		<td align="right">
		<font class="blacksm">Username</font>
		</tD>
		<td><input type="text" name="username" size="25" maxlength="50"></td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<asp:Button id="submit" runat="server" text="Submit" onClick="sendPassword" />
		</td>
	</tr>
	</table>
<% } %>
	</td>
</tr>
</table>

<!--#include file="./footer.aspx"-->
</form></body></html>