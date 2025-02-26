/*
ExcelPath   C:\Users\dba-pollbrod\Code\PERF\RCPD\SQ-PBDD22\20210816\SQLServerCheckup_query_outputs_SQ-PBDD22-BI_1_20210816_162011.xlsx
D.E.A.T.H   ELIMINATE
Uptime      14,71 days of uptime since août  1 2021 11:10PM
Run date:   2021-08-17 11:22
*/
/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [dbo].[PilotageRegenerationTableHistorique]
Index       [ix_PilotageRegenerationTableHistorique]
Rollback    --CREATE CLUSTERED INDEX [ix_PilotageRegenerationTableHistorique] ON [Rcpd1A].[dbo].[PilotageRegenerationTableHistorique] ( [DateFinSystem], [DateDebutSystem] ) WITH (FILLFACTOR=100, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='dbo', @TableName='PilotageRegenerationTableHistorique';
			Reads: 0 Writes: 38
			10 rows; 0.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [ix_PilotageRegenerationTableHistorique] ON [Rcpd1A].[dbo].[PilotageRegenerationTableHistorique];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransaction]
Index       [IDX_BridgeReportingTransaction_EstOccurrenceCourante]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransaction_EstOccurrenceCourante] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransaction] ( [EstOccurrenceCourante] ) INCLUDE ( [CleBridgeReportingTransaction], [CleNonReportingCP], [CleReportingCP], [CleReportingTransaction], [Regulator]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransaction';
			Reads: 0 Writes: 58
			413,738,502 rows; 65.1GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransaction_EstOccurrenceCourante] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransaction];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransaction]
Index       [IDX_BridgeReportingTransaction_DateOccurDebutFin]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransaction_DateOccurDebutFin] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransaction] ( [DateDebutOccurrence], [DateFinOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransaction';
			Reads: 0 Writes: 58
			413,738,502 rows; 24.7GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransaction_DateOccurDebutFin] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransaction];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccCoStatus]
Index       [IDX_BridgeReportingTransactionDtccCoStatus_CleProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccCoStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCoStatus] ( [CleProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccCoStatus';
			Reads: 0 Writes: 14
			6,160,880 rows; 308.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccCoStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCoStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccCoStatus]
Index       [IDX_BridgeReportingTransactionDtccCoStatus_CleReportingProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccCoStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCoStatus] ( [CleReportingTransactionProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccCoStatus';
			Reads: 0 Writes: 14
			6,160,880 rows; 111.8MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccCoStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCoStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccCrStatus]
Index       [IDX_BridgeReportingTransactionDtccCrStatus_CleProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccCrStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCrStatus] ( [CleProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccCrStatus';
			Reads: 0 Writes: 14
			590,359 rows; 24.7MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccCrStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCrStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccCrStatus]
Index       [IDX_BridgeReportingTransactionDtccCrStatus_CleReportingProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccCrStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCrStatus] ( [CleReportingTransactionProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccCrStatus';
			Reads: 0 Writes: 14
			590,359 rows; 10.9MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccCrStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccCrStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccEqStatus]
Index       [IDX_BridgeReportingTransactionDtccEqStatus_CleProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccEqStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccEqStatus] ( [CleProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccEqStatus';
			Reads: 0 Writes: 14
			14,363,087 rows; 689.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccEqStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccEqStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccEqStatus]
Index       [IDX_BridgeReportingTransactionDtccEqStatus_DateOccurCleHub]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccEqStatus_DateOccurCleHub] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccEqStatus] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccEqStatus';
			Reads: 0 Writes: 14
			14,363,087 rows; 681.8MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccEqStatus_DateOccurCleHub] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccEqStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccEqStatus]
Index       [IDX_BridgeReportingTransactionDtccEqStatus_CleReportingProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccEqStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccEqStatus] ( [CleReportingTransactionProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccEqStatus';
			Reads: 0 Writes: 14
			14,363,087 rows; 271.3MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccEqStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccEqStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccFxStatus]
Index       [IDX_BridgeReportingTransactionDtccFxStatus_CleProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccFxStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccFxStatus] ( [CleProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccFxStatus';
			Reads: 0 Writes: 14
			71,175,665 rows; 3.3GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccFxStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccFxStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccFxStatus]
Index       [IDX_BridgeReportingTransactionDtccFxStatus_CleReportingProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccFxStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccFxStatus] ( [CleReportingTransactionProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccFxStatus';
			Reads: 0 Writes: 14
			71,175,665 rows; 1.5GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccFxStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccFxStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccIrStatus]
Index       [IDX_BridgeReportingTransactionDtccIrStatus_CleProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccIrStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccIrStatus] ( [CleProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccIrStatus';
			Reads: 0 Writes: 14
			53,480,809 rows; 2.4GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccIrStatus_CleProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccIrStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccIrStatus]
Index       [IDX_BridgeReportingTransactionDtccIrStatus_DateOccurCleHub]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccIrStatus_DateOccurCleHub] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccIrStatus] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccIrStatus';
			Reads: 0 Writes: 14
			53,480,809 rows; 2.4GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccIrStatus_DateOccurCleHub] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccIrStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[BridgeReportingTransactionDtccIrStatus]
Index       [IDX_BridgeReportingTransactionDtccIrStatus_CleReportingProductDateOccur]
Rollback    --CREATE INDEX [IDX_BridgeReportingTransactionDtccIrStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccIrStatus] ( [CleReportingTransactionProduct], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='BridgeReportingTransactionDtccIrStatus';
			Reads: 0 Writes: 14
			53,480,809 rows; 1.0GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_BridgeReportingTransactionDtccIrStatus_CleReportingProductDateOccur] ON [Rcpd1A].[RcpdBusiness].[BridgeReportingTransactionDtccIrStatus];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdBusiness].[LinkReportingTransactionISDAProduct]
Index       [IX_LinkReportingTransactionISDAProduct]
Rollback    --CREATE INDEX [IX_LinkReportingTransactionISDAProduct] ON [Rcpd1A].[RcpdBusiness].[LinkReportingTransactionISDAProduct] ( [CleProduct] ) INCLUDE ( [CleReportingTransaction], [CleReportingTransactionISDAProduct]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='LinkReportingTransactionISDAProduct';
			Reads: 0 Writes: 58
			52,599,089 rows; 4.8GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_LinkReportingTransactionISDAProduct] ON [Rcpd1A].[RcpdBusiness].[LinkReportingTransactionISDAProduct];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodity]
