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
	DataSet newLeads;
	DataSet assignedLeads;
	DataSet scheduledLeads;
		
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
			Response.Redirect("./timeout.aspx");
		}
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() != "admin") {
		    if((Session["userid"].ToString() == "34") || (Session["userid"].ToString() == "44") || (Session["userid"].ToString() == "30") || (Session["userid"].ToString() == "49")){
    		    Response.Redirect("./new_leads.aspx");
    		}
    		else{
    			Response.Redirect("./nopriv.aspx");
    		}
		}


		message.Text = "";
		

		//only runs the following code the first time this page loads
		Session["sqlnew"] =  @"select d.[id] AS [ID], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.col0013 AS [Home Phone], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d WHERE [status] = 'New Lead' ";
		string sql = Session["sqlnew"] + "ORDER BY transactionDate DESC";
		newLeads = getMssqlData(sql);

//		Session["sqlold"] = @"select d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.col0013 AS [Home Phone], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid WHERE [status] = 'Assigned' ";
		Session["sqlold"] = @"select d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid WHERE [status] = 'Assigned' ";
		sql = Session["sqlold"] + "ORDER BY transactionDate DESC";
		assignedLeads = getMssqlData(sql);

//		Session["sqlsch"] = @"select d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.col0018 AS [High School], d.col0013 AS [Home Phone], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid WHERE [status] = 'Scheduled' ";
//		Session["sqlsch"] = @"select d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], cast(month(d.nextApptDate) AS varchar) + '-' + cast(day(d.nextApptDate) AS varchar) + '-' + cast(year(d.nextApptDate) AS varchar) AS [Appointment Date], locations.name AS [Location], d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid LEFT JOIN locations ON d.nextApptLocationid=locations.id WHERE [status] = 'Scheduled' ";
		Session["sqlsch"] = @"select d.[id] AS [ID], users.name AS [Assigned To], d.col0004 + ',' + d.col0002 AS [Student Name], d.nextApptDate AS [Appointment Date], locations.name AS [Location] FROM " + Session["mainDataTable"] + " AS d INNER JOIN users ON d.userid=users.userid LEFT JOIN locations ON d.nextApptLocationid=locations.id WHERE [status] = 'Scheduled' AND nextApptDate > getdate() AND users.userid != 29";

		sql = Session["sqlsch"] + "ORDER BY transactionDate DESC";
		scheduledLeads = getMssqlData(sql);

		if(!Page.IsPostBack) {
			Session["newsort"] = "DESC";
			Session["newcol"] = "transactionDate";

			Session["asssort"] = "DESC";
			Session["asscol"] = "transactionDate";

			Session["schsort"] = "DESC";
			Session["schcol"] = "transactionDate";

			Session["state"] = "list";
			Session["assign"] = "";

			Session["astate"] = "list";
			Session["reassign"] = "";

			Session["sstate"] = "list";
			Session["sreassign"] = "";

			leads.DataSource = newLeads.Tables[0].DefaultView;
			leads.DataBind();

			aleads.DataSource = assignedLeads.Tables[0].DefaultView;
			aleads.DataBind();

			sleads.DataSource = scheduledLeads.Tables[0].DefaultView;
			sleads.DataBind();

		}
		return;
	}

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
			message.Text = "** There was an error processing your request. **" + ex.Message;
			return;
		}
	}

	private void assignNewLead(Object sender, DataGridCommandEventArgs e) {
		Button b = (Button) e.CommandSource;
		//Response.Write(e.Item.Cells[3].Text.Trim());
		//return;
		if(b.Text == "Assign") {
			Session["state"] = "assign";
			Session["assign"] = e.Item.Cells[3].Text.Trim();
		}else if(b.Text == "Re-Assign") {
			Session["astate"] = "reassign";
			Session["reassign"] = e.Item.Cells[3].Text.Trim();
		}else if(b.Text == "Info") {
			openClaimReviewMenu(sender,e);
		}
	}

	private void reviewLead(Object sender, DataGridCommandEventArgs e) {

		Button b = (Button) e.CommandSource;
		//Response.Write(e.Item.Cells[3].Text.Trim());
		//return;
		if(b.Text == "Re-Assign") {
			Session["sstate"] = "reassign";
			Session["sreassign"] = e.Item.Cells[3].Text.Trim();
		}else if(b.Text == "Info") {
			openClaimReviewMenu(sender,e);
		}
	}

	private void updateDB(Object sender, EventArgs e) {
		try {
			Button b = (Button) sender;
			//Response.Write(b.Text);
			string sql = "";
			if(b.Text == "Re-Assign Lead") {
				//sql = "UPDATE mfac_client_data SET status = 'Assigned', assignedBy = '" + Session["userid"] + "', assignedDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user2"] + "' WHERE id = '" + Session["reassign"] + "';";
				Session["id"] = Session["reassign"];
				sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user2"] + "' WHERE id = '" + Session["id"] + "';";

				Session["astate"] = "list";
				Session["reassign"] = "";
				getMssqlData(sql);

				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user2"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				updateLog(Session["id"].ToString(), "Assigned");
			}else{
				Session["id"] = Session["assign"];
				//sql = "UPDATE mfac_client_data SET status = 'Assigned', assignedBy = '" + Session["userid"] + "', assignedDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user1"] + "' WHERE id = '" + Session["assign"] + "';";
				sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user1"] + "' WHERE id = '" + Session["id"] + "';";

				//restxt.Text = sql;
				Session["state"] = "list";
				Session["assign"] = "";
				getMssqlData(sql);

				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user1"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				updateLog(Session["id"].ToString(), "Assigned");
			}
			sql = Session["sqlold"].ToString();
			assignedLeads = getMssqlData(sql);

			aleads.DataSource = assignedLeads.Tables[0].DefaultView;
			aleads.DataBind();

			sql = Session["sqlnew"].ToString();
			newLeads = getMssqlData(sql);

			leads.DataSource = newLeads.Tables[0].DefaultView;
			leads.DataBind();
			Session["id"] = null;

		}catch(Exception ex){
			message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
			return;
		}
	}


	// this function is called when scheduled leads re-assign button is clicked
	private void updateDB2(Object sender, EventArgs e) {
		try {
			Button b = (Button) sender;
			//Response.Write(b.Text);
			string sql = "";
			if(b.Text == "Re-Assign Lead") {
				//sql = "UPDATE mfac_client_data SET status = 'Assigned', assignedBy = '" + Session["userid"] + "', assignedDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user2"] + "' WHERE id = '" + Session["reassign"] + "';";
				Session["id"] = Session["sreassign"];
				// sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user2"] + "' WHERE id = '" + Session["id"] + "';";
				sql = "UPDATE " + Session["mainDataTable"] + " SET transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user3"] + "' WHERE id = '" + Session["id"] + "';";
				//Response.Write(sql);
				Session["sstate"] = "list";
				Session["sreassign"] = "";
				getMssqlData(sql);

				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user2"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				updateLog(Session["id"].ToString(), "Assigned");
			}

			sql = Session["sqlsch"].ToString();
			scheduledLeads = getMssqlData(sql);

			sleads.DataSource = scheduledLeads.Tables[0].DefaultView;
			sleads.DataBind();
			Session["id"] = null;

		}catch(Exception ex){
			message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
			return;
		}
	}




	private void cancelReAssign(Object sender, EventArgs e) {
		Session["astate"] = "list";
		Session["reassign"] = "";

		Session["sstate"] = "list";
		Session["sreassign"] = "";
	}

	private void cancelAssign(Object sender, EventArgs e) {
		Session["state"] = "list";
		Session["assign"] = "";
	}

	private void newlead_sort(Object o, DataGridSortCommandEventArgs e) {
		string col = (string)e.SortExpression;
		if(col == Session["newcol"].ToString()) {
			if(Session["newsort"].ToString() == "desc") {
				Session["newsort"] = "asc";
			}else{
				Session["newsort"] = "desc";
			}
		}else{
			Session["newcol"] = col;
		}
		//string sql = @"select id as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data WHERE status = 'New Lead' ORDER BY [" + Session["newcol"] + "] " + Session["newsort"];
		string sql = Session["sqlnew"] + " ORDER BY [" + Session["newcol"] + "] " + Session["newsort"]; 
		newLeads = getMssqlData(sql);

		leads.DataSource = newLeads.Tables[0].DefaultView;
		leads.DataBind();
	}


    	private void newlead_page(Object sender, DataGridPageChangedEventArgs e) {
		//string sql = @"select id as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data WHERE status = 'New Lead' ORDER BY [" + Session["newcol"] + "] " + Session["newsort"];
		string sql = Session["sqlnew"] + " ORDER BY [" + Session["newcol"] + "] " + Session["newsort"]; 
		newLeads = getMssqlData(sql);

		leads.DataSource = newLeads.Tables[0].DefaultView;
        	leads.CurrentPageIndex = e.NewPageIndex;
		leads.DataBind();
	}

	private void schlead_sort(Object o, DataGridSortCommandEventArgs e) {
		string col = (string)e.SortExpression;
		if(col == Session["schcol"].ToString()) {
			if(Session["schsort"].ToString() == "desc") {
				Session["schsort"] = "asc";
			}else{
				Session["schsort"] = "desc";
			}
		}else{
			Session["schcol"] = col;
		}
		//string sql = @"select id as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data WHERE status = 'New Lead' ORDER BY [" + Session["newcol"] + "] " + Session["newsort"];
		string sql = Session["sqlsch"] + " ORDER BY [" + Session["schcol"] + "] " + Session["schsort"]; 
		scheduledLeads = getMssqlData(sql);

		sleads.DataSource = scheduledLeads.Tables[0].DefaultView;
		sleads.DataBind();
	}


    	private void schlead_page(Object sender, DataGridPageChangedEventArgs e) {
		//string sql = @"select id as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data WHERE status = 'New Lead' ORDER BY [" + Session["newcol"] + "] " + Session["newsort"];
		string sql = Session["sqlsch"] + " ORDER BY [" + Session["schcol"] + "] " + Session["schsort"]; 
		scheduledLeads = getMssqlData(sql);

		sleads.DataSource = scheduledLeads.Tables[0].DefaultView;
        	sleads.CurrentPageIndex = e.NewPageIndex;
		sleads.DataBind();
	}


	private void assignedlead_sort(Object o, DataGridSortCommandEventArgs e) {
		string col = (string)e.SortExpression;
		if(col == Session["asscol"].ToString()) {
			if(Session["asssort"].ToString() == "desc") {
				Session["asssort"] = "asc";
			}else{
				Session["asssort"] = "desc";
			}
		}else{
			Session["asscol"] = col;
		}
		//string sql = @"select id as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(assignedDate) as varchar) + '/' + cast(day(assignedDate) as varchar) + '/' + cast(year(assignedDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Assigned' ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
		string sql = Session["sqlold"] + " ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
		assignedLeads = getMssqlData(sql);

		aleads.DataSource = assignedLeads.Tables[0].DefaultView;
		aleads.DataBind();
	}


    	private void assignedlead_page(Object sender, DataGridPageChangedEventArgs e) {
		//string sql = @"select id as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(assignedDate) as varchar) + '/' + cast(day(assignedDate) as varchar) + '/' + cast(year(assignedDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Assigned' ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
		string sql = Session["sqlold"] + " ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
		assignedLeads = getMssqlData(sql);

		//Response.Write(e.NewPageIndex + "");
		aleads.DataSource = assignedLeads.Tables[0].DefaultView;
        	aleads.CurrentPageIndex = e.NewPageIndex;
		aleads.DataBind();
	}

	private void AssignGroup (Object sender, EventArgs e) {
		String sql;
		RowSelectorColumn  rsc = RowSelectorColumn.FindColumn(leads);
		message.Text = "";
        	if (rsc.SelectedIndexes.Length == 0) {
			message.Text = "You must select at least one lead to assign to use group assignment";
		} else if (Request["user1"] == "") {
			message.Text = "You must specify the Rep to use group assignment";
		} else {
			message.Text = rsc.SelectedIndexes.Length + " Leads Successfully Assigned";

			foreach (int selIndex in rsc.SelectedIndexes) {
				Session["id"] = leads.DataKeys[selIndex].ToString();
				//sql = "UPDATE mfac_client_data SET status = 'Assigned', assignedBy = '" + Session["userid"] + "', assignedDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user1"] + "' WHERE id = '" + Session["id"] + "';";
				sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user1"] + " WHERE [id] = " + Session["id"] + ";";
				//Response.Write(sql);
				
				getMssqlData(sql);
				//restxt.Text  += sql + "<p>";
				
				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user1"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				//restxt.Text  += sql + "<p>";
				updateLog(Session["id"].ToString(), "Assigned");
			}
			Session["id"] = null;

			//sql = @"select id as [ID],student_high_school as [High School],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data WHERE status = 'New Lead' ORDER BY createdDate DESC";
			sql = Session["sqlnew"] + " ORDER BY [" + Session["newcol"] + "] " + Session["newsort"];
			newLeads = getMssqlData(sql);
			leads.DataSource = newLeads.Tables[0].DefaultView;
			leads.DataBind();

			//sql = @"select id as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(assignedDate) as varchar) + '/' + cast(day(assignedDate) as varchar) + '/' + cast(year(assignedDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Assigned' ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
			sql = Session["sqlold"] + " ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
			assignedLeads = getMssqlData(sql);
			aleads.DataSource = assignedLeads.Tables[0].DefaultView;
			aleads.DataBind();
		}

	}

	private void ReAssignGroup (Object sender, EventArgs e) {
		String sql;
		RowSelectorColumn  rsc = RowSelectorColumn.FindColumn(aleads);
		message.Text = "";
        	if (rsc.SelectedIndexes.Length == 0) {
			message.Text = "You must select at least one lead to re-assign to use group re-assignment";
		} else if (Request["user2"] == "") {
			message.Text = "You must specify the Rep to use group re-assignment";
		} else {
			message.Text = rsc.SelectedIndexes.Length + " Leads Successfully Re-Assigned";

			foreach (int selIndex in rsc.SelectedIndexes) {
				Session["id"] = aleads.DataKeys[selIndex].ToString();
				//sql = "UPDATE mfac_client_data SET status = 'Assigned', assignedBy = '" + Session["userid"] + "', assignedDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user2"] + "' WHERE id = '" + Session["id"] + "';";
				sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user2"] + " WHERE [id] = " + Session["id"] + ";";
				getMssqlData(sql);
				//restxt.Text  += sql + "<p>";
				
				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user2"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				//restxt.Text  += sql + "<p>";
				updateLog(Session["id"].ToString(), "Assigned");
			}
			Session["id"] = null;
			//sql = @"select [id] as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(assignedDate) as varchar) + '/' + cast(day(assignedDate) as varchar) + '/' + cast(year(assignedDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Assigned' ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
			sql = Session["sqlold"] + " ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
			assignedLeads = getMssqlData(sql);
			aleads.DataSource = assignedLeads.Tables[0].DefaultView;
			aleads.DataBind();
		}

	}


	private void ReAssignSchedGroup (Object sender, EventArgs e) {
		String sql;
		RowSelectorColumn  rsc = RowSelectorColumn.FindColumn(sleads);
		message.Text = "";
        	if (rsc.SelectedIndexes.Length == 0) {
			message.Text = "You must select at least one lead to re-assign to use group re-assignment";
		} else if (Request["user3"] == "") {
			message.Text = "You must specify the Rep to use group re-assignment";
		} else {
			message.Text = rsc.SelectedIndexes.Length + " Leads Successfully Re-Assigned";

			foreach (int selIndex in rsc.SelectedIndexes) {
				Session["id"] = sleads.DataKeys[selIndex].ToString();
				//sql = "UPDATE mfac_client_data SET status = 'Assigned', assignedBy = '" + Session["userid"] + "', assignedDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user3"] + "' WHERE id = '" + Session["id"] + "';";
				//sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user3"] + " WHERE [id] = " + Session["id"] + ";";
				sql = "UPDATE " + Session["mainDataTable"] + " SET transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user3"] + " WHERE [id] = " + Session["id"] + ";";
				getMssqlData(sql);
				//restxt.Text  += sql + "<p>";

				
				//sql = "INSERT INTO assignmentHistory (userid,assignedBy,assignedDate) VALUES('" + Request["user2"] + "','" + Session["userid"] + "','" + System.DateTime.Now + "');";
				//getMssqlData(sql);
				//restxt.Text  += sql + "<p>";
				updateLog(Session["id"].ToString(), "Assigned");
			}
			Session["id"] = null;
			//sql = @"select [id] as [ID],student_last_name + ',' + student_first_name as [Student Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(assignedDate) as varchar) + '/' + cast(day(assignedDate) as varchar) + '/' + cast(year(assignedDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE status = 'Assigned' ORDER BY [" + Session["asscol"] + "] " + Session["asssort"];
			sql = Session["sqlsch"] + " ORDER BY [" + Session["schcol"] + "] " + Session["schsort"];
			scheduledLeads = getMssqlData(sql);
			sleads.DataSource = scheduledLeads.Tables[0].DefaultView;
			sleads.DataBind();
		}

	}
    	</script>


  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/admin_menu/nav.aspx"-->

