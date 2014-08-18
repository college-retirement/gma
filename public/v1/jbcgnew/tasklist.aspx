<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tasklist.aspx.cs" Inherits="jbcgnew_tasklist" %>

<%@ Register Src="../footer.ascx" TagName="footer" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>CRS CRM Task List</title>
    <link rel="stylesheet" type="text/css" href="../browsing.css" />
    <style>
    body{
        margin-top:0px;
        margin-left:0px;
        font-family: Arial;
        background-color: #cfe1cf;
        background-image: url(../images/forumtopbg.jpg);
        background-repeat: repeat-x;
    }
    .itemHead {
        border: solid 1px black;
        background-color: #FFD;
        text-align: center;
        font-family: Arial;
        font-size: 10pt;
        padding-right: 10px;
        padding-left: 10px;
    }
    .item {
        background-color: #fff;
        border-bottom: solid 1px #cccccc;
        font-family: Arial;
        font-size: 10pt;
        padding-right: 10px;
        padding-left: 10px;
    }
    .altitem {
        background-color: #DDF;
        border-bottom: solid 1px #cccccc;
        font-family: Arial;
        font-size: 10pt;
        padding-right: 10px;
        padding-left: 10px;
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div align="center">
        <table border="0" cellpadding="5" cellspacing="0" style="width: 100%;">
            <tr>
                <td style="text-align: left" valign="top">
                <a href="admin_account.aspx">
                    <img src="../Images/CRS2.gif" width="160" border="0" /></a></td>
                <td align="right" valign="top">
                    <span style="font-size: 8pt;"><strong><span style="font-size: 24pt">
                        College &amp; Retirement Solutions<br />
                    </span></strong>C l e a r ,&nbsp; C o n c i s e&nbsp; S o l u t i o n s&nbsp; F o r&nbsp;
                        Y o u r&nbsp; F u t u r e</span></td>
            </tr>
            <tr>
                <td style="text-align: left; font-weight: bold; font-size: 16pt; font-family: Arial;" colspan="2" valign="top">
                    Task List for <%= Session["name"].ToString() %>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: left" valign="top">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td>
                                    
                                    <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="left">
                                        <span style="font-size: 10pt">Type of Task: </span>
                                        <asp:DropDownList ID="taskNameDDL" runat="server" Font-Size="8pt">
                                        </asp:DropDownList>&nbsp;<asp:Button ID="Button2" runat="server" Font-Size="8pt"
                                            Text="Filter" OnClick="Button2_Click" /></td><td align="right"><asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True" Checked="True" OnCheckedChanged="CheckBox1_CheckedChanged"
                                            Text="Hide Complete Tasks?" /></td></tr></table>
                                        
                                            
                                            </td>
                                </tr>
                                <tr>
                                    <td>
                            <asp:DataList BorderStyle="solid" BorderColor="black" BorderWidth="1" ID="taskList" runat="server" Width="99%" OnEditCommand="taskList_EditCommand" OnDeleteCommand="taskList_DeleteCommand">
                                <HeaderTemplate>
                                    Task </td>
                                    <td nowrap="nowrap" style="width: 1%" class="itemHead">Name</td>
                                    <td nowrap="nowrap" style="width: 1%" class="itemHead">Due Date</td>
                                    <td nowrap="nowrap" style="width: 1%" class="itemHead">Complete
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Description") %>'></asp:Label></td>
                                    <td nowrap="nowrap" style="border-left: solid 1px #ddd;" align="left" class="item"><asp:Label ID="Label4" runat="server" Text='<%# "<a href=\"../viewCase.aspx?id=" + Eval("CaseID") + "\">" + Eval("Name") + "</a>" %>'></asp:Label></td>
                                    <td nowrap="nowrap" style="border-left: solid 1px #ddd;" align="center" class="item"><asp:Label ID="Label2" runat="server" Text='<%# Eval("DueDate") %>'></asp:Label></td>
                                    <td nowrap="nowrap" style="border-left: solid 1px #ddd;" align="right" class="item"><asp:Label Visible='<%# Eval("CompleteBy") != DBNull.Value ? true : false %>' ID="Label3" runat="server" Text='<%# Eval("CompleteDate") + "<br />by " + Eval("CompleteByName") %>'></asp:Label>
                                        <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button1" runat="server" Text="Done" CommandName="edit" CommandArgument='<%# Eval("ID") %>' /> <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button4" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this task?')" CommandName="delete" CommandArgument='<%# Eval("ID") %>' />
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Description") %>'></asp:Label></td>
                                    <td nowrap="nowrap" style="border-left: solid 1px #ddd;" align="left" class="altitem"><asp:Label ID="Label4" runat="server" Text='<%# "<a href=\"../viewCase.aspx?id=" + Eval("CaseID") + "\">" + Eval("Name") + "</a>" %>'></asp:Label></td>
                                    <td nowrap="nowrap" style="border-left: solid 1px #ddd;" align="center" class="altitem"><asp:Label ID="Label2" runat="server" Text='<%# Eval("DueDate") %>'></asp:Label></td>
                                    <td nowrap="nowrap" style="border-left: solid 1px #ddd;" align="right" class="altitem"><asp:Label Visible='<%# Eval("CompleteBy") != DBNull.Value ? true : false %>' ID="Label3" runat="server" Text='<%# Eval("CompleteDate") + "<br />by " + Eval("CompleteByName") %>'></asp:Label>
                                        <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button1" runat="server" Text="Done" CommandName="edit" CommandArgument='<%# Eval("ID") %>' /> <asp:Button Visible='<%# Eval("CompleteBy") != DBNull.Value ? false : true %>' ID="Button4" runat="server" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this task?')" CommandName="delete" CommandArgument='<%# Eval("ID") %>' />
                                </AlternatingItemTemplate>
                                <HeaderStyle Font-Bold="False" CssClass="itemHead" Font-Overline="False" Font-Strikeout="False" Font-Underline="False" Wrap="False" />
                                <AlternatingItemStyle CssClass="altitem" />
                                <ItemStyle CssClass="item" />
                            </asp:DataList></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center" valign="top">
                    <uc1:footer ID="Footer1" runat="server" />
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
