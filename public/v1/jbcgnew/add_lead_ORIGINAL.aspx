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
		
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null || Session["mainDataTable"] == null || Session["mainDictTable"] == null) {
			Response.Redirect("./timeout.aspx");
		}

		//only runs the following code the first time this page loads
		if(!Page.IsPostBack) {
			Session["state"] = "new";
		}

		return;
	}
		
	private void addLead(Object obj, EventArgs args) {
		Session["state"] = "old";
		message.Text = "";
		string sql = "SELECT * FROM " + Session["mainDictTable"] + " WHERE section = '6' AND number <= 44 AND input_field = 'Y' ORDER BY column_id ASC, number ASC";
		DataSet tmp = getMssqlData(sql);
		checkDataSimple(tmp,true);		

		if(message.Text == "") {
			try {
				//if(id.ToString() == Request["id"] || tmp.Tables[0].Rows[0][0].ToString() == "") {
				
				sql = "INSERT INTO " + Session["mainDataTable"] + " ([userid],[transactionBy],[transactionDate],[status]) VALUES(null," + Session["userid"] + ",'" + System.DateTime.Now.ToShortDateString() + "','New Lead');";
				getMssqlData(sql);

				sql = "SELECT MAX(id) FROM " + Session["mainDataTable"] + ";";
				tmp = getMssqlData(sql);
				int id = 1;
				try {
					id = Convert.ToInt32(tmp.Tables[0].Rows[0][0].ToString());
					//id++;	
				}catch{
					id = 1;	
				}

				Session["id"] = id.ToString();

				updateSection(6);
				updateLog(id.ToString(), "New Lead");
				message.Text = "*New lead stored successfully.*";
				//}else{
				//	message.Text = "*Lead has already been entered.*";
				//}
				Session["state"] = "new";
				Session["id"] = null;
			}catch(Exception e){
				//Response.Write(e.Message);
				message.Text = "*Could not store new lead.*<br>" + e.Message + "<br>" + e.StackTrace;
			}
		}
	}
    	</script>
  	</head>
<body text="#000000" bgColor="#ffffff" MS_POSITIONING="GridLayout">
<!--#include file="./images/intern_menu/nav.aspx"-->
<form method="post" runat="server">

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr>
		</table>
	</td>
</tr><tr>
	<td align="center">
	
<% if(Session["state"].ToString() == "old") { %>

	<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
	<tr>
		<td colspan="3" align="center">
			<asp:Button id="addtop" runat="server" text="Add Lead" onClick="addLead" />
		</td>
	</tr>
	<%= printForm(6, "web", 1, 27) %>
	<tr>
		<td colspan="3" align="center">
			<asp:Button id="add" runat="server" text="Add Lead" onClick="addLead" />
		</td>
	</tr>
	</table>
<% }else if(Session["state"].ToString() == "new") { %>

	<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="100%">
	<tr>
		<td colspan="3" align="center">
			<asp:Button id="addnewtop" runat="server" text="Add Lead" onClick="addLead" />
		</td>
	</tr>
	<%
		/*
		string sql = "SELECT MAX(id) FROM " + Session["mainDataTable"] + ";";
		DataSet tmp = getMssqlData(sql);
		int id = 1;
		try {
			id = Convert.ToInt32(tmp.Tables[0].Rows[0][0].ToString());
			id++;	
		}catch{
			id = 1;	
		}
		*/
	%>
	<%= printForm(6, "null", 1, 27) %>
	<tr>
		<td colspan="3" align="center">
			<!-- input type="hidden" name="id" value=" id " -->
			<asp:Button id="addnew" runat="server" text="Add Lead" onClick="addLead" />
		</td>
	</tr>
	</table>
<% } %>

	</td>
</tr>
</table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>