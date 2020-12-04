package com.yue.interceptor.admin;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class LoginInterceptor implements HandlerInterceptor {
	
	@Override
	public void afterCompletion(HttpServletRequest arg0,
			HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1,
			Object arg2, ModelAndView arg3) throws Exception {
		// TODO Auto-generated method stub

	}
	
	/*
	 *  before request, do intercept
	 *  return value: true is access accept and false is access denied
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response,Object object) throws Exception {
		String requestURI = request.getRequestURI();
		Object admin = request.getSession().getAttribute("admin");
		// if not login (no "admin" in session)
		if(admin == null){
			System.out.println("Login Interceptor: user not logged in");
			System.out.println("when access： " + requestURI);
			//if request is ajax, return json of error
			String header = request.getHeader("X-Requested-With");
			if("XMLHttpRequest".equals(header)){
				Map<String, String> ret = new HashMap<String, String>();
				ret.put("type", "error");
				ret.put("msg", "登录会话超时或还未登录，请重新登录!");
				response.getWriter().write(JSONObject.fromObject(ret).toString());
				return false;
			}
			// if request is not ajax, redirect to login page
			response.sendRedirect(request.getServletContext().getContextPath() + "/system/login");
			return false;
		}
		/*//获取菜单id
		String mid = request.getParameter("_mid");
		if(!StringUtils.isEmpty(mid)){
			List<Menu> allThirdMenu = MenuUtil.getAllThirdMenu((List<Menu>)request.getSession().getAttribute("userMenus"), Long.valueOf(mid));
			request.setAttribute("thirdMenuList", allThirdMenu);
		}*/		
		return true;
	}

}
