USE master
GO

BEGIN TRY
	DROP PROCEDURE new_infra_backup_databases
END TRY BEGIN CATCH END CATCH

GO

CREATE PROCEDURE new_infra_backup_databases
	@PathBackup VARCHAR(MAX),
	@DatabaseName VARCHAR(MAX)
AS

DECLARE 
	@SQLString VARCHAR(MAX);

-- EXECUTE BACKUP DATABASE
SET @SQLString = N'BACKUP DATABASE ' + @DatabaseName + N' TO DISK =''' + @PathBackup + @DatabaseName + N'.bak'' WITH COMPRESSION, INIT'
EXECUTE (@SQLString)
