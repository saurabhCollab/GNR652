# Import necessary modules; CSV is for reading .csv files and Plots is for plotting
using CSV
using Plots
using Statistics
using LinearAlgebra

# Y = β_0 * X_0 + β_1 * X_1 + β_2 * X_2
# if X_0 = 1: we can write the above as Y = β * X for vectorization
# Predictions from Model β: Y_Pred = β * X

# Read the dataset from file
dataset = CSV.read("scores.csv")

# Extract columns from the dataset
course1 = dataset.course1
course2 = dataset.course2
course3 = dataset.course3
#
# # Visualize the columns as a scatter plot
scatter3d(course1, course2, course3)
#
# # Stub column 1 for vectorization.
m = length(course1)
x0 = ones(m)
#
# # Define the features array
X = cat(x0, course1, course2, dims=2)

# Get the variable we want to regress
Y = course3

# Define a function to calculate cost function
function costFunction(X, Y, B)
    m = length(Y)
    cost = sum(((X * B) - Y).^2)/(2*m)
    return cost
end

# # Initial coefficients
B = zeros(3, 1)
# Calcuate the cost with intial model parameters B=[0,0,0]
intialCost = costFunction(X, Y, B)

# Define a function to perform gradient descent
function gradientDescent(X, Y, B, learningRate, numIterations)
    costHistory = zeros(numIterations)
    m = length(Y)
    # do gradient descent for require number of iterations
    for iteration in 1:numIterations
        # Predict with current model B and find loss
        loss = (X * B) - Y
        # Compute Gradients: Ref to Andrew Ng. course notes linked on course page and Moodle
        gradient = (X' * loss)/m
        # Perform a descent step in direction oposite to gradient; we want to minimize cost!
        B = B - learningRate * gradient
        # Calculate cost of the new model found by descending a step above
        cost = costFunction(X, Y, B)
        # Store costs in a vairable to visualize later
        costHistory[iteration] = cost
    end
    return B, costHistory
end

#
learningRate = 0.0001
newB, costHistory = gradientDescent(X, Y, B, learningRate, 1000)

# Make predictions using the learned model; newB
YPred = X * newB

# visualize and compare the the prediction with original; below we plot only first 10 entries; plot! is to plot on the existing plot window
plot(Y[1:10])
plot!(YPred[1:10])

# Visualize the learning: how the loss decreased.
plot(costHistory)
