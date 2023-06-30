/*
    TODO: At the end of development, write the launch date
    (
        line 100, 102, 224, 227, 298, 312, 382, 508, 566, 646, 704
    )
    TODO: Write .onion website link (line 150)
*/

USE master
GO

CREATE LOGIN SQL_Manager WITH PASSWORD='PASSWORD'
CREATE LOGIN SQL_Reader WITH PASSWORD='PASSWORD'
CREATE LOGIN SQL_Writer WITH PASSWORD='PASSWORD'
GO

USE [msdb]
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode= msdb.dbo.sp_add_job @job_name = N'ManagerTaskFast', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Data Collector', 
    @owner_login_name = N'SQL_Manager',
    @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'ComputeIndexedPagesTask', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'EXEC ComputeIndexedPagesTask
WAITFOR DELAY ''00:00:05''', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'UpdateHiddenServicesRankTask', 
    @step_id = 2, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'DECLARE @ret SMALLINT=1
WHILE @ret=1
BEGIN
  PRINT ''UpdateHiddenServicesRankTask - '' + CAST(CURRENT_TIMESTAMP AS VARCHAR)
  EXEC UpdateHiddenServicesRankTask @ret OUT
  WAITFOR DELAY ''00:00:05''
END', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'UpdatePageRankTask', 
    @step_id = 3, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'DECLARE @ret SMALLINT=1
WHILE @ret=1
BEGIN
  PRINT ''UpdatePageRankTask - '' + CAST(CURRENT_TIMESTAMP AS VARCHAR)
  EXEC UpdatePageRankTask @ret OUT  
  WAITFOR DELAY ''00:00:05''
END', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'0030 FROM 0015 TO 2345', 
    @enabled = 1, 
    @freq_type = 4, 
    @freq_interval = 1, 
    @freq_subday_type = 4, 
    @freq_subday_interval = 30, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 0, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time= /* hh:mm */, 
    @active_end_time = 235959, 
    @schedule_uid = N'94d68482-1736-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name = N'ManagerTaskLong', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Data Collector', 
    @owner_login_name = N'SQL_Manager', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'SelfPing', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0, @subsystem = N'TSQL', 
    @command = N'INSERT INTO [CrawleRequest] ([Url],[Priority],[ExpireDate]) VALUES (''http:// .onion/?ping'',1,CURRENT_TIMESTAMP+1)', 
    @database_name = N'websearcher-sql', 
    @flags = 0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'MirrorsDetectTask', 
    @step_id = 2, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'DECLARE @ret SMALLINT=1
WHILE @ret = 1
BEGIN
  PRINT ''MirrorsDetectTask - '' + CAST(CURRENT_TIMESTAMP AS VARCHAR)
  EXEC MirrorsDetectTask @ret OUT
  WAITFOR DELAY ''00:00:02''
END', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'PagesPurgeTask', 
    @step_id = 3, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'DECLARE @ret SMALLINT=1
WHILE @ret = 1
BEGIN
  PRINT ''PagesPurgeTask - '' + CAST(CURRENT_TIMESTAMP AS VARCHAR)
  EXEC PagesPurgeTask @ret OUT
  WAITFOR DELAY ''00:00:02''
END', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'CrawleRequest Purge', 
    @step_id = 4, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'DELETE FROM [CrawleRequest] WHERE [ExpireDate]<SYSDATETIME()', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'0100 FROM 0000 TO 2300', 
    @enabled = 1, 
    @freq_type = 4, 
    @freq_interval = 1, 
    @freq_subday_type = 8, 
    @freq_subday_interval = 1, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 0, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 0, 
    @active_end_time = /* hh:mm */, 
    @schedule_uid = N'2265d20c-1738-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name = N'RequestHDCrawleFast', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Data Collector', 
    @owner_login_name = N'websearcherdb\samfavstromal',
    @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'CrawleRequestEnqueue', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'DECLARE @hd AS NVARCHAR(450);
DECLARE @cursor as CURSOR;
SET @cursor = CURSOR FOR
  SELECT Url
    FROM Pages WITH (NOLOCK)
    WHERE Url=HiddenService
      AND (CrawleError IS NULL OR CrawleError=1)
      AND LastCrawle<DATEADD(HOUR, -12, SYSUTCDATETIME()) -- see time in [CheckCanCrawle]
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @hd
WHILE @@FETCH_STATUS = 0
BEGIN
  EXEC CrawleRequestEnqueue @hd, 2
  FETCH NEXT FROM @cursor INTO @hd
END
CLOSE @cursor;
DEALLOCATE @cursor;', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'every day 1 at 04:10', 
    @enabled = 1, 
    @freq_type = 8, 
    @freq_interval = 2, 
    @freq_subday_type = 1, 
    @freq_subday_interval = 0, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 1, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 41000, 
    @active_end_time = 235959, 
    @schedule_uid = N'd0147d5e-1738-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'every day 3 at 04:10', 
    @enabled = 1, 
    @freq_type = 8, 
    @freq_interval = 8, 
    @freq_subday_type = 1, 
    @freq_subday_interval = 0, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 1, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 41000, 
    @active_end_time = 235959, 
    @schedule_uid = N'fdeab252-1738-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name = N'RequestHDCrawleLong', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Data Collector', 
    @owner_login_name = N'websearcherdb\samfavstromal', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'CrawleRequestEnqueue', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'DECLARE @hd AS NVARCHAR(450);
DECLARE @cursor as CURSOR;
SET @cursor = CURSOR FOR
  SELECT HiddenService
    FROM HiddenServices WITH (NOLOCK)
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @hd
WHILE @@FETCH_STATUS = 0
BEGIN
  EXEC CrawleRequestEnqueue @hd, 2
  FETCH NEXT FROM @cursor INTO @hd
END
CLOSE @cursor;
DEALLOCATE @cursor;', 
    @database_name = N'websearcher-sql', 
    @flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'every day 5 at 04:10', 
    @enabled = 1, 
    @freq_type = 8, 
    @freq_interval = 32, 
    @freq_subday_type = 1, 
    @freq_subday_interval = 0, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 1, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 41000, 
    @active_end_time = 235959, 
    @schedule_uid = N'59b776ce-1739-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name = N'DbaOptimTask1', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Database Maintenance', 
    @owner_login_name = N'websearcherdb\samfavstromal',
    @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'BannedUrl REORGANIZE', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'ALTER INDEX ALL ON BannedUrl REORGANIZE
WAITFOR DELAY ''00:00:05''', 
    @database_name = N'websearcher-sql', 
    @flags = 0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'HiddenServices REORGANIZE', 
    @step_id = 2, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'ALTER INDEX ALL ON HiddenServices REORGANIZE
