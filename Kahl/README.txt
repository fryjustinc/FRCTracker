For Hough Transforms:

Run "hough_stough.m"
-->Uses the following functions:
	-clean_mask_hough.m
	-drawParallelLines.m
-->Uses images from the directory:
	-"/pix"

-->Input: Change the image name at the beginning of the file to change input
-->Output: Uses imshow to show masks and results
	



For image subtraction:

Run "imsubtract.m"
-->Uses the following class:
	-Image.m
-->Uses the following functions:
	-clean_mask_imsubtract.m
	-bounding_box.m
-->Uses images from directory:
	-"/QF2-1_5160-5240"
	-Can be changed in the code

-->Input: Images from specified directory, numbered consecutively
-->Outputs: 
	-Saves bounding boxed images to directory "/boxed"
	-Saves centroid information to "centroids.mat"
	--> Format for each row:
		<centroid_row> <centroid_col> <frame_number>
		

		
To track the robot and output the tracks

Run "tracking.m"
--> Uses centroids.mat (output of imsubtract.m or svm)
--> Requires a folder name "filtered_imgs" to be created in the directory
	- Used for saving images with overlaid centroids

--> Outputs
	- Images into filtered_imgs folder
	- A clip of the robots and their tracks (filtered.avi)