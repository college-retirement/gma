<%@ Page Language="C#" Debug="true" %>
<html>
	<head>
	<title><!--#include file="./title.aspx"--></title>
    	<link rel="stylesheet" type="text/css" href="<%= Session["serverroot"] %>cssfiles/styledefs.css" title="Default Style">
	<script language="C#" runat="server">
		
	public void Page_Load() {
		if(Session["userid"] == "" || Session["userid"] == null) {
				Response.Redirect("./timeout.aspx");
		}
		message.Text = "** You do not have access to this page. **";
	}
		
	</script>	
	</head>
<body>
<form runat="server">
<!--#include file="./images/login_menu/login.aspx"-->
<br><br>
<table border="0" cellpadding="0" cellspacing="1" align="center" valign="top" width="772">
	<tr><td align="center"><font class="red"><asp:Label id="message" runat="server"/>&nbsp;</font></td></tr>
</table>
<br>
<!--#include file="./footer.aspx"-->
</form></body></html>