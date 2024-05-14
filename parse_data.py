import json
import pandas as pd

# Step 1: Read the file line by line
json_list = []
with open("/home/martonaronvarga/Downloads/data.json", 'r') as file:
    # {trials: [{}, {}, {}]}
    for line in file:
        data = json.loads(line)
        data_list = data["trials"]
        # append data to the list
        json_list.extend(data_list)
combined_json = json.dumps(json_list)
df = pd.read_json(combined_json)
combined_csv = df.to_csv('/data/combined_data.csv', index=False)
with open('/data/combined_data.json', 'w') as outfile:
    outfile.write(combined_json)
