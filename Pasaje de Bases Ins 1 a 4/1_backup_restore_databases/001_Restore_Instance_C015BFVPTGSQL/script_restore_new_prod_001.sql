USE master
GO

BEGIN TRY
	DROP PROCEDURE new_infra_restore_databases
END TRY BEGIN CATCH END CATCH

GO

CREATE PROCEDURE new_infra_restore_databases
	@PathBackup VARCHAR(MAX),
	@DatabaseName VARCHAR(MAX)
AS

DECLARE 
	@SQLString VARCHAR(MAX),
	@LogicalNameData VARCHAR(MAX),
	@LogicalNameLog VARCHAR(MAX),
	@Disk VARCHAR(MAX),
	@DiskToLogicalData VARCHAR(MAX),
	@DiskToLogicalLog VARCHAR(MAX);
	

-- BEGIN EXECUTE RESTORE DATABASE
BEGIN TRY
	DROP TABLE #FileListHeaders
END TRY BEGIN CATCH END CATCH
	
CREATE TABLE #FileListHeaders (     
		LogicalName    nvarchar(128)
	,PhysicalName   nvarchar(260)
	,[Type] char(1)
	,FileGroupName  nvarchar(128) NULL
	,Size   numeric(20,0)
	,MaxSize    numeric(20,0)
	,FileID bigint
	,CreateLSN  numeric(25,0)
	,DropLSN    numeric(25,0) NULL
	,UniqueID   uniqueidentifier
	,ReadOnlyLSN    numeric(25,0) NULL
	,ReadWriteLSN   numeric(25,0) NULL
	,BackupSizeInBytes  bigint
	,SourceBlockSize    int
	,FileGroupID    int
	,LogGroupGUID   uniqueidentifier NULL
	,DifferentialBaseLSN    numeric(25,0) NULL
	,DifferentialBaseGUID   uniqueidentifier NULL
	,IsReadOnly bit
	,IsPresent  bit
)
IF cast(cast(SERVERPROPERTY('ProductVersion') as char(4)) as float) > 9 -- Greater than SQL 2005 
BEGIN
	ALTER TABLE #FileListHeaders ADD TDEThumbprint  varbinary(32) NULL
END
IF cast(cast(SERVERPROPERTY('ProductVersion') as char(2)) as float) > 12 -- Greater than 2014
BEGIN
	ALTER TABLE #FileListHeaders ADD SnapshotURL    nvarchar(360) NULL
END
		
INSERT INTO #FileListHeaders
EXEC ('RESTORE FILELISTONLY FROM DISK = N''' + @PathBackup + @DatabaseName + N'.bak''')
	
SET @LogicalNameData = (SELECT LogicalName FROM #FileListHeaders WHERE Type='D')
SET @LogicalNameLog  = (SELECT LogicalName FROM #FileListHeaders WHERE Type='L')

SELECT
		@DiskToLogicalData = CAST(SERVERPROPERTY('instancedefaultdatapath') AS VARCHAR(MAX)) + @DatabaseName + '.mdf',
		@DiskToLogicalLog = CAST(SERVERPROPERTY('instancedefaultlogpath') AS VARCHAR(MAX)) + @DatabaseName + '_log.ldf'
	
SET @Disk = @PathBackup + @DatabaseName + N'.bak'

RESTORE DATABASE @DatabaseName
FROM  DISK = @Disk
	WITH REPLACE,  
	MOVE @LogicalNameData
	TO @DiskToLogicalData,  
	MOVE @LogicalNameLog
	TO @DiskToLogicalLog
