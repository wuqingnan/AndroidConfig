<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文件上传</title>
<script type="text/javascript">
	function validateFile() {
		var value = document.getElementById("uploadFile").value;
		if (value) {
			var action = "/UploadServlet";
			if (location.search) {
				action += location.search;
			}
			document.form1.action = action;
			return true;
		}
		alert("请选择一个文件！");
		return false
	}
</script>
</head>
<body style="padding: 15px">
	<h1>文件上传</h1>
	<form name="form1" enctype="multipart/form-data" method="post">
		选择文件: <input type="file" id="uploadFile" name="uploadFile" /> 
		<br />
		<input type="submit" value="上传" onclick="return validateFile()" />
	</form>
</body>
</html>