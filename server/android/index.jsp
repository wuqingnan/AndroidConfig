<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.reflect.Type"%>
<%@ page import="com.google.gson.*"%>
<%@ page import="com.google.gson.reflect.TypeToken"%>
<%!public static List<Map<String, String>> loadConfig(HttpServletRequest request) {
		try {
			File file = new File(request.getServletContext().getRealPath("") + File.separator + "clients.json");
			BufferedReader reader = new BufferedReader(new FileReader(file));
			StringBuilder builder = new StringBuilder();
			String line = null;
			while ((line = reader.readLine()) != null) {
				builder.append(line);
			}
			reader.close();
			reader = null;

			Gson gson = new Gson();
			Type type = new TypeToken<List<Map<String, String>>>() {
			}.getType();
			List<Map<String, String>> list = gson.fromJson(builder.toString(), type);
			return list;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	String getApkUpdateTime(HttpServletRequest request, String apkPath) {
		File apkFile = new File(request.getServletContext().getRealPath("") + File.separator + apkPath);
		SimpleDateFormat format = new SimpleDateFormat("MM-dd HH:mm:ss");
		if (apkFile.exists()) {
			return "更新时间：" + format.format(new Date(apkFile.lastModified()));
		}
		return "更新时间：";
	}%>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
<meta name="description" content="">
<meta name="author" content="">
<link rel="icon" href="image/favicon.ico">

<title>云鸟Android</title>

<!-- Bootstrap core CSS -->
<link
	href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"
	rel="stylesheet">

<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<link href="../../assets/css/ie10-viewport-bug-workaround.css"
	rel="stylesheet">

<!-- Custom styles for this template -->
<link href="css/offcanvas.css" rel="stylesheet">

<!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
<!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
<script src="../../assets/js/ie-emulation-modes-warning.js"></script>

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
      <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>
	<%
		List<Map<String, String>> configList = loadConfig(request);
	%>
	<nav class="navbar navbar-fixed-top navbar-inverse">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#navbar" aria-expanded="false"
					aria-controls="navbar">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">云鸟Android</a>
			</div>
			<div id="navbar" class="collapse navbar-collapse">
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">Home</a></li>
					<li><a href="http://192.168.200.143:8000/" target="_blank">Jenkins</a></li>
					<li><a href="http://192.168.200.143:8081/" target="_blank">Nexus</a></li>
				</ul>
			</div>
			<!-- /.nav-collapse -->
		</div>
		<!-- /.container -->
	</nav>
	<!-- /.navbar -->

	<div class="container">

		<div class="row row-offcanvas row-offcanvas-right">

			<div class="col-xs-12 col-sm-9">
				<p class="pull-right visible-xs">
					<button type="button" class="btn btn-primary btn-xs"
						data-toggle="offcanvas">Toggle nav</button>
				</p>
				<div class="jumbotron">
					<h1>Android Team</h1>
					<p>用于提供Android各平台安装包和工具下载，Jenkins打包，Nexus本地代码库管理，以及上线包和热更新备份等功能。</p>
				</div>
				<div class="row">
					<%
						if (configList != null) {
							String name = null;
							String alias = null;
							String apkPath = null;
							Map<String, String> cfg = null;
							final String changeLogFormat = "http://192.168.200.143:8000/view/Build/job/%s-Build/changes";
							for (int i = 0; i < configList.size(); i++) {
								cfg = configList.get(i);
								name = cfg.get("name");
								alias = cfg.get("alias");
								apkPath = cfg.get("apkPath");

								out.println("<div class=\"col-xs-6 col-lg-4\">");
								out.println("<h3>" + name + "（" + alias + "）</h3>");

								out.println("<p>" + getApkUpdateTime(request, apkPath) + "</p>");

								out.println("<a href=\"" + apkPath + "\" class=\"thumbnail\">");
								out.println("<img src=\"image/QR-" + alias + ".png\" alt=\"" + name + "\">");
								out.println("</a>");

								out.println("<p><a target=\"_blank\" class=\"btn btn-default\" href=\""
										+ String.format(changeLogFormat, alias) + "\" role=\"button\">Change Log &raquo;</a></p>");
								out.println("</div>");
							}
						}
					%>
					<div class="col-xs-6 col-lg-4">
						<h3>鸟港共配服务版小程序</h3>
						<p>使用微信扫描并使用鸟港A端账户登录</p>
						<img src="image/QR-niaogang_a_miniapp.jpg" alt="鸟港共配服务版小程序">
					</div>
				</div>
				<!--/row-->
			</div>
			<!--/.col-xs-12.col-sm-9-->

			<div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar">
				<div class="list-group">
					<a href="/files/down.apk" class="list-group-item">Android下崽器</a> <a
						href="/files/app_client.zip" class="list-group-item">自动化测试工具 </a>
					<%
						if (configList != null) {
							String alias = null;
							for (int i = 0; i < configList.size(); i++) {
								alias = configList.get(i).get("alias");
								out.println("<a href=\"/release/" + alias + "\" target=\"_blank\" class=\"list-group-item\">"
										+ alias + "端上线包</a>");
							}
						}
					%>
					<a href="/hotfix/index.jsp" target="_blank" class="list-group-item">热更新</a>
					<a href="/files/index.jsp" target="_blank" class="list-group-item">文件下载</a>
				</div>
			</div>
			<!--/.sidebar-offcanvas-->
		</div>
		<!--/row-->

		<hr>

		<footer>
			<p>&copy; Android Team 2017</p>
		</footer>

	</div>
	<!--/.container-->


	<!-- Bootstrap core JavaScript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
	<script>
		window.jQuery
				|| document
						.write('<script src="../../assets/js/vendor/jquery.min.js"><\/script>')
	</script>
	<script
		src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
	<script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
	<script src="js/offcanvas.js"></script>
</body>
</html>
