package WebSearcher_Common;

import java.util.HashSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PageEntity
{
    private static final Pattern patternWhiteSpace = Pattern.compile("\\s{2,}");

    private String hiddenService;
    private String url;
    private String title;
    private String innerText;
    private String heading;

    private HashSet<String> innerLinks;
    private HashSet<String> outerLinks;
    private HashSet<String> outerHdLinks;
    
    private DateTime lastCrawle;
    
    public PageEntity(Uri uri) {
        url = UriManager.normalizeUrl(uri);
        hiddenService = UriManager.getHiddenService(url);
        lastCrawle = DateTime.UtcNow;
    }

    public String getHiddenService() { 
        return hiddenService; 
    }
    
    public void setHiddenService(String hiddenService) { 
        this.hiddenService = hiddenService; 
    }
    
    public String getUrl() { 
        return url; 
    }
    
    public void setUrl(String url) { 
        this.url = url; 
    }
    
    public String getTitle() { 
        return title; 
    }
    
    public void setTitle(String title) { 
        this.title = title; 
    }
    
    public String getInnerText() { 
        return innerText; 
    }
    
    public void setInnerText(String innerText) { 
        this.innerText = innerText; 
    }
    
    public String getHeading() { 
        return heading; 
    }
    
    public void setHeading(String heading) { 
        this.heading = heading; 
    }
    
    public HashSet<String> getInnerLinks() { 
        return innerLinks; 
    }
    
    public void setInnerLinks(HashSet<String> innerLinks) { 
        this.innerLinks = innerLinks; 
    }
    
    public HashSet<String> getOuterLinks() { 
        return outerLinks; 
    }
    
    public void setOuterLinks(HashSet<String> outerLinks) { 
        this.outerLinks = outerLinks; 
    }
    
    public HashSet<String> getOuterHdLinks() { 
        return outerHdLinks; 
    }
    
    public void setOuterHdLinks(HashSet<String> outerHdLinks) { 
        this.outerHdLinks = outerHdLinks; 
    }
    
    public DateTime getLastCrawle() { 
        return lastCrawle; 
    }
    
    public void setLastCrawle(DateTime lastCrawle) { 
        this.lastCrawle = lastCrawle; 
    }

    @Override
    public String toString() { 
        return url; 
    }
    
    public static String normalizeText(String innerText) {
        if (innerText == null || innerText.isEmpty()) {
            throw new IllegalArgumentException("innerText cannot be null or empty");
        }
        return patternWhiteSpace.matcher(innerText.replace("</form>", "")).replaceAll(" ").trim();
    }
}
