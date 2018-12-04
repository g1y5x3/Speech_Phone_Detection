import numpy as np
import matplotlib.pyplot as plt
import matplotlib.collections as collections
from python_speech_features import mfcc

def predict_voice_state(model, voice_sample, voice_feature, num_components):
    """ THIS PARAMETER NEED TO BE FURTHER INVESTIGATED """
    # sample window = time x sampling rate
    sample_window = int(0.01 * 20000)
    """ THIS PARAMETER NEED TO BE FURTHER INVESTIGATED """

    # Use trainned HMM to predict the states
    state_prediction = model.predict(voice_feature)
    state_length = len(state_prediction)

    print(state_prediction)
    print("State 0: ", sum(state_prediction==0)/len(state_prediction))
    print("State 1: ", sum(state_prediction==1)/len(state_prediction))
    print("State 2: ", sum(state_prediction==2)/len(state_prediction))

    # Expand the state prediction from feature vectors to the original
    # voice signals
    # i - index
    # s - state
    voice_state = np.zeros((num_components,voice_sample.size))
    for i,s in enumerate(state_prediction):

        # Skip the first and last state to make it able to detect 
        # after differentiation
        # the first state
        if i == 0:
            for j in range(1, sample_window):
                voice_state[s,j] = 1
        # from the second state until the second last state
        elif i < state_length - 1:
            for j in range(i*sample_window, i*sample_window+sample_window):
                voice_state[s,j] = 1
        # last state
        else:
            for j in range(i*sample_window, voice_sample.size-1):
                voice_state[s,j] = 1

    # Plot the expanded voice state sequence
    c = ['r','g','y','c','m']
    plt.figure(figsize=(15, 5))
    plt.plot(voice_sample, c='b', alpha=0.8)

    for s in range(0,num_components):
        i_start = []    # all start indices for the current state
        i_end   = []    # all end indices for the current state

        # peform the differentiation
        voice_detect = np.diff(voice_state[s,:])
        # find non-zero elements +1/-1
        for i, v in enumerate(voice_detect):
            if v == 1:
                i_start.append(i)
            elif v == -1:
                i_end.append(i)

        for i,j in zip(i_start, i_end):
            p = plt.axvspan(i, j, facecolor=c[s] , alpha=0.4)

    plt.show()
    
    
def load_voice_testing(voice, index):
    Tmp_Data = voice['data']
    Start = voice['datastart']
    End = voice['dataend']
    Sample_Rate = voice['samplerate']

    rep = Start.shape[1]
    sample_rate = Sample_Rate[4,0]

    # Extract features from all 55 rep of voice signals
    voice_feature = np.empty((0, 13))
    length = []

    # Get the indices for the current repetiton
    voice_start = int(Start[4,index]) - 1
    voice_end = int(End[4,index])

    # Extract and center the current voice signal
    voice_sample = Tmp_Data[0,voice_start:voice_end]
    voice_sample = voice_sample - np.mean(voice_sample)

    # MFCC feature vectors are typically computed every 10ms using 
    # an overlapping analysis window of 25ms
    mfcc_feat = mfcc(voice_sample, sample_rate, 0.025, 0.01)

    # Concatnate individual feature into one single array
    voice_feature = np.append(voice_feature, mfcc_feat, axis=0)
    length.append(int(mfcc_feat.shape[0]))

    # Plot ONE voice sample signals    
    plt.figure(figsize=(15, 5))
    plt.plot(voice_sample)
    plt.title("Testing Voice")
    plt.show()
    
    print(voice_feature)
    print(length)
    
    return voice_sample, voice_feature, length