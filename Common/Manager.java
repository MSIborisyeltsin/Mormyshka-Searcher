import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class UriManager {
    private static String[] bannedUrlQuerys = null;

    public static void normalizeUrlInit(SqlManager sql) {
        if (bannedUrlQuerys == null) {
            try {
                bannedUrlQuerys = sql.getBannedUrlQuerys();
            } catch (SqlException ex) {
                System.out.println("UriManager.normalizeUrlInit SqlException : " + ex.getMessage());
                bannedUrlQuerys = new String[0];   // non fatal, may continue to work
            }
        }
    }

    public static String normalizeUrl(Uri absoluteUri) {
        if (absoluteUri == null) {
            throw new IllegalArgumentException("absoluteHref cannot be null");
        }

        for (int i = 0; i < bannedUrlQuerys.length; i++) {
            if (absoluteUri.getQuery().contains(bannedUrlQuerys[i] + "=")) {
                boolean hasReallyOneQueryMatch = false;
                Map<String, String> q = parseQueryString(absoluteUri.getQuery());
                for (int j = i; j < bannedUrlQuerys.length; j++) {
                    if (q.containsKey(bannedUrlQuerys[j])) {
                        hasReallyOneQueryMatch = true;
                        q.remove(bannedUrlQuerys[j]);
                    }
                }
                if (hasReallyOneQueryMatch) {
                    String query = buildQueryString(q);
                    UriBuilder ub = new UriBuilder(absoluteUri);
                    ub.setQuery(Uri.escapeUriString(HttpUtility.urlDecode(query)));
                    absoluteUri = ub.build(); // will normalize like other URLs
                }
                break;
            }
        }

        String absoluteHref = absoluteUri.toString()
                .replace("&amp;", "&")
                .replace("&shy;", "")
                .replace("&#173;", "")
                .replace("</form>", "");

        int iPos = absoluteHref.indexOf('#');
        if (iPos > 0) {
            absoluteHref = absoluteHref.substring(0, iPos - 1); // remove # in URLs
        }

        while (absoluteHref.endsWith("?")) {
            absoluteHref = absoluteHref.substring(0, absoluteHref.length() - 1);
        }

        if (absoluteHref.indexOf('/', 8) > 0) {
            while (absoluteHref.endsWith("/") && absoluteHref.indexOf('/', 8) < (absoluteHref.length() - 1)) {
                absoluteHref = absoluteHref.substring(0, absoluteHref.length() - 1);
            }
        } else {
            absoluteHref += "/";
        }

        return absoluteHref;
    }

    public static String getHiddenService(String url) {
        int i = url.indexOf('/', 29);
        if (i > 0) {
            return url.substring(0, i + 1);
        } else {
            return url;
        }
    }

    public static boolean isHiddenService(String url) {
        int i = url.indexOf('/', 29);
        if (i > 0) {
            return (i + 1) == url.length();
        } else {
            return true;
        }
    }

    public static boolean isTorUri(Uri uri) {
        return uri != null
                && (uri.getScheme().equals("http") || uri.getScheme().equals("https"))
                && uri.getDnsSafeHost().endsWith(".onion") && uri.getDnsSafeHost().length() == 22;
    }

    private static Map<String, String> parseQueryString(String queryString) {
        Map<String, String> queryMap = new HashMap<>();
        Pattern pattern = Pattern.compile("([^&=]+)=([^&]*)");
        Matcher matcher = pattern.matcher(queryString);
        while (matcher.find()) {
            queryMap.put(matcher.group(1), matcher.group(2));
        }
        return queryMap;
    }

    private static String buildQueryString(Map<String, String> queryMap) {
        StringBuilder queryString = new StringBuilder();
        for (Map.Entry<String, String> entry : queryMap.entrySet()) {
            queryString.append(entry.getKey()).append("=").append(entry.getValue()).append("&");
        }
        if (queryString.length() > 0) {
            queryString.setLength(queryString.length() - 1); // remove last '&'
        }
        return queryString.toString();
    }
}
