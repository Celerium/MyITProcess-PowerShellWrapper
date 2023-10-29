---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Export-MipModuleSettings.html
parent: Special
schema: 2.0.0
title: Export-MipModuleSettings
---

# Export-MipModuleSettings

## SYNOPSIS
Gets the saved MyITProcess configuration settings

## SYNTAX

## DESCRIPTION
The Get-MyITProcessModuleSettings cmdlet gets the saved MyITProcess configuration settings

By default the configuration file is stored in the following location:
    $env:USERPROFILE\MyITProcessAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-MyITProcessModuleSettings

The default location of the MyITProcess configuration file is:
    $env:USERPROFILE\MyITProcessAPI\config.psd1

### EXAMPLE 2
```powershell
Get-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -MyITProcessConfFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the MyITProcess configuration file in this example is:
    C:\MyITProcessAPI\MyConfig.psd1

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Get-MyITProcessModuleSettings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Get-MyITProcessModuleSettings.html)

