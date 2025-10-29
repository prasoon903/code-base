IF NOT EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.VersionDetails') AND TYPE = 'U') 
BEGIN

	CREATE TABLE VersionDetails (
	 [Skey] decimal(19) IDENTITY(1, 1),
	 [Project] varchar (50) NULL,
	 [Environment] varchar (50) NULL,
	 [Version] varchar (50) NULL,
	 [TimeStamp] datetime NULL
	CONSTRAINT csPk_VersionDetails PRIMARY KEY CLUSTERED (
	 [Skey]
	))

END

IF NOT EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.UserDetails') AND TYPE = 'U') 
BEGIN

	CREATE TABLE UserDetails (
	 [Skey] decimal(19) IDENTITY(1, 1),
	 [Project] varchar (50) NULL,
	 [Username] varchar (100) NULL,
	 [UserIP] varchar (100) NOT NULL,
	 [UserAccess] INT NULL, -- 0: No Access, 1: ReadOnly, 2: ReadWrite, 3: SuperUser
	 [DateAdded] datetime NULL,
	 [AddedByUserIP] varchar (100) NULL
	CONSTRAINT csPk_UserDetails PRIMARY KEY CLUSTERED (
	 [Skey]
	))

END

IF NOT EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.VersionDetailsModificationLog') AND TYPE = 'U') 
BEGIN

	CREATE TABLE VersionDetailsModificationLog (
	 [Skey] decimal(19) IDENTITY(1, 1),
	 [Project] varchar (50) NULL,
	 [Environment] varchar (50) NULL,
	 [VersionModified] varchar (50) NULL,
	 [UserIP] varchar (100) NULL,
	 [DateModified] datetime NULL
	CONSTRAINT csPk_VersionDetailsModificationLog PRIMARY KEY CLUSTERED (
	 [Skey]
	))

END