
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!-- #include file="../../c_option.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_function.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_system_lib.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_system_base.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_system_plugin.asp" -->
<!-- #include file="../../plugin/p_config.asp" -->

<%
Call System_Initialize
Call ZBQQConnect_Initialize()
Select Case Request.QueryString("tp")
	Case "wb"
		Call ZBQQConnect_Class.fakeQQConnect.Run(11,"","","","")
		ZBQQConnect_Config.Write "WBToken",ZBQQConnect_Class.fakeQQConnect.Token
		ZBQQConnect_Config.Write "WBSecret",ZBQQConnect_Class.fakeQQConnect.Secret
		ZBQQConnect_Config.Write "WBName",ZBQQConnect_Class.fakeQQConnect.UserID
		ZBQQConnect_Config.Save
		'Response.end
		Response.write "<script>opener.location.href=opener.location.href.replace(""act=wblogout"","""");window.close()</script>"
		
	Case else
		Call ZBQQConnect_Class.GetOpenId(ZBQQConnect_class.CallBack)
		ZBQQConnect_DB.OpenID=ZBQQConnect_Class.OpenID
		ZBQQConnect_DB.AccessToken=ZBQQConnect_Class.AccessToken
		
		If ZBQQConnect_DB.LoadInfo(4) Then
			If CInt(ZBQQConnect_DB.objUser.ID)<>0 Then
				If ZBQQConnect_DB.Login=True Then
					Response.Redirect GetCurrentHost&"/ZB_SYSTEM/ADMIN/ADMIN.ASP?ACT=SiteInfo"
				Else
					Response.Write ZBQQConnect_DB.objUser.ID
				End If
			Else
				a
			End If
		Else
			a
		End If
End Select
Function a
		Dim b
		b=ZBQQConnect_class.API("https://graph.qq.com/user/get_info","{'format':'json'}","GET&")
		Set b=ZBQQConnect_toobject(b)
		ZBQQConnect_DB.tHead=b.data.head
		b=ZBQQConnect_class.API("https://graph.qq.com/user/get_user_info","{'format':'json'}","GET&")
		Set b=ZBQQConnect_toobject(b)
		ZBQQConnect_DB.QZoneHead=b.figureurl_2
		Set ZBQQConnect_DB.objUser=BlogUser
		ZBQQConnect_DB.Email=MD5(BlogUser.EMail)
		ZBQQConnect_DB.Bind
		If BlogUser.Level=5 Then
			Response.Redirect "select.asp?QQOPENID="&ZBQQConnect_Class.OpenID
		Else
			Response.write "<script>opener.location.href=opener.location.href.replace(""act=logout"","""");window.close()</script>"
		End If
		Response.Cookies("inpName")=b.nickname
		Response.Cookies("inpName").Expires = DateAdd("d", 365, now)
		Response.Cookies("inpName").Path="/"
End Function
%>