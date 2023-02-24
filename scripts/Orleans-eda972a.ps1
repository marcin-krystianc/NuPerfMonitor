#########################################################
$dotnet_base_url = "https://download.visualstudio.microsoft.com/download/pr/253e5af8-41aa-48c6-86f1-39a51b44afdc/5bb2cb9380c5b1a7f0153e0a2775727b/dotnet-sdk-7.0.100-linux-x64.tar.gz"
$dotnet_url = Get-Content -Path $PSScriptRoot\daily-linux.txt
$repoUrl = "https://github.com/dotnet/orleans.git"
$commitHash = "eda972a0de495e793e33ef07030b9e5a9397c9dc"
$solutionFilePath = "Orleans.sln"
$globalJsonPath = ""

#########################################################
. "$PSScriptRoot\Init.ps1"

$repoName = GenerateNameFromGitUrl $repoUrl
$resultsFilePath = "results.csv"
$sourcePath = $([System.IO.Path]::GetFullPath($repoName))
SetupGitRepository $repoUrl $commitHash $sourcePath
$solutionFilePath = "$sourcePath\$solutionFilePath"
$ProgressPreference = 'SilentlyContinue' #https://github.com/PowerShell/PowerShell/issues/2138 
if ($globalJsonPath) {Remove-Item "$sourcePath\$globalJsonPath"}

$versions = @("dotnet_base", "dotnet")
ForEach ($version In $versions) {
	$url = (Get-Variable ("$version" + "_url")).Value
	Invoke-WebRequest -Uri "$url" -OutFile ("$version" + ".tar.gz")
	New-Item -Name "$version" -ItemType "Directory"
	. tar xfz ("$version" + ".tar.gz") --directory "$version"
	. "$PSScriptRoot\..\NuGet.Client\scripts\perftests\RunPerformanceTests.ps1" -nugetClientFilePath "$version\dotnet" -solutionFilePath $solutionFilePath -resultsFilePath $resultsFilePath -iterationCount 1 -staticGraphRestore
}