Index       [IDX_SatelliteCommodity_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteCommodity_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodity] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodity';
			Reads: 0 Writes: 19
			6,687,297 rows; 391.8MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodity_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodity];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodity]
Index       [IDX_SatelliteCommodity_CleHubDateOccurDesc]
Rollback    --CREATE INDEX [IDX_SatelliteCommodity_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodity] ( [CleReportingTransaction], [DateDebutOccurrence] DESC ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodity';
			Reads: 0 Writes: 19
			6,687,297 rows; 382.2MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodity_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodity];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityFloatLeg1]
Index       [IDX_SatelliteCommodityFloatLeg1_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityFloatLeg1_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg1] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityFloatLeg1';
			Reads: 0 Writes: 19
			7,694,784 rows; 591.2MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityFloatLeg1_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg1];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityFloatLeg1]
Index       [IDX_SatelliteCommodityFloatLeg1_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityFloatLeg1_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg1] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityFloatLeg1';
			Reads: 0 Writes: 19
			7,694,784 rows; 438.7MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityFloatLeg1_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg1];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityFloatLeg2]
Index       [IDX_SatelliteCommodityFloatLeg2_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityFloatLeg2_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg2] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityFloatLeg2';
			Reads: 0 Writes: 19
			6,843,667 rows; 518.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityFloatLeg2_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg2];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityFloatLeg2]
Index       [IDX_SatelliteCommodityFloatLeg2_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityFloatLeg2_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg2] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityFloatLeg2';
			Reads: 0 Writes: 19
			6,843,667 rows; 394.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityFloatLeg2_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityFloatLeg2];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityGenericProduct]
Index       [IDX_SatelliteCommodityGenericProduct_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityGenericProduct_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityGenericProduct] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityGenericProduct';
			Reads: 0 Writes: 19
			7,222,525 rows; 544.2MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityGenericProduct_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityGenericProduct];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityGenericProduct]
Index       [IDX_SatelliteCommodityGenericProduct_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityGenericProduct_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityGenericProduct] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityGenericProduct';
			Reads: 0 Writes: 19
			7,222,525 rows; 413.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityGenericProduct_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityGenericProduct];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityGenericProduct]
