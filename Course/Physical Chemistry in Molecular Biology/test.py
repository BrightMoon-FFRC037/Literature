# SMB HW3


# Q4
import numpy as np
import matplotlib.pyplot as plt

N = 1000  # length
T = 298
k_B = 1.380649e-23
e = -k_B * T
steps = 2500
repeats = 1000


def energy_change(protein, i):
    """Calculate the energy change for flipping the i-th amino acid."""
    left_neighbor = protein[i - 1] if i > 0 else protein[-1]
    right_neighbor = protein[i + 1] if i < N - 1 else protein[0]

    # energy change
    delta_E = 0
    if protein[i] == 'C':
        if left_neighbor == 'C':
            delta_E += e
        if right_neighbor == 'C':
            delta_E += e
        if left_neighbor == 'H':
            delta_E -= e
        if right_neighbor == 'H':
            delta_E -= e
    else:  # if current state is 'H'
        if left_neighbor == 'C':
            delta_E -= e
        if right_neighbor == 'C':
            delta_E -= e
        if left_neighbor == 'H':
            delta_E += e
        if right_neighbor == 'H':
            delta_E += e
    return delta_E


def metropolis_step(protein, T):
    i = np.random.randint(0, N)
    delta_E = energy_change(protein, i)

    # metropolis
    if delta_E < 0 or np.random.rand() < np.exp(-delta_E / (k_B * T)):
        protein[i] = 'H' if protein[i] == 'C' else 'C'


def simulate_protein(T, steps):
    """Simulate protein folding over a number of steps."""
    protein = ['C'] * N  # initialization
    helical_fraction = []
    for step in range(steps):
        metropolis_step(protein, T)
        helical_fraction.append(protein.count('H') / N)

    return helical_fraction


def run_simulation(T, steps, repeats):
    """Run multiple simulations and average the helical fraction at steady state."""
    steady_state_fractions = []

    for _ in range(repeats):
        helical_fraction = simulate_protein(T, steps)
        steady_state_fractions.append(np.mean(helical_fraction[-100:]))  # Average over last 100 steps


    return np.mean(steady_state_fractions)


helical_fraction = simulate_protein(T, steps)

plt.plot(range(steps), helical_fraction)
plt.xlabel('monte carlo steps')
plt.ylabel('helical fractions')
plt.title('folding trajectory in 298K')
plt.show()

mean_helical_fraction = run_simulation(T, steps, repeats)
print(f"mean helical fraction at T = {T} : {mean_helical_fraction:.4f}")

# Parameters
Temperatures = np.array(range(200,620,20))
N = 1000
k_B = 1.380649e-23  # Boltzmann constant in J/K
e = -k_B   # Energy difference for HC pairs in J
steps = 2500  # Number of Monte Carlo steps per simulation
repeats = 100  # Number of simulations


res = []
for T in Temperatures:
    temp = run_simulation(T,steps,repeats)
    res.append(temp)
plt.plot(Temperatures,res)
plt.xlabel('temperature')
plt.ylabel('steady state')
plt.ylim((-0.1,1.1))
plt.title('transition curve')

plt.show()
