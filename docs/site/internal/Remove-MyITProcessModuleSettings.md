---
external help file: MyITProcessAPI-help.xml
grand_parent: internal
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessModuleSettings.html
parent: DELETE
schema: 2.0.0
title: Remove-MyITProcessModuleSettings
---

# Remove-MyITProcessModuleSettings

## SYNOPSIS
Removes the stored MyITProcess configuration folder.

## SYNTAX

```powershell
Remove-MyITProcessModuleSettings [-MyITProcessConfPath <String>] [-AndVariables] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

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

### -MyITProcessConfPath
Define the location of the MyITProcess configuration folder.

By default the configuration folder is located at:
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

### -AndVariables
Define if sensitive MyITProcess variables should be removed as well.

By default the variables are not removed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessModuleSettings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessModuleSettings.html)

