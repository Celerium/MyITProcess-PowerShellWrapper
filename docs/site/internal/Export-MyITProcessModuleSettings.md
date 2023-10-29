---
external help file: MyITProcessAPI-help.xml
grand_parent: internal
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Export-MyITProcessModuleSettings.html
parent: GET
schema: 2.0.0
title: Export-MyITProcessModuleSettings
---

# Export-MyITProcessModuleSettings

## SYNOPSIS
Exports the MyITProcess BaseURI, API, & JSON configuration information to file.

## SYNTAX

```powershell
Export-MyITProcessModuleSettings [-MyITProcessConfPath <String>] [-MyITProcessConfFile <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Export-MyITProcessModuleSettings cmdlet exports the MyITProcess BaseURI, API, & JSON configuration information to file.

Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
This means that you cannot copy your configuration file to another computer or user account and expect it to work.

## EXAMPLES

### EXAMPLE 1
```powershell
Export-MyITProcessModuleSettings
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's MyITProcess configuration file located at:
    $env:USERPROFILE\MyITProcessAPI\config.psd1

### EXAMPLE 2
```powershell
Export-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -MyITProcessConfFile MyConfig.psd1
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's MyITProcess configuration file located at:
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Export-MyITProcessModuleSettings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Export-MyITProcessModuleSettings.html)

