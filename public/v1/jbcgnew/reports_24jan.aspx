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
		//string sql = @"select client_last_name as [Client Last Name],client_first_name as [Class First Name],student_last_name as [Student Last Name],student_first_name as [Student First Name], cast(month(createdDate) as varchar) + '-' + cast(day(createdDate) as varchar) + '-' + cast(year(createdDate) as varchar) as [Created On],status as [Status] FROM mfac_client_data WHERE createdBy = '" + Session["userid"] + "' ORDER BY createdDate ASC";
		//DataSet data = getMssqlData(sql);
		//dataView.DataSource = data.Tables[0].DefaultView;
		//dataView.DataBind();
		//return;
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
<!--#include file="./images/admin_menu/nav2.aspx"-->
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
	<td>
	

		<!--
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr class="grey">
			<td align="center"><font class="black">There are no available reports at this time.</font></td>
		</tr>
		</table>
		-->

		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td width="33%" align="center"><a class="black" target="new" href="repSummary.aspx">Representative Summary</a></td>
			<td width="33%" align="center"><a class="black" target="new" href="genPresentationSeed.aspx">Gen Presentation Seed</a></td>
			<td width="33%" align="center"><a class="black" target="new" href="apptSummary.aspx">Appointment Follow Up Report</a></td>
		</tr>
		<tr>
			<td width="33%" align="center"><a class="black" target="new" href="apptStatusSummary.aspx">Appointment Status Report</a></td>
			<td width="33%"></td>
			<td width="33%"></td>
		</tr>
		</table>

	</td>
</tr>
</table>

</form>
<!--#include file="./footer.aspx"-->
</body>
</html>