<#
    .SYNOPSIS
    Retirer les caractères blancs en début de ligne des requêtes ou de texte long à afficher à l'écran.

        .PARAMETER Text
        Le texte à retirer les espaces en début de ligne.

    .EXAMPLE
    Appel traditionnel avec paramètres:

    $query = Remove-BolWhiteSpace -Text "select *
    from table1"

    .EXAMPLE
    Appel par "pipeline" plus facile à lire:

    $query =  "select *
    from table1" | Remove-BolWhiteSpace

    .NOTES
    Tags: Private, HelpV2, NoImpact, Debug
    Author: Pollus Brodeur
    Copyright: Commission de la Construction du Quebec (CCQ)
#>
function Remove-BolWhiteSpace {
    param (
        [Parameter(ValueFromPipeline, Mandatory)]
        [string]$Text
    )
    return $Text -replace '(?m)^\s+', '' # Explication : regexr.com/4t0qo
}
# Pour permettre l'appel par DotSource
$script:RemoveBolWhiteSpaceLocation = $PSCommandPath