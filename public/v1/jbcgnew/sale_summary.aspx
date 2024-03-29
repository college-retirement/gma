<%@  Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<html>
<head>
    <title>
        <!--#include file="./title.aspx"-->
    </title>
    <link href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">

    <script type="text/javascript">
        function checkPrice() {
            var myPrice = document.getElementById('<%= pricebox.ClientID %>');
            if (myPrice.value == "" || myPrice.value == "0") {
                myPrice.focus();
                alert('Please enter a price for this package before continuing.');
                return false;
            }
            return true;
        }
        function TallyUp(myCheckBox, price) {
            var myPrice = parseInt(price, 10);
            var mySRPbox = document.getElementById('<%= retailprice.ClientID %>');
            var mySRP = parseInt(mySRPbox.value, 10);
            if (!mySRP || mySRP == null || mySRP == 'NaN' || mySRP == '')
                mySRP = 0;
            if (myCheckBox.checked)
                mySRP = mySRP + myPrice;
            else mySRP = mySRP - myPrice;
            if (mySRP == 0)
                mySRPbox.value = '0';
            else mySRPbox.value = mySRP;
        }
    </script>

</head>

<script language="C#" runat="server">		
    public void Page_Load()
    {
        //Check to see if the session is still alive otherwise redirect.
        if (Session["userid"] == null || Session["userid"].ToString() == "")
        {
            Response.Redirect("./timeout.aspx");
        }
        if (Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "intern")
        {
            Response.Redirect("./nopriv.aspx");
        }

        if (Page.IsPostBack) return;

        initPage();
    }

    public void initPage()
    {
        DataTable mySales = CRSCRM.Sale.getSalesByCaseID(Convert.ToInt32(Session["id"].ToString()));
        if (mySales.Rows.Count < 1)
            saleList.Visible = false;
        else
        {
            saleList.Visible = true;
            saleList.DataSource = mySales;
            saleList.DataBind();
        }

        DataTable myProduts = CRSCRM.Product.getActiveProducts();
        productList.DataSource = myProduts;
        productList.DataBind();
        int i = 0;
        for (i = 0; i < productList.Items.Count; i++)
        {
            DataListItem myItem = productList.Items[i];
            CheckBox tmpChkBox = ((CheckBox)myItem.FindControl("prodChkBox"));
            TextBox tmpTxtBox = ((TextBox)myItem.FindControl("prodPrice"));
            tmpChkBox.Attributes.Add("onclick", "TallyUp(this," + tmpTxtBox.Text + ");");
        }
        PackageList.DataSource = CRSCRM.Package.getList();
        PackageList.DataBind();
    }
    protected void savebutton_Click(Object obj, EventArgs args)
    {
        calcDiscount();
        CRSCRM.Sale mySale = new CRSCRM.Sale();
        try
        {
            mySale.caseID = Convert.ToInt32(Session["id"].ToString());
            mySale.price = Convert.ToDouble(pricebox.Text);
            mySale.notes = notebox.Text;
            mySale.package = packagebox.Text;
            mySale.date = DateTime.Now;
            mySale.discount = Convert.ToDouble(discount.Text);
            mySale.retailprice = Convert.ToDouble(retailprice.Text);
            mySale.paid = "N";
            mySale.active = "N";

            int mySaleID = mySale.Save();


        }
        catch (Exception Ex)
        {
            outputLabel.Text = Ex.Message + "<br /><br />" + Ex.StackTrace;
        }
        bool isChk;
        int i = 0;
        for (i = 0; i < productList.Items.Count; i++)
        {
            DataListItem myItem = productList.Items[i];
            isChk = ((CheckBox)myItem.FindControl("prodChkBox")).Checked;
            TextBox tmpTxtBox = ((TextBox)myItem.FindControl("prodID"));
            int productID = Convert.ToInt32(tmpTxtBox.Text);
            if (isChk)
            {
                mySale.addProduct(productID);
                SQLManager.GeneralNonQuery("INSERT INTO CRM_ProductsByUser (userid, product, active) SELECT u.userid, '" + productID.ToString() + "' as 'product', 'N' as 'active' FROM users u where u.usercase='" + Session["id"].ToString() + "'");
            }
        }
        initPage();
        retailprice.Text = string.Empty;
        discount.Text = string.Empty;
        pricebox.Text = "0";
    }
    protected void calcDiscount()
    {
        double myRetailPrice = 0, myPrice = 0, myDiscount = 0;
        /*double chargePrice = Convert.ToDouble(pricebox.Text);
        int i = 0;
        for (i = 0; i < productList.Items.Count; i++)
        {
            DataListItem myItem = productList.Items[i];
            TextBox tmpTxtBox = ((TextBox)myItem.FindControl("prodPrice"));
            myPrice = Convert.ToDouble(tmpTxtBox.Text);
            if (((CheckBox)myItem.FindControl("prodChkBox")).Checked)
            {
                myRetailPrice += myPrice;
            }
        }
        retailprice.Text = myRetailPrice.ToString();
        myDiscount = myRetailPrice - chargePrice;
        discount.Text = myDiscount.ToString();*/
        myPrice = Convert.ToDouble(pricebox.Text);
        myRetailPrice = Convert.ToDouble(retailprice.Text);
        //outputLabel.Text = retailprice.Text + "," + pricebox.Text;
        myDiscount =  myRetailPrice - myPrice;
        discount.Text = myDiscount.ToString();
        savebutton.Enabled = true;
    }
    protected void calcdiscount_Click(object sender, EventArgs e)
    {
        calcDiscount();
    }
    protected void saleList_DeleteCommand(object Sender, CommandEventArgs e)
    {
        CRSCRM.Sale mySale = new CRSCRM.Sale(Convert.ToInt32(e.CommandArgument));
        mySale.Delete();
        initPage();
    }
    protected void saleList_UpdateCommand(object Sender, CommandEventArgs e)
    {
        CRSCRM.Sale mySale = new CRSCRM.Sale(Convert.ToInt32(e.CommandArgument));
        mySale.markPaid();
        EventManager.Trigger("markPaid", mySale.caseID.ToString());
        initPage();
    }
    protected void saleList_EditCommand(object Sender, CommandEventArgs e)
    {
        CRSCRM.Sale mySale = new CRSCRM.Sale(Convert.ToInt32(e.CommandArgument));
        mySale.ActivateProducts();
        initPage();
    }
    public bool getVisible(string yesOrNo)
    {
        if (yesOrNo.ToUpper() == "Y")
            return false;
        return true;
    }
    public bool getVisible2(string yesOrNo)
    {
        if (yesOrNo.ToUpper() == "Y")
            return true;
        return false;
    }

    protected void PackageList_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        CRSCRM.Package myPackage = new CRSCRM.Package(Convert.ToInt32(e.CommandArgument));
        DataTable myProducts = myPackage.getProducts();
        int i = 0;
        for (i = 0; i < productList.Items.Count; i++)
        {
            DataListItem myItem = productList.Items[i];
            CheckBox myCB = ((CheckBox)myItem.FindControl("prodChkBox"));
            myCB.Checked = false;
            int productPrice = Convert.ToInt32(((TextBox)myItem.FindControl("prodPrice")).Text);            
            int prodID = Convert.ToInt32(((TextBox)myItem.FindControl("prodID")).Text);
            for(int j = 0; j < myProducts.Rows.Count; j++)
            {
                if (Convert.ToInt32(myProducts.Rows[j]["ProductID"].ToString()) == prodID)
                {
                    myCB.Checked = true;
                }
            }
        }
        
        retailprice.Text = pricebox.Text = myPackage.Price.ToString();
        packagebox.Text = myPackage.Name;
        savebutton.Enabled = true;
    }

    protected void savepackagebutton_Click(object sender, EventArgs e)
    {
        if (packagebox.Text == string.Empty)
        {
            outputLabel.Text = "You must provide a name for this package.";
            return;
        }
        CRSCRM.Package myPackage = new CRSCRM.Package(packagebox.Text);

        try
        {
            myPackage.Name = packagebox.Text;
            myPackage.Price = Convert.ToInt32(pricebox.Text);
            myPackage.Save();
        }
        catch (Exception Ex)
        {
            outputLabel.Text = Ex.Message + "<br /><br />" + Ex.StackTrace;
        }
        bool isChk;
        int i = 0;
        for (i = 0; i < productList.Items.Count; i++)
        {
            DataListItem myItem = productList.Items[i];
            isChk = ((CheckBox)myItem.FindControl("prodChkBox")).Checked;
            TextBox tmpTxtBox = ((TextBox)myItem.FindControl("prodID"));
            int productID = Convert.ToInt32(tmpTxtBox.Text);
            if (isChk)
            {
                myPackage.addProduct(productID);
                outputLabel.Text = "Package Saved";
            }
        }
        initPage();
        retailprice.Text = string.Empty;
        discount.Text = string.Empty;
        pricebox.Text = "0";
    }