<form runat="server">
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
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<% if(Session["state"].ToString() == "list") { %>
		<tr>
			<td align="center"><font class="black">New Leads</td>
		</tr>

		<tr>
			<td class="grey" align="center">

				<% if(newLeads.Tables.Count > 0) {
					if(newLeads.Tables[0].Rows.Count > 0) { %>
					<ASP:Datagrid 
						id="leads" 
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
						OnEditCommand="assignNewLead"
						OnSortCommand="newlead_sort"
						OnPageIndexChanged="newlead_page"
						Font-Size = "9pt"
						Font-Name = "Arial"
						>
						<columns>
							<mbrsc:RowSelectorColumn AllowSelectAll="True" SelectionMode="Multiple" />
							<asp:editcommandcolumn buttontype="PushButton" edittext="Assign"/>
							<asp:editcommandcolumn buttontype="PushButton" edittext="Info"/>
						</columns>

						<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
						<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
						<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
						<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
						<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
					</asp:datagrid>
					<% }else{ %>
						<font class="black">There are no new leads to view.</font>
					<% } %>
				<% }else{ %>
					<font class="black">There are no new leads to view.</font>
				<% } %>
		<% }else if(Session["state"].ToString() == "assign"){
			DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM [" + Session["mainDataTable"] + "] WHERE [id] = " + Session["assign"] + ";");
			//Response.Write(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM [" + Session["mainDataTable"] + "] WHERE [id] = " + Session["assign"] + ";");
			//return;
		%>
		<tr>
			<td align="center"><font class="black">Assign Lead</td>
		</tr>
		<tr>
			<td align="center">
				<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="70%">
				<tr>
					<td><font class="red">Student Name&nbsp;</font></td>
					<td><font class="black"><%= tmp.Tables[0].Rows[0]["Student Name"] %></font></td>
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
					<td><font class="red">Assign To</font></td>
					<td>
					<select name="user1">
						<%= printUserList() %>
					</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="assignLead" runat="server" text="Assign Lead" onClick="updateDB" />&nbsp;
						<asp:Button id="cancelAssignLead" runat="server" text="Cancel" onClick="cancelAssign" />
					</td>
				</tr>
				</table>
		<% } %>
			</td>
		</tr>
		</table>


		<% 
		if(Session["state"].ToString() == "list") {
			if(newLeads.Tables.Count > 0) {
			if(newLeads.Tables[0].Rows.Count > 0) { 
		%>
	
	&nbsp;&nbsp;<font class="black">Assign Selected To: &nbsp;</font><select name="user1"><%= printUserList() %></select> <asp:Button runat="server" onclick="AssignGroup" text="Assign Selected" /> </p>
		<%
				}
			}
		} 
		%>
		

		<p>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">

		<% if(Session["astate"].ToString() == "list") { %>
		<tr>
			<td align="center"><font class="black">Assigned Leads</td>
		</tr>
		<tr>
			<td class="grey" align="center">
			<% if(assignedLeads.Tables.Count > 0) {
				if(assignedLeads.Tables[0].Rows.Count > 0) { %>
				<ASP:Datagrid 
				id="aleads" 
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
				OnEditCommand="assignNewLead"
				OnSortCommand="assignedlead_sort"
				OnPageIndexChanged="assignedlead_page"
				>

				<columns>
					<mbrsc:RowSelectorColumn AllowSelectAll="True" SelectionMode="Multiple" />
					<asp:editcommandcolumn buttontype="PushButton" edittext="Re-Assign"/>
					<asp:editcommandcolumn buttontype="PushButton" edittext="Info"/>
				</columns>

				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>
				<% }else{ %>
					<font class="black">There are no assigned leads to view.</font>
				<% } %>
			<% }else{ %>
				<font class="black">There are no assigned leads to view.</font>
			<% } %>
		<% }else if(Session["astate"].ToString() == "reassign") {
			//DataSet tmp = getMssqlData(@"SELECT client_last_name + ',' + client_first_name as [Client Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE id = '" + Session["reassign"] + "';");
			DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM [" + Session["mainDataTable"] + "] AS d INNER JOIN users ON users.userid = d.userid WHERE [id] = " + Session["reassign"] + ";");
		%>
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
					<select name="user2">
						<%= printUserList() %>
					</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="assignLead2" runat="server" text="Re-Assign Lead" onClick="updateDB" />&nbsp;
						<asp:Button id="cancelReAssignLead" runat="server" text="Cancel" onClick="cancelReAssign" />
					</td>
				</tr>
				</table>
		<% } %>
			</td>
		</tr>
		</table>

		<% if(Session["astate"].ToString() == "list") {
			if(assignedLeads.Tables.Count > 0) {
				if(assignedLeads.Tables[0].Rows.Count > 0) { %>
	
	&nbsp;&nbsp;<font class="black">Re-Assign Selected To: &nbsp;</font><select name="user2"><%= printUserList() %></select> <asp:Button runat="server" onclick="ReAssignGroup" text="Re-Assign Selected" /> </p>
		<%  		}
			}
		    } %>



		<!-- Scheduled Leads grid -->

		<p>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<% if(Session["sstate"].ToString() == "list") { %>

		<tr>
			<td align="center"><font class="black">Scheduled Leads</td>
		</tr>
		<tr>
			<td class="grey" align="center">
			<% if(scheduledLeads.Tables.Count > 0) {
				if(scheduledLeads.Tables[0].Rows.Count > 0) { %>
				<ASP:Datagrid 
				id="sleads" 
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
				OnSortCommand="schlead_sort"
				OnPageIndexChanged="schlead_page"
				>

				<columns>
					<mbrsc:RowSelectorColumn AllowSelectAll="True" SelectionMode="Multiple" />
					<asp:editcommandcolumn buttontype="PushButton" edittext="Re-Assign"/>
					<asp:editcommandcolumn buttontype="PushButton" edittext="Info"/>
				</columns>

				<SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
				<AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
				<ItemStyle ForeColor="#000000" BackColor="#E7E7FF"></ItemStyle>
				<HeaderStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#4A3C8C"></HeaderStyle>
				<FooterStyle ForeColor="#4A3C8C" BackColor="#B5C7DE"></FooterStyle>
				</asp:datagrid>
				<% }else{ %>
					<font class="black">There are no scheduled cases to view.</font>
				<% } %>
			<% } %>

		<% }else if(Session["sstate"].ToString() == "reassign") {
			//DataSet tmp = getMssqlData(@"SELECT client_last_name + ',' + client_first_name as [Client Name], home_phone as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM mfac_client_data INNER JOIN users ON users.userid = mfac_client_data.userid WHERE id = '" + Session["reassign"] + "';");
			DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], users.name as [Assigned To], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM [" + Session["mainDataTable"] + "] AS d INNER JOIN users ON users.userid = d.userid WHERE [id] = " + Session["sreassign"] + " AND users.userid != 29;");
		%>


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
					<select name="user3">
						<%= printUserList() %>
					</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:Button id="assignLead3" runat="server" text="Re-Assign Lead" onClick="updateDB2" />&nbsp;
						<asp:Button id="cancelSchedReAssignLead" runat="server" text="Cancel" onClick="cancelReAssign" />
					</td>
				</tr>
				</table>

		<% } %>
			</td>
		</tr>
		</table>

		<% if(Session["sstate"].ToString() == "list") {
			if(scheduledLeads.Tables.Count > 0) {
				if(scheduledLeads.Tables[0].Rows.Count > 0) { %>
	
	&nbsp;&nbsp;<font class="black">Re-Assign Selected To: &nbsp;</font><select name="user3"><%= printUserList() %></select> <asp:Button runat="server" onclick="ReAssignSchedGroup" text="Re-Assign Selected" /> </p>
		<%  		}
			}
		    } %>


	

	</td>
</tr>
</table>
</form>
<!--#include file="./footer.aspx"-->
</body>
</html>