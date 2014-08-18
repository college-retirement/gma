<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript" SRC="<%= Session["imagedir"] %>global_functions.js"></SCRIPT>
<center>
	<table width="772" border="0" cellspacing="0" cellpadding="0" BGCOLOR="#FFFFFF">
	<tr>
		<td width="772" colspan="5" height="1" background="<%= Session["imagedir"] %>dashHR.gif"><img src="<%= Session["imagedir"] %>dashHR.gif" width="1" height="1"></td>
	</tr>			
	<tr>
		<TD WIDTH="1" BGCOLOR="#CCCCCC"><img src="<%= Session["imagedir"] %>1x1_spacer.gif" alt="" width="1" height="1" border="0"></TD>
		<td width="570"><A HREF="<%= Session["serverroot"] %>"><IMG SRC="<%= Session["imagedir"] %>logo.gif" border="0" alt="Madison Financial Aid Consultants"></A></td>
		<td width="200" align="left">
			<font class="red">Client:<font>&nbsp;<font class="black"><%= Session["client_last_name"] + "," + Session["client_first_name"] %></font>
			<br><font class="red">Student:</font>&nbsp;<font class="black"><%= Session["student_last_name"] + "," + Session["student_first_name"] %></font>
			<br><font class="red">Phone:</font>&nbsp;<font class="black"><%= Session["home_phone"] %></font>
			<br><font class="red">Email:</font>&nbsp;<font class="black"><%= Session["parent_email_address"] %></font>
		</td>
		<TD WIDTH="1" BGCOLOR="#CCCCCC"><img src="<%= Session["imagedir"] %>1x1_spacer.gif" alt="" width="1" height="1" border="0"></TD>
	</tr>
	</table>

<table width="772" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <TD WIDTH="1" BGCOLOR="#CCCCCC"><img src="<%= Session["imagedir"] %>1x1_spacer.gif" alt="" width="1" height="1" border="0"></TD>
        <td height="23" width="770" BGCOLOR="#ffffff">

<img src="<%= Session["imagedir"] %>tabs_end.gif" width="26" height="23"><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><A 
	HREF="case_info.aspx" target="_top" onMouseOver="swapImage('but1', '<%= Session["imagedir"] %>case_review_menu/but1on.gif');" onMouseOut="swapImage('but1', '<%= Session["imagedir"] %>case_review_menu/but1on.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but1on.gif" ALT="But1 Caption" BORDER="0" NAME="but1" height="23"></a><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><A 
	HREF="mfac_client_data.aspx" target="_top" onMouseOver="swapImage('but2', '<%= Session["imagedir"] %>case_review_menu/but2on.gif');" onMouseOut="swapImage('but2', '<%= Session["imagedir"] %>case_review_menu/but2off.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but2off.gif" ALT="But2 Caption" BORDER="0" NAME="but2" height="23"></a><!--<img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><A 
	HREF="rtc.aspx" target="_top" onMouseOver="swapImage('but3', '<%= Session["imagedir"] %>case_review_menu/but3on.gif');" onMouseOut="swapImage('but3', '<%= Session["imagedir"] %>case_review_menu/but3off.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but3off.gif" ALT="But3 Caption" BORDER="0" NAME="but3" height="23"></a>--><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><A 
	HREF="sale_summary.aspx" target="_top" onMouseOver="swapImage('but4', '<%= Session["imagedir"] %>case_review_menu/but4on.gif');" onMouseOut="swapImage('but4', '<%= Session["imagedir"] %>case_review_menu/but4off.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but4off.gif" ALT="But4 Caption" BORDER="0" NAME="but4" height="23"></a><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><A
	HREF="case_notes.aspx" target="_top" onMouseOver="swapImage('but6', '<%= Session["imagedir"] %>case_review_menu/but6on.gif');" onMouseOut="swapImage('but6', '<%= Session["imagedir"] %>case_review_menu/but6off.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but6off.gif" ALT="But6 Caption" BORDER="0" NAME="but6" height="23"></a><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><A
	HREF="clientInfoUpload.aspx" target="_top" onMouseOver="swapImage('but7', '<%= Session["imagedir"] %>case_review_menu/but7on.gif');" onMouseOut="swapImage('but7', '<%= Session["imagedir"] %>case_review_menu/but7off.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but7off.gif" ALT="But7 Caption" BORDER="0" NAME="but7" height="23"></a><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><A
	<% if(Session["account_type"] != null && Session["account_type"].ToString().ToLower() == "admin") { %>
		HREF="assign_leads.aspx" target="_top" onMouseOver="swapImage('but8', '<%= Session["imagedir"] %>case_review_menu/but8on.gif');" onMouseOut="swapImage('but8', '<%= Session["imagedir"] %>case_review_menu/but8off.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but8off.gif" ALT="But8 Caption" BORDER="0" NAME="but8" height="23"></a><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><IMG
	<% }else{ %>
		HREF="new_leads.aspx" target="_top" onMouseOver="swapImage('but8', '<%= Session["imagedir"] %>case_review_menu/but8on.gif');" onMouseOut="swapImage('but8', '<%= Session["imagedir"] %>case_review_menu/but8off.gif');"><IMG SRC="<%= Session["imagedir"] %>case_review_menu/but8off.gif" ALT="But8 Caption" BORDER="0" NAME="but8" height="23"></a><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><IMG
	<% } %>
	src="<%= Session["imagedir"] %>tabs_end.gif" width="26" height="23"><IMG
	src="<%= Session["imagedir"] %>tabs_end.gif" width="26" height="23"><IMG
	src="<%= Session["imagedir"] %>tabs_end.gif" width="26" height="23"><IMG
	src="<%= Session["imagedir"] %>tabs_end.gif" width="26" height="23"><IMG
	src="<%= Session["imagedir"] %>tabs_end.gif" width="126" height="23"><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23"><img src="<%= Session["imagedir"] %>tabs_divider.gif" width="1" height="23">
</td><TD WIDTH="1" BGCOLOR="#CCCCCC"><img src="<%= Session["imagedir"] %>1x1_spacer.gif" alt="" width="1" height="1" border="0">
</TD>

    </tr>
</table>
</center>