Index       [IDX_SatelliteCommodityGenericProduct_CleHubDateOccurDesc]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityGenericProduct_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityGenericProduct] ( [CleReportingTransaction], [DateDebutOccurrence] DESC ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityGenericProduct';
			Reads: 0 Writes: 19
			7,222,525 rows; 395.5MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityGenericProduct_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityGenericProduct];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityMetal]
Index       [IDX_SatelliteCommodityMetal_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityMetal_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityMetal] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityMetal';
			Reads: 0 Writes: 19
			6,583,607 rows; 498.2MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityMetal_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityMetal];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteCommodityMetal]
Index       [IDX_SatelliteCommodityMetal_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteCommodityMetal_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityMetal] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteCommodityMetal';
			Reads: 0 Writes: 19
			6,583,607 rows; 374.4MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteCommodityMetal_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteCommodityMetal];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteOption]
Index       [IDX_SatelliteOption_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteOption_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteOption] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteOption';
			Reads: 0 Writes: 19
			74,548,847 rows; 4.1GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteOption_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteOption];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteOption]
Index       [IDX_SatelliteOption_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteOption_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteOption] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteOption';
			Reads: 0 Writes: 19
			74,548,847 rows; 5.3GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteOption_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteOption];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteProductDtccCr]
Index       [IDX_SatelliteProductDtccCr_CleHubDateOccurDesc]
Rollback    --CREATE INDEX [IDX_SatelliteProductDtccCr_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteProductDtccCr] ( [CleProduct], [DateDebutOccurrence] DESC ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteProductDtccCr';
			Reads: 0 Writes: 9
			83 rows; 0.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteProductDtccCr_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteProductDtccCr];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteProductDtccFx]
Index       [IDX_SatelliteProductDtccFx_CleHubDateOccurDesc]
Rollback    --CREATE INDEX [IDX_SatelliteProductDtccFx_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteProductDtccFx] ( [CleProduct], [DateDebutOccurrence] DESC ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteProductDtccFx';
			Reads: 0 Writes: 9
			36 rows; 0.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteProductDtccFx_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteProductDtccFx];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteProductDtccIr]
Index       [IDX_SatelliteProductDtccIr_CleHubDateOccurDesc]
Rollback    --CREATE INDEX [IDX_SatelliteProductDtccIr_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteProductDtccIr] ( [CleProduct], [DateDebutOccurrence] DESC ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteProductDtccIr';
			Reads: 0 Writes: 9
			55 rows; 0.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteProductDtccIr_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteProductDtccIr];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteReportingTransactionProductDetail]
Index       [IDX_SatelliteReportingTransactionProductDetail_EstOccurrenceCourante]
Rollback    --CREATE INDEX [IDX_SatelliteReportingTransactionProductDetail_EstOccurrenceCourante] ON [Rcpd1A].[RcpdRaw].[SatelliteReportingTransactionProductDetail] ( [EstOccurrenceCourante] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteReportingTransactionProductDetail';
			Reads: 0 Writes: 38
			74,214,953 rows; 3.9GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteReportingTransactionProductDetail_EstOccurrenceCourante] ON [Rcpd1A].[RcpdRaw].[SatelliteReportingTransactionProductDetail];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionCommonData]
Index       [IDX_SatelliteTransactionCommonData_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionCommonData_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionCommonData';
			Reads: 0 Writes: 19
			91,547,269 rows; 6.5GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionCommonData_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionCommonData]
Index       [IDX_SatelliteTransactionCommonData_EstOccurrenceCourante]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionCommonData_EstOccurrenceCourante] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData] ( [EstOccurrenceCourante] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionCommonData';
			Reads: 0 Writes: 38
			91,547,269 rows; 4.7GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionCommonData_EstOccurrenceCourante] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionCommonData]
Index       [IDX_SatelliteTransactionCommonData_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionCommonData_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionCommonData';
			Reads: 0 Writes: 19
			91,547,269 rows; 5.0GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionCommonData_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionCommonData]
Index       [IDX_SatelliteTransactionCommonData_CleHubDateOccurDesc]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionCommonData_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData] ( [CleReportingTransaction], [DateDebutOccurrence] DESC ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionCommonData';
			Reads: 0 Writes: 19
			91,547,269 rows; 4.5GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionCommonData_CleHubDateOccurDesc] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonData];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionCommonDataLeg2]
Index       [IDX_SatelliteTransactionCommonDataLeg2_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionCommonDataLeg2_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonDataLeg2] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionCommonDataLeg2';
			Reads: 0 Writes: 19
			83,280,361 rows; 5.9GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionCommonDataLeg2_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonDataLeg2];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionCommonDataLeg2]
