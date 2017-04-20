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
%>

<%
	String clientId = request.getParameter("client");
	if (clientId == null) {
		clientId = "S";
	}
	
	Map<String, String> map = getClients(request);
	if (map.containsKey(clientId)) {
		out.println("build/" + map.get(clientId));
	} else {
		String json = "{}";
		if (clientId.equals("ALL")) {
			StringBuilder builder = new StringBuilder("{\"list\":[");
			Set<String> keySet = map.keySet();
			if (keySet != null) {
				for (String key : keySet) {
					builder.append("{\"id\":\"" + key + "\"},");
				}
				if (keySet.size() > 0) {
					builder.deleteCharAt(builder.length() - 1);
				}
			}
			builder.append("]}");
			json = builder.toString();
		} else if (clientId.equals("UP")) {
			json = "{\"version\":200020000,\"msg\":\"1.切换服务器到143\",\"filename\":\"build/down.apk\",\"hasPatch\":0,\"patchName\":\"samplePatch.apatch\"}";
		}
		out.println(json);
	}
%>
