<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script runat="server" language="C#">	
	//gets run every time the screen refreshes on this page
	public void Page_Load() {
		if(Session["defaultpassword"] == null) {
			Session["defaultpassword"] = "123";
		}
		Session["state"] = "entry";
	}
	

	//adds the user to audits.users
	private void applicationSubmit(Object obj, EventArgs args) {
		//clears the aspx label control
		message.Text = "";

		//checks required fields
		if(Request["name"] == "") {
			message.Text += "** Name cannot be left blank. **<br>";
		}

		if(Request["address"] == "") {
			message.Text += "** Address cannot be left blank. **<br>";
		}

		if(Request["phone"] == "") {
			message.Text += "** Phone cannot be left blank. **<br>";
		}else{
			if(Request["phone"].Length < 10) {
				message.Text += "** Phone number must contain an area code. **<br>";
			}else{
				try{
					long test = Convert.ToInt64(Request["phone"]);
				}catch(Exception e) {
					message.Text += "** Phone number must contain only numbers. **<br>";
				}
			}
		}

		if(Request["username"] == "") {
			message.Text += "** Username cannot be left blank. **<br>";
		}

		if(Request["emailaddress"] == "") {
			message.Text += "** Email address cannot be left blank. **<br>";
		}

		if(Request["password1"] == "") {
			message.Text += "** Password cannot be left blank. **<br>";
		}			
	
		//checks to see if the user already exists
		string sql = "SELECT * FROM users WHERE username='" + Request["username"] + "'";
		DataSet data = getMssqlData(sql);
		if(data.Tables.Count > 0) {
			if(data.Tables[0].Rows.Count > 0) {
				message.Text += "** The username you've chosen is already in use. **<br>";
			}
		}

		sql = "SELECT * FROM applications WHERE username='" + Request["username"] + "'";
		data = getMssqlData(sql);
		if(data.Tables.Count > 0) {
			if(data.Tables[0].Rows.Count > 0) {
				message.Text += "** The username you've chosen is already in use. **<br>";
			}
		}

		if(message.Text != "") {
			return;
		}

		try {
			sql = "INSERT INTO applications VALUES('" + clean(Request["address"]) + "','" + clean(Request["emailaddress"]) + "','" + clean(Request["name"]) + "','" + clean(Request["pword1"]) + "','" + clean(Request["phone"]) + "','" + clean(Request["username"]) + "');";
			getMssqlData(sql);
			//message.Text = "Application stored successfully.";
		}catch(Exception e) {
			//Response.Write(e.Message);
			message.Text = "** Could not store application. **";
		}
		Session["state"] = "submitted";
		return;
	}

	private string clean(string src){
		return src.Replace("'","''");
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
			<td><font class="white">Account Application&nbsp;</font></td>
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
		<td align="right" width="40%"><font class="blacksm" align="right">**Name:</font></td>					
		<td><input type="text" name="name" size="20" maxlength="50" value="<%= Request["name"] %>"></td>
	</tr>
	<tr>
		<td align="right"><font class="blacksm">**Address:</font></td>
		<td><input type="text" name="address" size="40" maxlength="255" value="<%= Request["address"] %>"></td>
	</tr>
	<tr>
		<td align="right"><font class="blacksm" align="right">**Phone:</font></td>
		<td><input type="text" name="phone" size="10" maxlength="10" value="<%= Request["phone"] %>"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><font class="redsm">** You must provide a valid email address. **</font></td>
	</tr>
	<tr>
		<td align="right"><font class="blacksm" align="right">**Email Address:</font></td>
		<td><input type="text" name="emailaddress" size="30" maxlength="100" value="<%= Request["emailaddress"] %>"></td>
	</tr>
	<tr>
		<td align="right"><font class="blacksm">**Username:</font></td>					
		<td><input type="text" name="username" size="15" maxlength="15" value="<%= Request["username"] %>"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><font class="blacksm">** You will be prompted to change your password upon logging in. **</font></td>
	</tr>
	<tr>
		<td align="right"><font class="blacksm" align="right">Password:</font></td>					
		<td>
			<input type="text" name="password1" size="20" maxlength="50" value="<%= Session["defaultpassword"] %>" disabled>
			<input type="hidden" name="pword1" value="<%= Session["defaultpassword"] %>">
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<asp:Button id="appsubmit" runat="server" text="Submit" onClick="applicationSubmit" />
		</td>
	</tr>
	</table>
<% }else if(Session["state"] == "submitted") { %>
	<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
	<tr height="80">
		<td align="center">
		<font class="black">Application stored successfully.</font>
		</tD>
	</tr>
	</table>
<% } %>
	</td>
</tr>
</table>

<!--#include file="./footer.aspx"-->
</form></body></html>