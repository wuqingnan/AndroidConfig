<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>

<%
	try {
		File file = new File(request.getRealPath("") + File.separator + "config.json");
		BufferedReader reader = new BufferedReader(new FileReader(file));
		StringBuilder builder = new StringBuilder();
		String line = null;
		while ((line = reader.readLine()) != null) {
			builder.append(line);
		}
		reader.close();
		reader = null;
		
		out.println(builder.toString());
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
