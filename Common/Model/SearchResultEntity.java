import java.util.List;

public class SearchResultEntity
{
    private int resultsTotalNb;
    private List<PageResultEntity> results;

    public SearchResultEntity() { }

    public int getResultsTotalNb() {
        return resultsTotalNb;
    }

    public void setResultsTotalNb(int resultsTotalNb) {
        this.resultsTotalNb = resultsTotalNb;
    }

    public List<PageResultEntity> getResults() {
        return results;
    }

    public void setResults(List<PageResultEntity> results) {
        this.results = results;
    }
}
