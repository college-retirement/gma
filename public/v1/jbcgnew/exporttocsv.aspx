<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>   
<%@ Import Namespace="System.Data.SqlClient" %>   
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Web.UI.WebControls.WebParts" %>
<%@ Import Namespace="System.Web.UI.HtmlControls" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    static DataTable dt_student;
    
    SqlConnection sqlcon = new SqlConnection(ConfigurationManager.ConnectionStrings["madison_collegeadvisorsnetworkConnectionString2"].ConnectionString.ToString());

    private void FillStudentGrid()
    {
        try
        {
            dt_student = new DataTable();
            string str_stud = "SELECT DISTINCT pi.claimid AS 'ID', pi.col0002 AS 'FName', pi.col0004 AS 'LName', emails.Email as 'Email', cd.col0020 AS 'GradYear' FROM mfac_parent_info pi INNER JOIN mfac_client_data2 cd ON pi.claimid=cd.id INNER JOIN ( SELECT pi.col0018 AS 'Email', pi.claimid AS 'ID' FROM mfac_parent_info pi WHERE pi.col0018 <> '' AND pi.col0018 <> 'no email' AND pi.col0018 NOT LIKE '%;%' UNION ALL SELECT cd.col0014 AS 'Email', cd.id as 'ID' FROM mfac_client_data2 cd WHERE cd.col0014 <> '' AND cd.col0014 <> 'no email' AND cd.col0014 NOT LIKE '%;%' ) emails ON pi.claimid=emails.ID WHERE pi.col0002 <> '' AND pi.col0002 <> 'parent' AND pi.col0004 <> '' AND pi.col0004 <> 'parent' ORDER BY GradYear ASC, LName ASC";
            // 10/14/08 Richard Gilchrist - Changed above query line so that output is in sync with what is necessary for 
            // benchmarkemail.com, which is why we developed this tool in the first place.
            //
            // The new query takes email addresses from both the client data and parent info tables and matches them
            // with both the first and last name, the ID, and the grad year. The new query does not allow blanks
            // in the names or email address fields
            SqlDataAdapter da_stud = new SqlDataAdapter(str_stud, sqlcon);
            da_stud.Fill(dt_student);
            gvStudent.DataSource = dt_student;
            gvStudent.DataBind();
        }
        catch (Exception ex)
        {
        }
    }

    private void CreateCSVFile(DataTable dt, string str_path)
    {
        try
        {
            StreamWriter sw = new StreamWriter(str_path, false);

            int colCount = dt.Columns.Count;
            for (int i = 0; i < colCount; i++)
            {

                sw.Write(dt.Columns[i]);
                if (i < colCount - 1)
                {
                    sw.Write(",");

                }

            }

            sw.Write(sw.NewLine);
            // Now write all the rows.

            foreach (DataRow dr in dt.Rows)
            {

                for (int i = 0; i < colCount; i++)
                {

                    if (!Convert.IsDBNull(dr[i]))
                    {

                        sw.Write(dr[i].ToString());
                    }

                    if (i < colCount - 1)
                    {

                        sw.Write(",");
                    }

                }
                sw.Write(sw.NewLine);

            }
            sw.Close();

            export_tocsv.Visible = true;

        }
        catch (Exception ex)
        {
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        CreateCSVFile(dt_student, Server.MapPath("./uploads/") + "tempCSV.csv");
    }


    protected void gvStudent_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvStudent.PageIndex = e.NewPageIndex;
        gvStudent.DataSource = dt_student;
        gvStudent.DataBind();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        FillStudentGrid();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<title><!--#include file="./title.aspx"--></title>
	<LINK href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet"></head>
<body><!--#include file="./images/admin_menu/nav.aspx"-->
    <form id="form1" runat="server">
<div style="text-align:center;">
             
                <asp:GridView ID="gvStudent" runat="server" AutoGenerateColumns="True" AllowPaging="true"  Style="position: static" OnPageIndexChanging="gvStudent_PageIndexChanging">
                
                </asp:GridView>
        
                <asp:Button ID="btnExport" runat="server" Style="position: static" Text="Export to CSV File" OnClick="btnExport_Click" />
        
                <a href="uploads/tempCSV.csv" runat="server" id="export_tocsv" visible="false" target="_parent">Open CSV File </a>
                </div>
    </form>
</body>
</html>
