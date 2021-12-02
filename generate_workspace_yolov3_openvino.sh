#!/bin/bash


#1. Create a folder for your datasets. Usually, multiple users use one folder for all datasets to be able to share them. Later on, in the 
#training and inference scripts, you will need the path to the dataset.
#2. Create the EML tools folder structure, e.g. ```eml-tools```. The structure can be found here: https://github.com/embedded-machine-learning/eml-tools#interface-folder-structure
ROOTFOLDER=`pwd`

#In your root directory, create the structure. Sample code
mkdir -p eml_projects
mkdir -p venv

#3. Clone the EML tools repository into your workspace
EMLTOOLSFOLDER=./eml-tools
if [ ! -d "$EMLTOOLSFOLDER" ] ; then
  git clone https://github.com/embedded-machine-learning/eml-tools.git "$EMLTOOLSFOLDER"
else 
  echo $EMLTOOLSFOLDER already exists
fi


#4. Create the task spooler script to be able to use the correct task spooler on the device. In our case, just copy
#./init_ts.sh

# Project setup
#1. Go to your project folder and clone the YoloV5 repository. Then rename it for your project.

cd eml_projects/
YOLOFOLDER=./yolov3-oxford-pets
if [ ! -d "$YOLOFOLDER" ] ; then
  git clone https://github.com/ultralytics/yolov3.git $YOLOFOLDER
else 
  echo $YOLOFOLDER already exists
fi
#mv yolov3 yolov3-oxford-pets

#2. Create a virtual environment for yolov5 in your venv folder. The venv folder is put outside of the project folder to 
#avoid copying lots of small files when you copy the project folder. Conda would also be a good alternative.
# From root
cd $ROOTFOLDER
cd ./venv
YOLOVENV=./yolov3_pv38
if [ ! -d "$YOLOVENV" ] ; then
  virtualenv -p python3.8 yolov3_pv38
  source yolov3_pv38/bin/activate

  # Install necessary libraries
  python -m pip install --upgrade pip
  pip install --upgrade setuptools cython wheel

  # Install yolov5 libraries
  cd ../eml_projects/yolov3-oxford-pets/
  pip install -r requirements.txt

  # Install EML libraries
  pip install lxml xmltodict tdqm beautifulsoup4 pycocotools

  # Install OpenVino libraries
  pip install onnx-simplifier networkx defusedxml
else 
  echo $YOLOVENV already exists
fi

# Activate YoloV3 environment
cd $ROOTFOLDER
source ./venv/yolov3_pv38/bin/activate

#3. Create a virtual environment for OpenVino 2021.4 in Python 3.6 as it does not cope with Python 3.8
# From root
cd ./venv
OPENVINOVENVFOLDER=openvino_py36
if [ ! -d "$OPENVINOVENVFOLDER" ] ; then
  virtualenv -p python3.6 openvino_py36
  source openvino_py36/bin/activate

  # Install necessary libraries
  python -m pip install --upgrade pip
  pip install --upgrade setuptools cython wheel

  # Install EML libraries
  pip install lxml xmltodict tdqm beautifulsoup4 pycocotools pandas absl-py

  # Install OpenVino libraries
  pip install onnx-simplifier networkx defusedxml progress requests
else 
  echo $OPENVINOVENVFOLDER already exists
fi
