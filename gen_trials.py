import pandas as pd
import random
import json
import string

def generate_random_string(length):
    characters = string.ascii_lowercase
    return ''.join(random.choice(characters) for _ in range(length))

# Read csvs

neg_words = pd.read_csv('neg_words.csv')
neu_words = pd.read_csv('neu_words.csv')
pos_words = pd.read_csv('pos_words.csv')

# Define random 6 character strings for the practice trials, make dataframe with with 80 rows'
practice_block_length = 80
practice_words = pd.DataFrame({'translation': [generate_random_string(7) for _ in range(practice_block_length)], 'Arousal_mean_rating': ['0']*practice_block_length, 'Valence_mean_rating': ['0']*practice_block_length, 'Arousal_median_rating': ['0']*practice_block_length, 'Valence_median_rating': ['0']*practice_block_length, 'Arousal_sd_rating': ['0']*practice_block_length, 'Valence_sd_rating': ['0']*practice_block_length})

# Choose 20 words from each list without repetition
neg_words_block_1 = neg_words.sample(n=20)
neu_words_block_1 = neu_words.sample(n=20)
pos_words_block_1 = pos_words.sample(n=20)
# Generate 80 rows of data for each list, each word is repeated 4 times, then shuffle the rows
neg_words_block_1 = pd.concat([neg_words_block_1]*4, ignore_index=True).sample(frac=1)
neu_words_block_1 = pd.concat([neu_words_block_1]*4, ignore_index=True).sample(frac=1)
pos_words_block_1 = pd.concat([pos_words_block_1]*4, ignore_index=True).sample(frac=1)

# Choose 20 words from each list without repetition
neg_words_block_2 = neg_words.sample(n=20)
neu_words_block_2 = neu_words.sample(n=20)
pos_words_block_2 = pos_words.sample(n=20)

# Generate 80 rows of data for each list, each word is repeated 4 times, then shuffle the rows
neg_words_block_2 = pd.concat([neg_words_block_2]*4, ignore_index=True).sample(frac=1)
neu_words_block_2 = pd.concat([neu_words_block_2]*4, ignore_index=True).sample(frac=1)
pos_words_block_2 = pd.concat([pos_words_block_2]*4, ignore_index=True).sample(frac=1)

# Function to randomize correct responses mapping and color axes
def group_participants():
    correct_responses = random.choice([['f', 'j', 'd', 'k'], ['j', 'f', 'k', 'd']]) # staying symmetric
    if correct_responses == ['f', 'j', 'd', 'k']:
        reversed_correct_responses = 'FALSE'
    else:
        reversed_correct_responses = 'TRUE'
    colors = random.choice([['red', 'green', 'blue', 'yellow'], ['blue', 'yellow', 'red', 'green']])
    if colors == ['red', 'green', 'blue', 'yellow']:
        reversed_color_axes= 'FALSE'
    else:
        reversed_color_axes = 'TRUE'
    fingers = random.choice(['index', 'middle', 'both'])
    conditions = ['negative', 'neutral', 'positive', 'practice']
    congruency = ['congruent', 'incongruent']
    return correct_responses, colors, fingers, conditions, congruency, reversed_correct_responses, reversed_color_axes

correct_responses, colors, fingers, conditions, congruency, reversed_correct_responses, reversed_color_axes = group_participants()

# Generate a dictionary of trials

