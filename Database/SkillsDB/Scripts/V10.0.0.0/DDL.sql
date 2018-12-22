PRINT '========================================='
PRINT '================V10.0.0.0================='
PRINT '================DDL.sql=================='
PRINT '========================================='

PRINT 'Change datatype for Type column...'
GO

ALTER TABLE tbl_UserAcquiredSkillSubskill
ALTER COLUMN [Type] VARCHAR(20)

GO
	









