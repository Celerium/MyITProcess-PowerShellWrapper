---
external help file: MyITProcessAPI-help.xml
grand_parent: internal
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Import-MyITProcessModuleSettings.html
parent: GET
schema: 2.0.0
title: Import-MyITProcessModuleSettings
---

# Import-MyITProcessModuleSettings

## SYNOPSIS
Imports the MyITProcess BaseURI, API, & JSON configuration information to the current session.

## SYNTAX

```powershell
Import-MyITProcessModuleSettings [-MyITProcessConfPath <String>] [-MyITProcessConfFile <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Import-MyITProcessModuleSettings cmdlet imports the MyITProcess BaseURI, API, & JSON configuration
information stored in the MyITProcess configuration file to the users current session.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\MyITProcessAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Import-MyITProcessModuleSettings
```

Validates that the configuration file created with the Export-MyITProcessModuleSettings cmdlet exists
then imports the stored data into the current users session.

The default location of the MyITProcess configuration file is:
    $env:USERPROFILE\MyITProcessAPI\config.psd1

### EXAMPLE 2
```powershell
Import-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -MyITProcessConfFile MyConfig.psd1
```

Validates that the configuration file created with the Export-MyITProcessModuleSettings cmdlet exists
then imports the stored data into the current users session.

The location of the MyITProcess configuration file in this example is:
    C:\MyITProcessAPI\MyConfig.psd1

## PARAMETERS

### -MyITProcessConfPath
Define the location to store the MyITProcess configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\MyITProcessAPI

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"MyITProcessAPI"}else{".MyITProcessAPI"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -MyITProcessConfFile
Define the name of the MyITProcess configuration file.

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Import-MyITProcessModuleSettings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Import-MyITProcessModuleSettings.html)

