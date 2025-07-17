function CX  {
    <#
    Pour générer un script qui change un HEAP avec PK en CX
    Exception: il faut vérifier s'il y a des FK qui pointent vers cette table
               il faut vérifier si les colonnes clés sont IS NULL
    #>
    param (
        $TableFullname
    )
    foreach ($tbl in $TableFullname) {
        $t = Get-DbaDbTable -SqlInstance SFO-BDD3093\BI_1 -Database Oddi1A -Table $tbl
        $pk = $t.Indexes | Where-Object IndexKeyType -eq DriPrimaryKey
        $keys = $t.Indexes[0].IndexedColumns.Name -join ','
        if ($t.Indexes.Count -gt 1) { Write-Warning "plusieurs indexes sur $tbl" }
    <#
        "ALTER TABLE $tbl DROP CONSTRAINT $pk;
        ALTER TABLE $tbl ADD CONSTRAINT
        $pk PRIMARY KEY CLUSTERED ($keys)
        WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
        ALTER TABLE $tbl SET (LOCK_ESCALATION = TABLE);
        GO
        " -replace '[\t ]{2,8}'
    #>
        "PRINT '$tbl'
        IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('$tbl') AND [type] = 1)
            PRINT '  CX exists already'
        ELSE
        BEGIN
            BEGIN TRANSACTION;
            ALTER TABLE $tbl DROP CONSTRAINT $pk;
            ALTER TABLE $tbl ADD CONSTRAINT
            $pk PRIMARY KEY CLUSTERED ($keys)
            WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
            ALTER TABLE $tbl SET (LOCK_ESCALATION = TABLE);
            COMMIT;
            PRINT '  CX added';
        END
        GO
        " -replace '[ ]{8}'
    }
}

function MetaCX {
    param (
        $NbDecimal = 2 # le nombre de digit pour
    )
    #region -> CSV
    $csv = "ID;NOTE;FullName
    1;FF, ActHeap;OddiBusiness.SatelliteCompteFacebook
    2;FF, ActHeap;OddiBusiness.SatelliteSuiviDonneesFacebook
    3;FF, ActHeap;Oddi.SatelliteSuiviDonneesFacebook
    4;ActHeap;Oddi.SatelliteWhiteListSameAsCommentaire
    5;ActHeap;Oddi.SatelliteLienEmetteurInitieDetails
    6;ActHeap;Oddi.SatelliteTelephoneDetails
    7;ActHeap;Oddi.SatelliteLienEntreContactsDetails
    8;ActHeap;OddiBusiness.LinkPersonneNomPersonneNettoye
    9;ActHeap;OddiBusiness.LinkReseau
    10;ActHeap;Oddi.SatelliteDeclarationTransactionDetails
    11;ActHeap;Oddi.SatelliteCompteDeCourtageDetails
    12;FF, ActHeap;Oddi.SatelliteInitieDetails
    13;ActHeap;Oddi.SatelliteEmetteurDetails
    14;ActHeap;Oddi.SatelliteWhiteListSameAsDetails
    15;ActHeap;Oddi.SatelliteIdentificationFirme
    16;ActHeap;Oddi.SatelliteInitieDeclarationTransactionTickerDetails
    17;ActHeap;Oddi.SatelliteFournisseurServiceTelephoneDetails
    18;ActHeap;Oddi.LinkEmploi
    19;ActHeap;Oddi.LinkWhiteListSameAs
    20;ActHeap;Oddi.SatelliteCompteFacebook
    21;FF, ActHeap;Oddi.SatelliteTourCellulaireDetails
    22;ActHeap;OddiBusiness.SatelliteTickerImpacteParEvenementDetails
    23;ActHeap;OddiBusiness.SatelliteTickerDetails
    24;ActHeap;Oddi.SatelliteEmetteurCodeNaic
    25;ActHeap;Oddi.SatelliteInformationActuelle
    26;FF, ActHeap;Oddi.SatelliteLienDeControleDetails
    27;ActHeap;Oddi.LinkWhiteListProbable
    28;ActHeap;Oddi.SatelliteWhiteListProbableDetails
    29;FF, ActHeap;OddiBusiness.SatelliteEvenementDeMarcheDetails
    30;ActHeap;OddiBusiness.SatelliteWhiteListProbableDetails
    31;FF, ActHeap;Oddi.SatelliteEvenementDeMarcheDetails
    32;ActHeap;Oddi.SatelliteEmetteurBrancheActivite" | ConvertFrom-Csv -Delimiter ';'
    #endregion

    $csv | ForEach-Object {
        "/* {0:d$NbDecimal}-{1} */" -f [int]$_.ID, $_.FullName
        CX -TableFullname $_.FullName
    }
}

function PrettyfierTSQL {
    <#
    .DESCRIPTION
    Rendre plus lisible le code TSQL produit par MS
    .NOTES
    Fonctionne seulement avec PWSH 7 a cause de utf8NoBOM
    #>
    param (
        $Path = 'C:\Users\dba-pollbrod\Code\temp.sql',
        [switch]$Console
    )
    $code = Get-Content -Path $Path -Raw
    $code = $code -replace "`r`n\s+(\()",'$1'
    $code = $code -replace "`r`n[`t ]+(\))",'$1'
    $code = $code -replace "`r`nGO",';' -replace 'COMMIT\b','COMMIT;'
    $code | Out-File 'C:\Users\dba-pollbrod\Code\temp1.sql' -Encoding utf8NoBOM
}