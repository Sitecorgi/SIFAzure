try{           
    $functionRoot = Join-Path -Path $PSScriptRoot -ChildPath 'Functions' -Resolve
        
    Get-ChildItem -Path $functionRoot -Filter '*.ps1' | 
    ForEach-Object {
        Write-Verbose ("Importing function {0}." -f $_.FullName)
        . $_.FullName | Out-Null
    }  
}
catch{
    Write-Warning $_.Exception.Message
}