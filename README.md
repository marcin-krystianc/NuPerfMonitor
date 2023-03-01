# NuGet Regression Testing
The NuGet Regression Testing is an automated system for monitoring the performance of the NuGet package manager.
It continuously runs benchmarks for new releases of NuGet and in case of performance regressions, it raises an alert.
Visit https://marcin-krystianc.github.io/TestSelfHostedPlotly/ to see the dashboard.

## Motivation
In our company we work with .NET solutions containing hundreds of projects, we also care about developers' productivity, therefore we are deeply interested in improving the performance of the .NET ecosystem.
One of the key factors of developers' productivity is the time spent waiting for NuGet to restore packages. We also want to benefit from runtime improvements which are shipped with every new release of .NET, but migrating to a new runtime is depending on being able to use the corresponding version of a .NET SDK and NuGet.
It happened in the past that there were some changes in NuGet that performed very poorly on large solutions and it prevented us from jumping to a newly released .NET until the bug was fixed.
To prevent from such unpleasant surprises in the future we have created NuGet Regression Testing.

## How it works
- [Scripts](https://github.com/NuGet/NuGet.Client/tree/dev/scripts/perftests from the [NuGet.Client](https://github.com/NuGet/NuGet.Client) repository with custom [test cases](https://github.com/marcin-krystianc/TestSelfHostedPlotly/tree/master/scripts/perftests/testCases).are are used for benchmarks, 
- GitHub Actions and GitHub-hosted runners are used to run benchmarks on a [daily schedule](https://github.com/marcin-krystianc/TestSelfHostedPlotly/blob/master/.github/workflows/benchmarks.yml)
- Python script is used to [process results](https://github.com/marcin-krystianc/TestSelfHostedPlotly/blob/master/process_results.py) into a [data.csv](https://github.com/marcin-krystianc/TestSelfHostedPlotly/blob/master/data.csv) file that makes it easy plotting charts and can be used further data analysis.
- There is also another python script that is used to [generate alerts](https://github.com/marcin-krystianc/TestSelfHostedPlotly/blob/master/generate_alert.py) in case of performance regression is found an Issue is created
- [Plotly.js](https://plotly.com/javascript/) is used to generate charts from the benchamrk results, visit the [website]https://marcin-krystianc.github.io/TestSelfHostedPlotly/) to see it.

## Interested in contributing?
