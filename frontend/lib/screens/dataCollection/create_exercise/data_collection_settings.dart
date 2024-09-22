// forgot what buffer num i used for the model but default was 4
// i vaguely remember it was 4
// but 3 is working soo it must be 3
// int bufferNum = 4;


int bufferNum = 3;


// Minimum luminance value when collecting data
// user can still continue getting data but this will warn the user through an error icon above
double luminanceValueThreshold = 11.0;

int datasetMax = 100;

// camera scaling
double scaleX = 0.95;
double scaleY = 0.80;

// maximum dataset that can be collected
int MaxNegativeDataset = 100;
int MaxPositiveDataset = 100;

// minimum datset required per model
int MinNegativeDataset = 1;
int MinPositiveDataset = 1;

// video demo of exercise
int minVideoDuration = 5;
int maxVideoDuration = 15;

// determines how much change of coordinates from previous frame to current frame
double changeRangeDefault = 0.045;

int noMovementBufferThresholdDefault = 5;

// BE AWARE OF THIS PARAMETER
// This should match the training data pre process...currently its 3 decimal places
int dataNormalizedDecimalPlace = 3;

// multiplier for minimum width and height for nullifying coordinates (nullifies X or Y coordinates if respective coordinates size(max-min) is below the threshold)
double heightMultiplierThreshold = .45;
double widthMultiplierThreshold = .25;
