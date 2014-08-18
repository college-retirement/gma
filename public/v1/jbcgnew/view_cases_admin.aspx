<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Register TagPrefix="mbrsc" Namespace="MetaBuilders.WebControls" 
         Assembly="MetaBuilders.WebControls.RowSelectorColumn" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<html>
  <head>
	<title><!--#include file="./title.aspx"--></title>
	<!--#include file="./globalFunctions.aspx"-->
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
		//string sql = @"select id as [ID], users.name as [Assigned To], student_last_name + ',' + student_first_name as [Student Name], student_high_school as [High School], home_phone as [Home Phone], status + ' ' + cast(month(payment_authorizationDate) as varchar) + '-' + cast(day(payment_authorizationDate) as varchar) + '-' + cast(year(payment_authorizationDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Payment Authorized' ORDER BY payment_authorizationDate DESC";

//		Session["sql"] = "SELECT d.[id] AS [ID], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.col0013 AS [Home Phone], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d WHERE [status] = 'Payment Authorized' ";
//		Session["sql"] = "SELECT d.[id] AS [ID], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d WHERE [status] = 'Payment Authorized' ";
		Session["sql"] = "SELECT d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid WHERE [status] = 'Payment Authorized' ";
//		Response.Write(Session["sql"]);

		string sql = Session["sql"] + " ORDER BY d.transactionDate DESC;";
		data = getMssqlData(sql);
		if(!Page.IsPostBack) {
			Session["sort"] = "desc";
			// Session["col"] = "payment_authorizationDate";			
			Session["col"] = "transactionDate";			

			Session["state"] = "list";

			dataView.DataSource = data.Tables[0].DefaultView;
			dataView.DataBind();
		}
		return;
	}
		
	//Generic data access function for querying SQL databases