def gen_trials(conditions, congruency, colors, fingers, correct_responses, words, reversed_correct_responses, reversed_color_axes):
    trials = []
    for i in range(words.shape[0]):
        # Chose congruency
        current_congruency = random.choice(congruency)
        # Make color axes red-green and blue-yellow alternating
        if i % 2 == 0:
            current_colors = colors[:2]            
        else:
            current_colors = colors[2:]

        # Choose target color
        target_color = random.choice(current_colors)
        # Get mapping of target color based on participant group
        target_color_index = colors.index(target_color)
        correct_response = correct_responses[target_color_index]

        flanker_colors = [color for color in current_colors if color != target_color]
        # Define correct response based on target color
        correct_response = correct_responses[target_color_index]
        # Create dictionary where stimulus is the ith word repeated five times vertically, middle word should be the same or differ based on congruency in color, color axes should alternate, add condition, color, correct_response and these variables as keys from the csv: Arousal_mean_rating, Valence_mean_rating, Arousal_median_rating, Valence_median_rating, Arousal_sd_rating, Valence_sd_rating
        if current_congruency == 'congruent':
            trials.append({'stimulus': f'<p style="color: {target_color};">{words.iloc[i, 0]}</p> <p style="color: {target_color};">{words.iloc[i, 0]}</p><p style="color: {target_color};">{words.iloc[i, 0]}</p><p style="color: {target_color};">{words.iloc[i, 0]}</p><p style="color: {target_color};">{words.iloc[i, 0]}</p>',
                        'condition': conditions,
                        'target_color': target_color,
                        'correct_response': correct_response,
                        'arousal_mean_rating': words.loc[i, 'Arousal_mean_rating'],
                        'valence_mean_rating': words.loc[i, 'Valence_mean_rating'],
                        'arousal_median_rating': words.loc[i, 'Arousal_median_rating'],
                        'valence_median_rating': words.loc[i, 'Valence_median_rating'],
                        'arousal_sd_rating': words.loc[i, 'Arousal_sd_rating'],
                        'valence_sd_rating': words.loc[i, 'Valence_sd_rating'],
                        'congruency': 'congruent',
                        'reversed_correct_responses': reversed_correct_responses,
                        'reversed_color_axes': reversed_color_axes,
                        'fingers': fingers})
        else:
            trials.append({'stimulus': f'<p style="color: {flanker_colors[0]};">{words.iloc[i, 0]}</p> <p style="color: {flanker_colors[0]};">{words.iloc[i, 0]}</p><p style="color: {target_color};">{words.iloc[i, 0]}</p><p style="color: {flanker_colors[0]};">{words.iloc[i, 0]}</p><p style="color: {flanker_colors[0]};">{words.iloc[i, 0]}</p>',
                        'condition': conditions,
                        'target_color': target_color,
                        'correct_response': correct_response,
                        'arousal_mean_rating': words.loc[i, 'Arousal_mean_rating'],
                        'valence_mean_rating': words.loc[i, 'Valence_mean_rating'],
                        'arousal_median_rating': words.loc[i, 'Arousal_median_rating'],
                        'valence_median_rating': words.loc[i, 'Valence_median_rating'],
                        'arousal_sd_rating': words.loc[i, 'Arousal_sd_rating'],
                        'valence_sd_rating': words.loc[i, 'Valence_sd_rating'],
                        'congruency': 'incongruent',
                        'reversed_correct_responses': reversed_correct_responses,
                        'reversed_color_axes': reversed_color_axes,
                        'fingers': fingers})
    return trials

# Generate trials for each condition
negative_trials_block_1 = gen_trials('negative', congruency, colors, fingers, correct_responses, neg_words_block_1, reversed_correct_responses, reversed_color_axes)
positive_trials_block_1 = gen_trials('positive', congruency, colors, fingers, correct_responses, pos_words_block_1, reversed_correct_responses, reversed_color_axes)
neutral_trials_block_1 = gen_trials('neutral', congruency, colors, fingers, correct_responses, neu_words_block_1, reversed_correct_responses, reversed_color_axes)

negative_trials_block_2 = gen_trials('negative', congruency, colors, fingers, correct_responses, neg_words_block_2, reversed_correct_responses, reversed_color_axes)
positive_trials_block_2 = gen_trials('positive', congruency, colors, fingers, correct_responses, pos_words_block_2, reversed_correct_responses, reversed_color_axes)
neutral_trials_block_2 = gen_trials('neutral', congruency, colors, fingers, correct_responses, neu_words_block_2, reversed_correct_responses, reversed_color_axes)

practice_trials_block = gen_trials('practice', congruency, colors, fingers, correct_responses, practice_words, reversed_correct_responses, reversed_color_axes)


# Print trials to one JSON file
print(json.dumps({'negative_trials_block_1': negative_trials_block_1, 'positive_trials_block_1': positive_trials_block_1, 'neutral_trials_block_1': neutral_trials_block_1, 'negative_trials_block_2': negative_trials_block_2, 'positive_trials_block_2': positive_trials_block_2, 'neutral_trials_block_2': neutral_trials_block_2, 'practice_trials_block': practice_trials_block}))
