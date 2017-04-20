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
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(file), "utf-8"));

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
		return "<h5><stressThis>" + id + "端git更新日志（最近几次）</stressThis>:</br><div id=\"log\">"
				+ sb.toString().replace("\n", "<br/>") + "</div></h5>";
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
		return "更新时间：" + format.format(new Date(apkFile.lastModified())) + " | 分支：" + branch + " | Task：" + task + "<br/>";
	}

	synchronized void writeLog(HttpServletRequest request) {
		String hostname = "";
		String ip = request.getRemoteAddr();
		SimpleDateFormat format = new SimpleDateFormat("MM-dd HH:mm:ss");
		try {
			hostname = InetAddress.getByName(ip).getHostName();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		try {
			// 打开一个写文件器，构造函数中的第二个参数true表示以追加形式写文件
			FileWriter writer = new FileWriter(request.getRealPath("") + File.separator + "log.log", true);
			writer.write("\r\n" + format.format(new Date()) + "|" + ip + "|HOST:" + hostname + "|remoteHost"
					+ request.getRemoteHost());
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
%>
<html>
<head>
<title>Android 客户端下载</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="http://cdn.bootcss.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet">

<style type="text/css">
#log{
	color:#191970;
	padding: 20px;
	width:100%;
	margin:20px 0px 10px 0px;
	border-style: solid;
	position:relative;
}
#logParent{
	width:100%;
	color:#8B0000;
	padding:0px 10px 0px 10px;
	position:absolute;
}
stressThis{
	font-size: 140%;
}
</style>
</head>

<body>
	<%
		String clientId = request.getParameter("client");
		if (clientId == null) {
			clientId = "S";
		}
		String apk = "AndroidSMaster.apk";
		
		Map<String, String> map = getClients(request);
		if (map.containsKey(clientId)) {
			apk = map.get(clientId);
		}

		out.println("<div id=\"logParent\">");
		out.println(getFileInfo(request, apk, clientId));
		out.println(getFileContentHtml(request, clientId));
		out.println("</div>");
	%>
</body>
  
</html>
