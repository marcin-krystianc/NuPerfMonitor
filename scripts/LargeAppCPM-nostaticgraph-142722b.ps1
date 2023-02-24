#########################################################
$dotnet_base_url = "https://download.visualstudio.microsoft.com/download/pr/253e5af8-41aa-48c6-86f1-39a51b44afdc/5bb2cb9380c5b1a7f0153e0a2775727b/dotnet-sdk-7.0.100-linux-x64.tar.gz"
$dotnet_url = "https://aka.ms/dotnet/8.0.1xx/daily/dotnet-sdk-linux-x64.tar.gz"
$repoUrl = "https://github.com/marcin-krystianc/TestSolutions.git"
$commitHash = "142722bebfe90c4e5c98303fa1598db6a760adae"
$solutionFilePath = "LargeAppWithPrivatePackagesCentralisedNGBVRemoved\solution\LargeAppWithPrivatePackagesCentralisedNGBVRemoved.sln"
$globalJsonPath = ""

#########################################################
. "Init.ps1"

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
	. "$PSScriptRoot\..\RunPerformanceTests.ps1" -nugetClientFilePath "$version\dotnet" -solutionFilePath $solutionFilePath -resultsFilePath $resultsFilePath -iterationCount 1
}