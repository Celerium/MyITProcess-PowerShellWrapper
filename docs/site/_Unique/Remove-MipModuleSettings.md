---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Remove-MipModuleSettings.html
parent: Special
schema: 2.0.0
title: Remove-MipModuleSettings
---

# Remove-MipModuleSettings

## SYNOPSIS
Removes the stored MyITProcess configuration folder.

## SYNTAX

## DESCRIPTION
The Remove-MyITProcessModuleSettings cmdlet removes the MyITProcess folder and its files.
This cmdlet also has the option to remove sensitive MyITProcess variables as well.

By default configuration files are stored in the following location and will be removed:
    $env:USERPROFILE\MyITProcessAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-MyITProcessModuleSettings
```

Checks to see if the default configuration folder exists and removes it if it does.

The default location of the MyITProcess configuration folder is:
    $env:USERPROFILE\MyITProcessAPI

### EXAMPLE 2
```powershell
Remove-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -AndVariables
```

Checks to see if the defined configuration folder exists and removes it if it does.
If sensitive MyITProcess variables exist then they are removed as well.

The location of the MyITProcess configuration folder in this example is:
    C:\MyITProcessAPI

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessModuleSettings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessModuleSettings.html)

