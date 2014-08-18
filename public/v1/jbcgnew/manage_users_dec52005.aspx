<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<html>
  <head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	<script language="C#" runat="server">
		
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() != "admin") {
			Response.Redirect("./nopriv.aspx");
		}
		//only runs the following code the first time this page loads
		if(!Page.IsPostBack) {

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
			throw(e);
		}
		//Response.Write(dt.Tables.Count + "");
		return dt;
	}

    	</script>
  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/admin_menu/nav3.aspx"-->
<form method="post" runat="server">

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<!--
<tr class="red">
	<td>
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Add New Lead&nbsp;</font></td>
		</tr></table>
	</td>
</tr>
-->
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td>
	
	<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="80%">
	<tr>
		<td colspan="2"></td>
	</tr>
	<tr>
		<td align="center">
			<% if(Session["priv_add_user"].ToString() == "1") { %>
				<a class="black" href="./adduser.aspx">Add User</a><br>
			<% }else{ %>
				<font class="grey">Download</font>	
			<% } %>
		</td>
		<td align="center">
			<% if(Session["priv_add_user"].ToString() == "1") { %>
				<a class="black" href="./applicationAdmin.aspx">Application Admin</a><br>
			<% }else{ %>
				<font class="grey">Add User</font>	
			<% } %>
		</td>
		<td align="center">
			<% if(Session["priv_edit_user"].ToString() == "1") { %>
				<a class="black" href="./edituser.aspx">Edit User</a><br>
			<% }else{ %>
				<font class="grey">Edit User</font>	
			<% } %>
		</td>
	</tr>
	<tr>
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