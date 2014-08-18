<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
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



		Session["sql"] = "SELECT d.[id] AS [ID], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.col0013 AS [Home Phone], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d WHERE transactionBy = " + Session["userid"] + " AND status = 'New Lead' ";
		string sql = Session["sql"] + " ORDER BY d.transactionDate DESC;";
		data = getMssqlData(sql);
		if(!Page.IsPostBack) {
			Session["delete"] = "first";
			Session["sort"] = "DESC";
			Session["col"] = "transactionDate";

			try {
				dataView.DataSource = data.Tables[0].DefaultView;
				dataView.DataBind();
				//Session["state"] = "show";
			}catch{
				//Session["state"] = "hide";
			}
		}
		return;
	}


	private void deleteFirst(Object sender, DataGridCommandEventArgs e) {
		string sql = "";
		Session["id"] = e.Item.Cells[1].Text.Trim();

		//sql = @"select d.[id] AS [ID], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.col0013 AS [Home Phone], c.status + ' ' + cast(month(c.transactionDate) AS varchar) + '-' + cast(day(c.transactionDate) AS varchar) + '-' + cast(year(c.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN " + Session["mainLogTable"] + " AS c ON c.[claimid] = " + Session["id"] + " WHERE c.transactionBy = " + Session["userid"] + " AND [status] = 'New Lead' ";
		sql = Session["sql"] + " AND [id] = " + Session["id"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];	

		data = getMssqlData(sql);
		dataView2.DataSource = data.Tables[0].DefaultView;
		dataView2.DataBind();
		Session["delete"] = "second";
		message.Text = "Please confirm deletion by hitting 'Delete' again.<br>DO NOT use the browser back button on this screen!";
	}

	private void deleteSecond(Object sender, DataGridCommandEventArgs e) {
		Button b = (Button) e.CommandSource;
		String sql = "";
		if(b.Text == "Delete") {
			Session["delete"] = "first";
			if(Session["id"].ToString() == e.Item.Cells[2].Text.Trim() ) {
				try {
					getMssqlData("DELETE FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["id"] + ";");
					message.Text = "Claim deleted successfully.";
				}catch{
					message.Text = "Claim data could not be deleted.";
				}

				try {
					getMssqlData("DELETE FROM " + Session["mainParentTable"] + " WHERE [claimid] = " + Session["id"] + ";");
					message.Text = "Claim deleted successfully.";
				}catch{
					message.Text = "Claim parent data could not be deleted.";
				}

				try {
					getMssqlData("DELETE FROM [notes] WHERE [claimid] = " + Session["id"] + ";");
					message.Text = "Claim deleted successfully.";
				}catch{
					message.Text = "Claim comments data could not be deleted.";
				}

				try {
					updateLog(Session["id"].ToString(), "Deleted");
					getMssqlData("UPDATE " + Session["mainLogTable"] + " SET [active] = 'N' WHERE [claimid] = " + Session["id"] + ";");
					message.Text = "Claim deleted successfully.";
				}catch{
					message.Text = "Could not update the transaction log.";
				}	
				sql = Session["sql"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
				data = getMssqlData(sql);
				dataView.DataSource = data.Tables[0].DefaultView;
				dataView.DataBind();
			}	
		}else if(b.Text == "Cancel") {
			Session["delete"] = "first";
			Session["id"] = null;
			message.Text = "";
		}
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
		string sql = Session["sql"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		data = getMssqlData(sql);
		dataView.DataSource = data.Tables[0].DefaultView;
		dataView.DataBind();
	}


    	private void lead_page(Object sender, DataGridPageChangedEventArgs e) {
		string sql = Session["sql"] + " ORDER BY [" + Session["col"] + "] " + Session["sort"];
		data = getMssqlData(sql);
		dataView.DataSource = data.Tables[0].DefaultView;
        	dataView.CurrentPageIndex = e.NewPageIndex;
		dataView.DataBind();
	}

    	</script>
  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/intern_menu/nav1.aspx"-->
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
			<td align="center"><font class="black">All Cases</td>
		</tr>
		<tr>
			<% if(Session["delete"].ToString() == "first") { %>
			<td class="grey" align="center">
				<ASP:Datagrid 
				id="dataView" 
				runat="server" 
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
				OnEditCommand="deleteFirst"
				OnSortCommand="lead_sort"
				OnPageIndexChanged="lead_page"
				>

				<columns>
					<asp:editcommandcolumn buttontype="PushButton" edittext="Delete"/>
				</columns>

				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>
			</td>
			<% }else{ %>
			<td class="grey" align="center">
				<ASP:Datagrid 
				id="dataView2" 
				runat="server" 
				allowsorting="false" 
				AllowPaging="false" 
				PageSize="1" 
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
				OnEditCommand="deleteSecond"
				>

				<columns>
					<asp:editcommandcolumn buttontype="PushButton" edittext="Delete"/>
					<asp:editcommandcolumn buttontype="PushButton" edittext="Cancel"/>
				</columns>

				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>
			</td>
			<% } %>
		</tr>
		</table>
	<% }else{ %>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr align="center">
			<td class="grey"><font class="black">There are no cases to view.</font></td>

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