Index       [IDX_SatelliteTransactionCommonDataLeg2_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionCommonDataLeg2_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonDataLeg2] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionCommonDataLeg2';
			Reads: 0 Writes: 19
			83,280,361 rows; 4.6GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionCommonDataLeg2_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionCommonDataLeg2];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionDirection]
Index       [IDX_SatelliteTransactionDirection_BridgeUnion]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionDirection_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionDirection] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionDirection';
			Reads: 0 Writes: 19
			83,246,221 rows; 5.9GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionDirection_BridgeUnion] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionDirection];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionDirection]
Index       [IDX_SatelliteTransactionDirection_CleDate]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionDirection_CleDate] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionDirection] ( [CleReportingTransaction], [DateDebutOccurrence] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionDirection';
			Reads: 0 Writes: 19
			83,246,221 rows; 4.5GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionDirection_CleDate] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionDirection];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [Rcpd1A]
Table       [RcpdRaw].[SatelliteTransactionDirection]
Index       [IDX_SatelliteTransactionDirection_DateCle]
Rollback    --CREATE INDEX [IDX_SatelliteTransactionDirection_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionDirection] ( [DateDebutOccurrence], [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdRaw', @TableName='SatelliteTransactionDirection';
			Reads: 0 Writes: 19
			83,246,221 rows; 4.6GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_SatelliteTransactionDirection_DateCle] ON [Rcpd1A].[RcpdRaw].[SatelliteTransactionDirection];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[DimNonReportingCP]
Index       [IX_DimNonReportingCP_LEI]
Rollback    --CREATE INDEX [IX_DimNonReportingCP_LEI] ON [RcpdBi1A].[Rcpd].[DimNonReportingCP] ( [LEI] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='DimNonReportingCP';
			Reads: 0 Writes: 28
			965,474 rows; 18.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_DimNonReportingCP_LEI] ON [RcpdBi1A].[Rcpd].[DimNonReportingCP];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[DimReportingCP]
Index       [IX_DimReportingCP_LEI]
Rollback    --CREATE INDEX [IX_DimReportingCP_LEI] ON [RcpdBi1A].[Rcpd].[DimReportingCP] ( [LEI] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='DimReportingCP';
			Reads: 0 Writes: 28
			18,750 rows; 0.5MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_DimReportingCP_LEI] ON [RcpdBi1A].[Rcpd].[DimReportingCP];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[DimReportingTransaction]
Index       [IX_DimReportingTransaction_UTI]
Rollback    --CREATE INDEX [IX_DimReportingTransaction_UTI] ON [RcpdBi1A].[Rcpd].[DimReportingTransaction] ( [UTI] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='DimReportingTransaction';
			Reads: 0 Writes: 56
			55,531,565 rows; 1.2GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_DimReportingTransaction_UTI] ON [RcpdBi1A].[Rcpd].[DimReportingTransaction];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[FactReportingTransactionDetail]
Index       [IX_FactReportingTransactionDetail_CleReportingCP]
Rollback    --CREATE INDEX [IX_FactReportingTransactionDetail_CleReportingCP] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail] ( [CleReportingCP] ) INCLUDE ( [CleEffectiveDate], [CleMaturityDate], [EstOccurrenceCourante]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='FactReportingTransactionDetail';
			Reads: 0 Writes: 56
			423,402,570 rows; 9.4GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_FactReportingTransactionDetail_CleReportingCP] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[FactReportingTransactionDetail]
Index       [IX_FactReportingTransactionDetail_CleNonReportingCP]
Rollback    --CREATE INDEX [IX_FactReportingTransactionDetail_CleNonReportingCP] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail] ( [CleNonReportingCP] ) INCLUDE ( [CleEffectiveDate], [CleMaturityDate], [EstOccurrenceCourante]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='FactReportingTransactionDetail';
			Reads: 0 Writes: 56
			423,402,570 rows; 9.5GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_FactReportingTransactionDetail_CleNonReportingCP] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[FactReportingTransactionDetail]
Index       [IX_FactReportingTransactionDetail_AssetClass]
Rollback    --CREATE INDEX [IX_FactReportingTransactionDetail_AssetClass] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail] ( [CleRegulator], [CleEffectiveDate], [CleMaturityDate] ) INCLUDE ( [AssetClass], [EstOccurrenceCourante]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='FactReportingTransactionDetail';
			Reads: 0 Writes: 56
			423,402,570 rows; 8.4GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_FactReportingTransactionDetail_AssetClass] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[FactReportingTransactionDetail]
