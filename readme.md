# **Nmap XML to HTML Converter**

This PowerShell script provides a convenient way to transform Nmap XML output files into human-readable HTML reports using the official Nmap XSL stylesheet. 

**For Zenmap users on Windows, this script is particularly useful as Zenmap does not offer a direct option to save scan results as HTML. It allows you to easily convert your .xml output files into more manageable and viewable .html reports.**

## **🚀 Features**

* **XML to HTML Transformation:** Converts raw Nmap XML data into a styled HTML report.  
* **Standalone Output:** The generated HTML file is self-contained and can be viewed directly in any web browser without needing external files (once generated).  
* **Optional Output Path:** If you don't specify an output filename, the script automatically generates one based on the input filename (e.g., scan\_results.xml becomes scan\_results.html).  
* **Default XSL Stylesheet Path:** By default, the script looks for the nmap.xsl stylesheet in the same directory as the script. You can also specify a custom path for the XSL file.  


## **💡 How to Use**

1. Save the Script:  
   Save the PowerShell script provided (e.g., Convert-NmapXml2Html.ps1) to a location on your computer.  
2. Open PowerShell:  
   Navigate to the directory where you saved the script using the cd command.  
   cd C:\\Path\\To\\Your\\Script

3. Place nmap.xsl:  
   Ensure that nmap.xsl is in the same directory as your script, or be prepared to specify its path using the \-LocalXslPath parameter.  
4. **Run the Script:**  
   You can run the script with different arguments:  
   * Basic Usage (Input XML only):  
     The script will convert my\_scan.xml and save the output as my\_scan.html in the same directory.  
     .\\Convert-NmapXml2Html.ps1 my\_scan.xml

   * Specify Input and Output HTML File:  
     Convert input.xml and save the output to a specific output\_report.html file.  
     .\\Convert-NmapXml2Html.ps1 C:\\scans\\input.xml C:\\reports\\output\_report.html

   * Specify Input and a Custom XSL Stylesheet Path:  
     Use a custom.xsl file located elsewhere to transform another\_scan.xml.  
     .\\Convert-NmapXml2Html.ps1 .\\another\_scan.xml \-LocalXslPath 'D:\\MyStylesheets\\custom.xsl'

   * **Combine all options:**  
     .\\Convert-NmapXml2Html.ps1 C:\\data\\raw\_scan.xml C:\\output\\final\_report.html \-LocalXslPath 'C:\\Program Files (x86)\\Nmap\\nmap.xsl'

## **⚠️ Important Notes**

* **XSLT Transformation:** This script performs an XSLT transformation, meaning it *applies* the stylesheet to your XML data to produce a new HTML document. It does **not** embed the XSL stylesheet directly into the XML file's \<?xml-stylesheet?\> instruction or as a CDATA section within the XML. 
* **Standalone HTML:** The resulting .html file is a complete, standalone report. You can open it directly in any web browser.  
* **Downloading nmap.xsl:** If you don't have the nmap.xsl file, you can always download the latest version directly from the official Nmap SVN repository: [https://nmap.org/svn/docs/nmap.xsl](https://nmap.org/svn/docs/nmap.xsl).  
* **About Nmap:** This script leverages the powerful XML output and XSL stylesheet provided by the Nmap project. Nmap is a free and open-source utility for network discovery and security auditing, and it's truly a fantastic tool for network professionals and enthusiasts alike. Learn more about Nmap at their official website: [https://nmap.org/](https://nmap.org/).

## **Troubleshooting**

* **"File not found" errors:**  
  * Double-check the paths to your input XML file and the nmap.xsl file.  
  * Ensure nmap.xsl exists in the default location (.\\nmap.xsl) or that you've provided the correct path with \-LocalXslPath.  
* **"Invalid XML or XSL format" errors:**  
  * Verify that your Nmap XML output file is well-formed.  
  * Ensure your nmap.xsl file is not corrupted.

