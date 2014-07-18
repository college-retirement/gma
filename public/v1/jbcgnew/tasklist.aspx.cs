using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class jbcgnew_tasklist : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["account_type"] == null || Session["account_type"].ToString().ToLower() == "customer" )
        {
            Response.Redirect("../_default.aspx");
        }
        
        if (Page.IsPostBack)
            return;

        initPage();
    }
    protected void initPage()
    {
        setupTaskNameList();
        DataTable myTasks = TaskManager.getTasksByUser(Convert.ToInt32(Session["userid"]),true);
        taskList.DataSource = myTasks;
        taskList.DataBind();
        UpdatePanel1.Update();
    }
    protected void setupTaskNameList()
    {
        DataTable myTaskNames = TaskManager.getTaskNamesByUser(Convert.ToInt32(Session["userid"]));
        int i = 0;
        taskNameDDL.Items.Add("All Tasks");
        for (i = 0; i < myTaskNames.Rows.Count; i++)
        {
            taskNameDDL.Items.Add(myTaskNames.Rows[i]["description"].ToString());
        }
    }
    protected void refreshPage()
    {
        DataTable myTasks = null;
        if(taskNameDDL.SelectedIndex == 0)
            myTasks = TaskManager.getTasksByUser(Convert.ToInt32(Session["userid"]),CheckBox1.Checked);
        else
            myTasks = TaskManager.getTasksByUser(Convert.ToInt32(Session["userid"]), CheckBox1.Checked,taskNameDDL.SelectedItem.Text);
        taskList.DataSource = myTasks;
        taskList.DataBind();
        UpdatePanel1.Update();
    }
    protected void taskList_EditCommand(object source, DataListCommandEventArgs e)
    {
        TaskManager.Task myTask = new TaskManager.Task(Convert.ToInt32(e.CommandArgument.ToString()));
        myTask.Complete(Convert.ToInt32(Session["userid"].ToString()));
        refreshPage();
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        refreshPage();
    }
    protected void taskList_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        TaskManager.Task myTask = new TaskManager.Task(Convert.ToInt32(e.CommandArgument.ToString()));
        myTask.Delete();
        refreshPage();
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        refreshPage();
    }
}
