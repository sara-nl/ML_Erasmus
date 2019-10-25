# Deep Learning
## Goal
- Practial, not theoretical
- Use R
- Introduce assignment in first week
- Should provide good basics
- Should be focused on time-series predictions
- Should be in Dutch
- Should be fairly easy

## Structure
Below is a proposal of course structure and notebook content plan.

### Each lecture
- Overview & recap last week, question
- ...
- Summary -> Hand-over to notebooks
- Notebooks practice what was covered
- Homework




### 1. Introduction
- Course organisation
- Introduce the field of DL.
- Refresher on R and tensors.
- Neural Networks introduction.
- The XOR problem.

#### Slides 1
- What we will do
- DL
  - What is it?
  - Why is it a thing now?
  - Cool examples

- ML overview
  - Supervised, semi-supervised, unsupervised & reinforcement
  - Classification, multilable classification, regression
- Software we will be using
  - Keras + R
  - Eager vs lazy evaluations
  - Tensorboard

#### Notebook 1
Soft refresher on R and tensors.

#### Slides 2
- Easy intro to NN
  - Nodes, layers and edges
  - In/hidden/out
  - Activations (sigmoid only)
  - Parameters

#### Notebook 2
Implement and experience XOR problem.

#### Slides 3
- Recap/Summary
- Homework?


### 2. ML & DL fundamentals
- Define the learning optimisation task.
- Solving the XOR problem using Keras.
- Model evaluations and capacity.
- Tuning a model.

#### Slides 1
- Recap of basic NN components
- Loss functions
- Gradient descent
- Backprop
- Learning rate (hyperparameter).
- Gradient descent
- Stochastic gradient descent
- Pre-processing/formatting data
  - Cleaning (outliers, wrong values)
  - Real-valued
  - scaling

#### Notebook 1
- Solving the XOR problem.
- Training & Test split.
- Epochs
- Hint of overfitting

* Notebook: showing underfitting and overfitting with a fancier XOR problem (point clouds, outliers) - show with sufficient #neurons/#layers we can model everything
Bonus/at home: MNIST? - may be difficult because they haven't had multiclass classification yet


#### Slides 2
- Performance evaluation, metrics
- train/test/val
- Model complexity
- Over- and underfitting
- Hyperparameter tuning
- Optimizers, briefly, Momentum, lr per weights

#### Notebook 2
- Fancy XOR problem
- Show under and overfitting using different complexity models.
- Hyperparameter tuning (LR).

#### Slides 3
Recap/Homework.

#### Notes
- Training process: exploration & preprocessing, then training followed by evaluation
- Most popular optimizers: how do they work?
- Properly-tuned SGD outperforms all other optimizers (papers!)
- Effect of network complexity on convergence
- Effect of learning rate and momentum on convergence
- How to choose the 'best' model by the validation/training loss curves
- Mention cross-validation
- Which metric to choose? - RMSE vs MSE, MAE, etc. Why one for loss, why the other as a metric?
- How to interpret the network from the notebook?
- What does convergence mean exactly: for higher learning rates we see a steep decline in loss from e.g. 2500 to 61 at its lowest, which is convergence, but not to a great result.
- Effect of batch size and compute power on compute performance and quality of network results.
- Emphasise complex interaction between optimizer (hyperparameters), batch size and network complexity.
- Rules of thumb when choosing an optimizer and its hyperparameters
- Overfitting and the capacity of a network: NNs of sufficient complexity will memorize your data set (batch shuffling)



### 3. Classification
First part:
* Slides: controlling overfitting: dropout & regularization, maybe other stuff as well?
* Notebook:
Second part:
* Slides: other optimizers, vanishing gradient (sigmoids), the role of dense layers
* Notebooks: Boston housing data set (regression), compared with ordinary LM, trying different optimizers, deep networks with sigmoids

### Slides 1
- One-hot encoding
- logits
- Softmax as generalization of logistic regression
- Cross entropy
- Pre-processing/formatting data
  - Categorical (one-hot encoding)
  - Missing values?
  - Binning
- Class weights
#### Notebook 1
 MNIST - multiclass classification

#### Slides 2
- Explain vanishing 
- Introduce ReLU
- Introduce drop-out
#### Notebook 2 - implement ReLU, dropout, more if they're up for it
show effects on convergence with dropout and reg.

### 4. RNNs, time-series predictions
- Input can be a sequence, output can be a sequence, notation
- RNN, share weights over time. We use the same parameters for every element in the sequence.
- Backprop through time.
- Different architectures
  - one-to-one
  - many-to-one
  - one-to-many
  - many-to-many (two types)
- Using backprop this deep is hard. Many updates to the same weight for different inputs -> SGD explodes or it's very small.
  - Gradient clipping to stop exploding
  - Vanishing
  
  
### 5. 
- GRUs addressing vanishing gradient
  - Simpler, more recent (2014) than LSTM
  - Scales better
  - memory cell
  - update gate
  - relevance gate
- LSTMs
  - Old (1997), more complex than GRU
  - Often the go-to model
  - memory cell
  - hidden cell
  - update gate
  - forget gate
  - output gate
- Bidirectional RNNs (BRNNs)

#### Time-series prediction notebook
- From data to model

### 5. Improving NNs
- Data augmentation
- Vanishing gradient, ReLU helps
- Exploding gradient, batch normalization helps
- Dead ReLU, lower learning rate
- Apply dropout
- Initializations of weights (gaussian)
- Regularization (structural risk minimization)
  - L2 - lambda hyperparameter

#### Improve time-series notebook
- try using sigmoid
- apply dropout
- bn
- Transfer learning

### 6. CNNs?
Convs
- Convs
  - Sharing weights
  - padding
- Pooling
- Visualizing parameters
- Visualizing areas of interest
- Architectures

#### CNN notebook

### 7. Review & Summary
- Reinforcement learning?

## Other material

### Refreshers/Cheatsheets
https://seeing-theory.brown.edu/#firstPage
https://stanford.edu/~shervine/teaching/cs-229.html

### VU (BA) machine learning course
Held by Peter Bloem.
 - https://www.dropbox.com/sh/o7iq26b614im37j/AADcOKRb-CTNNXnF_ss1Sl4oa?dl=0
 - https://github.com/pbloem/machine-learning

### UvA (MA) Deep Learning course
Very mathematical
- https://uvadlc.github.io/

### Google ML crash course
Focuses on ML and is very practical
- https://developers.google.com/machine-learning/crash-course/ml-intro

### Coursera DL spec.
A great deep dive into DL.
https://www.coursera.org/specializations/deep-learning
https://karpathy.github.io/2015/05/21/rnn-effectiveness/
### Udacity DL by Google
A brief introduction to DL
https://eu.udacity.com/course/deep-learning--ud730

### fast.ai
https://www.fast.ai/

6. 
