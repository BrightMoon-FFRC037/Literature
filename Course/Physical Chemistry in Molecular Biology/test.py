import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation


fig, ax = plt.subplots()


def initialize(size):
    L=size
    # Initialize the lattice with spins down (-1)
    lattice = -np.ones((L, L), dtype=int)
    # Set the middle 10x10 spins to be up (+1)
    lattice[5:15, 5:15] = 1
    return lattice


def deltaU(array,x,y):
    l = array.shape[0]-1
    if x == 0: top = array[l,y] 
    else: top = array[x-1,y]
    if x == l: bottom = array[0,y]
    else: bottom = array[x+1,y]
    if y == 0: left = array[x,l]
    else: left = array[x,y-1]
    if y == l: right = array[x,0]
    else: right = array[x,y+1]
    return 2*array[x,y]*(top+bottom+left+right)

def simulate(T):
    size = 20
    img = initialize(size)
    ims = []
    N=10**3
    for i in range(N):
        x = np.random.randint(0, size)
        y = np.random.randint(0, size)
        delta = deltaU(img,x,y)
        if delta <= 0:
            img[x,y] = -img[x,y]
        else:
            if np.random.random() < np.exp(-delta/T):
                img[x,y] = -img[x,y]
        if i == N-1:
            ax.imshow(img)  # show an initial one first
    plt.show()

simulate(T=1)