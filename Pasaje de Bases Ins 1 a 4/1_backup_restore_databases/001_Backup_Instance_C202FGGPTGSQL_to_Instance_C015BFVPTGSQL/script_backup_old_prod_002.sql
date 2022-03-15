USE master
GO

DECLARE 
	@PathBackup VARCHAR(MAX);


-- SERVER - FOLDER PATH
SET @PathBackup = '\\C015BFVPTGSQL\SQLP004\j$\backup\CHG0739255\'


---------------------------- 	
-- EXECUTE BACKUP DATABASES
----------------------------


EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_111144'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_103673'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_121061'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_107517'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_109798'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_100394'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_104499'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_101995'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_105411'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_101931'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_109310'
EXEC new_infra_backup_databases @PathBackup, 'PTG_GPP_101076'

