<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%!
	public static Map<String, String> getClients(HttpServletRequest req) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			File file = new File(req.getRealPath("") + File.separator + "clients.config");
			BufferedReader reader = new BufferedReader(new FileReader(file));
			String line = null;
			String[] strs = null;
			while ((line = reader.readLine()) != null) {
				strs = line.split("=");
				map.put(strs[0], strs[1]);
			}
			reader.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
	String getFileContentHtml(HttpServletRequest req, String id) {
		StringBuilder sb = new StringBuilder();
		try {
			File file = new File(req.getRealPath("") + "/build/" + id + "GitLog.log");
			BufferedReader bufferedReader = new BufferedReader(
					new InputStreamReader(new FileInputStream(file), "utf-8"));
			String line = null;
			String commitId = null;
			int count = 0;
			while ((line = bufferedReader.readLine()) != null) {
				if (line.contains("commit ")) {
					count++;
					commitId = line.replace("commit", "");
					commitId = commitId.substring(0, 10);
					line = "=========更新内容" + count + "=========<br/>commitId:" + commitId + "<br/>";
				}
				sb.append(line).append("<br/>");
			}
			bufferedReader.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<h4><stressThis>" + id + "端git更新日志（最近几次）</stressThis>:</br><div id=\"log\">"
				+ sb.toString().replace("\n", "<br/>") + "</div></h4>";
	}

	String getFileInfo(HttpServletRequest req, String apkName, String id) {
		File propFile = new File(req.getRealPath("") + "/build/" + id + "BranchInfo.properties");
		File apkFile = new File(req.getRealPath("") + "/build/" + apkName);
		SimpleDateFormat format = new SimpleDateFormat("MM-dd HH:mm:ss");
		String branch = "";
		String task = "";
		Properties prop = null;
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(propFile);
			prop = new Properties();
			prop.load(fis);
			branch = prop.getProperty("Branch");
			task = prop.getProperty("Task");
			fis.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "<smallNormal>更新时间：" + format.format(new Date(apkFile.lastModified())) + " | 分支：" + branch + " | Task："
				+ task + "</smallNormal><br/>";
	}

	synchronized void writeLog(HttpServletRequest request) {
		String ip = request.getRemoteAddr();
		SimpleDateFormat format = new SimpleDateFormat("MM-dd HH:mm:ss");
		try {
			// 打开一个写文件器，构造函数中的第二个参数true表示以追加形式写文件
			FileWriter writer = new FileWriter(request.getRealPath("") + File.separator + "log.log", true);
			writer.write("\r\n" + format.format(new Date()) + "|" + ip + "|headers:" + printHeader(request));
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private String printHeader(HttpServletRequest request) {
		Enumeration names = request.getHeaderNames();
		StringBuilder sb = new StringBuilder("headerInfo---");
		while (names.hasMoreElements()) {
			String name = names.nextElement().toString();
			Enumeration headers = request.getHeaders(name);
			sb.append(name).append(":");
			while (headers.hasMoreElements()) {
				sb.append(headers.nextElement()).append(" ");
			}
			sb.append("\n");
		}
		sb.append("======================================\n");
		return sb.toString();
	}
%>
<html>
<head>
<title>Android 客户端下载</title>
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
	margin:20px 0px 10px 0px;
	border-style: solid;
	OVERFLOW-Y: auto;
	OVERFLOW-X:hidden;
	position:relative;
}
#logParent{
	width:58%;
	color:#8B0000;
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
smallNormal{
	font-weight:bold;
	line-height: 60%;
	font-size:65%;
	color:#DC143C;
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
	<div id="side">
		<div id="sideDownload">
			<stressThis><a target="_blank" href="/files/down.apk"><newRed>2.0新版本&nbsp请内网使用</newRed>下载云鸟Android下崽器</a></stressThis>
			<br/>
			<stressThis><a target="_blank" href="/files/app_client.zip"><newRed>new&nbsp请在内网使用</newRed>下载app自动化测试器</a></stressThis>
			<br/>
			<a target="_blank" href="/files/index.jsp">下载文件列表</a>&nbsp&nbsp
			<a target="_blank" href="/release/index.jsp">上线包列表</a>&nbsp&nbsp
			<a target="_blank" href="/hotfix/index.jsp">热修复BASE包</a>
			<br/>
			<%
				Map<String, String> map = getClients(request);
				Set<String> keySet = map.keySet();
				for (String key : keySet) {
					out.println("<a target=\"_blank\" href=\"/build/" + map.get(key) + "\">下载" + key + "端</a><br/>");
					out.println(getFileInfo(request, map.get(key), key));
				}
			%>
			<a target="_blank" href="http://192.168.200.143:8000">Check in jenkins</a>
			<br/> 
			<a target="_blank" href="/nexus/">Check in nexus</a>
			<br/> 
		</div>
		<div id="sideInfo">
			<p>说明：B端版本每5分钟检查一次代码的更新情况，如果发现有更新进行build，build一次一般耗时6-7分钟，因此一般如果代码merge后<stressThis>最晚15分钟</stressThis>后下载到的版本为包含此次merge的版本
			</p>
			<p>S端、Y端、C端、F端都是每15分钟检查一次代码变化再进行Build</p>
		</div>
	</div>
	<%
		out.println("<div id=\"logParent\">");
		for (String key : keySet) {
			out.println(getFileContentHtml(request, key));
		}
		out.println("</div>");
	%>
</body>
  
</html>
