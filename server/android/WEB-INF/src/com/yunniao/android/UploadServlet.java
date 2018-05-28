package com.yunniao.android;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class UploadServlet
 */
@WebServlet("/UploadServlet")
public class UploadServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	// 上传文件存储目录
	private static final String DEFAULT_DIRECTORY = "files";

	// 上传配置
	private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 400; // 40MB
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 450; // 50MB

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UploadServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Do nothing!
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 检测是否为多媒体上传
		if (!ServletFileUpload.isMultipartContent(request)) {
			// 如果不是则停止
			setResult(response, "Error: 表单必须包含 enctype=multipart/form-data");
			return;
		}

		String path = request.getParameter("path");
		if (path == null || path.trim().equals("")) {
			path = DEFAULT_DIRECTORY;
		}

		// 配置上传参数
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// 设置内存临界值 - 超过后将产生临时文件并存储于临时目录中
		factory.setSizeThreshold(MEMORY_THRESHOLD);
		// 设置临时存储目录
		factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

		ServletFileUpload upload = new ServletFileUpload(factory);

		// 设置最大文件上传值
		upload.setFileSizeMax(MAX_FILE_SIZE);

		// 设置最大请求值 (包含文件和表单数据)
		upload.setSizeMax(MAX_REQUEST_SIZE);

		// 中文处理
		upload.setHeaderEncoding("UTF-8");

		// 构造临时路径来存储上传的文件
		// 这个路径相对当前应用的目录
		String uploadPath = getServletContext().getRealPath("/") + File.separator + path;

		// 如果目录不存在则创建
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) {
			uploadDir.mkdir();
		}

		try {
			Map<String, List<FileItem>> map = upload.parseParameterMap(request);
			for (Map.Entry<String, List<FileItem>> entry : map.entrySet()) {
				List<FileItem> formItems = entry.getValue();
				if (formItems != null && formItems.size() > 0) {
					// 迭代表单数据
					for (FileItem item : formItems) {
						// 处理不在表单中的字段
						if (!item.isFormField()) {
							String fileName = new File(item.getName()).getName();
							String filePath = uploadPath + File.separator + fileName;
							File storeFile = new File(filePath);
							// 在控制台输出文件的上传路径
							System.out.println(filePath);
							// 保存文件到硬盘
							item.write(storeFile);
							request.setAttribute("message", "文件上传成功!");
						}
					}
				}
			}
		} catch (Exception ex) {
			setResult(response, "文件上传失败: " + ex.getMessage());
		}
		setResult(response, "文件上传成功！");
	}

	private void setResult(HttpServletResponse response, String msg) {
		try {
			response.setHeader("Content-type", "text/html; charset=UTF-8");
			response.setCharacterEncoding("UTF-8");
			PrintWriter writer = response.getWriter();
			writer.println(msg);
			writer.flush();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
