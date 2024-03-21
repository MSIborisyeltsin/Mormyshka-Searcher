import java.util.concurrent.CancellationException;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

public class CommonRole implements AutoCloseable {

    private final AtomicBoolean runCompleted = new AtomicBoolean(false);
    private final ExecutorService executorService = Executors.newSingleThreadExecutor();

    @Override
    public void close() {
        System.out.println("CommonRole is stopping");

        executorService.shutdownNow();

        while (!runCompleted.get()) {
            try {
                TimeUnit.SECONDS.sleep(30);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public void run() {
        System.out.println("CommonRole is running");

        CompletableFuture<Void> future = CompletableFuture.runAsync(this::runAsync, executorService);
        try {
            future.get();
        } catch (Exception e) {
            if (e.getCause() instanceof CancellationException) {
                System.out.println("CommonRole.run OperationCanceled");
            } else {
                System.err.println("CommonRole.run Exception : " + e.getCause().toString());
            }
        }
        runCompleted.set(true);
    }

    protected void runAsync() {
        try {
            Thread.sleep(100);
            throw new UnsupportedOperationException();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    public static void main(String[] args) {
        try (CommonRole commonRole = new CommonRole()) {
            commonRole.run();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
