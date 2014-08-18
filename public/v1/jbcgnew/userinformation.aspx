<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script runat="server" language="C#">
	//Check Session validity.
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		if(!Page.IsPostBack) {
			message.Text = "";
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
	
	//Get all the user's information and print it in an html table.  Returns the table.
	private string processUserInfo() {
		string package = "";

		string sql = "SELECT * FROM users WHERE userid='" + Session["userid"] + "' AND active='1'";
		DataSet data = new DataSet();
		try	{
			data = getMssqlData(sql);	
		}catch(Exception e) {
			message.Text = "** Error encountered. **<br>" + e.Message;
			return "error";							
		}
		if(data.Tables[0].Rows.Count == 0) {
			message.Text = "** Error encountered. **";
			return "error";
		}
		try {
			for(int i = 0; i < data.Tables[0].Columns.Count; i++) {
				package += "<tr><td><font class=\"redsm\">" + data.Tables[0].Columns[i].ColumnName + "</font></td><td><font class=\"redsm\">" + data.Tables[0].Rows[0][i] + "</font></td></tr>";
			}
		}catch(Exception e) {
			message.Text = "** Error loading user settings. **";
			return "error";
		}		
		return package;
	}			
	</script>
<body>
<form enctype="multipart/form-data" runat="server">
<% if(Session["account_type"].ToString() == "Intern") { %>
	<!--#include file="./images/intern_menu/nav2.aspx"-->
<% }else if(Session["account_type"].ToString() == "Representative") { %>
	<!--#include file="./images/rep_menu/nav2.aspx"-->
<% }else if(Session["account_type"].ToString() == "Admin") { %>
	<!--#include file="./images/admin_menu/nav4.aspx"-->
<% } %>

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="3" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">User Information&nbsp;</font></td>
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
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="70%">
		<tr><td><font class="black">Field</font></td><td><font class="black">Value</font></td></tr>
		<%= processUserInfo() %>
		</table>
	</td>
</tr></table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>