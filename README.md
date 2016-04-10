### Final Class Project for the "Getting and Cleaning Data" Coursera Module

The script "run_analysis.R" reads and manipulates the "Human Activity Recognition Using Smartphones" data according to the incordance with the course guidelines and outputs the combined data in a tidy format.

The script assumes that you have already downloaded and unzipped the UCI HAR data (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) to the working directory, preserving the exisiting file structure.

This data represents measurements collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## run_analysis.R

The script follows the following steps in order to combine and summarise the data:

* Checks if the necessary packages are installed (dplyr, tidyr) and installs any that are missing
* Loads required packages into R

* Reads in lables and feature descriptions
* Reads X, y and subject data for both train and test datasets
* Set descriptive names for all columns in merged X, y and subject data
* Combines X, y and subject data for both train and test datasets

* Selects only features containing measurements on the mean and standard deviation

* Rewrites measurement names with descriptive labels


* Creates a second data set (tidy) in a long format, with meaurement types and their values broken down by the Subject ID and activity
* Summarises means per unique activity and Subject ID pair

* Writes this second data set to csv file "tidy.csv" to the current working directory