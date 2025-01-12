import matplotlib.pyplot as plt
import numpy as np
epsilon = [1.25,1.5,1.75,2,2.25,2.5]
epsilon = [2.25,2.5]
correct_H = ((0,4),(1,5),(2,6),(3,7),(4,8),(5,9),(4,0),(5,1),(6,2),(7,3),(8,4),(9,5))
standard = []
for i in range(10):
    temp = []
    for j in range(10):
        if (i,j) not in correct_H:
            temp.append(0) 
        else:
            temp.append(1)
    standard.append(temp)
standard
def delta_U(position,current_epsilon): #在某个位置改变氢键状态造成的能量变化量
    x,y = position
    if (x,y) in correct_H and peptide[x][y]==0: #将在正确的位置形成氢键
        return -current_epsilon
    if (x,y) in correct_H and peptide[x][y]==1: #将破坏正确位置已经形成的氢键
        return +current_epsilon
    if (x,y) not in correct_H and peptide[x][y]==0: #将在错误的位置形成氢键
        return +current_epsilon
    if (x,y) not in correct_H and peptide[x][y]==1: #将破坏错误位置已经形成的氢键
        return -current_epsilon
def determine(delta_e):
    if delta_e  < 0:
        return True
    else:
        random_number = np.random.uniform(0, 1)
        boltzmann_factor = np.exp(-delta_e)
        if random_number < boltzmann_factor:
            return True
        else: return False
def find_the_lucky_dog():
    x=y=0
    while x==y:
        x = np.random.randint(0, 10)
        y = np.random.randint(0, 10)
    return [x,y]
initial_peptide = []
for i in range(10):
    temp = []
    for j in range(10):
        temp.append(0) # 初始条件没有氢键，全0
        initial_peptide.append(temp)
mean_step_to_steady_state = []
for energy in epsilon:
    temp = []
    for N in range(1):
        peptide = initial_peptide
        count = 0
        while(not peptide == standard):
            chosen_position = find_the_lucky_dog()
            if determine(delta_U(position=chosen_position,current_epsilon=energy)):
                x,y = chosen_position
                if peptide[x][y] == 1:
                    peptide[x][y] = peptide[y][x] = 0
                elif peptide[x][y] == 0:
                    peptide[x][y] = peptide[y][x] = 1
            count += 1
        temp.append(count)
    mean_step_to_steady_state.append(np.mean(np.array(temp)))
plt.plot(epsilon,mean_step_to_steady_state)
plt.xlabel('Energy Difference')
plt.ylabel('Mean Steps to Reach Standard Condition (Repeated 100 times)')
plt.show()