WAITFOR DELAY ''00:00:05''', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'HiddenServiceMirrors REORGANIZE', 
    @step_id = 3, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'ALTER INDEX ALL ON HiddenServiceMirrors REORGANIZE
WAITFOR DELAY ''00:00:05''', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'HiddenServiceLinks REORGANIZE', 
    @step_id = 4, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'ALTER INDEX ALL ON HiddenServiceLinks REORGANIZE
WAITFOR DELAY ''00:00:05''', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'SearchCatalog REORGANIZE', 
    @step_id = 5, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'ALTER FULLTEXT CATALOG SearchCatalog REORGANIZE', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'0400 FROM 0030 TO 2030', 
    @enabled = 1, 
    @freq_type = 4, 
    @freq_interval = 1, 
    @freq_subday_type = 8, 
    @freq_subday_interval = 4, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 0, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 3000, 
    @active_end_time = 235959, 
    @schedule_uid = N'4169c0bc-173a-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name = N'DbaOptimTask2', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Database Maintenance', 
    @owner_login_name = N'websearcherdb\samfavstromal',
    @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'Pages REORGANIZE', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'ALTER INDEX ALL ON Pages REORGANIZE', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'0400 FROM 0130 TO 2130', 
    @enabled = 1, 
    @freq_type = 4, 
    @freq_interval = 1, 
    @freq_subday_type = 8, 
    @freq_subday_interval = 4, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 0, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 13000, 
    @active_end_time = 235959, 
    @schedule_uid = N'df093550-173a-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name = N'DbaOptimTask3', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Database Maintenance', 
    @owner_login_name = N'websearcherdb\samfavstromal',
    @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'DbRowStats', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 3, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'  INSERT INTO DbRowStats VALUES (
  SYSUTCDATETIME()
  ,(SELECT COUNT(1) FROM HiddenServices WITH (NOLOCK))
  ,(SELECT COUNT(1) FROM Pages WITH (NOLOCK) WHERE CrawleError IS NULL AND HiddenService=Url)
  ,(SELECT COUNT(1) FROM Pages WITH (NOLOCK))
  ,(SELECT COUNT(1) FROM Pages WITH (NOLOCK) WHERE CrawleError IS NULL)
  ) ', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'CrawleRequest REORGANIZE', 
    @step_id = 2, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'ALTER INDEX ALL ON CrawleRequest REORGANIZE', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'0400 FROM 0230 TO 2230', 
    @enabled = 1, 
    @freq_type = 4, 
    @freq_interval = 1, 
    @freq_subday_type = 8, 
    @freq_subday_interval = 4, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 0, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 23000, 
    @active_end_time = 235959,
    @schedule_uid = N'5902df78-173b-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name = N'DbaOptimTask4', 
    @enabled = 1, 
    @notify_level_eventlog = 0, 
    @notify_level_email = 0, 
    @notify_level_netsend = 0, 
    @notify_level_page = 0, 
    @delete_level = 0, 
    @description = N'No description available.', 
    @category_name = N'Database Maintenance', 
    @owner_login_name = N'websearcherdb\samfavstromal',
    @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @jobId, @step_name = N'sp_updatestats', 
    @step_id = 1, 
    @cmdexec_success_code = 0, 
    @on_success_action = 1, 
    @on_success_step_id = 0, 
    @on_fail_action = 2, 
    @on_fail_step_id = 0, 
    @retry_attempts = 0, 
    @retry_interval = 0, 
    @os_run_priority = 0,
    @subsystem = N'TSQL', 
    @command = N'EXEC sp_updatestats', 
    @database_name = N'websearcher-sql', 
    @flags = 4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @jobId, @name = N'0400 FROM 0330 TO 2330', 
    @enabled = 1, 
    @freq_type = 4, 
    @freq_interval = 1, 
    @freq_subday_type = 8, 
    @freq_subday_interval = 4, 
    @freq_relative_interval = 0, 
    @freq_recurrence_factor = 0, 
    @active_start_date = /* YearMonthDay */, 
    @active_end_date = 99991231, 
    @active_start_time = 33000, 
    @active_end_time = 235959, 
    @schedule_uid = N'e82ef074-173b-11ee-be56-0242ac120002'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/* Tools */

-- Trailling ? cleanup
update p SET URL=SUBSTRING(URL, 0, len(URL)) from pages p where HiddenService<>url and url like '?/' and not exists (SELECT 1 FROM Pages s WHERE s.URL=SUBSTRING(p.URL,0,len(p.URL)))
DELETE from pages where HiddenService<>url and url like '?/'

-- Trailling slash cleanup
update p SET URL=SUBSTRING(URL, 0, len(URL)) from pages p where HiddenService<>url and url like '%/' and not exists (SELECT 1 FROM Pages s WHERE s.URL=SUBSTRING(p.URL,0,len(p.URL)))
DELETE from pages where HiddenService<>url and url like '%/'

-- Stats
select p.Title, s.* FROM (
SELECT HiddenService, count(1) pages, min(url) minUrl, max(url) maxUrl, min(CrawleError) minCrawleError, max(CrawleError) maxCrawleError, min(FirstCrawle) FirstCrawle, max(LastCrawle) LastCrawle from Pages WITH (NOLOCK) group by HiddenService having count(1)>2
)s INNER JOIN Pages p WITH (NOLOCK) ON s.HiddenService=p.Url ORDER BY 1 desc

-- hd up
SELECT COUNT(1) FROM Pages p WITH (NOLOCK)
WHERE p.HiddenService=p.Url AND p.CrawleError IS NULL

FROM (
SELECT HiddenService, count(1) pages, min(url) minUrl, max(url) maxUrl, min(CrawleError) minCrawleError, max(CrawleError) maxCrawleError, min(FirstCrawle) FirstCrawle, max(LastCrawle) LastCrawle from Pages WITH (NOLOCK) group by HiddenService having count(1)>2
)s INNER JOIN  ON s.HiddenService=p.Url ORDER BY 1 desc

EXEC sp_spaceused N'Pages'
EXEC sp_spaceused N'HiddenServices'


SELECT Query, COUNT(DISTINCT HiddenService) As HiddenServiceCount, COUNT(1) AS UrlCount, MIN(Url) AS MinUrl, MAX(Url) AS MaxUrl FROM (
  SELECT HiddenService, Url ,SUBSTRING(Url, CHARINDEX('?',Url,30), CHARINDEX('=',Url,CHARINDEX('?',Url,30))-CHARINDEX('?',Url,30)+1) as Query FROM Pages WITH (NOLOCK) WHERE Url LIKE '%?%=%'-- AND Url NOT LIKE '%?'
  ) s GROUP BY Query ORDER BY 2 DESC

SELECT t.Title,SUBSTRING(p.InnerText,0,128) InnerText,  p.Url, p.CrawleError
    ,(SELECT COUNT(1) FROM HiddenServiceLinks WHERE HiddenServiceTarget=p.url) HasHiddenServiceTarget
    ,m1.HiddenServiceMain as AlreadyMirrorOf
    ,(SELECT TOP 1 HiddenServiceMain FROM HiddenServiceMirrors m2 WHERE p.Url=m2.HiddenServiceMain) AlreadyMirrorMain
  FROM (SELECT Title, COUNT(1) NbHiddenServices FROM Pages WITH (NOLOCK) WHERE Url=HiddenService GROUP BY Title HAVING COUNT(1)>1) t
    INNER JOIN Pages p WITH (NOLOCK) ON t.Title=p.Title
    LEFT JOIN HiddenServiceMirrors m1 ON p.Url=m1.HiddenService
  WHERE p.Url=p.HiddenService
  ORDER BY t.Title ASC, InnerText ASC, AlreadyMirrorMain DESC, HasHiddenServiceTarget DESC


-- improve MAIN mirror
SELECT p.Url, h.[IndexedPages],h.[Rank], p.[Rank], p.crawleError, p.lastcrawle, p.title, p.heading
  ,(SELECT COUNT(1) FROM [HiddenServiceMirrors] WHERE [HiddenServiceMain]=p.Url) HasMirror
  FROM Pages p WITH (NOLOCK)
  INNER JOIN HiddenServices h WITH (NOLOCK) ON h.HiddenService=p.Url
  WHERE Url IN (SELECT distinct HiddenServiceMain FROM HiddenServiceMirrors WITH (NOLOCK))
  ORDER BY Title, h.[Rank] DESC

SELECT HiddenService FROM HiddenServices ORDER BY IndexedPages DESC
SELECT * FROM PAges WHERE Url LIKE '...' ORDER BY Url ASC

-- search new popular useless stopwords
select TOP 1000 display_term, SUM(document_count) document_count from sys.dm_fts_index_keywords (DB_ID('websearcher-sql'), OBJECT_ID('Pages') ) GROUP BY display_term order by SUM(document_count) desc

-- TO optim before  use : page double detect
  DELETE FROM Pages WHERE Url IN (
    SELECT CASE WHEN LEN(a)<LEN(b) THEN b WHEN LEN(a)>LEN(b) THEN a  WHEN a>b THEN a ELSE b END urlToDelete
    FROM (
      SELECT MIN(Url) a, Max(Url) b
      FROM Pages
      WHERE HiddenService = (SELECT TOP 1 HiddenService FROM HiddenServices ORDER BY IndexedPages DESC)
      GROUP BY HiddenService, InnerText
      HAVING COUNT(1)>1
    ) s
  )

  -- Normalizing old Url loop
SELECT top(1000) URL, substring(url, 0, CHARINDEX('?',url,37)) + REPLACE(REPLACE(substring(url, CHARINDEX('?',url,37),450),'/','%2'),' ','+') as url2 INTO #tmp FROM PAGES WITH (NOLOCK) WHERE URL LIKE '%?%/%'
DELETE FROM Pages WHERE url in (SELECT url FROM #tmp WHERE EXISTS (SELECT 1 FROM Pages WITH (NOLOCK) WHERE url2=Pages.url))
DELETE FROM #tmp WHERE EXISTS (SELECT 1 FROM Pages WITH (NOLOCK) WHERE url2=Pages.url)
UPDATE p SET p.Url=t.url2 FROM Pages p INNER JOIN #tmp t on p.Url=t.Url
DROP TABLE #tmp
GO
