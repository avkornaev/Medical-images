The red blood cells mechanical properties may indicate a healthy or diseased state of an organism. Modern equipment for video recording and processing allows the red blood cells motion and deformation observation in vessels in real-time mode. Obviously, real-time in-vivo health condition monitoring is a promising method. The paper deals with processing data obtained using nailfold high-speed videocapillaroscopy. To detect the red blood cells speed two approaches are used. The deterministic approach is based on pixel intensities analysis for object detection and calculation of the red blood cells displacement and velocity in a vessel. The obtained data formulate targets for machine learning. The stochastic approach is based on a sequence of artificial neural networks. The semantic segmentation network "UNet" is used for vessel detection. Then, the classification network "GoogleNet" is used as a feature extractor to convert masked frames of a video to a sequence of feature vectors. And finally, the long short-term memory network is used to approximate the red blood cells velocity.

The repository includes 3 main tasks.

The "Task1_FramesCropping" is connected with frames preprocessing. An input frame of 800x800 transforms to 224x224 by cropping with rectangle of a specific size and position. The programm has some additional options: clustering, imitation of 3 layers, images adjusting. Obtained frames are used in the next task.
A part of the dataset of initial frames is available here:

The "Task2_SemanticSegmentation" is also connected with images preprocessing. The semantic segmentation is applied to highlight the regions of 3 vessels in an image. The MATLAB Image Labeler app is used. Obtained images are used in the next task.
The dataset of initial frames is available here:

The "Task3_Fitting" is the processor. The task includes 2 subtasks.
The 'Task3_1_FeatureExtracion.m' programm converts frames to feature vector and generates dataset for the fitting. The feature vectors are the output of the activations function on the last pooling layer of the GoogLeNet network [https://www.mathworks.com/help/deeplearning/ug/classify-videos-using-deep-learning.html]. Then, the programm 
The 'Task3_2_VelFitting.m' programm





