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
	DataSet data;	

	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() != "admin") {
			Response.Redirect("./nopriv.aspx");
		}

		if(!Page.IsPostBack) {
			Session["col"] = "id";
			Session["sort"] = "asc";

			Session["state"] = "form";
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

	private void next(Object obj, EventArgs e) {
		if(Request["beginDate"] == "") {
			message.Text = "**Begin date is required.**";
			return;
		}
		if(Request["endDate"] == "") {
			message.Text = "**End date is required.**";
			return;
		}
		DateTime dt = new DateTime();

		try {
			dt = Convert.ToDateTime(Request["beginDate"]);
		}catch(Exception ex) {
			message.Text = "**Begin date is invalid.**";
			return;
		}

		try {
			dt = Convert.ToDateTime(Request["endDate"]);
		}catch(Exception ex) {
			message.Text = "**End date is invalid.**";
			return;
		}

		Session["sql"] = @"SELECT b.col0004 + ',' + b.col0002 AS [Client Name], a.[claimid] AS [ID], c.[name] As [Scheduled By], a.[appointment] AS [Appointment], a.[status] AS [Status], a.[pending] AS [Pending], d.[name] AS [Location], a.[apptStatus] AS [Appt Status], a.[apptClient] AS [Appt Client]  FROM appointments AS a INNER JOIN [" + Session["mainParentTable"] + "] AS b ON a.claimid = b.claimid AND b.id = 1 INNER JOIN users AS c ON c.userid = a.userid INNER JOIN locations AS d ON a.locationid = d.[id] WHERE appointment BETWEEN '" + Request["beginDate"] + "' AND '" + Request["endDate"] + "'";
		data = getMssqlData(Session["sql"].ToString());
		//Session["sort"] = "desc";
		//Session["col"] = "payment_authorizationDate";			

		dataView.DataSource = data.Tables[0].DefaultView;
		dataView.DataBind();

		Session["state"] = "showReport";

	}

	private void lead_sort(Object o, DataGridSortCommandEventArgs e) {
		string col = (string)e.SortExpression;
		if(col == Session["col"].ToString()) {
			if(Session["sort"].ToString() == "desc") {
				Session["sort"] = "asc";
			}else{
				Session["sort"] = "desc";
			}
		}else{
			Session["col"] = col;
		}
		//Session["sql"] = @"SELECT b.col0004 + ',' + b.col0002 AS [Client Name], a.[claimid] AS [ID], c.[name] As [Scheduled By], a.[appointment] AS [Appointment], a.[status] AS [Status], a.[pending] AS [Pending], d.[name] AS [Location]  FROM appointments AS a INNER JOIN [" + Session["mainParentTable"] + "] AS b ON a.claimid = b.claimid AND b.id = 1 INNER JOIN users AS c ON c.userid = a.userid INNER JOIN locations AS d ON a.locationid = d.[id] WHERE apptStatus = 'Showed' AND apptClient IN ('MFAC','Client') AND appointment BETWEEN '" + Request["beginDate"] + "' AND '" + Request["endDate"] + "' ORDER BY [" + Session["col"] + "] " + Session["sort"];
		string sql = Session["sql"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		data = getMssqlData(sql);

		dataView.DataSource = data.Tables[0].DefaultView;
		dataView.DataBind();
	}


    	private void lead_page(Object sender, DataGridPageChangedEventArgs e) {
		//Session["sql"] = @"SELECT b.col0004 + ',' + b.col0002 AS [Client Name], a.[claimid] AS [ID], c.[name] As [Scheduled By], a.[appointment] AS [Appointment], a.[status] AS [Status], a.[pending] AS [Pending], d.[name] AS [Location]  FROM appointments AS a INNER JOIN [" + Session["mainParentTable"] + "] AS b ON a.claimid = b.claimid AND b.id = 1 INNER JOIN users AS c ON c.userid = a.userid INNER JOIN locations AS d ON a.locationid = d.[id] WHERE apptStatus = 'Showed' AND apptClient IN ('MFAC','Client') AND appointment BETWEEN '" + Request["beginDate"] + "' AND '" + Request["endDate"] + 
		string sql = Session["sql"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		data = getMssqlData(sql);

		dataView.DataSource = data.Tables[0].DefaultView;
        	dataView.CurrentPageIndex = e.NewPageIndex;
		dataView.DataBind();
	}

    	</script>
  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/login_menu/login.aspx"-->
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
</tr>
<% if(Session["state"].ToString() == "showReport") { %>
<tr>
	<td align="center">
	

	<% if(data.Tables[0].Rows.Count > 0) { %>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="black">Appointment Status Report</td>
		</tr>
		<tr>
			<td class="grey" align="center">
				<ASP:Datagrid 
				id="dataView" 
				runat="server" 
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
				width="100%"
				Font-Size = "9pt"
				Font-Name = "Arial"
				OnSortCommand="lead_sort"
				OnPageIndexChanged="lead_page"
				>

				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>
			</font></td>
		</tr>
		</table>
	<% }else{ %>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr class="grey" align="center">
			<td><font class="black">There are no appointments to report on.</font></td>

		</tr>
		</table>
	<% } %>

	</td>
</tr>
<% }else if(Session["state"].ToString() == "form") { %>
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="200">
		<tr align="center">
			<td><font class="blacksm">Begin Date*</font></td>
			<td><input type="text" name="beginDate" maxlength="10" size="15"></td>
		</tr>
		<tr align="center">
			<td><font class="blacksm">End Date*</font></td>
			<td><input type="text" name="endDate" maxlength="10" size="15"></td>
		</tr>
		<tr>
			<td colspan="2"><asp:Button id="nextid" runat="server" text="Generate Report" onClick="next" /></td>
		</tr>
		</table>
	</td>
</tr>
<% } %>
</table>

</form>
<!--#include file="./footer.aspx"-->
</body>
</html>