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

		//only runs the following code the first time this page loads
		//string sql = @"select id as [ID],client_last_name + ',' + client_first_name as [Client Name],users.name as [Assigned To], student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], status + ' ' + cast(month(payment_authorizationDate) as varchar) + '-' + cast(day(payment_authorizationDate) as varchar) + '-' + cast(year(payment_authorizationDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Payment Authorized' ORDER BY payment_authorizationDate DESC";
		Session["sql"] = @"SELECT users.name as [Name], status as [Status], count(id) as [Count] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users on users.userid = d.userid WHERE d.userid <> ''GROUP BY users.name,status ORDER BY users.name ASC, status ASC";
		//Session["sql"] = "SELECT d.[id] AS [ID], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.col0013 AS [Home Phone], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d WHERE d.userid = " + Session["userid"] + " AND [status] = 'Payment Authorized' ";
		data = getMssqlData(Session["sql"].ToString());
		if(!Page.IsPostBack) {
			Session["sort"] = "desc";
			Session["col"] = "payment_authorizationDate";			

			dataView.DataSource = data.Tables[0].DefaultView;
			dataView.DataBind();
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
		string sql = @"select id as [ID], users.name as [Assigned To], student_last_name + ',' + student_first_name as [Student Name], student_high_school as [High School], home_phone as [Home Phone], status + ' ' + cast(month(payment_authorizationDate) as varchar) + '-' + cast(day(payment_authorizationDate) as varchar) + '-' + cast(year(payment_authorizationDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Payment Authorized' ORDER BY [" + Session["col"] + "] " + Session["sort"];
		data = getMssqlData(sql);

		dataView.DataSource = data.Tables[0].DefaultView;
		dataView.DataBind();
	}


    	private void lead_page(Object sender, DataGridPageChangedEventArgs e) {
		string sql = @"select id as [ID], users.name as [Assigned To], student_last_name + ',' + student_first_name as [Student Name], student_high_school as [High School], home_phone as [Home Phone], status + ' ' + cast(month(payment_authorizationDate) as varchar) + '-' + cast(day(payment_authorizationDate) as varchar) + '-' + cast(year(payment_authorizationDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Payment Authorized' ORDER BY [" + Session["col"] + "] " + Session["sort"];
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
</tr><tr>
	<td align="center">
	

	<% if(data.Tables[0].Rows.Count > 0) { %>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="black">Representative Summary</td>
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
			<td><font class="black">There are no cases to report on.</font></td>

		</tr>
		</table>
	<% } %>

	</td>
</tr>
</table>

</form>
<!--#include file="./footer.aspx"-->
</body>
</html>