</script>

<body style="text-align: center">
    <!--#include file="./images/case_review_menu/nav3.aspx"-->
    <form runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="text-align: center;">
                <table border="0" cellpadding="5" cellspacing="0" style="margin: 0 auto; width: 792px; font-family: calibri, verdana, arial;">
                    <tr>
                        <td style="text-align: center" colspan="2">
                            <asp:Label ID="outputLabel" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-weight: bold; font-size: 15pt; padding-bottom: 15px;
                            border-bottom: black 1px solid;" colspan="2">
                            Sale Summary
                        </td>
                    </tr>
                    <tr>
                        <td style="border-bottom: black 1px solid; text-align: center" colspan="2">
                            <asp:DataList OnEditCommand="saleList_EditCommand" OnUpdateCommand="saleList_UpdateCommand"
                                OnDeleteCommand="saleList_DeleteCommand" ID="saleList" Width="100%" runat="server"
                                BorderColor="Black" BorderStyle="Solid" BorderWidth="1px">
                                <HeaderTemplate>
                                    <table width="100%" border="0" cellpadding="5" cellspacing="0">
                                        <tr>
                                            <td style="width: 1%; text-align: left;" nowrap="nowrap">
                                                Date
                                            </td>
                                            <td style="text-align: left;">
                                                Package Name
                                            </td>
                                            <td style="width: 1%; text-align: right;" nowrap="nowrap">
                                                Price
                                            </td>
                                            <td style="width: 1%; text-align: center;" nowrap="nowrap">
                                                Invoice
                                            </td>
                                            <td style="width: 1%; text-align: center;" nowrap="nowrap">
                                                Paid
                                            </td>
                                            <td style="width: 1%; text-align: left;" nowrap="nowrap">
                                                Options
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr bgcolor="#e7e7ff">
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: left;" nowrap="nowrap">
                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("date") %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; text-align: left;">
                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("package") %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: right;" nowrap="nowrap">
                                            $<asp:Label ID="Label3" runat="server" Text='<%# Eval("price") %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: center;" nowrap="nowrap">
                                            <input type="button" value="Invoice" style="font-family: Arial; font-size: 8pt;"
                                                onclick="<%# "window.open('./invoice.aspx?id=" + Eval("id") + "')" %>" />
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: center;" nowrap="nowrap">
                                            <asp:Button Visible='<%# getVisible(Eval("paid").ToString()) %>' ID="Button2" runat="server"
                                                OnClientClick="return confirm('This will mark this invoice as Paid.')" Text="Mark Paid"
                                                Font-Size="8pt" CommandArgument='<%# Eval("ID") %>' CommandName="update" />
                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("paidDate") %>' Visible='<%# getVisible2(Eval("paid").ToString()) %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: center;" nowrap="nowrap">
                                            <input type="button" onclick="alert('You can no longer activate products from this screen!\n\nVisit the client\'s Case Info screen to activate products.');"
                                                value="Activate" style="font-size: 8pt;" />
                                            <asp:Label ID="Label5" runat="server" Text="Active" Visible='<%# getVisible2(Eval("active").ToString()) %>'></asp:Label>
                                            <asp:Button OnClientClick="return confirm('Are you sure you want to delete this sale?')"
                                                ID="Button1" runat="server" Text=" X " Font-Size="8pt" CommandArgument='<%# Eval("ID") %>'
                                                CommandName="delete" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: left;" nowrap="nowrap">
                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("date") %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; text-align: left;">
                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("package") %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: right;" nowrap="nowrap">
                                            $<asp:Label ID="Label3" runat="server" Text='<%# Eval("price") %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: center;" nowrap="nowrap">
                                            <input type="button" value="Invoice" style="font-family: Arial; font-size: 8pt;"
                                                onclick="<%# "window.open('./invoice.aspx?id=" + Eval("id") + "')" %>" />
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: center;" nowrap="nowrap">
                                            <asp:Button Visible='<%# getVisible(Eval("paid").ToString()) %>' ID="Button2" runat="server"
                                                OnClientClick="return confirm('This will mark this invoice as Paid.')" Text="Mark Paid"
                                                Font-Size="8pt" CommandArgument='<%# Eval("ID") %>' CommandName="update" />
                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("paidDate") %>' Visible='<%# getVisible2(Eval("paid").ToString()) %>'></asp:Label>
                                        </td>
                                        <td style="border-top: solid 1px gray; width: 1%; text-align: center;" nowrap="nowrap">
                                            <input type="button" onclick="alert('You can no longer activate products from this screen!\n\nVisit the client\'s Case Info screen to activate products.');"
                                                value="Activate" style="font-size: 8pt;" />
                                            <asp:Label ID="Label5" runat="server" Text="Active" Visible='<%# getVisible2(Eval("active").ToString()) %>'></asp:Label>
                                            <asp:Button OnClientClick="return confirm('Are you sure you want to delete this sale?')"
                                                ID="Button1" runat="server" Text=" X " Font-Size="8pt" CommandArgument='<%# Eval("ID") %>'
                                                CommandName="delete" />
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:DataList>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 10pt; text-align: center;" colspan="2">
                            Pick services cafeteria style from the list below, and enter the price, notes, etc.<br />
                            When you're done, click 'Save Changes'
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 10pt; text-align: right; width:65%;">
                            <asp:DataList ID="productList" runat="server" BorderColor="Black" BorderStyle="Solid"
                                BorderWidth="1px" CellPadding="5" Width="100%">
                                <HeaderTemplate>
                                    New Sale
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="prodChkBox" runat="server" Text='<%# Eval("name") + " [$" + Eval("sugg_price").ToString() + "]" %>'
                                        Checked="false" />
                                    <asp:TextBox ID="prodID" runat="server" Text='<%# Eval("ID")%>' Visible="False" ReadOnly="True" />
                                    <asp:TextBox ID="prodPrice" runat="server" Text='<%# Eval("sugg_price")%>' Visible="False"
                                        ReadOnly="True" />
                                </ItemTemplate>
                                <HeaderStyle BorderColor="Black" BorderStyle="Solid" BorderWidth="1px" Font-Bold="True"
                                    HorizontalAlign="Center" />
                            </asp:DataList>
                        </td>
                        <td style="font-size: 10pt; text-align: left; width: 35%; vertical-align: top;">
                            <asp:DataList ID="PackageList" runat="server" 
                                OnUpdateCommand="PackageList_UpdateCommand" style="margin-right: 2px" ItemStyle-Wrap="False">
                                <HeaderTemplate>
                                    Packages:
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="selectpackage" runat="server" Text='<%# Eval("Name") %>' CommandArgument='<%# Eval("PackageID") %>'
                                        CommandName="Update" />
                                </ItemTemplate>
                            </asp:DataList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            
                            <table border="0" width="100%" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="width: 1%" align="right" nowrap="noWrap" valign="top">
                                        Notes:
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="notebox" runat="server" Rows="5" TextMode="MultiLine" Width="100%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 1%; text-align: right;" align="right" nowrap="noWrap">
                                        Package:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="packagebox" runat="server" Width="99%"></asp:TextBox>
                                    </td>
                                    <td style="width: 1%; text-align: right" nowrap="noWrap">
                                        Retail Price:
                                    </td>
                                    <td style="width: 1%; text-align: right;" nowrap="noWrap">
                                        $<asp:TextBox ID="retailprice" runat="server" Rows="1" Width="100px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" nowrap="nowrap" style="width: 1%; text-align: right; height: 31px;">
                                    </td>
                                    <td style="height: 31px" align="right">
                                        <asp:Button OnClientClick="return checkPrice()" ID="calcdiscount" runat="server"
                                            Font-Names="Arial" Font-Size="8pt" Font-Underline="True" OnClick="calcdiscount_Click"
                                            Text="Calculate �" />
                                    </td>
                                    <td nowrap="nowrap" style="width: 1%; color: red; border-bottom: black 1px solid;
                                        text-align: right; height: 31px;">
                                        - Discount:
                                    </td>
                                    <td nowrap="nowrap" style="width: 1%; color: red; border-bottom: black 1px solid;
                                        text-align: right; height: 31px;">
                                        $<asp:TextBox ID="discount" runat="server" Rows="1" Width="100px" Enabled="false" BorderStyle="None" BackColor="Transparent" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" nowrap="nowrap" style="width: 1%; text-align: right">
                                    </td>
                                    <td>
                                    </td>
                                    <td nowrap="nowrap" style="width: 1%; text-align: right">
                                        Price:
                                    </td>
                                    <td nowrap="nowrap" style="width: 1%; text-align: right">
                                        $<asp:TextBox ID="pricebox" runat="server" Rows="1" Width="100px">0</asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;" colspan="4">
                                        <asp:Button ID="savebutton" runat="server" OnClick="savebutton_Click" Text="Create Invoice"
                                            Enabled="False" />
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:Button ID="savepackagebutton" runat="server" Text="Save Selections as Package"
                                            OnClick="savepackagebutton_Click" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <a href="http://www.college-retirement.com/invoicetracker.aspx">Invoice Tracker</a>
    </form>
    <!--#include file="./footer.aspx"-->
</body>
</html>
