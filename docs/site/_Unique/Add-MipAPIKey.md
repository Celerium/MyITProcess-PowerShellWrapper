---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Add-MipAPIKey.html
parent: Special
schema: 2.0.0
title: Add-MipAPIKey
---

# Add-MipAPIKey

## SYNOPSIS
Sets your API key used to authenticate all API calls.

## SYNTAX

## DESCRIPTION
The Add-MyITProcessAPIKey cmdlet sets your API key which is used to authenticate all API calls made to MyITProcess.
Once the API key is defined by Add-MyITProcessAPIKey, it is encrypted using SecureString.

The MyITProcess API keys are generated via the MyITProcess web interface at Organization Settings \> API Keys.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-MyITProcessAPIKey
```

Prompts to enter in the API Key

### EXAMPLE 2
```powershell
Add-MyITProcessAPIKey -Api_key '12345'
```

The MyITProcess API will use the string entered into the \[ -Api_Key \] parameter.

### EXAMPLE 3
```
'12345' | Add-MyITProcessAPIKey
```

The Add-MyITProcessAPIKey function will use the string passed into it as its API key.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Add-MyITProcessAPIKey.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Add-MyITProcessAPIKey.html)

