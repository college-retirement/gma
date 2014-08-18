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

public partial class jbcgnew_invoice : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["account_type"] == null || Session["account_type"].ToString().ToLower() == "customer")
            Response.Redirect("../default.aspx");
        if(Request.QueryString["id"] == null || Request.QueryString["id"].ToString() == string.Empty)
            Response.Redirect("../default.aspx");

        if (Page.IsPostBack) return;

        initPage();
    }

    public void initPage()
    {
        int myID = Convert.ToInt32(Request.QueryString["id"].ToString());
        CRSCRM.Sale mySale = new CRSCRM.Sale(myID);
        pricebox.Text = mySale.price.ToString();
        pricelabel1.Text = mySale.price.ToString();
        pricelabel2.Text = mySale.price.ToString();
        PA_Price_2.Text = PA_price.Text = mySale.price.ToString();
        DataTable parentInfo = SQLManager.GetData("*","mfac_parent_info","where ID='1' AND claimid='" + mySale.caseID.ToString() + "'");
        DataTable caseInfo = SQLManager.GetData("*", "mfac_client_data2", "where id='" + mySale.caseID + "'");
        if(parentInfo.Rows.Count > 0 && parentInfo.Rows[0]["col0004"] != DBNull.Value)
            packagebox.Text = mySale.package + " for the " + parentInfo.Rows[0]["col0004"].ToString() + " family.";
        else packagebox.Text = "Your Package: " + mySale.package;
        notebox.Text = mySale.notes;
        if (notebox.Text == string.Empty)
            notelabel.Visible = false;
        discountbox.Text = mySale.discount.ToString();
        retailprice.Text = mySale.retailprice.ToString();

        if (parentInfo.Rows.Count > 0)
        {
            Label7.Text = Label2.Text = parentName.Text = parentInfo.Rows[0]["col0002"].ToString() + " " + parentInfo.Rows[0]["col0004"].ToString();
            Label4.Text = emailAddress.Text = parentInfo.Rows[0]["col0018"].ToString();
        }

        if (caseInfo.Rows.Count > 0)
        {
            Label1.Text = studentName.Text = caseInfo.Rows[0]["col0002"].ToString() + " " + caseInfo.Rows[0]["col0004"].ToString();
            Label5.Text = address.Text = caseInfo.Rows[0]["col0007"].ToString();
            Label6.Text = cityStateZip.Text = caseInfo.Rows[0]["col0009"].ToString() + ", " + caseInfo.Rows[0]["col0010"].ToString() + " " + caseInfo.Rows[0]["col0011"].ToString();
            Label3.Text = homePhone.Text = caseInfo.Rows[0]["col0013"].ToString();
            gradYear.Text = gradYear2.Text = caseInfo.Rows[0]["col0020"].ToString();
        }

        DataTable myProducts = mySale.Products();
        DataList1.DataSource = myProducts;
        DataList1.DataBind();
        PAserviceList.DataSource = myProducts;
        PAserviceList.DataBind();

        studentName.Attributes.Add("onchange", "mirror1()");
        parentName.Attributes.Add("onchange", "mirror1()");
        emailAddress.Attributes.Add("onchange", "mirror1()");
        address.Attributes.Add("onchange", "mirror1()");
        TextBox7.Attributes.Add("onchange", "mirror1()");
        gradYear.Attributes.Add("onchange", "mirror1()");
        homePhone.Attributes.Add("onchange", "mirror1()");
        TextBox9.Attributes.Add("onchange", "mirror1()");
        cityStateZip.Attributes.Add("onchange", "mirror1()");
        TextBox8.Attributes.Add("onchange", "mirror1()");

        Label1.Attributes.Add("onchange", "mirror2()");
        Label2.Attributes.Add("onchange", "mirror2()");
        Label4.Attributes.Add("onchange", "mirror2()");
        Label5.Attributes.Add("onchange", "mirror2()");
        TextBox4.Attributes.Add("onchange", "mirror2()");
        gradYear2.Attributes.Add("onchange", "mirror2()");
        Label3.Attributes.Add("onchange", "mirror2()");
        TextBox6.Attributes.Add("onchange", "mirror2()");
        Label6.Attributes.Add("onchange", "mirror2()");
        TextBox5.Attributes.Add("onchange", "mirror2()");        
    }

    public string getYear(int offset)
    {
        if (DateTime.Now.Month >= 6)
            return DateTime.Now.AddYears(offset).Year.ToString();
        else return DateTime.Now.AddYears((offset-1)).Year.ToString();
    }

    public string getCaseYear(int offset)
    {
        int myID = Convert.ToInt32(Request.QueryString["id"].ToString());
        CRSCRM.Sale mySale = new CRSCRM.Sale(myID);
        int gradYear = Convert.ToInt32(SQLManager.GetValue("col0020", "mfac_client_data2", "where id='" + mySale.caseID.ToString() + "'")) + offset;
        return gradYear.ToString();
    }
    
}
