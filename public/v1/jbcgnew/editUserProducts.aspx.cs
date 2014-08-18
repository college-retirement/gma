using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class jbcgnew_editUserProducts : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack) return;
        int myUserID = -1;
        if (Request.QueryString["userid"] != null && Request.QueryString["userid"].ToString() != string.Empty)
            myUserID = Convert.ToInt32(Request.QueryString["userid"].ToString());
        else return;
        DataTable myProducts = SQLManager.GetDataPrimitive("Select distinct p.name, pbu.product, pbu.active FROM CRM_ProductsByUser pbu INNER JOIN CRM_Products p ON pbu.product=p.id where pbu.userid='" + myUserID.ToString() + "' order by pbu.product");
        ProdList.DataSource = myProducts;
        ProdList.DataBind();
    }
    protected void SaveProd_Click(object sender, EventArgs e)
    {
        int myUserID = -1;
        if (Request.QueryString["userid"] != null && Request.QueryString["userid"].ToString() != string.Empty)
        {
            myUserID = Convert.ToInt32(Request.QueryString["userid"].ToString());

            foreach (DataListItem myItem in ProdList.Items)
            {
                if (((CheckBox)myItem.FindControl("activeCB")).Checked)
                    SQLManager.GeneralNonQuery("UPDATE CRM_ProductsByUser SET active='Y' WHERE userid='" + myUserID.ToString() + "' AND product='" + ((HiddenField)myItem.FindControl("product")).Value + "'");
                else
                    SQLManager.GeneralNonQuery("UPDATE CRM_ProductsByUser SET active='N' WHERE userid='" + myUserID.ToString() + "' AND product='" + ((HiddenField)myItem.FindControl("product")).Value + "'");
            }
        }
        Response.Redirect("case_info.aspx");

    }
    protected void ProdList_ItemCreated(object sender, DataListItemEventArgs e)
    {
    }
    protected void ProdList_PreRender(object sender, EventArgs e)
    {
        foreach(DataListItem myItem in ProdList.Items)
            if (((HiddenField)myItem.FindControl("active")).Value.ToUpper() == "Y")
                ((CheckBox)myItem.FindControl("activeCB")).Checked = true;
            else
                ((CheckBox)myItem.FindControl("activeCB")).Checked = false;
    }
}
