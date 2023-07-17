package WebSearcherCommon;

public class PageResultEntity
{
    private String urlClick;
    private String url;
    private String urlToolTip;
    private String title;
    private String titleToolTip;
    private String innerText;
    private boolean crawlError;
    private int daySinceLastCrawl;
    private int hourSinceLastCrawl;
    private String hiddenServiceMain;
    private String hiddenServiceMainClick;

    public PageResultEntity()

    public String getUrlClick() {
        return urlClick;
    }

    public void setUrlClick(String urlClick) {
        this.urlClick = urlClick;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getUrlToolTip() {
        return urlToolTip;
    }

    public void setUrlToolTip(String urlToolTip) {
        this.urlToolTip = urlToolTip;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitleToolTip() {
        return titleToolTip;
    }

    public void setTitleToolTip(String titleToolTip) {
        this.titleToolTip = titleToolTip;
    }

    public String getInnerText() {
        return innerText;
    }

    public void setInnerText(String innerText) {
        this.innerText = innerText;
    }

    public boolean isCrawlError() {
        return crawlError;
    }

    public void setCrawlError(boolean crawlError) {
        this.crawlError = crawlError;
    }

    public int getDaySinceLastCrawl() {
        return daySinceLastCrawl;
    }

    public void setDaySinceLastCrawl(int daySinceLastCrawl) {
        this.daySinceLastCrawl = daySinceLastCrawl;
    }

    public int getHourSinceLastCrawl() {
        return hourSinceLastCrawl;
    }

    public void setHourSinceLastCrawl(int hourSinceLastCrawl) {
        this.hourSinceLastCrawl = hourSinceLastCrawl;
    }

    public String getHiddenServiceMain() {
        return hiddenServiceMain;
    }

    public void setHiddenServiceMain(String hiddenServiceMain) {
        this.hiddenServiceMain = hiddenServiceMain;
    }

    public String getHiddenServiceMainClick() {
        return hiddenServiceMainClick;
    }

    public void setHiddenServiceMainClick(String hiddenServiceMainClick) {
        this.hiddenServiceMainClick = hiddenServiceMainClick;
    }

    @Override
    public String toString() {
        return url;
    }
}
