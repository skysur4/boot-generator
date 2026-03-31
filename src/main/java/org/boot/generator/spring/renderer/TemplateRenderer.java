package org.boot.generator.spring.renderer;

import freemarker.template.Configuration;
import freemarker.template.Template;
import org.springframework.stereotype.Component;

import java.io.StringWriter;
import java.util.Map;

@Component
public class TemplateRenderer {

    private final Configuration cfg;

    public TemplateRenderer() {
        cfg = new Configuration(Configuration.VERSION_2_3_34);
        cfg.setClassLoaderForTemplateLoading(
                getClass().getClassLoader(), "templates");
        cfg.setDefaultEncoding("UTF-8");
    }

    public String render(String templateName, Map<String, Object> model) {
        try (StringWriter writer = new StringWriter()) {
            Template template = cfg.getTemplate(templateName);
            template.process(model, writer);
            return writer.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}