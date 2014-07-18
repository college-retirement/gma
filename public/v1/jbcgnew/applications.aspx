<%@ Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
	</head>
	<script language="C#" runat="server">
	//global variable which hold found files paths

	//user home directory only
	string[] files;
	//global directory only
	//string[] global;
		
	public void Page_Load() {
		//Check to see if the session is still alive otherwise redirect.
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		//Check user's access privileges.
		if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern") {
			Response.Redirect("./nopriv.aspx");
		}else{
			try {
				//A final check of the directory structure.
				checkDirs();

				files = null;

				//Search the user's home directory.
				files = System.IO.Directory.GetFiles(Session["userrootdir"].ToString() + "products");

				if(files.Length == 0) {
					message.Text = "** There are currently no files to download. **";
				}
			}catch(Exception e) {
				//If the user's home directory doesn't exist create it.
				System.IO.Directory.CreateDirectory(Session["userrootdir"].ToString() + "\\products");
				message.Text = "** The products did not exist so it has been created.<br>There are no applications to download. **";				
			}				
		}				
	}

	//The function creates the following directories only if they do not exist.
	//If they do exist it does nothing.  This function is designed to ensure that
	//the following important directories exist.
	public void checkDirs() {
		System.IO.Directory.CreateDirectory(Session["userrootdir"] + "\\products");
	}
			
	</script>
<body>
<form runat="server">
<!--#include file="./images/case_review_menu/nav4.aspx"-->

<table border="1" cellpadding="0" cellspacing="0" align="center" valign="top" width="772">
<tr class="grey">
	<td>
		<table border="0" cellpadding="2" cellspacing="0" align="center" valign="top" width="100%">
		<tr>
			<td width="5%"></td>
			<td><font class="white">Application Downloads&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="4" align="center" valign="top" width="100%">
		<tr>
			<td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td>
		</tr></table>
	</td>
</tr><tr>
	<td align="center">
		<table border="0" cellpadding="4" cellspacing="0" align="center" valign="top" width="70%">
		<tr><td align="left" width="65%"><font class="black">Application Name</font></td><td align="left" width="35%"><font class="black">Download Link</font></td></tr>
				<%
					//splits and prints the files found in the user's home directory.
					try {
						if(files.Length > 0) {
							string[] container;
							for(int i = 0; i < files.Length; i++) {
								container = files[i].Split('\\'); %>
								<tr><td><font class="red"><%= container[(container.Length - 1)] %></font></td>		
								<td><font class="black"><a href="<%= Session["serverroot"] %><%= "userfolders/" + Session["username"] + "/download/" %><%= container[(container.Length - 1)] %>">download</a></font></td></tr>
				<%			}
						}
					}catch(Exception e) {

					}
				%>
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		</table>
	</td>
</tr></table>
</form>
<!--#include file="./footer.aspx"-->
</body></html>