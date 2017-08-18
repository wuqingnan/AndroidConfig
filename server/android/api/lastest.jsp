<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.reflect.Type"%>
<%@ page import="com.google.gson.*"%>
<%@ page import="com.google.gson.reflect.TypeToken"%>

<%
	String json = "{\"version\":\"200030000\", \"feature\":\"1、修改部分API\",\"filepath\":\"files/down.apk\"}";
	out.println(json);
%>
