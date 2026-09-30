package com.mind_your.mind.config;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CustomCorsFilter extends OncePerRequestFilter {

    /** http://localhost:<porta> ou http://127.0.0.1:<porta> */
    private static final java.util.regex.Pattern ORIGEM_LOCAL =
            java.util.regex.Pattern.compile("^http://(localhost|127\\.0\\.0\\.1)(:\\d+)?$");

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String origin = request.getHeader("Origin");

        // Aceita qualquer porta local: o site usa 3000/5173 e o app Flutter Web
        // em desenvolvimento sobe numa porta aleatória.
        if (origin != null && ORIGEM_LOCAL.matcher(origin).matches()) {
            response.setHeader("Access-Control-Allow-Origin", origin);
        } else {
            // Fallback para garantir que o localhost:3000 seja sempre aceito
            response.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        }

        response.setHeader("Vary", "Origin");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "authorization, content-type, accept, xsrf-token");
        response.setHeader("Access-Control-Expose-Headers", "xsrf-token");
        response.setHeader("Access-Control-Allow-Credentials", "true");

        if ("OPTIONS".equals(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            filterChain.doFilter(request, response);
        }
    }
}
