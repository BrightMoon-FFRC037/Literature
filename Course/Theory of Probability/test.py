from sympy import Matrix, symbols
# Define a symbolic matrix or a numeric one
A = Matrix([[5, 4], [1, 2]])
# Calculate eigenvalues and eigenvectors
print(A.eigenvects())
print(A.eigenvals())
