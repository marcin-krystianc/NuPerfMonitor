import sys
import pandas as pd
import plotly.express as px
from pathlib import Path
from io import StringIO

def fetch_csv(csvPath: str) -> pd.DataFrame:
    return pd.read_csv(csvPath)

def get_regression(data: pd.DataFrame) -> [str]:
    regressions = []
    grouped_data = data.groupby(["scenario", "solution"])
    for (k, d) in grouped_data:
        # take quantile .25 from last 10 items
   
        result = d["relative duration"][-10:].quantile(.25)
        if result > 110:
            formatters = {
                'timestamp': (lambda a : a.strftime("%Y-%m-%d %H:%M:%S ")),
                'duration': (lambda a : "{:.2f}s".format(float(a))),
                'base duration': (lambda a : "{:.2f}s".format(float(a))),
                'relative duration': (lambda a : "{:.2f}%".format(float(a))),
            }
            columns = ['timestamp', 'version', 'duration', 'base duration', 'relative duration']
            header = "Scenario = " + str(d["scenario"].values[-1]) + "\n" + \
                     "Base Version = " + str(d["base version"].values[-1]) + "\n" + \
                     "Solution = " + str(d["solution"].values[-1])
            data_string = f'{d[-10:].to_string(header=True, index=False, justify="right", columns=columns, formatters=formatters)}'
            line_length = len(data_string.splitlines()[0])
            line = '-' * line_length
            regressions.append('\n' + line)
            regressions.append(header)
            regressions.append(line)
            regressions.append(data_string)
            regressions.append(line)
            regressions.append("")

    return regressions

data = fetch_csv(sys.argv[1])
data["timestamp"] = pd.to_datetime(data["timestamp"])
data = data.loc[data["scenario"] != 'warmup']
regressions = get_regression(data)

if regressions:
    with open(sys.argv[2], 'w') as fp:
        fp.write('\n'.join([x for x in regressions]))
elif os.path.exists(sys.argv[2]):
    os.remove(sys.argv[2])
