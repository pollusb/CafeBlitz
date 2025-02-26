<#
    .SYNOPSIS
    Pour afficher un objet en Verbose.

    .DESCRIPTION
    Permettre de retourner un objet ou une collection en Verbose. Cette fonction sert au "débugage".

        .PARAMETER InputObject
        Un objet ou une collection.

    .EXAMPLE
    Un appel depuis la console. Il faut monter la fonction en mémoire en DotSource, vu que cette fonction est privée:

    . AdminSQL\Functions\_Private\Out-Verbose.ps1
    Get-DbaDatabase CCQSQL047122 -Verbose | select name | Out-Verbose -Verbose # ici, je dois forcer -Verbose

    .EXAMPLE
    Dans une fonction, c'est différent car c'est seulement lorsqu'on passe -Verbose à l'appel qu'il sera activé:

    . AdminSQL\Functions\_Private\Out-Verbose.ps1
    function maFnc{[CmdletBinding()]param($a) $a | Out-Verbose}                # ma fonction utilise Out-Verbose
    $b = Get-DbaDatabase CCQSQL047122 | select name
    maFnc -a $b -Verbose                                                       # je dois passer -Verbose

    .NOTES
    Tags: Private, HelpV2, NoImpact, Debug
    Author: Pollus Brodeur
    Copyright: Commission de la Construction du Quebec (CCQ)
#>
function Out-Verbose {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject
    )
    begin {
        $all = @()
    }
    process {
        $all += $InputObject
    }
    end {
        Write-Verbose ($all | Out-String)
    }
}
# Pour permettre l'appel par DotSource
$script:OutVerboseLocation = $PSCommandPath