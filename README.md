# MyITProcess API PowerShell Wrapper

This PowerShell module acts as a wrapper for the [MyITProcess](https://www.trumethods.com/myitprocess) API.

> Based off of the [ITGlue](https://github.com/itglue/powershellwrapper) project. Without their contributions I would not have been able to write this PowerShell wrapper. Thank you all!

---

## Introduction

The MyITProcess's reporting API offers users the ability to extract data from myITprocess into third-party reporting tools.
- Full documentation for MyITProcess's RESTful API can be found [here](https://reporting.live.myitprocess.com/index.html).

This module serves to abstract away the details of interacting with MyITProcess's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using MyITProcess's API to create documentation scripts, automation, and integrations.

### Function Naming

MyITProcess features a REST API that makes use of common HTTPs GET actions. In order to maintain PowerShell best practices, only approved verbs are used.
- GET -> Get-

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `MyITProcess` in an attempt to prevent naming problems.

For example, one might access the `/users` API endpoint by running the following PowerShell command with the appropriate parameters:

```posh
Get-MyITProcessUsers
```

---

## Install & Import

:exclamation: As of 2022-02-07 the MyITProcess API is in **BETA**. So this module has been published as a prerelease. For BETA testing you can install the module with the following command:
- When the API is out of BETA, I will adjust to any changes and note any new information here
```posh
Install-Module -Name MyITProcessAPI -AllowPrerelease
```

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/MyITProcessAPI) with the following command:
- :information_source: This module supports PowerShell 5.0+ and should work in PowerShell Core.
```posh
Install-Module -Name MyITProcessAPI
```

If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *Master* branch and place the *MyITProcessAPI* folder into the (default) `C:\Program Files\WindowsPowerShell\Modules` folder.

After installation (by either methods), load the module into your workspace:

```posh
Import-Module MyITProcessAPI
```

---
## Initial Setup

After importing this module, you will need to configure both the *base URI* & *API key* that are used to talk with MyITProcess.

1. Run `Add-MyITProcessBaseURI`
   - By default, MyITProcess's `https://reporting.live.myitprocess.com/public-api/v1` uri is used.
   - If you have your own API gateway or proxy, you may put in your own custom uri by specifying the `-base_uri` parameter:
     -  `Add-MyITProcessBaseURI -base_uri http://myapi.gateway.example.com`
<br><br>


2. Run `Add-MyITProcessAPIKey`
   - It will prompt you to enter your API key
   - MyITProcess API keys are generated by going to *MyITProcess > Organization Settings > API Keys*
<br><br>

[optional]
1. Run `Export-MyITProcessModuleSettings`
   - This will create a config file at `%UserProfile%\MyITProcessAPI` that securely holds the *base uri* & *API key* information.
   - Next time you run `Import-Module`, this configuration will automatically be loaded.
      - :warning: Exporting module settings encrypts your API key in a format that can **only be unencrypted with your Windows account**. It makes use of PowerShell's `System.Security.SecureString` type, which uses reversible encrypted tied to your user principal. This means that you cannot copy your configuration file to another computer or user account and expect it to work.
      - :warning: Exporting and importing module settings requires use of the `ConvertTo-SecureString` cmdlet, which is currently buggy in Linux & Mac PowerShell core ports.

---
## Usage

Calling an API resource is as simple as running `Get-MyITProcess<`*resourceName*`>`
   - The following is a table of supported functions and their corresponding API resources:
   - Table entries with [ `-` ] indicate that the functionality is NOT supported by the MyITProcess reporting API at this time.

| API Resource                  | Create    | Read                                              | Update    | Delete    |
| ----------------------------- | --------- | ------------------------------------------------- | --------- | --------- |
| Clients                       | -         | `Get-MyITProcessClients`                          | -         | -         |
| Findings                      | -         | `Get-MyITProcessFindings`                         | -         | -         |
| Initiatives                   | -         | `Get-MyITProcessInitiatives`                      | -         | -         |
| Meetings                      | -         | `Get-MyITProcessMeetings`                         | -         | -         |
| Recommendations               | -         | `Get-MyITProcessRecommendations`                  | -         | -         |
| Recommendation Configurations | -         | `Get-MyITProcessRecommendationsConfigurations`    | -         | -         |
| Reviews                       | -         | `Get-MyITProcessReviews`                          | -         | -         |
| Review Overdue Categories     | -         | `Get-MyITProcessReviewsCategoriesOverdue`         | -         | -         |
| Users                         | -         | `Get-MyITProcessUsers`                            | -         | -         |

Each `Get-MyITProcess*` function will respond with the raw data that MyITProcess's API provides. Usually, this data has at least four sub-sections:

- `page` - The current page number
- `pageSize` - The amount of data per page number
- `totalCount` - The total number of objects found
- `items` - The actual information that was requested

---
## Wiki & Help :blue_book:

Each resource allows for filters and parameters to be used to specify the desired output from MyITProcess's reporting API. Check out the wiki article on [Using Filters and Parameters](https://github.com/Celerium/MyITProcess-PowerShellWrapper/wiki/Using-Filters-and-Parameters).

  - A full list of functions can be retrieved by running `Get-Command -Module MyITProcessAPI`.
  - Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-MyITProcessUsers
Get-Help Get-MyITProcessUsers -Full
```
For more information about using this module, as well as examples and advanced functionality, check out the [wiki](https://github.com/Celerium/MyITProcess-PowerShellWrapper/wiki)!

---
## ToDo List :dart:

- [ ] Build more robust Pester & ScriptAnalyzer tests
- [ ] Build a better API parameter to more securely handle API keys
- [ ] Figure out how to do CI & PowerShell gallery automation
- [ ] Work on more logically named parameters
- [ ] See if Switch parameters can be removed with parameter sets or maybe auto set when any sub-parameters are defined
- [ ] Create user friendly documentation