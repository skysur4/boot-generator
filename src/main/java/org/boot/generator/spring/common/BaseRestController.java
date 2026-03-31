package org.boot.generator.spring.common;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/api")
public class BaseRestController {
	@Autowired
	protected HttpServletRequest httpRequest;

	@Autowired
	protected HttpServletResponse httpResponse;
}