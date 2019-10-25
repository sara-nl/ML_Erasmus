# Assignment 1
In assigment we want to have a simple classification task which can be solved only using fully connected layers.

## Dataset
Potentially some balanced fraud detection dataset.

## Flow
We want to have the notebook which we do in class (2-2) to be very similar to this flow.
1. Read data and split
  1. Maybe plot
  1. Scale, either min/max scale or gaussian scaling. Preferably the min/max scale.
1. Create an initial network
1. Tell them which loss to use and metric.
1. They should reiterate on the network/hyperparameters until the loss/metric is below some certain number.
1. Then they should further refine the hyperparameters using the validation dataset. The losses/metrics should not be too different between the two datasets.
1. They should then end by running the model against the test dataset and report on the metric.
