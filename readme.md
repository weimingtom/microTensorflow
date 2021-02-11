# microTensorflow

This library is an automated GitHub workflow to pull the Tensorflow Lite for Microcontrollers out of the TensorFlow repository so they can be used in your custom projects.

## Usage

1. tflite-micro
    > This is the standard TensorFlow Lite for Microcontrollers library using the C/C++ kernels.
2. tflite-micro-cmsis
    > This is the TensorFlow Lite for Microcontrollers library using the CMSIS-NN kernels.
3. tflite-micro-ethosu
    > This is the TensorFlow Lite for Microcontrollers library optimised for Ethos-U with the CMSIS-NN kernels. This needs testing when the hardware becomes available

### Adding your own Kernels

Kernels can be added like they can for the standard Tensorflow Lite for Microcontrollers repo. You can add a folder with the new kernels in and use the current headers and remove the old kernels, or you could write directly and overwrite the current kernel files. 

### Cmake

## Why This Library Exists

Currently Tensorflow Lite for Microcontrollers uses a complex Makefile system, this is good for producing the examples for different targets. However when it comes to building custom projects this makes it hard to find a starting point. This library gives you 3 different libraries for you to be able to get started on your own projects.

#to do

- add the CMakeLists.txt files
- show how to use in your own project
