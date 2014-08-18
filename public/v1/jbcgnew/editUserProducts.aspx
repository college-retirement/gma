<%@ Page Language="C#" AutoEventWireup="true" CodeFile="editUserProducts.aspx.cs"
    Inherits="jbcgnew_editUserProducts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>
        <!--#include file="./title.aspx"-->
    </title>
    <link href="./cssfiles/styledefs.css" type="text/css" rel="stylesheet">
</head>
<body text="#000000" bgcolor="#ffffff" style="text-align: center">
    <!--#include file="./images/case_review_menu/nav.aspx"-->
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="message" runat="server"></asp:Label>
        <br />
        <asp:DataList ID="ProdList" runat="server" Width="700px" CellPadding="3"
            BorderStyle="None" onitemcreated="ProdList_ItemCreated" BackColor="White" 
            BorderColor="#E7E7FF" BorderWidth="1px" GridLines="Horizontal" 
            onprerender="ProdList_PreRender">
            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
            <ItemTemplate>
                <table border="0" cellpadding="5" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 350px; text-align: right;border-right:dashed 1px black;">
                            <asp:HiddenField ID="product" Value='<%# Eval("product") %>' runat="server" />
                            <asp:Label ID="prodname" Text='<%# Eval("name") %>' runat="server" ></asp:Label>
                        </td>
                        <td style="width: 350px; text-align: left;">
                            <asp:HiddenField ID="active" Value='<%# Eval("active") %>' runat="server" />
                            <asp:CheckBox ID="activeCB" runat="server" />
                        </td>
                    </tr>
                </table>
            </ItemTemplate>
            
            <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
            <SelectedItemStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
            <AlternatingItemStyle BackColor="#F7F7F7" />
            <ItemStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
            
            <HeaderTemplate>
                <table border="0" cellpadding="5" cellspacing="0" width="100%">
                    <tr>
                        <td style="border-right: dashed 1px black; width: 350px; text-align: right;">
                            Product Name</td>
                        <td style="width: 350px; text-align: left;">
                            Active
                        </td>
                    </tr>
                </table>
            </HeaderTemplate>
        </asp:DataList>
        <asp:Button ID="SaveProd" runat="server" OnClick="SaveProd_Click" Text="Save" />
    </div>
    </form>
    <!--#include file="./footer.aspx"-->
</body>
</html>
