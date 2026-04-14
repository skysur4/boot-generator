package ${package};

import java.time.ZoneId;
import java.util.Locale;

public interface AppConstants {
    String ROLE_PREFIX = "ROLE_";
    String REALM_ROLES_KEY = "realm_roles";

    String AUTHORIZATION_HEADER = "Authorization";
    String BEARER_PREFIX = "Bearer ";
    String DEFAULT_PRINCIPAL_NAME = "SYSTEM";

    String USER_INFO = "userInfo";
    String X_AUTHORITY_HEADER = "x-authority";

    String DELIMITER_PATH = "/";
    String DELIMITER_PIPE = "|";
    String DELIMITER_DOUBLE_PIPE = "||";
    String DELIMITER_SHARP = "#";


    int DEFAULT_PAGE_NUMBER = 1;
    int DEFAULT_PAGE_SIZE = 0;

	/** Default locale relates */
    String   DEF_DATE_FORMAT   = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    ZoneId   DEF_TIMEZONE      = ZoneId.of("Asia/Seoul");
    Locale   DEF_LOCALE      = Locale.KOREA;
    String[] SUPPORT_LANGUAGES = new String[] { Locale.KOREA.toLanguageTag(), Locale.US.toLanguageTag() };

    String API_VERSION_V1 = "v1";
    String API_VERSION_V2 = "v2";
    String API_VERSION_V1_PATH = DELIMITER_PATH + API_VERSION_V1;
    String API_VERSION_V2_PATH = DELIMITER_PATH + API_VERSION_V2;

    String DEFAULT_RESPONSE_OK = "succeed";
    String DEFAULT_RESPONSE_ERROR = "failed";
}