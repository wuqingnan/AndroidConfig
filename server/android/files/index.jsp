<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%--注意这个文件是一个硬链接文件 由ln创建
	source文件位于~/server/android/filelist.jsp
	ln ~/server/android/filelist.jsp index.jsp
	修改这个文件会影响所有显示文件列表的页面
--%>
<%!
	String listFiles(File dir){
		StringBuilder sb=new StringBuilder();
		SimpleDateFormat format=new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
		try {
			File[] files = dir.listFiles();
			if(files==null || files.length <= 0) {
				return "没有文件";
			}
			
			List<File> fileList = new ArrayList<>(Arrays.asList(files));
			Collections.sort(fileList, new Comparator<File>() {
				@Override
				public int compare(File f1, File f2) {
					return Long.compare(f2.lastModified(), f1.lastModified());
				}
			});
			
			for (File file : fileList) {
				if (file.isDirectory() || file.getName().endsWith(".jsp") || file.getName().startsWith(".")) {
					continue;
				}
				
				sb.append("<a target=\"_blank\" href=\"./" + file.getName() + "\">")
				.append(file.getName())
				.append("&nbsp;|&nbsp")
				.append(format.format(new Date(file.lastModified())))
				.append("</a><br/>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(sb.toString().length()<=0){
			return "没有文件";
		}
		return sb.toString();
	}

%>
<html>
<head>
<title>文件下载ln</title>
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
		out.println(listFiles(file.isDirectory() ? file : file.getParentFile()));
	%>
  </div>
  </body>
  
</html>
