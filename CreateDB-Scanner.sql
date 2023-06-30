CREATE OR ALTER PROCEDURE CheckCanScan(@Url NVARCHAR(450), @ret TINYINT OUTPUT) AS 
BEGIN
    SET NOCOUNT ON
  DECLARE @MaxPagesPerHiddenService INT=10000 -- go to 9000 after a purge per 1000
  DECLARE @MaxRefreshPage INT=72
  DECLARE @MaxRefreshRoot INT=12
  DECLARE @HiddenService NVARCHAR(37)
  SELECT @HiddenService=SUBSTRING(@Url,0,CHARINDEX ('/', @Url,30)+1)
  
  IF NOT EXISTS (SELECT 1 FROM HiddenServices WITH (NOLOCK) WHERE HiddenService=@HiddenService AND @MaxPagesPerHiddenService<IndexedPages) -- strict > because purge is >=
  BEGIN

    DECLARE @lastScan DATETIMEOFFSET
    SELECT @lastScan=LastScan FROM Pages WITH (NOLOCK) WHERE Url=@Url  
    IF @@ROWCOUNT=1
    BEGIN
      IF (@Url<>@HiddenService)
        SET @ret=CASE WHEN DATEADD(hh, @MaxRefreshPage, @lastScan)<SYSUTCDATETIME() THEN 1 ELSE 0 END
      ELSE
        SET @ret=CASE WHEN DATEADD(hh, @MaxRefreshRoot, @lastScan)<SYSUTCDATETIME() THEN 1 ELSE 0 END
    END
    ELSE
    BEGIN
      SET @ret=1
      SELECT @ret=0
        WHERE EXISTS (SELECT 1 FROM BannedUrl WHERE @Url LIKE UrlLike)
    END

    -- if still seems OK, is it a mirror know (remove only sub pages) ?
    IF @ret=1 AND @Url<>@HiddenService
      AND EXISTS (SELECT 1 FROM HiddenServiceMirrors WHERE HiddenService=@HiddenService)
        SET @ret=0
  END
  ELSE
    SET @ret=0
END
GO


CREATE OR ALTER PROCEDURE ScanRequestEnqueue(@Url NVARCHAR(450), @prio TINYINT) AS 
BEGIN
    SET NOCOUNT ON

  DECLARE @canScan SMALLINT
  EXEC CheckCanScan @Url, @canScan OUTPUT
  IF @canScan=1
  BEGIN
    BEGIN TRY 
      INSERT INTO ScanRequest VALUES (@Url, @prio, DATEADD(DAY,
        CASE @prio WHEN 1 THEN 31 WHEN 2 THEN 14 WHEN 3 THEN 7 WHEN 4 THEN 3 WHEN 5 THEN 1 ELSE 0.5 END 
        , SYSUTCDATETIME()))
    END TRY
    BEGIN CATCH -- unicity check by PK
      SET @canScan = 0 -- dummy
    END CATCH
  END
END
GO
GRANT EXECUTE ON ScanRequestEnqueue TO SQL_Writer
GRANT EXECUTE ON ScanRequestEnqueue TO SQL_Reader
GO


CREATE OR ALTER PROCEDURE FixUri(@OldUrl NVARCHAR(450), @NewUrl NVARCHAR(450)) AS 
BEGIN
    SET NOCOUNT ON

  BEGIN TRY 
    UPDATE Pages SET Url = @NewUrl WHERE Url = @OldUrl
  END TRY
  BEGIN CATCH -- unicity check by PK
    DELETE Pages WHERE Url = @OldUrl
  END CATCH
END
GO
GRANT EXECUTE ON FixUri TO SQL_Writer
GO


CREATE OR ALTER PROCEDURE ScanRequestMassEnqueue(@Urls NVARCHAR(MAX), @prio TINYINT) AS 
BEGIN
    SET NOCOUNT ON
  DECLARE @Url NVARCHAR(450)
  DECLARE db_cursor CURSOR FOR 
    SELECT value FROM STRING_SPLIT(@Urls, CHAR(13)) -- \r
  OPEN db_cursor  
  FETCH NEXT FROM db_cursor INTO @Url  

  WHILE @@FETCH_STATUS = 0  
  BEGIN  
    EXEC ScanRequestEnqueue @Url, @prio
    FETCH NEXT FROM db_cursor INTO @Url  
  END  

  CLOSE db_cursor  
  DEALLOCATE db_cursor 
END
GO
GRANT EXECUTE ON ScanRequestMassEnqueue TO SQL_Writer
GO

CREATE OR ALTER PROCEDURE ScanRequestDequeue AS 
BEGIN
    SET NOCOUNT ON;

  -- no CheckCanScan : the Url have been checked on insert and is unique in queue
  WITH t AS (SELECT TOP(1) Url FROM ScanRequest WITH (ROWLOCK, READPAST) ORDER BY Priority, ExpireDate)
    DELETE FROM t
    OUTPUT deleted.Url;

END
GO
GRANT EXECUTE ON ScanRequestDequeue TO SQL_Writer
GO
