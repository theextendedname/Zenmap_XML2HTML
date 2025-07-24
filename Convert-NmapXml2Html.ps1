function Convert-NmapXml2Html {
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputXmlPath,

        [Parameter(Mandatory=$false)]
        [string]$LocalXslPath = ".\nmap.xsl", # Path to the local nmap.xsl file

        [Parameter(Mandatory=$false)]
        [string]$OutputHtmlPath
    )

    try {
        # Determine the actual output file path if not provided
        if (-not $OutputHtmlPath) {
            $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($InputXmlPath)
            $fileDirectory = [System.IO.Path]::GetDirectoryName($InputXmlPath)

            if ([string]::IsNullOrEmpty($fileDirectory)) {
                $fileDirectory = Get-Location
            }

            $OutputHtmlPath = Join-Path -Path $fileDirectory -ChildPath "$($fileNameWithoutExtension).html"
            Write-Host "Output HTML file not specified. Defaulting to: '$OutputHtmlPath'"
        }

        # --- Validate XSL Path ---
        if (-not (Test-Path $LocalXslPath -PathType Leaf)) {
            throw "Local XSL file not found at the specified path: '$LocalXslPath'. Please ensure it exists."
        }
        # --- Validate Input XML Path ---
        if (-not (Test-Path $InputXmlPath -PathType Leaf)) {
            throw "Input XML file not found at the specified path: '$InputXmlPath'. Please ensure it exists."
        }

        Write-Host "Transforming '$InputXmlPath' using '$LocalXslPath' to '$OutputHtmlPath'..."

        # Create an XSLT processor object
        $xslt = New-Object System.Xml.Xsl.XslCompiledTransform

        # Load the XSL stylesheet
        $xslt.Load($LocalXslPath)

        # Perform the transformation
        $xslt.Transform($InputXmlPath, $OutputHtmlPath)

        Write-Host "Successfully transformed '$InputXmlPath' to '$OutputHtmlPath'."
        Write-Host "The output is now a standalone HTML file that can be opened directly in a browser."
    }
    catch [System.IO.FileNotFoundException] {
        Write-Error "Error: File not found. $($_.Exception.Message)"
    }
    catch [System.Security.SecurityException] {
        Write-Error "Error: Permission denied when accessing file. $($_.Exception.Message)"
    }
    catch [System.Xml.XmlException] {
        Write-Error "Error: Invalid XML or XSL format. $($_.Exception.Message)"
    }
    catch {
        Write-Error "An unexpected error occurred during transformation: $($_.Exception.Message)"
    }
}

# --- Command-Line Argument Handling and Function Call ---

$cliInputXmlPath = $null
$cliLocalXslPath = $null
$cliOutputHtmlPath = $null

# Simple parsing for positional args and an optional named parameter
if ($args.Count -ge 1) {
    $cliInputXmlPath = $args[0]
    if ($args.Count -ge 2) {
        $cliOutputHtmlPath = $args[1]
    }
    # Check for -LocalXslPath parameter
    for ($i = 0; $i -lt $args.Count; $i++) {
        if ($args[$i] -eq "-LocalXslPath" -and ($i + 1) -lt $args.Count) {
            $cliLocalXslPath = $args[$i + 1]
            break
        }
    }

    $params = @{ InputXmlPath = $cliInputXmlPath }
    if ($cliOutputHtmlPath) {
        $params.OutputHtmlPath = $cliOutputHtmlPath
    }
    if ($cliLocalXslPath) {
        $params.LocalXslPath = $cliLocalXslPath
    }

    Convert-NmapXml2Html @params

} else {
    Write-Host "This script transforms an Nmap XML report into a standalone HTML file using a local XSL stylesheet."
    Write-Host "Usage:"
    Write-Host "  .\Convert-NmapXml2Html.ps1 <InputXmlPath> [OutputHtmlPath] [-LocalXslPath <PathToXsl>]"
    Write-Host ""
    Write-Host "Arguments:"
    Write-Host "  <InputXmlPath>    : Required. Path to the Nmap XML input file."
    Write-Host "  [OutputHtmlPath]  : Optional. Path for the output HTML file."
    Write-Host "                      Defaults to <InputFileName>.html in the same directory."
    Write-Host "  -LocalXslPath     : Optional. Path to the nmap.xsl file to use for transformation."
    Write-Host "                      Defaults to '.\nmap.xsl' (current directory)."
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Convert-NmapXml2Html.ps1 C:\scans\report.xml"
    Write-Host "  .\Convert-NmapXml2Html.ps1 C:\scans\report.xml C:\output\nmap_report.html"
    Write-Host "  .\Convert-NmapXml2Html.ps1 .\scan.xml -LocalXslPath 'D:\MyXsls\custom_nmap.xsl'"
}