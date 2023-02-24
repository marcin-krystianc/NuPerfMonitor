# NuGet Regression Testing
NuGet Regression Testing is a system to continously monitor performance of NuGet, it comes with visualization and alerting capabilities as well.
Go to https://marcin-krystianc.github.io/TestSelfHostedPlotly to see current results.

## Our motivation
NuGet is a package manager for .NET that is shipped together with [.NET SDK](https://dotnet.microsoft.com/en-us/download).
In our company we work with .NET solutions containg hundreds of projects and referencing hundreds of NuGet packages, therefore being able to quickly restore NuGet packagesfor such solutions is realy important for us. 
Recently, when we tried to upgrade our code to use .NET 7, we noticed a performance regression in NuGet which forced us to keep using older version of .NET until a new SDK with a fix is released.
To avoid such unplesant surprises in the future, we've decided to build a dedicated regression testing system for NuGet. 

## How it works