Index       [IX_FactReportingTransactionDetail_CleEffectiveDate]
Rollback    --CREATE INDEX [IX_FactReportingTransactionDetail_CleEffectiveDate] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail] ( [CleEffectiveDate] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='FactReportingTransactionDetail';
			Reads: 0 Writes: 28
			423,402,570 rows; 7.0GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_FactReportingTransactionDetail_CleEffectiveDate] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[FactReportingTransactionDetail]
Index       [IX_FactReportingTransactionDetail_CleMaturityDate]
Rollback    --CREATE INDEX [IX_FactReportingTransactionDetail_CleMaturityDate] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail] ( [CleMaturityDate] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='FactReportingTransactionDetail';
			Reads: 0 Writes: 28
			423,402,570 rows; 7.3GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_FactReportingTransactionDetail_CleMaturityDate] ON [RcpdBi1A].[Rcpd].[FactReportingTransactionDetail];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[FactValuation]
Index       [IX_FactValuationCleRegulatorDate]
Rollback    --CREATE INDEX [IX_FactValuationCleRegulatorDate] ON [RcpdBi1A].[Rcpd].[FactValuation] ( [CleRegulator], [DateDebutOccurrence] ) INCLUDE ( [CleCurrency], [CleReportingCP], [CleReportingTransaction], [CleValuationDate], [ValuationAmount], [ValuationDateConvertedAmount]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='FactValuation';
			Reads: 0 Writes: 28
			1,188,312,822 rows; 38.8GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_FactValuationCleRegulatorDate] ON [RcpdBi1A].[Rcpd].[FactValuation];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdBi1A]
Table       [Rcpd].[FactValuation]
Index       [IX_FactValuationKeyReporting]
Rollback    --CREATE INDEX [IX_FactValuationKeyReporting] ON [RcpdBi1A].[Rcpd].[FactValuation] ( [CleReportingTransaction] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdBi1A', @SchemaName='Rcpd', @TableName='FactValuation';
			Reads: 0 Writes: 28
			1,188,312,822 rows; 16.7GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IX_FactValuationKeyReporting] ON [RcpdBi1A].[Rcpd].[FactValuation];

