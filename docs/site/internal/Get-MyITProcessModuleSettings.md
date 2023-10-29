---
external help file: MyITProcessAPI-help.xml
grand_parent: internal
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Get-MyITProcessModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-MyITProcessModuleSettings
---

# Get-MyITProcessModuleSettings

## SYNOPSIS
Gets the saved MyITProcess configuration settings

## SYNTAX

### index (Default)
```powershell
Get-MyITProcessModuleSettings [-MyITProcessConfPath <String>] [-MyITProcessConfFile <String>]
 [<CommonParameters>]
```

### show
```powershell
Get-MyITProcessModuleSettings [-openConfFile] [<CommonParameters>]
```

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

### -MyITProcessConfPath
Define the location to store the MyITProcess configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\MyITProcessAPI

```yaml
Type: String
Parameter Sets: index
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
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -openConfFile
Opens the MyITProcess configuration file

```yaml
Type: SwitchParameter
Parameter Sets: show
Aliases:

Required: False
Position: Named
Default value: False
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Get-MyITProcessModuleSettings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Get-MyITProcessModuleSettings.html)