/*	private DataSet getMssqlData(string s) {
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
*/


	private string printUserList(string id) {
		string package = "";
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		string sql = "SELECT * FROM users WHERE account_type = 'Representative' ORDER BY name";
		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(sql, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";							
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		DataSet data = new DataSet();
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		activeConn.Close();
		try {
			if(data.Tables[0].Rows.Count == 0) {
				message.Text = "** No users found. **";
				return "";
			}else{
				package += "<option value=\"\">SELECT ONE</option>\n";
				for(int i = 0; i < data.Tables[0].Rows.Count; i++) {
					if(id == data.Tables[0].Rows[i]["userid"].ToString() ) {
						package += "<option selected value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
					}else{
						package += "<option value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
					}
				}
			}
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		return package;
	}

	private string printUserList() {
		string package = "";
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		string sql = "SELECT * FROM users WHERE account_type = 'Representative' ORDER BY name";
		SqlConnection activeConn = new SqlConnection(connStr);			
		SqlCommand comm = new SqlCommand(sql, activeConn);
		try	{
			comm.CommandTimeout = Convert.ToInt32(Session["auditdbtimeout"]);
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";							
		}
		SqlDataAdapter dAdpt = new SqlDataAdapter();
		dAdpt.SelectCommand = comm;
		try {
			activeConn.Open();
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		DataSet data = new DataSet();
		try {
			dAdpt.Fill(data);
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		activeConn.Close();
		try {
			if(data.Tables[0].Rows.Count == 0) {
				message.Text = "** No users found. **";
				return "";
			}else{
				package += "<option value=\"\">SELECT ONE</option>\n";
				for(int i = 0; i < data.Tables[0].Rows.Count; i++) {
					//if(id == data.Tables[0].Rows[i]["userid"].ToString() ) {
					//	package += "<option selected value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
					//}else{
						package += "<option value=\"" + data.Tables[0].Rows[i]["userid"] + "\">" + data.Tables[0].Rows[i]["name"] + "</option>\n";
					//}
				}
			}
		}catch(Exception e) {
			message.Text = "** Error loading user set. **<br>" + e.Message;
			return "";			
		}
		return package;
	}


	private void openClaimReviewMenu(Object sender, DataGridCommandEventArgs e) {
		try {
			Session["id"] = e.Item.Cells[3].Text.Trim();
			//DataSet temp = getMssqlData("SELECT student_last_name,student_first_name,client_last_name,client_first_name,home_phone,parent_email_address FROM mfac_client_data WHERE id='" + Session["id"] + "';");
			DataSet temp = getMssqlData("SELECT col0004,col0002,col0013 FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["id"] + ";");
			Session["home_phone"] = temp.Tables[0].Rows[0]["col0013"].ToString();
			Session["student_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
			Session["student_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();

			temp = getMssqlData("SELECT col0004,col0002,col0018 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + Session["id"] + ";");
			Session["parent_email_address"] = temp.Tables[0].Rows[0]["col0018"].ToString();
			Session["client_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
			Session["client_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();

			Response.Redirect("./case_info.aspx");
		}catch(Exception ex) {
			message.Text = "** There was an error processing your request. **";
			return;
		}
	}


	private void reviewLead(Object sender, DataGridCommandEventArgs e) {

		Button b = (Button) e.CommandSource;
		//Response.Write(e.Item.Cells[3].Text.Trim());
		//return;
		if(b.Text == "Re-Assign") {
			Session["state"] = "reassign";
			Session["reassign"] = e.Item.Cells[3].Text.Trim();
		}else if(b.Text == "Info") {
			openClaimReviewMenu(sender,e);
		}
	}



	// this function is called when scheduled leads re-assign button is clicked
	private void updateDB(Object sender, EventArgs e) {
		try {
			Button b = (Button) sender;
			//Response.Write(b.Text);
			string sql = "";
			if(b.Text == "Re-Assign Lead") {
				Session["id"] = Session["reassign"];
				sql = "UPDATE " + Session["mainDataTable"] + " SET transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user"] + "' WHERE id = '" + Session["id"] + "';";
				Session["state"] = "list";
				Session["reassign"] = "";
				getMssqlData(sql);

				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user2"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				updateLog(Session["id"].ToString(), "Assigned");
			}


			sql = Session["sql"].ToString();
			data = getMssqlData(sql);

			dataView.DataSource = data.Tables[0].DefaultView;
			dataView.DataBind();
			Session["id"] = null;

		}catch(Exception ex){
			message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
			return;
		}
	}


	private void cancelAssign(Object sender, EventArgs e) {
		Session["state"] = "list";
		Session["reassign"] = "";
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
		//string sql = @"select id as [ID], users.name as [Assigned To], student_last_name + ',' + student_first_name as [Student Name], student_high_school as [High School], home_phone as [Home Phone], status + ' ' + cast(month(d.transactionDate) as varchar) + '-' + cast(day(d.transactionDate) as varchar) + '-' + cast(year(d.transactionDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Payment Authorized' ORDER BY [" + Session["col"] + "] " + Session["sort"];
//		string sql = Session["id"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		string sql = Session["sql"].ToString() + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		data = getMssqlData(sql);

		dataView.DataSource = data.Tables[0].DefaultView;
		dataView.DataBind();
	}


    	private void lead_page(Object sender, DataGridPageChangedEventArgs e) {
		//string sql = @"select id as [ID], users.name as [Assigned To], student_last_name + ',' + student_first_name as [Student Name], student_high_school as [High School], home_phone as [Home Phone], status + ' ' + cast(month(d.transactionDate) as varchar) + '-' + cast(day(d.transactionDate) as varchar) + '-' + cast(year(d.transactionDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Payment Authorized' ORDER BY [" + Session["col"] + "] " + Session["sort"];
//		string sql = Session["id"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		string sql = Session["sql"].ToString() + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		data = getMssqlData(sql);

		dataView.DataSource = data.Tables[0].DefaultView;
        	dataView.CurrentPageIndex = e.NewPageIndex;
		dataView.DataBind();
	}


	private void AssignGroup (Object sender, EventArgs e) {
		String sql;
		RowSelectorColumn  rsc = RowSelectorColumn.FindColumn(dataView);
		message.Text = "";
        	if (rsc.SelectedIndexes.Length == 0) {
			message.Text = "You must select at least one lead to re-assign to use group re-assignment";
		} else if (Request["user"] == "") {
			message.Text = "You must specify the Rep to use group re-assignment";
		} else {
			message.Text = rsc.SelectedIndexes.Length + " Leads Successfully Re-Assigned";

			foreach (int selIndex in rsc.SelectedIndexes) {
				Session["id"] = dataView.DataKeys[selIndex].ToString();

				sql = "UPDATE " + Session["mainDataTable"] + " SET transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user"] + " WHERE [id] = " + Session["id"] + ";";
				getMssqlData(sql);
				//restxt.Text  += sql + "<p>";
				
				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user2"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				//restxt.Text  += sql + "<p>";

				// updateLog(Session["id"].ToString(), "Assigned");
			}
			Session["id"] = null;
//			sql = Session["id"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
			sql = Session["sql"].ToString() + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
			data = getMssqlData(sql);
//			dataView.DataSource = data.Tables[0].DefaultView;
//			dataView.DataBind();

			dataView.DataSource = data.Tables[0].DefaultView;
			dataView.DataBind();
		}
	}

    	</script>
  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/admin_menu/nav1.aspx"-->
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
	


	<% if(Session["state"].ToString() == "list") { %>


		<% if(data.Tables[0].Rows.Count > 0) { %>

		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">

		<tr>
			<td align="center"><font class="black">Authorized Cases</td>
		</tr>
		<tr>
			<td class="grey" align="center">
				<ASP:Datagrid 
				id="dataView" 
				runat="server" 
				DataKeyField="ID"
				allowsorting="true" 
				AllowPaging="true" 
				PageSize="25" 
				PagerStyle-Mode="NumericPages"
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
				OnEditCommand="reviewLead"
				OnSortCommand="lead_sort"
				OnPageIndexChanged="lead_page"
				>

				<columns>
					
					<asp:editcommandcolumn buttontype="PushButton" edittext="Re-Assign"/>
					<asp:editcommandcolumn buttontype="PushButton" edittext="Info"/>
				</columns>

				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>
			</font></td>
		</tr>
		<tr>
			<td>
	&nbsp;&nbsp;<font class="black">Re-Assign Selected To: &nbsp;</font><select name="user"><%= printUserList() %></select> <asp:Button runat="server" onclick="AssignGroup" text="Re-Assign Selected" /> </p>
			</td>
		</tr>
		</table>
	

		<% }else{ %>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr class="grey" align="center">
			<td><font class="black">There are no authorized cases to view.</font></td>

		</tr>
		</table>

		<% } %>


	<% }else if(Session["state"].ToString() == "reassign") {
		//DataSet tmp = getMssqlData(@"SELECT client_last_name + ',' + client_first_name as [Client Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE id = '" + Session["reassign"] + "';");
		DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM [" + Session["mainDataTable"] + "] AS d INNER JOIN users ON users.userid = d.userid WHERE [id] = " + Session["reassign"] + ";");
	%>
	
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">

		<tr>
			<td align="center"><font class="black">Re-Assign Lead</td>
		</tr>
		<tr>
			<td align="center">
				<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="70%">
				<tr>
					<td><font class="red">Student Name&nbsp;</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Student Name"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Assigned To</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Assigned To"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Home Phone</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Home Phone"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Status</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Status"] %></font></td>
				</tr>
				<tr>
					<td><font class="red">Re-Assign To</font></td>
					<td>
					<select name="user">
						<%= printUserList() %>
					</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="assignLead" runat="server" text="Re-Assign Lead" onClick="updateDB" />&nbsp;
						<asp:Button id="cancelReAssignLead" runat="server" text="Cancel" onClick="cancelAssign" />
					</td>
				</tr>
				</table>
			</td>
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