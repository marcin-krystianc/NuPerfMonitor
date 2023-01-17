import sys
import pandas as pd
import plotly.express as px
from pathlib import Path
from io import StringIO

def fetch_csv(csvPath: str) -> pd.DataFrame:
    return pd.read_csv(csvPath)

def plot_cumulative_state(df: pd.DataFrame, outfile: str):
    fig = px.line(
        df,
        x="timestamp",
        y="relative duration",
        title="NuGet restore time",
        color='solution',
        facet_col="scenario",
        facet_col_wrap=1,
        markers=True,
        hover_data=["solution", "scenario", "duration", "timestamp", "version", "base version"]
    )

    fig.update_traces(marker={'size': 4})
    fig.update_layout(title_x=0.5)
    fig.update_yaxes(ticksuffix="%", title='', rangemode="tozero")
    fig.update_xaxes(title='')
    fig.for_each_annotation(lambda a: a.update(text=a.text.split("=")[-1]))

    fig.write_html(outfile, include_plotlyjs='cdn')

data = fetch_csv(sys.argv[1])
data["timestamp"] = pd.to_datetime(data["timestamp"])
data = data.loc[data["scenario"] != 'warmup']
plot_cumulative_state(data, sys.argv[2])
