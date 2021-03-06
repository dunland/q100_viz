import json
import pandas
import threading
import socketio


class Stats:
    def __init__(self, socket_addr):
        # set up Socket.IO client to talk to stats viz
        self.io = socketio.Client()

        def run():
            self.io.connect(socket_addr)
            self.io.wait()

        thread = threading.Thread(target=run, daemon=True)
        thread.start()

    def send_message(self, msg):
        try:
            self.io.emit('message', msg)
        except:
            print("Could not connect to Socket.IO server.")

    def send_max_values(self, max_values, min_values):
        self.send_message("init\n" + "\n".join(map(str, max_values + min_values)))

    def send_dataframe_as_json(self, df):
        self.send_message(export_json(df, None))

    def send_dataframes_as_json(self, dfs):
        self.send_message(json.dumps([json.loads(export_json(df, None)) for df in dfs]))


def append_csv(file, df, cols):
    """Open data from CSV and join them with a GeoDataFrame based on osm_id."""
    values = pandas.read_csv(file, usecols=['osm_id', *cols.keys()], dtype=cols).set_index('osm_id')
    return df.join(values, on='osm_id')


def make_clusters(buildings):
    # group the buildings by cell ID
    return buildings.groupby(by='cell')


def export_json(df, outfile):
    """Export a dataframe to JSON file."""
    return pandas.DataFrame(df).to_json(outfile, orient='records', force_ascii=False, default_handler=str)
