
@ObjectName NVARCHAR(386) = NULL, /* 'dbname.schema.table' -- if you are lazy and want to fill in @DatabaseName, @SchemaName and @TableName, and since it's the first parameter can simply do: sp_BlitzIndex 'sch.table' */
@DatabaseName NVARCHAR(128) = NULL, /*Defaults to current DB if not specified*/
@SchemaName NVARCHAR(128) = NULL, /*Requires table_name as well.*/
@TableName NVARCHAR(261) = NULL,  /*Requires schema_name as well.*/
@Mode TINYINT=0, /*0=Diagnose, 1=Summarize, 2=Index Usage Detail, 3=Missing Index Detail, 4=Diagnose Details*/
/*Note:@Mode doesn't matter if you're specifying schema_name and @TableName.*/
@Filter TINYINT = 0, /* 0=no filter (default). 1=No low-usage warnings for objects with 0 reads. 2=Only warn for objects >= 500MB */
/*Note:@Filter doesn't do anything unless @Mode=0*/
@SkipPartitions BIT	= 0,
@SkipStatistics BIT	= 1,
@UsualStatisticsSamplingPercent FLOAT = 100, /* FLOAT to match sys.dm_db_stats_properties. More detail later. 100 by default because Brent suggests that if people are persisting statistics at all, they are probably doing 100 in lots of places and not filtering that out would produce noise. */
@GetAllDatabases BIT = 0,
@ShowColumnstoreOnly BIT = 0, /* Will show only the Row Group and Segment details for a table with a columnstore index. */
@BringThePain BIT = 0,
@IgnoreDatabases NVARCHAR(MAX) = NULL, /* Comma-delimited list of databases you want to skip */
@ThresholdMB INT = 250 /* Number of megabytes that an object must be before we include it in basic results */,
@OutputType VARCHAR(20) = 'TABLE' ,
@OutputServerName NVARCHAR(256) = NULL ,
@OutputDatabaseName NVARCHAR(256) = NULL ,
@OutputSchemaName NVARCHAR(256) = NULL ,
@OutputTableName NVARCHAR(261) = NULL ,
@IncludeInactiveIndexes BIT = 0 /* Will skip indexes with no reads or writes */,
@ShowAllMissingIndexRequests BIT = 0 /*Will make all missing index requests show up*/,
@ShowPartitionRanges BIT = 0 /* Will add partition range values column to columnstore visualization */,
@SortOrder NVARCHAR(50) = NULL, /* Only affects @Mode = 2. */
@SortDirection NVARCHAR(4) = 'DESC', /* Only affects @Mode = 2. */
@Help TINYINT = 0,
@Debug BIT = 0,
@Version     VARCHAR(30) = NULL OUTPUT,
@VersionDate DATETIME = NULL OUTPUT,
@VersionCheckMode BIT = 0

