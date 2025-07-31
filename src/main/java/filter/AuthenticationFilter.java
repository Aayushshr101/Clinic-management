package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import util.SessionUtil;

@WebFilter(urlPatterns = "/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Optional: Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        // Allow static files and public pages
        if (
            uri.contains("/view/login.jsp") ||
            uri.contains("/view/register.jsp") ||
            uri.contains("/view/doctorSetPassword.jsp") ||              
            uri.endsWith("/setDoctorPassword") ||  
            uri.contains("/view/index.jsp") ||
            uri.endsWith(".css") || uri.endsWith(".js") ||
            uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".jpeg") ||
            uri.endsWith("/") || uri.endsWith("/home") ||
            uri.endsWith("/login") || uri.endsWith("/register")
        ) {
            chain.doFilter(request, response);
            return;
        }

        // Block access if not logged in
        boolean isLoggedIn = SessionUtil.getAttribute(req, "user") != null;

        if (!isLoggedIn) {
            res.sendRedirect(req.getContextPath() + "/view/login.jsp");
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Optional: Cleanup if needed
    }
}
