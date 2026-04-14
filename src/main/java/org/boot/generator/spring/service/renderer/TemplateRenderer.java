package org.boot.generator.spring.service.renderer;

import freemarker.template.Configuration;
import freemarker.template.Template;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.StringWriter;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Map;

@Component
public class TemplateRenderer {
    private final static String PATH_DELIMITER = "/";
    private final static String TEMPLATE_PATH = "templates";
    private final Configuration cfg;

    public TemplateRenderer() {
        cfg = new Configuration(Configuration.VERSION_2_3_34);
        cfg.setClassLoaderForTemplateLoading(getClass().getClassLoader(), TEMPLATE_PATH);
        cfg.setDefaultEncoding("UTF-8");
    }

    public String render(String architecture, String templateName, Map<String, Object> model) {
        try (StringWriter writer = new StringWriter()) {
            Template template = cfg.getTemplate(PATH_DELIMITER + architecture + PATH_DELIMITER + templateName);
            template.process(model, writer);
            return writer.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public File[] loadRawFilesFrom(String folder) throws URISyntaxException {
        URL resource = getClass().getClassLoader().getResource(folder);
        if (resource != null) {
            // Converts URL to URI then to File (works if on local disk)
            return new File(resource.toURI()).listFiles();
        }

        return null;
    }
}