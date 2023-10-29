<#
    .SYNOPSIS
        Gets a users report from the MyITProcess reporting API.

    .DESCRIPTION
        The Get-MyITProcessUsersReport script gets a users report from the MyITProcess reporting API.

        This is a proof of concept script. It is not intended to be used in production.

    .PARAMETER APIKey
        Enter in the MyITProcess API key for authentication

    .PARAMETER APIEndPoint
        Define what MyITProcess endpoint to connect to.
        The default is https://reporting.live.myitprocess.com/public-api/v1

    .PARAMETER Days
        Defines the number of days a user has not logged in to be classified as inactive

        The default is 90 days.

    .PARAMETER Report
        Defines if the script should output the results to a CSV, HTML or Both.

    .PARAMETER ShowReport
        Switch statement to open the report folder after the script runs.

    .EXAMPLE
        Get-MyITProcessUsersReport -APIKey 12345

        Gets all users from the MyITProcess reporting API and sends the data to a CSV file.
        By default any user the has not logged in for more than 90 days will be classified as inactive.

    .EXAMPLE
        Get-MyITProcessUsersReport -APIKey 12345 -Days -180 -Report HTML

        Gets all users from the MyITProcess reporting API and sends the data to a HTML file.
        Any user the has not logged in for more than 180 days will be classified as inactive.

    .EXAMPLE
        Get-MyITProcessUsersReport -APIKey 12345 -Days -30 -Report All

        Gets all users from the MyITProcess reporting API and sends the data to both a CSV & HTML file.
        Any user the has not logged in for more than 30 days will be classified as inactive.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-Automation
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html

#>
#Requires -Version 5.0

#Region    [ Parameters ]

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        $APIKEY,

        [Parameter(Mandatory=$false)]
        $APIEndpoint = 'https://reporting.live.myitprocess.com/public-api/v1',

        [Parameter(Mandatory=$false)]
        [ValidateRange([Int]::MinValue,-1)]
        [Int]$Days = (-90),

        [Parameter(Mandatory=$false)]
        [ValidateSet('All','CSV','HTML')]
        [String]$Report = 'CSV',

        [Parameter(Mandatory=$false)]
        [Switch]$ShowReport

    )

#EndRegion [ Parameters ]

''
Write-Output "Start - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
''

