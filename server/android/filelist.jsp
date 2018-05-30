<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%--注意这个文件是一个硬链接文件 由ln创建
	source文件位于~/server/android/filelist.jsp
	ln ~/server/android/filelist.jsp index.jsp
	修改这个文件会影响所有显示文件列表的页面
--%>
<%!
	String listFiles(File dir) {
		StringBuilder sb = new StringBuilder();
		SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
		try {
			File[] files = dir.listFiles();
			if (files == null || files.length <= 0) {
				return "<th colspan='4'>没有文件</th>";
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

				sb.append("<tr>");
				sb.append("<td><a href=\"./" + file.getName() + "\">").append(file.getName()).append("</a></td>");
				sb.append("<td align=\"right\">").append(format.format(new Date(file.lastModified()))).append("</td>");
				sb.append("<td align=\"right\">").append(getFileSize(file)).append("</td>");
				sb.append("<td>&nbsp;</td>");
				sb.append("</tr>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (sb.toString().length() <= 0) {
			return "<th colspan='4'>没有文件</th>";
		}
		return sb.toString();
	}

	String getFileSize(File file) {
		String[] units = {"B", "KB", "MB", "GB", "TB"};
		double size = 0;
		int unit = 0;
		if (file != null && file.isFile()) {
			size = file.length();
			while(size >= 1024) {
				size /= 1024;
				unit++;
			}
		}
		if (unit <= 1) {
			return (int)size + units[unit];
		}
		return String.format(Locale.CHINA, "%.1f", size) + units[unit];
	}
%>
<html>
<head>
<title>文件下载</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link
	href="http://cdn.bootcss.com/bootstrap/3.3.1/css/bootstrap.min.css"
	rel="stylesheet">
<style>
th {
	text-align: center;
	color: blue;
	min-width: 100px;
}

td {
	padding-left: 10px;
}
</style>
</head>
<body>
	<table style="padding-top: 20px">
		</br>
		<tr>
			<th align="center">Name</th>
			<th align="center">Last modified</th>
			<th align="center">Size</th>
			<th align="center">Description</th>
		</tr>
		<tr>
			<th colspan="4"><hr></th>
		</tr>

		<%
			File file = new File(application.getRealPath(request.getRequestURI()));
			out.println(listFiles(file.isDirectory() ? file : file.getParentFile()));
		%>
		<tr>
			<th colspan="4"><hr></th>
		</tr>
	</table>
</body>
</html>