/*
D.E.A.T.H.  ELIMINATE (harmful)
Database    [RcpdCommunBi1A]
Table       [CmnBi].[ExecutionVariables]
Index       [IDX_ExecutionVariables_IdExecutionChaineTravail]
Rollback    --CREATE INDEX [IDX_ExecutionVariables_IdExecutionChaineTravail] ON [RcpdCommunBi1A].[CmnBi].[ExecutionVariables] ( [IdChaine], [IdExecutionChaine] ) INCLUDE ( [IdExecutionTravail]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdCommunBi1A', @SchemaName='CmnBi', @TableName='ExecutionVariables';
			Reads: 0 Writes: 25,656
			1,191,593 rows; 44.5MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_ExecutionVariables_IdExecutionChaineTravail] ON [RcpdCommunBi1A].[CmnBi].[ExecutionVariables];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [Rcpd1A]
Table       [RcpdBusiness].[PitAssetLeg]
Index       [IDX_PitAssetLeg_IdPitAssetLeg]
Rollback    --CREATE UNIQUE INDEX [IDX_PitAssetLeg_IdPitAssetLeg] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg] ( [IdPitAssetLeg] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='PitAssetLeg';
			Reads: 0 Writes: 0
			0 rows; 0.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_PitAssetLeg_IdPitAssetLeg] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [Rcpd1A]
Table       [RcpdBusiness].[PitAssetLeg]
Index       [IDX_PitAssetLeg_RacineDate]
Rollback    --CREATE INDEX [IDX_PitAssetLeg_RacineDate] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='PitAssetLeg';
			Reads: 0 Writes: 0
			0 rows; 0.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_PitAssetLeg_RacineDate] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [Rcpd1A]
Table       [RcpdBusiness].[PitAssetLeg]
Index       [IDX_PitAssetLeg_RacineCleDate]
Rollback    --CREATE INDEX [IDX_PitAssetLeg_RacineCleDate] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg] ( [CleRacineSource], [CleReportingTransaction], [DateDebutOccurrence] ) WITH (FILLFACTOR=100, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='PitAssetLeg';
			Reads: 0 Writes: 0
			0 rows; 0.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_PitAssetLeg_RacineCleDate] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [Rcpd1A]
Table       [RcpdBusiness].[PitAssetLeg]
Index       [IDX_PitAssetLeg_DateOccur]
Rollback    --CREATE INDEX [IDX_PitAssetLeg_DateOccur] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg] ( [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='PitAssetLeg';
			Reads: 0 Writes: 0
			0 rows; 0.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_PitAssetLeg_DateOccur] ON [Rcpd1A].[RcpdBusiness].[PitAssetLeg];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [Rcpd1A]
Table       [RcpdBusiness].[PitBusinessReportingTransaction]
Index       [IDX_PitBusinessReportingTransaction_RacineDate]
Rollback    --CREATE INDEX [IDX_PitBusinessReportingTransaction_RacineDate] ON [Rcpd1A].[RcpdBusiness].[PitBusinessReportingTransaction] ( [CleRacineSource], [DateDebutOccurrence] ) INCLUDE ( [CleReportingTransaction]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='PitBusinessReportingTransaction';
			Reads: 0 Writes: 0
			460,347,353 rows; 20.4GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_PitBusinessReportingTransaction_RacineDate] ON [Rcpd1A].[RcpdBusiness].[PitBusinessReportingTransaction];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [Rcpd1A]
Table       [RcpdBusiness].[PitBusinessReportingTransaction]
Index       [IDX_PitBusinessReportingTransaction_DateOccurCleHub]
Rollback    --CREATE INDEX [IDX_PitBusinessReportingTransaction_DateOccurCleHub] ON [Rcpd1A].[RcpdBusiness].[PitBusinessReportingTransaction] ( [DateDebutOccurrence], [CleReportingTransaction] ) INCLUDE ( [CleRacineSource]) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='Rcpd1A', @SchemaName='RcpdBusiness', @TableName='PitBusinessReportingTransaction';
			Reads: 0 Writes: 0
			460,347,353 rows; 18.4GB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_PitBusinessReportingTransaction_DateOccurCleHub] ON [Rcpd1A].[RcpdBusiness].[PitBusinessReportingTransaction];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [RcpdAbstract1A]
Table       [Abstract].[Attribut]
Index       [idxAttributUtilise]
Rollback    --CREATE INDEX [idxAttributUtilise] ON [RcpdAbstract1A].[Abstract].[Attribut] ( [Utilise], [DebutValidite], [FinValidite] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdAbstract1A', @SchemaName='Abstract', @TableName='Attribut';
			Reads: 0 Writes: 0
			25,286 rows; 0.6MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [idxAttributUtilise] ON [RcpdAbstract1A].[Abstract].[Attribut];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [RcpdCommunBi1A]
Table       [CmnBi].[ExecutionRejetsFonctionnels]
Index       [IDX_ExecutionRejetsFonctionnels_IdExecutionTravail]
Rollback    --CREATE INDEX [IDX_ExecutionRejetsFonctionnels_IdExecutionTravail] ON [RcpdCommunBi1A].[CmnBi].[ExecutionRejetsFonctionnels] ( [IdExecutionTravail] ) WITH (FILLFACTOR=100, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdCommunBi1A', @SchemaName='CmnBi', @TableName='ExecutionRejetsFonctionnels';
			Reads: 0 Writes: 0
			38 rows; 0.1MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
DROP INDEX [IDX_ExecutionRejetsFonctionnels_IdExecutionTravail] ON [RcpdCommunBi1A].[CmnBi].[ExecutionRejetsFonctionnels];

/*
D.E.A.T.H.  ELIMINATE (unused)
Database    [RcpdCommunBi1A]
Table       [CmnBi].[PilotageFuseauHoraire]
Index       [cndx_primarykey_timezonerule]
Rollback    --ALTER TABLE [RcpdCommunBi1A].[CmnBi].[PilotageFuseauHoraire] ADD CONSTRAINT [cndx_primarykey_timezonerule] PRIMARY KEY CLUSTERED ( [TimeZoneRuleId] ) WITH (FILLFACTOR=90, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);
More Info   EXEC dbo.sp_BlitzIndex @DatabaseName='RcpdCommunBi1A', @SchemaName='CmnBi', @TableName='PilotageFuseauHoraire';
			Reads: 0 Writes: 0
			0 rows; 0.0MB
            14,71 days of uptime since août  1 2021 11:10PM
*/
--ALTER TABLE [RcpdCommunBi1A].[CmnBi].[PilotageFuseauHoraire] DROP CONSTRAINT [cndx_primarykey_timezonerule];

/*
SOMMAIRE
53 indexes sont considérés nuisibles. Les supprimer, libèrera 269,94 GB
9 indexes sont considérés inutiles. Les supprimer, libèrera 38,80 GB

L'exécution de ce script est instantané
*/
