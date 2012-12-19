﻿<%@ LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'未完成功能：
'1.得到需要更新的主题（tname）
'2.用XML来判断是否有app子节点
'3.显示更新列表
'4.下载更新
%>
<% Option Explicit %>
<% 'On Error Resume Next %>
<% Response.Charset="UTF-8" %>
<!-- #include file="../../c_option.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_function.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_system_lib.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_system_base.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_system_plugin.asp" -->
<!-- #include file="../../../ZB_SYSTEM/function/c_system_event.asp" -->
<!-- #include file="../../plugin/p_config.asp" -->
<!-- #include file="function.asp"-->
<%


Call System_Initialize()
'检查非法链接
Call CheckReference("")
'检查权限
If BlogUser.Level>1 Then Call ShowError(6)
If CheckPluginState("AppCentre")=False Then Call ShowError(48)
%>
<!--#include file="..\..\..\zb_system\admin\admin_header.asp"-->
<!--#include file="..\..\..\zb_system\admin\admin_top.asp"-->
        <div id="divMain">
          <div id="ShowBlogHint">
            <%Call GetBlogHint()%>
          </div>
          <div class="divHeader">应用中心</div>
          <div class="SubMenu">
            <%SubMenu(0)%>
          </div>
          <div id="divMain2"> 

<%
Dim bolSilent,bolReDownload,objXml,objChildXml
Set objXml=CreateObject("Microsoft.XMLDOM")


Select Case Request.QueryString("action")
	Case "silent"
		bolSilent=True
		bolReDownload=True
	Case "recheck"
		bolReDownload=True
End Select

If bolReDownload Then Call ReCheck
If bolSilent Then Response.End
objXml.Load BlogPath&"zb_users\cache\appcentre.xml"
If objXml.ReadyState=4 Then
	'这里该显示更新列表了
End If



Function ReCheck()
	Dim objXmlHttp,strURL,bolPost,str,bolIsBinary
	Set objXmlHttp=Server.CreateObject("MSXML2.ServerXMLHTTP")

	strUrl=APPCENTRE_UPDATE_URL&"?tname=&pname="&Server.URLEncode(Replace(ZC_USING_PLUGIN_LIST,"|",","))
	objXmlHttp.Open "GET",strURL
	objXmlHttp.Send 

	If objXmlHttp.ReadyState=4 Then
		If objXmlhttp.Status=200 Then
		Else
			ShowErr
		End If
		
		
	Else
		ShowErr
	End If
	If Err.Number<>0 Then ShowErr
	
	
	'这里应该用XML来判断是否有app子节点
	Call SaveToFile(BlogPath&"zb_users\cache\appcentre.xml",objXmlHttp.ResponseText,"utf-8",False)
End Function

Function ShowErr()
%>
            <p>处理<a href='<%=strURL%>' target='_blank'><%=strURL%></a>(method:<%=Request.ServerVariables("REQUEST_METHOD")%>)时出错：</p>
            <p>ASP错误信息：<%=IIf(Err.Number=0,"无",Err.Number&"("&Err.Description&")")%></p>
            <p>HTTP状态码：<%If objXmlhttp.readyState<4 Then Response.Write "未发送请求" Else Response.Write objXmlhttp.status%></p>
            <p>&nbsp;</p>
            <p>可能的原因有：</p>
            <p>
            <ol>
              <li>您的服务器不允许通过HTTP协议连接到：<a href="<%=APPCENTRE_URL%>" target="_blank"><%=APPCENTRE_URL%></a>；</li>
              <li>您进行了一个错误的请求；</li>
              <li>服务器暂时无法连接，可能是遭到攻击或者检修中。</li>
            </ol>
            <p>请<a href="javascript:location.reload()">点击这里刷新重试</a>，或者到<a href="http://bbs.rainbowsoft.org" target="_blank">Z-Blogger论坛</a>发帖询问。</p>

<%
	Response.End
End Function
%>
          </div>
        </div>
        <script type="text/javascript">ActiveLeftMenu("aAppcentre");</script> 
        <!--#include file="..\..\..\zb_system\admin\admin_footer.asp"-->