#Region    [ Prerequisites ]

    $ScriptName = 'Get-MyITProcessUsersReport'
    $ReportFolderName = "$ScriptName-Report"
    $FileDate = Get-Date -Format 'yyyy-MM-dd-HHmm'
    $HTMLDate = (Get-Date -Format 'yyyy-MM-dd h:mmtt').ToLower()

    #Install MyITProcess Module
    Try {
        If(Get-PackageProvider -ListAvailable -Name NuGet -ErrorAction Stop){}
        Else{
            Install-PackageProvider -Name NuGet -Confirm:$False
        }

        If(Get-Module -ListAvailable -Name MyITProcessAPI) {
            Import-module MyITProcessAPI -ErrorAction Stop
        }
        Else {
            Install-Module MyITProcessAPI -Force -ErrorAction Stop
            Import-Module MyITProcessAPI -ErrorAction Stop
        }
    }
    Catch {
        Write-Error $_
        break
    }

    #Settings MyITProcess login information
    Add-MyITProcessBaseURI -base_uri $APIEndpoint
    Add-MyITProcessAPIKey $APIKey -ErrorAction Stop


    #Define & create logging location
    Try{

        $Log = "C:\Audits\$ReportFolderName"

        If ($Report -ne 'Console'){
            $CSVReport  = "$Log\$ScriptName-Report-$FileDate.csv"
            $HTMLReport = "$Log\$ScriptName-Report-$FileDate.html"

            If ((Test-Path -Path $Log -PathType Container) -eq $false){
                New-Item -Path $Log -ItemType Directory > $Null
            }
        }
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion [ Prerequisites ]

Write-Output " - (1/3) - $(Get-Date -Format MM-dd-HH:mm) - Getting users from MyITProcess"

#Region     [ MyITProcess API ]

    #Grabs all reviews from the MyITProcess API
    $Page_Number = 1
    $PageResults = [System.Collections.ArrayList]@()
    Do {
        $Current_Page = Get-MyITProcessUsers -paginationRule -page_number $Page_Number
        Write-Verbose "Page $Page_Number of $([math]::ceiling($Current_Page.totalCount/$Current_Page.pageSize))"
        $PageResults += $Current_Page.items
        Write-Verbose "$($PageResults.count) records retrieved"
        $Page_Number++
    }
    While ( $([math]::ceiling($Current_Page.totalCount/$Current_Page.pageSize)) -ne $Page_Number -1 )

    #Customize the results
    Try{
        $MyITProcessUserResults = (Get-MyITProcessUsers).items | Select-Object `
                                            @{Name='status';Expression={    if ((Get-Date).AddDays([Int]$Days) -gt $_.lastLoginDate) {'InActive'}
                                                                            else {'Active'} }},`
                                            @{Name='id';Expression={$_.id}}, `
                                            @{Name='firstName';Expression={$_.firstName}}, `
                                            @{Name='lastName';Expression={$_.lastName}}, `
                                            @{Name='roleName';Expression={$_.roleName}}, `
                                            @{Name='lastLoginDate';Expression={[DateTime]$_.lastLoginDate | Get-Date -Format 'yyyy-MM-dd hh:mm'}}
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion  [ MyITProcess API ]

#Region     [ CSV Report ]
    Try{
        If($Report -eq 'All' -or $Report -eq 'CSV'){
            Write-Output " - (2/3) - $(Get-Date -Format MM-dd-HH:mm) - Generating CSV"
            $MyITProcessUserResults | Sort-Object roleName | Select-Object $ScriptName,* | Export-Csv $CSVReport -NoTypeInformation
        }
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion  [ CSV Report ]

#Region    [ HTML Report]

    Try{
        If ($Report -eq 'All' -or $Report -eq 'HTML'){
            Write-Output " - (3/3) - $(Get-Date -Format MM-dd-HH:mm) - Generating HTML"

            #HTML card header data to highlight useful information
            $TotalUsers = ($MyITProcessUserResults.id).count
            $TotalRoles = ($MyITProcessUserResults.roleName | Select-Object -Unique).count
            $InactiveUsers = ($MyITProcessUserResults | Where-Object {(Get-Date).AddDays([Int]$Days) -gt $_.lastLoginDate}).count

    #Region    [ HTML Report Building Blocks ]

        # Build the HTML header
        # This grabs the raw text from files to shorten the amount of lines in the PSScript
        # General idea is that the HTML assets would infrequently be changed once set
            $Meta = Get-Content -Path "$PSScriptRoot\Assets\Meta.html" -Raw
            $Meta = $Meta -replace 'xTITLECHANGEx',"$ScriptName"
            $CSS = Get-Content -Path "$PSScriptRoot\Assets\Styles.css" -Raw
            $JavaScript = Get-Content -Path "$PSScriptRoot\Assets\JavaScriptHeader.html" -Raw
            $Head = $Meta + ("<style>`n") + $CSS + ("`n</style>") + $JavaScript

        # HTML Body Building Blocks (In order)
            $TopNav = Get-Content -Path "$PSScriptRoot\Assets\TopBar.html" -Raw
            $DivMainStart = '<div id="layoutSidenav">'
            $SideBar = Get-Content -Path "$PSScriptRoot\Assets\SideBar.html" -Raw
            $SideBar = $SideBar -replace ('xTIMESETx',"$HTMLDate")
            $DivSecondStart = '<div id="layoutSidenav_content">'
            $PreLoader = Get-Content -Path "$PSScriptRoot\Assets\PreLoader.html" -Raw
            $MainStart = '<main>'

        #Base Table Container
            $BaseTableContainer = Get-Content -Path "$PSScriptRoot\Assets\TableContainer.html" -Raw

        #Summary Header
            $SummaryTableContainer = $BaseTableContainer
            $SummaryTableContainer = $SummaryTableContainer -replace ('xHEADERx',"$ScriptName - Summary")
            $SummaryTableContainer = $SummaryTableContainer -replace ('xBreadCrumbx','')

        #Summary Cards
        #HTML in Summary.html would be edited depending on the report and summary info you want to show
            $SummaryCards = Get-Content -Path "$PSScriptRoot\Assets\Summary.html" -Raw
            $SummaryCards = $SummaryCards -replace ('xCARD1Valuex',$TotalUsers)
            $SummaryCards = $SummaryCards -replace ('xCARD2Valuex',$InactiveUsers)
            $SummaryCards = $SummaryCards -replace ('xCARD3Valuex',$TotalRoles)

        #Body table headers, would be duplicated\adjusted depending on how many tables you want to show
            $BodyTableContainer = $BaseTableContainer
            $BodyTableContainer = $BodyTableContainer -replace ('xHEADERx',"$ScriptName - Details")
            $BodyTableContainer = $BodyTableContainer -replace ('xBreadCrumbx',"Data gathered from $(hostname)")

        #Ending HTML
            $DivEnd = '</div>'
            $MainEnd = '</main>'
            $JavaScriptEnd = Get-Content -Path "$PSScriptRoot\Assets\JavaScriptEnd.html" -Raw

    #EndRegion [ HTML Report Building Blocks ]
    #Region    [ Example HTML Report Data\Structure ]

        #Creates an HTML table from PowerShell function results without any extra HTML tags
        $TableResults = $MyITProcessUserResults | ConvertTo-Html -As Table -Fragment -Property status,firstName,lastName,roleName,lastLoginDate `
                                        -PostContent    '   <ul>
                                                                <li>Note: SAMPLE 1 = Only applies to stuff and things</li>
                                                                <li>Note: SAMPLE 2 = Only applies to stuff and things</li>
                                                                <li>Note: SAMPLE 3 = Only applies to stuff and things</li>
                                                            </ul>
                                                        '

        #Table section segregation
        #PS doesn't create a <thead> tag so I have find the first row and make it so
        $TableHeader = $TableResults -split "`r`n" | Where-Object {$_ -match '<th>'}
        #Unsure why PS makes empty <colgroup> as it contains no data
        $TableColumnGroup = $TableResults -split "`r`n" | Where-Object {$_ -match '<colgroup>'}

        #Table ModIfications
        #Replacing empty html table tags with simple replaceable names
        #It was annoying me that empty rows showed in the raw HTML and I couldn't delete them as they were not $NUll but were empty
        $TableResults = $TableResults -replace ($TableHeader,'xblanklinex')
        $TableResults = $TableResults -replace ($TableColumnGroup,'xblanklinex')
        $TableResults = $TableResults | Where-Object {$_ -ne 'xblanklinex'} | ForEach-Object {$_.Replace('xblanklinex','')}

        #Inject modified data back into the table
        #Makes the table have a <thead> tag
        $TableResults = $TableResults -replace '<Table>',"<Table>`n<thead>$TableHeader</thead>"
        $TableResults = $TableResults -replace '<table>','<table class="dataTable-table" style="width: 100%;">'

        #Mark Focus Data to draw attention\talking points
        #Need to understand RegEx more as this doesn't scale at all
        $TableResults = $TableResults -replace '<td>InActive</td>','<td class="BadStatus">InActive</td>'


        #Building the final HTML report using the various ordered HTML building blocks from above.
        #This is injecting html\css\javascript in a certain order into a file to make an HTML report
        $HTML = ConvertTo-HTML -Head $Head -Body "  $TopNav $DivMainStart $SideBar $DivSecondStart $PreLoader $MainStart
                                                    $SummaryTableContainer $SummaryCards $DivEnd $DivEnd $DivEnd
                                                    $BodyTableContainer $TableResults $DivEnd $DivEnd $DivEnd
                                                    $MainEnd $DivEnd $DivEnd $JavaScriptEnd
                                                "
        $HTML = $HTML -replace '<body>','<body class="sb-nav-fixed">'
        $HTML | Out-File $HTMLReport -Encoding utf8

    }
}
Catch{
    Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
    ''
    Write-Error $_
    break
}
#EndRegion [ HTML Report ]

    If ($ShowReport){
        Invoke-Item $Log
    }

''
Write-Output "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
''