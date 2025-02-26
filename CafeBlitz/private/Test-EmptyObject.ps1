<#
    .SYNOPSIS
    Retourne un message d'avertissement si aucune lignes dans l'objet de retour d'une requête.

        .PARAMETER Type
        Le nom affiché dans le message. Vu que l'objet est null, je dois passer le nom.

        .PARAMETER Advice
        La bonne pratique sera de commencer par "Try:" et de fournir un texte sur plusieurs lignes si necessaire.

        .PARAMETER Break
        Arrêtera la boucle dans la fonction appelante sinon sortira de l'appel séquentiel.

        .PARAMETER Stop
        Lance une exception.

    .EXAMPLE
    > 6 fast examples, (don't forget to DotSource this file)

    Test-EmptyObject -InputObject $null             # Displays a warning
    Test-EmptyObject -InputObject $null -Stop       # Generate an exception
    Test-EmptyObject -InputObject $null -Break      # Displays a warning. There's no loop here!

    foreach ($obj in @(1,$null,3)) { $obj; Test-EmptyObject $obj }          # Will display 1, warning then 3
    foreach ($obj in @(1,$null,3)) { $obj; Test-EmptyObject $obj -Break }   # Will display 1 then warning. Break will get out of the loop
    foreach ($obj in @(1,$null,3)) { $obj; Test-EmptyObject $obj -Stop }    # Will display 1 then exception.

    .EXAMPLE
    > Pipe an object and see what -Advice is used for (don't forget to DotSource this file)

    $null | Test-EmptyObject -Advice "Try not using null value"

    .NOTES
    Tags: Private, HelpV2, NoImpact
    Author: Pollus Brodeur
    Copyright: Commission de la Construction du Quebec (CCQ)
#>
function Test-EmptyObject {
    param (
        [Parameter(ValueFromPipeline,Position=0)]
        $InputObject,

        [Parameter(Position=1)]
        $Type = 'line',

        [string]$Advice,

        [switch]$Stop,

        [switch]$Break
    )
    process{
        if (!$InputObject) {
            $Msg = "no $type found using provided criterias." + "`n`r" + $Advice
            if ($Stop) { throw $Msg }
            Write-Warning $Msg
            if ($Break) { break }
        }
    }
}