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
	<script language=javascript>
//Date:29/11/2007 
//In this page i have added the three grids and all other functionality is the same only in this all datagrids are converted to the gridview.
//In all the 3 grids the delete link is there so we can delete that particular record and it is deleted from the database and and in the gridview.
//when clicking on the delete button in the gridview the javascript confirmation comes.
 function SelectAllCheckboxes(spanChk){

   // Added as ASPX uses SPAN for checkbox
   var oItem = spanChk.children;
   var theBox= (spanChk.type=="checkbox") ? 
        spanChk : spanChk.children.item[0];
   xState=theBox.checked;
   elm=theBox.form.elements;

   for(i=0;i<elm.length;i++)
     if(elm[i].type=="checkbox" && 
              elm[i].id!=theBox.id)
     {
       //elm[i].click();
       if(elm[i].checked!=xState)
         elm[i].click();
      // elm[i].checked=xState;
     }
 }
 
 
</script>
	<script language="C#" runat="server">
	
		
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

		}
		return;
	}



	private string printUserList() {
		string package = "";
		string connStr = "DATA SOURCE=" + Session["dbserver"] + ";User ID=" + Session["dbusername"] + ";Password=" + Session["dbpassword"] + ";DATABASE=" + Session["database"];
		string sql = "SELECT * FROM madison_sysdba.users WHERE account_type = 'Representative' ORDER BY name";
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



        private void updateDB(Object sender, EventArgs e)
        {
            try
            {
                Button b = (Button)sender;
                //Response.Write(b.Text);
                string sql = "";
                if (b.Text == "Re-Assign Lead")
                {

                    Session["id"] = Session["reassign"];
                    sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user2"] + "' WHERE id = '" + Session["id"] + "';";

                    Session["astate"] = "list";
                    Session["reassign"] = "";
                    getMssqlData(sql);

                    updateLog(Session["id"].ToString(), "Assigned");
                    GridView1.DataBind();
                    GridView2.DataBind();
                }
                else
                {

                    Session["id"] = Session["assign"];

                    sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user1"] + "' WHERE id = '" + Session["id"] + "';";

                    //restxt.Text = sql;
                    Session["state"] = "list";
                    Session["assign"] = "";
                    getMssqlData(sql);


                    updateLog(Session["id"].ToString(), "Assigned");
                    GridView2.DataBind();
                }

            }
            catch (Exception ex)
            {
                message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
                return;
            }
        }

        private void updateDB2(Object sender, EventArgs e)
        {
            try
            {
                //Button b = (Button)sender;
               
                string sql = "";
                                   
                    Session["id"] = Session["sreassign"];
                    sql = "UPDATE " + Session["mainDataTable"] + " SET transactionBy = '" + Session["userid"] + "', transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = '" + Request["user3"] + "' WHERE id = '" + Session["id"] + "';";
                    Session["sstate"] = "list";
                    Session["sreassign"] = "";
                    getMssqlData(sql);
                    updateLog(Session["id"].ToString(), "Assigned");
                    GridView3.DataBind();       
                Session["id"] = null;

            }
            catch (Exception ex)
            {
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


        private void AssignGroup(Object sender, EventArgs e)
        {
            try
            {
                string sql;
                message.Text = "";

                foreach (GridViewRow row in GridView1.Rows)
                {
                    CheckBox check = (CheckBox)row.FindControl("chkSelect");
                    if (check != null && check.Checked)
                    {
                        int id = Convert.ToInt32(GridView1.DataKeys[row.RowIndex].Value);
                        Session["id"] = Convert.ToInt32(id);
                        sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user1"] + " WHERE [id] = " + Session["id"] + ";";
                        getMssqlData(sql);
                        updateLog(Session["id"].ToString(), "Assigned");
                        GridView1.DataBind();
                    }

                }
                Session["id"] = null;
            }
            catch (Exception ex)
            {
                message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
                return;
            }
        }
          
          private void ReAssignGroup (Object sender, EventArgs e) 
          {
              try
              {
                  string sql;
                  message.Text = "";

                  foreach (GridViewRow row in GridView2.Rows)
                  {
                      CheckBox check = (CheckBox)row.FindControl("chkAssignSelect");
                      if (check != null && check.Checked)
                      {
                          int id = Convert.ToInt32(GridView2.DataKeys[row.RowIndex].Value);
                          Session["id"] = Convert.ToInt32(id);
                          sql = "UPDATE " + Session["mainDataTable"] + " SET status = 'Assigned', transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user2"] + " WHERE [id] = " + Session["id"] + ";";
                          getMssqlData(sql);
                          updateLog(Session["id"].ToString(), "Assigned");
                          GridView2.DataBind();
                      }

                  }
                  Session["id"] = null;
              }
              catch (Exception ex)
              {
                  message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
                  return;
              }
	      }
        private void ReAssignSchedGroup(Object sender, EventArgs e)
        {
            try
            {
                string sql;
                message.Text = "";
                foreach (GridViewRow row in GridView3.Rows)
                {
                    CheckBox check = (CheckBox)row.FindControl("chkReAssignSelect");
                    if (check != null && check.Checked)
                    {
                        int id = Convert.ToInt32(GridView3.DataKeys[row.RowIndex].Value);
                        Session["id"] = Convert.ToInt32(id);
                        sql = "UPDATE " + Session["mainDataTable"] + " SET transactionBy = " + Session["userid"] + ", transactionDate = '" + System.DateTime.Now.ToShortDateString() + "', userid = " + Request["user3"] + " WHERE [id] = " + Session["id"] + ";";
                        getMssqlData(sql);
                        updateLog(Session["id"].ToString(), "Assigned");
                        GridView3.DataBind();
                    }


                }
                Session["id"] = null;
            }
            catch (Exception ex)
            {
                message.Text = " " + ex.Message;
            }
           

        }   
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int userid;
                if (e.CommandName == "Select")
                {
                                       
                    userid = Convert.ToInt32(e.CommandArgument);
                    System.Web.HttpContext.Current.Session["id"] = Convert.ToInt32(userid);
                    message.Text = "";
                    DataSet temp = getMssqlData("SELECT col0004,col0002,col0013 FROM " + Session["mainDataTable"] + " WHERE [id] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["home_phone"] = temp.Tables[0].Rows[0]["col0013"].ToString();
                    Session["student_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["student_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();

                    temp = getMssqlData("SELECT col0004,col0002,col0018 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["parent_email_address"] = temp.Tables[0].Rows[0]["col0018"].ToString();
                    Session["client_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["client_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();
                    Response.Redirect("./case_info.aspx");
                }
                else if (e.CommandName == "Assign")
                {
                    userid = Convert.ToInt32(e.CommandArgument);
                    Session["assign"] = Convert.ToInt32(userid);
                    Session["state"] = "assign";
                    
                }
                
            }
            catch (Exception ex)
            {
                message.Text = "** There was an error processing your request. **" + ex.Message;
                return;
            }

        }   
        
        protected void GridView2Update(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int userid;
                if (e.CommandName == "Select")
                {
                                       
                    userid = Convert.ToInt32(e.CommandArgument);
                    System.Web.HttpContext.Current.Session["id"] = Convert.ToInt32(userid);
                    message.Text = "";
                    DataSet temp = getMssqlData("SELECT col0004,col0002,col0013 FROM " + Session["mainDataTable"] + " WHERE [id] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["home_phone"] = temp.Tables[0].Rows[0]["col0013"].ToString();
                    Session["student_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["student_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();

                    temp = getMssqlData("SELECT col0004,col0002,col0018 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["parent_email_address"] = temp.Tables[0].Rows[0]["col0018"].ToString();
                    Session["client_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["client_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();
                    Response.Redirect("./case_info.aspx");
                }
                else if (e.CommandName == "Re-Assign")
                {
                    userid = Convert.ToInt32(e.CommandArgument);
                    Session["reassign"] = Convert.ToInt32(userid);
                    Session["astate"] = "reassign";
                    
                }
                
            }
            catch (Exception ex)
            {
                message.Text = "** There was an error processing your request. **" + ex.Message;
                return;
            }

        }

        protected void GridView3UpdateRecord(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int userid;
                if (e.CommandName == "Select")
                {

                    userid = Convert.ToInt32(e.CommandArgument);
                    System.Web.HttpContext.Current.Session["id"] = Convert.ToInt32(userid);
                    message.Text = "";
                    DataSet temp = getMssqlData("SELECT col0004,col0002,col0013 FROM " + Session["mainDataTable"] + " WHERE [id] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["home_phone"] = temp.Tables[0].Rows[0]["col0013"].ToString();
                    Session["student_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["student_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();

                    temp = getMssqlData("SELECT col0004,col0002,col0018 FROM " + Session["mainParentTable"] + " WHERE [id] = 1 AND [claimid] = " + System.Web.HttpContext.Current.Session["id"] + ";");
                    Session["parent_email_address"] = temp.Tables[0].Rows[0]["col0018"].ToString();
                    Session["client_last_name"] = temp.Tables[0].Rows[0]["col0004"].ToString();
                    Session["client_first_name"] = temp.Tables[0].Rows[0]["col0002"].ToString();
                    Response.Redirect("./case_info.aspx");
                }
                else if (e.CommandName == "Re-Assign")
                {
                    userid = Convert.ToInt32(e.CommandArgument);
                    Session["sreassign"] = Convert.ToInt32(userid);
                    Session["sstate"] = "sreassign";

                }

            }
            catch (Exception ex)
            {
                message.Text = "** There was an error processing your request. **" + ex.Message;
                return;
            }

        }         
    
       
</script>


  	</head>
<body text="#000000" bgColor="#ffffff" >
<!--#include file="./images/admin_menu/nav.aspx"-->

<form id="Form1" runat="server">
<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="redsm"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<% if(Session["state"].ToString() == "list") { %>
		<tr>
			<td align="center"><font class="black">New Leads</font></td>
		</tr>

		<tr>
			<td class="grey" align="center">
            <%if (GridView1.Rows.Count > 0)
              { %>
			 <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" DataKeyNames="id" OnRowCommand ="GridView1_RowCommand" AllowPaging="True" Font-Names="arial" Font-Size="9pt" PageSize="25" Width="990px" AllowSorting="True" CellPadding="3" >
                    <Columns>
                         <asp:TemplateField HeaderText="Select">
                        <ItemTemplate>
    
                    <asp:CheckBox ID="chkSelect"  runat="server" />
       
                 </ItemTemplate>
                 <HeaderTemplate>
    
    <input id="chkAll"  onclick="javascript:SelectAllCheckboxes(this);" 
              runat="server" type="checkbox"  /> 
       
    </HeaderTemplate>
   </asp:TemplateField>
                    <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this Record?');" />
                        
                        <asp:Button ID="btnassign" runat="server" Text="Assign"  CommandName="Assign" CommandArgument='<%# Eval("id") %>'/>
                        </ItemTemplate></asp:TemplateField>
                        
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandArgument='<%# Eval("id") %>'  CommandName="Select"
                                    Text="Info" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                            SortExpression="ID"  />
                           <asp:BoundField DataField="userid" HeaderText="User Id" ReadOnly="True"
                            SortExpression="userid" />                  
                        <asp:BoundField DataField="Student Name" HeaderText="Student Name" ReadOnly="True"
                            SortExpression="Student Name" />
                        <asp:BoundField DataField="High School" HeaderText="High School" SortExpression="High School" />
                        <asp:BoundField DataField="Home Phone" HeaderText="Home Phone" SortExpression="Home Phone" />
                        <asp:BoundField DataField="Status" HeaderText="Status" ReadOnly="True" SortExpression="Status" />
                    </Columns>
                 <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                 <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
                 <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
                 <AlternatingRowStyle BackColor="#F7F7F7" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:madison_collegeadvisorsnetworkConnectionString2 %>" DeleteCommand="DELETE FROM madison_sysdba.mfac_client_data2 WHERE (id = @id)" SelectCommand="SELECT id AS 'ID', userid,col0004 + col0002 AS 'Student Name', col0018 AS 'High School', col0013 AS 'Home Phone', status + ' ' + CAST(MONTH(transactionDate) AS varchar) + '-' + CAST(DAY(transactionDate) AS varchar) + '-' + CAST(YEAR(transactionDate) AS varchar) AS 'Status' FROM madison_sysdba.mfac_client_data2 AS d WHERE (status = 'New Lead')">
                    <DeleteParameters>
                        <asp:Parameter Name="id" />
                    </DeleteParameters>
                </asp:SqlDataSource>
                <%}
                  else
                  { %>
                <font class="black">There are no New leads to view.</font>
                
                <%} %>
				
		<% }else if(Session["state"].ToString() == "assign"){
			DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM " + Session["mainDataTable"] + " WHERE [id] = " + Session["assign"] + ";");
			//Response.Write(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], status + ' ' + cast(month(createdDate) as varchar) + '/' + cast(day(createdDate) as varchar) + '/' + cast(year(createdDate) as varchar) as [Status] FROM [" + Session["mainDataTable"] + "] WHERE [id] = " + Session["assign"] + ";");
			//return;
		%>
		<tr>
			<td align="center"><font class="black">Assign Lead</font></td>
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
						<asp:Button id="assignLead" runat="server" text="Assign Lead" OnClick="updateDB" />&nbsp;
						<asp:Button id="cancelAssignLead" runat="server" text="Cancel" OnClick ="cancelAssign" />
					</td>
				</tr>
				</table>
		<% } %>
		</td>
		</tr>
		<tr>
		<td>
		<% 
		if(Session["state"].ToString() == "list"){ 
		%>
	
	&nbsp;&nbsp;<font class="black">Assign Selected To: &nbsp;</font><select name="user1"><%= printUserList() %></select> <asp:Button  ID ="Button1" runat="server" onclick="AssignGroup" text="Assign Selected"/> 
		<%
				
		} 
		%>
			</td>
			</tr>
		</table>
		
		<%--Assigned Leads--%>
		
				<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">

		<% if(Session["astate"].ToString() == "list") { %>
		<tr>
			<td align="center"><font class="black">Assigned Leads</font> </td>
		</tr>
		<tr>
			<td class="grey" align="center">
			<%if (GridView2.Rows.Count > 0)
     { %>
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" DataKeyNames="id" OnRowCommand ="GridView2Update" AllowPaging="True" Font-Names="arial" Font-Size="9pt" PageSize="25" Width="954px" AllowSorting="True" CellPadding="3">
                    <Columns>
                    <asp:TemplateField HeaderText="Select">
                        <ItemTemplate>
                        <asp:CheckBox ID="chkAssignSelect"  runat="server" />
                     </ItemTemplate>
                    <HeaderTemplate>
                    <input id="chkAll"  onclick="javascript:SelectAllCheckboxes(this);" 
                    runat="server" type="checkbox"  /> 
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnaDelete" runat="server" CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this Record?');" />
                        
                        <asp:Button ID="btnaassign" runat="server" Text="Re-Assign"  CommandName="Re-Assign" CommandArgument='<%# Eval("id") %>'/>
                        </ItemTemplate></asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Select"
                                    Text="Info" CommandArgument='<%# Eval("id") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                            SortExpression="ID" />
                            <asp:BoundField DataField="userid" HeaderText="User Id" ReadOnly="True"
                            SortExpression="userid" /> 
                        <asp:BoundField DataField="Assigned To" HeaderText="Assigned To" SortExpression="Assigned To" />
                        <asp:BoundField DataField="Student Name" HeaderText="Student Name" ReadOnly="True"
                            SortExpression="Student Name" />
                        <asp:BoundField DataField="High School" HeaderText="High School" SortExpression="High School" />
                        <asp:BoundField DataField="Status" HeaderText="Status" ReadOnly="True" SortExpression="Status" />
                    </Columns>
                    <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                    <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
                    <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
                    <AlternatingRowStyle BackColor="#F7F7F7" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:madison_collegeadvisorsnetworkConnectionString2 %>" DeleteCommand="DELETE FROM madison_sysdba.mfac_client_data2 WHERE (id = @id)" SelectCommand="select d.id AS 'ID',d.userid,madison_sysdba.users.name AS 'Assigned To', d.col0004  + d.col0002 AS 'Student Name', d.col0018 AS 'High School', d.status + ' ' + cast(month(d.transactionDate) AS varchar) + '-' + cast(day(d.transactionDate) AS varchar) + '-' + cast(year(d.transactionDate) AS varchar) AS 'Status' FROM  madison_sysdba.mfac_client_data2 AS d INNER JOIN madison_sysdba.users ON d.userid=madison_sysdba.users.userid WHERE status = 'Assigned'">
                    <DeleteParameters>
                        <asp:Parameter Name="id" />
                    </DeleteParameters>
                </asp:SqlDataSource>
                <%}
                  else
                  { %>
                  <font class="black">There are no Assigned leads to view.</font>
                <%} %>
			
		<% }else if(Session["astate"].ToString() == "reassign") {

         DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], madison_sysdba.users.name as [Assigned To], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN madison_sysdba.users ON madison_sysdba.users.userid = d.userid WHERE [id] = " + Session["reassign"] + ";");
		%>
		</td>
		</tr>
		
		<tr>
			<td align="center"><font class="black">Re-Assign Lead</font></td>
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
				</td>
				</tr>
		<% } %>
		<tr>
		<td>
		
		<% if(Session["astate"].ToString() == "list") {%>
			
	&nbsp;&nbsp;
	<font class="black">Re-Assign Selected To: &nbsp;</font><select name="user2"><%= printUserList() %></select> <asp:Button ID="Button2" runat="server" onclick="ReAssignGroup" text="Re-Assign Selected" /> 
		<%  		
			
		    } %>
		    </td>
		    </tr>
		</table>
		
		

<%--Scheduled Leads--%>

<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<% if (Session["sstate"].ToString() == "list")
     { %>

		<tr>
			<td align="center"><font class="black">Scheduled Leads</font> </td>
		</tr>
		<tr>
			<td class="grey" align="center">
			<%if (GridView3.Rows.Count > 0)
     { %>
                <asp:GridView ID="GridView3" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CellPadding="3" DataKeyNames="id" DataSourceID="SqlDataSource3" Font-Names="arial" Font-Size="9pt" PageSize="25" Width="948px" OnRowCommand="GridView3UpdateRecord">
                    <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                    <Columns>
                    <asp:TemplateField HeaderText="Select">
                        <ItemTemplate>
                        <asp:CheckBox ID="chkReAssignSelect"  runat="server" />
                     </ItemTemplate>
                    <HeaderTemplate>
                    <input id="chkAll"  onclick="javascript:SelectAllCheckboxes(this);" 
                    runat="server" type="checkbox"  /> 
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnaDelete" runat="server" CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this Record?');" />
                        
                        <asp:Button ID="btnrassign" runat="server" Text="Re-Assign"  CommandName="Re-Assign" CommandArgument='<%# Eval("id") %>'/>
                        </ItemTemplate></asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Select"
                                    Text="Info" CommandArgument='<%# Eval("id") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                            SortExpression="ID" />
                            <asp:BoundField DataField="userid" HeaderText="User Id" ReadOnly="True"
                            SortExpression="userid" /> 
                        <asp:BoundField DataField="Assigned To" HeaderText="Assigned To" SortExpression="Assigned To" />
                        <asp:BoundField DataField="Student Name" HeaderText="Student Name" ReadOnly="True"
                            SortExpression="Student Name" />
                        <asp:BoundField DataField="Appointment Date" HeaderText="Appointment Date" SortExpression="Appointment Date" />
                        <asp:BoundField DataField="Location" HeaderText="Location" SortExpression="Location" />
                        
                        
                    </Columns>
                    <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
                    <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
                    <AlternatingRowStyle BackColor="#F7F7F7" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:madison_collegeadvisorsnetworkConnectionString2 %>" DeleteCommand="DELETE FROM madison_sysdba.mfac_client_data2 WHERE (id = @id)" SelectCommand="select d.id AS 'ID',d.userid,madison_sysdba.users.name AS 'Assigned To', d.col0004 +  d.col0002 AS 'Student Name',&#13;&#10; d.nextApptDate AS 'Appointment Date', madison_sysdba.locations.name AS 'Location' &#13;&#10;FROM madison_sysdba.mfac_client_data2 AS d INNER JOIN madison_sysdba.users ON d.userid=madison_sysdba.users.userid&#13;&#10; LEFT JOIN madison_sysdba.locations ON d.nextApptLocationid=madison_sysdba.locations.id WHERE status = 'Scheduled' AND nextApptDate > getdate() AND madison_sysdba.users.userid != 29">
                    <DeleteParameters>
                        <asp:Parameter Name="id" />
                    </DeleteParameters>
                </asp:SqlDataSource>
                <%}
                  else
                  { %>
                  <font class="black">There are no Scheduled leads to view.</font>
                <%} %>
			</td>
			</tr>
			<%} else if(Session["sstate"].ToString() == "sreassign") {
         DataSet tmp = getMssqlData(@"SELECT col0004 + ',' + col0002 AS [Student Name], col0013 as [Home Phone], madison_sysdba.users.name as [Assigned To], status + ' ' + cast(month(transactionDate) as varchar) + '/' + cast(day(transactionDate) as varchar) + '/' + cast(year(transactionDate) as varchar) as [Status] FROM " + Session["mainDataTable"] + " AS d INNER JOIN madison_sysdba.users ON madison_sysdba.users.userid = d.userid WHERE [id] = " + Session["sreassign"] + " AND madison_sysdba.users.userid != 29;");
		%>
		<tr>
			<td align="center"><font class="black">Re-Assign Lead</font></td>
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
		<tr>
		<td>
		<%  if(Session["sstate"].ToString() == "list") {%>
			
	
<font class="black">Re-Assign Selected To: &nbsp;</font><select name="user3"><%= printUserList() %></select> <asp:Button ID="Button3" runat="server" onclick="ReAssignSchedGroup" text="Re-Assign Selected" /> 
		<%  		
			
		    } %>
		    </td>
		    </tr>

		</table>

		
</table>

   </form> 
<!--#include file="./footer.aspx"-->
</body>
</html>
