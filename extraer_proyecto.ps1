$outputFile = "reporte_completo_proyecto.txt"
Remove-Item $outputFile -ErrorAction SilentlyContinue

Get-ChildItem -Recurse | ForEach-Object {
    if (-not $_.PSIsContainer) {
        Add-Content $outputFile Add-Content $outputFile "`r`n`r`n==============================="

        Add-Content $outputFile "Archivo: $($_.FullName)"
        Add-Content $outputFile "==============================="
        Get-Content $_.FullName | Add-Content $outputFile
    }
}
