---
title: Tracking CSV
parent: Home
nav_order: 2
---

# Tracking CSV

When updating the documentation for this project, the tracking CSV plays a huge part in organizing of the markdown documents. Any new functions or endpoints should be added to the tracking CSV when publishing an updated module or documentation version.

{: .warning }
I recommend downloading the CSV from the link provided rather then viewing the table below.

[Tracking CSV](https://github.com/Celerium/MyITProcess-PowerShellWrapper/blob/main/docs/Endpoints.csv)

---

## CSV markdown table

|Category        |EndpointUri                                       |Method|Function                             |Complete|Notes                       |
|----------------|--------------------------------------------------|------|-------------------------------------|--------|----------------------------|
|alert           |/alert/dismiss/{id}                               |POST  |Clear-MyITProcessAlert                     |YES     |                            |
|alert           |/alert/history/info                               |GET   |Get-MyITProcessAlert                       |YES     |                            |
|alert           |/alert/history/info/{id}                          |GET   |Get-MyITProcessAlert                       |YES     |                            |
|billing         |/billing/usage/client                             |GET   |Get-MyITProcessBilling                     |YES     |                            |
|billing         |/billing/usage/device/{id}                        |GET   |Get-MyITProcessBilling                     |YES     |                            |
|clientManagement|/tenants                                          |GET   |Get-MyITProcessTenant                      |YES     |                            |
|clientManagement|/tenants/detail                                   |GET   |Get-MyITProcessTenant                      |YES     |                            |
|clientManagement|/tenants/detail/{id}                              |GET   |Get-MyITProcessTenant                      |YES     |                            |
|internal        |                                                  |POST  |Add-MyITProcessAPIKey                      |YES     |                            |
|internal        |                                                  |POST  |Add-MyITProcessBaseURI                     |YES     |                            |
|internal        |                                                  |PUT   |ConvertTo-MyITProcessQueryString           |YES     |                            |
|internal        |                                                  |GET   |Export-MyITProcessModuleSettings           |YES     |                            |
|internal        |                                                  |GET   |Get-MyITProcessAPIKey                      |YES     |                            |
|internal        |                                                  |GET   |Get-MyITProcessBaseURI                     |YES     |                            |
|internal        |                                                  |GET   |Get-MyITProcessMetaData                    |YES     |                            |
|internal        |                                                  |GET   |Get-MyITProcessModuleSettings              |YES     |                            |
|internal        |                                                  |GET   |Import-MyITProcessModuleSettings           |YES     |                            |
|internal        |                                                  |GET   |Invoke-MyITProcessRequest                  |YES     |                            |
|internal        |                                                  |DELETE|Remove-MyITProcessAPIKey                   |YES     |                            |
|internal        |                                                  |DELETE|Remove-MyITProcessBaseURI                  |YES     |                            |
|internal        |                                                  |DELETE|Remove-MyITProcessModuleSettings           |YES     |                            |
|internal        |                                                  |POST  |Set-MyITProcessAPIKey                      |YES     |Alias of Add-MyITProcessAPIKey    |
|internal        |                                                  |POST  |Set-MyITProcessBaseURI                     |YES     |Alias of Add-MyITProcessBaseUri   |
|internal        |                                                  |GET   |Test-MyITProcessAPIKey                     |YES     |Alias of Add-MyITProcessCredential|
|inventory       |/inventory/component/info                         |GET   |Get-MyITProcessComponent                   |YES     |                            |
|inventory       |/inventory/component/info/{id}                    |GET   |Get-MyITProcessComponent                   |YES     |                            |
|inventory       |/inventory/configuration                          |GET   |Get-MyITProcessConfiguration               |YES     |                            |
|inventory       |/inventory/configuration/{id}                     |GET   |Get-MyITProcessConfiguration               |YES     |                            |
|inventory       |/inventory/device/detail                          |GET   |Get-MyITProcessDevice                      |YES     |                            |
|inventory       |/inventory/device/detail/{id}                     |GET   |Get-MyITProcessDevice                      |YES     |                            |
|inventory       |/inventory/device/detail/extended                 |GET   |Get-MyITProcessDevice                      |YES     |                            |
|inventory       |/inventory/device/detail/extended/{id}            |GET   |Get-MyITProcessDevice                      |YES     |                            |
|inventory       |/inventory/device/info                            |GET   |Get-MyITProcessDevice                      |YES     |                            |
|inventory       |/inventory/device/info/{id}                       |GET   |Get-MyITProcessDevice                      |YES     |                            |
|inventory       |/inventory/device/lifecycle                       |GET   |Get-MyITProcessDeviceLifecycle             |YES     |                            |
|inventory       |/inventory/device/lifecycle/{id}                  |GET   |Get-MyITProcessDeviceLifecycle             |YES     |                            |
|inventory       |/inventory/device/warranty                        |GET   |Get-MyITProcessDeviceWarranty              |YES     |                            |
|inventory       |/inventory/device/warranty/{id}                   |GET   |Get-MyITProcessDeviceWarranty              |YES     |                            |
|inventory       |/inventory/entity/audit                           |GET   |Get-MyITProcessEntity                      |YES     |                            |
|inventory       |/inventory/entity/audit/{id}                      |GET   |Get-MyITProcessEntity                      |YES     |                            |
|inventory       |/inventory/entity/note                            |GET   |Get-MyITProcessEntity                      |YES     |                            |
|inventory       |/inventory/entity/note/{id}                       |GET   |Get-MyITProcessEntity                      |YES     |                            |
|inventory       |/inventory/interface/info                         |GET   |Get-MyITProcessInterface                   |YES     |                            |
|inventory       |/inventory/interface/info/{id}                    |GET   |Get-MyITProcessInterface                   |YES     |                            |
|inventory       |/inventory/network/detail                         |GET   |Get-MyITProcessNetwork                     |YES     |                            |
|inventory       |/inventory/network/detail/{id}                    |GET   |Get-MyITProcessNetwork                     |YES     |                            |
|inventory       |/inventory/network/info                           |GET   |Get-MyITProcessNetwork                     |YES     |                            |
|inventory       |/inventory/network/info/{id}                      |GET   |Get-MyITProcessNetwork                     |YES     |                            |
|other           |/authentication/verify                            |GET   |Get-MyITProcessCredential                  |YES     |                            |
|poolers         |/settings/snmppoller/{snmpPollerSettingId}/devices|GET   |Get-MyITProcessSNMPPollerDevice            |YES     |                            |
|poolers         |/settings/snmppoller                              |GET   |Get-MyITProcessSNMPPollerSetting           |YES     |                            |
|poolers         |/settings/snmppoller/{snmpPollerSettingId}        |GET   |Get-MyITProcessSNMPPollerSetting           |YES     |                            |
|poolers         |/stat/snmppoller/int                              |GET   |Get-MyITProcessSNMPPolllerHistory          |YES     |                            |
|poolers         |/stat/snmppoller/string                           |GET   |Get-MyITProcessSNMPPolllerHistory          |YES     |                            |
|statistics      |/stat/component/{componentType}/{statId}          |GET   |Get-MyITProcessComponentStatistics         |YES     |                            |
|statistics      |/stat/deviceAvailability/{statId}                 |GET   |Get-MyITProcessDeviceAvailabilityStatistics|YES     |                            |
|statistics      |/stat/device/{statId}                             |GET   |Get-MyITProcessDeviceStatistics            |YES     |                            |
|statistics      |/stat/interface/{statId}                          |GET   |Get-MyITProcessInterfaceStatistics         |YES     |                            |
|statistics      |/stat/oid/{statId}                                |GET   |Get-MyITProcessOIDStatistics               |YES     |                            |
|statistics      |/stat/service/{statId}                            |GET   |Get-MyITProcessServiceStatistics           |YES     |                            |
