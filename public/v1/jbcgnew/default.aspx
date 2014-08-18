<%@ Page Language="C#" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System" %>
<script language="c#" runat="server">
private void Page_Load(object sender, System.EventArgs e)
{
Response.Status = "301 Moved Permanently";
Response.AddHeader("Location","http://www.college-retirement.com/_default.aspx");
}
</script>