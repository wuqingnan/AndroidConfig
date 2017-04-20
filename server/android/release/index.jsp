<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%!
	String listDirs(File dir){
		StringBuilder sb=new StringBuilder();
		try {
			File[] files = dir.listFiles();
			for(int i = 0, len = files.length; i < len; i++) {
				if (!files[i].isDirectory()) {
					continue;
				}
				sb.append("<a href=\"./" + files[i].getName() + "/\">").append(files[i].getName() + "端上线包列表").append("</a><br/>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}

%>
<html>
<head>
<title>线上包列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="http://cdn.bootcss.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet">

<style type="text/css">
body{
	font-family:'微软雅黑'
}
#sideDownload{
	width:100%;
	position:relative;
	padding: 10px;
	line-height: 160%;
	border-style: dashed;
	font-size: 150%;
	text-align:center
}
#side{
	width:38%;
	position:fixed;
	margin:20px 10px 0px 10px;
}
#sideInfo{
	width:100%;
	top:10px;
	color:#000080;
	position:relative;
	font-weight:bold;
	padding: 10px;
	text-indent:20px;
	line-height: 130%;
	border-style: dashed;
	font-size: 115%;
}
#log{
	color:#191970;
	padding: 20px;
	height:500px;
	width:100%;
	font-size:150%;
	margin:20px 0px 10px 0px;
	border-style: solid;
	OVERFLOW-Y: auto;
	OVERFLOW-X:hidden;
	position:relative;
}
#logParent{
	width:58%;
	color:#8B0000;
	font-size:200%;
	margin:20px 10px 0px 10px;
	padding:0px 10px 0px 10px;
	left:40%;
	border-style: double;
	position:absolute;
	display:inline;
}
stressThis{
	font-size: 140%;
}
smallUnderline{
	font-weight:bold;
	line-height: 60%;
	font-size:65%;
	color:#DC143C;
	text-decoration: underline
}
newRed{
	font-size:50%;
	color:#ff0000;
}
</style>
</head>

<body>
	<div id="log">
	<%
		File file = new File(application.getRealPath(request.getRequestURI()));
		out.println(listDirs(file.isDirectory() ? file : file.getParentFile()));
	%>
	</div>
</body>
  
</html>
