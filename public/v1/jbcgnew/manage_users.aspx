<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace ="System.Configuration" %>
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
  
        protected void Gridview1UpdateRecord(object sender, GridViewDeleteEventArgs e)
        {
            //When user is being deleted all his leads r assigning to the default user that is account type is : Admin.
            string config = ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ToString();
            SqlConnection sconnect = new SqlConnection(config);
            sconnect.Open();
            try
            {
                int userid = (int)GridView1.DataKeys[e.RowIndex].Value;
                
                string sqlquery = "select userid from users where priv_application_admin ='1' and account_type='Admin'";
                SqlCommand scm = new SqlCommand(sqlquery, sconnect);
                SqlDataReader sdread = scm.ExecuteReader();
                int i = 0;
                while (sdread.Read())
                {
                    Session["userid1"] = sdread["userid"].ToString();
                    i++;

                }
                sdread.Close();
                for (int j = 0; j < i; j++)
                {
                    string sqlupdatequery = "update mfac_client_data2 set userid = " + Session["userid1"] + ",transactionBy = " + Session["userid"] + ",transactionDate='" + System.DateTime.Now.ToShortDateString() + "' where userid=" + Convert.ToInt32(userid);
                    SqlCommand cm = new SqlCommand(sqlupdatequery, sconnect);
                    cm.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                message.Text = "** There was an error processing your request. **<br>" + ex.StackTrace;
                return;
            }
            finally
            {
                sconnect.Close();
            }
        }

  
	
	    
    	</script>
    	
  	</head>
<body text="#000000" bgColor="#ffffff" >
<!--#include file="./images/admin_menu/nav3.aspx"-->
<form method="post" runat="server">

<table border="1" cellpadding="0" cellspacing="0" align="center"  width="772">
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
	<td style="height: 398px">
	
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
	<table>
	<tr>
	<td class = "grey">
    <%-- 
    //Date:29/11/2007
     Implementation: I have added the gridview in that when the user is deleted all leads should be assigned to the admin
     so i have taken the userid of that user which is about to  delete, and updated with the admin id in the mfac-client_data2 table 
     and also i have updated the fields of the TransactionBy and TransactionDate. In TransactionBy the id id will be the userid who has logged in the system
     and TransactionDate will be the system date. and from user i have deleted the record of that user which is about to delete
     In gridview there is delete button clicking on the delete button the record should be deleted from database and from gridview.
     and it is showing the message which is in javascript.
     --%>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" DataKeyNames="userid" Font-Names="arial" Font-Size="9pt" AllowPaging="True" PageSize="25" AllowSorting="True" BackColor="White" BorderColor="Black" CellPadding="3" OnRowDeleting = "Gridview1UpdateRecord">
            <Columns>
            <asp:TemplateField>

            <ItemTemplate>
<asp:Button ID="Button1" runat="server" CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this Record?');" />
     
</ItemTemplate></asp:TemplateField>
                <asp:BoundField DataField="userid" HeaderText="userid" SortExpression="userid" />
                <asp:BoundField DataField="account_creation_date" HeaderText="Account Creation Date"
                    SortExpression="account_creation_date" />
                <asp:BoundField DataField="active" HeaderText="Active" SortExpression="active" />
                <asp:BoundField DataField="address" HeaderText="Address" SortExpression="address" />
                <asp:BoundField DataField="emailaddress" HeaderText="Emailaddress" SortExpression="emailaddress" />
                <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                <asp:BoundField DataField="password" HeaderText="password" SortExpression="password" Visible = "False"/>
                <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                <asp:BoundField DataField="password_expiration_date" HeaderText="Password Expiration Date"
                    SortExpression="password_expiration_date" />
                <asp:BoundField DataField="password_set_date" HeaderText="Password Set Date" SortExpression="password_set_date" />
                <asp:BoundField DataField="previous_password" HeaderText="previous_password" SortExpression="previous_password" Visible ="False"/>
                <asp:BoundField DataField="account_type" HeaderText="Account type" SortExpression="account_type" />
                <asp:BoundField DataField="priv_add_user" HeaderText="priv_add_user" SortExpression="priv_add_user" Visible ="False" />
                <asp:BoundField DataField="priv_download" HeaderText="priv_download" SortExpression="priv_download" Visible ="False" />
                <asp:BoundField DataField="priv_edit_user" HeaderText="priv_edit_user" SortExpression="priv_edit_user" Visible ="False" />
                <asp:BoundField DataField="priv_upload" HeaderText="priv_upload" SortExpression="priv_upload" Visible ="False" />
                <asp:BoundField DataField="priv_application_admin" HeaderText="priv_application_admin"
                    SortExpression="priv_application_admin" Visible ="False" />
                    
            </Columns>
            <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" Font-Size="9pt" />
            <RowStyle BackColor="#E7E7FF" ForeColor="Black" />
            <PagerStyle Font-Names="arial" Font-Size="9pt" />
            <HeaderStyle BackColor="#4A3C8C" ForeColor="#F7F7F7" />
            <AlternatingRowStyle BackColor="#F7F7F7" />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:madison_collegeadvisorsnetworkConnectionString2 %>"
            DeleteCommand="DELETE FROM users WHERE (userid = @userid)" SelectCommand="SELECT users.* FROM users">
            <DeleteParameters>
                <asp:Parameter Name="userid" />
            </DeleteParameters>
        </asp:SqlDataSource>
       
       
    </td>	</tr>
	</table>
        
	</td>
</tr>
</table>

</form>
<!--#include file="./footer.aspx"-->
</body>
</html>