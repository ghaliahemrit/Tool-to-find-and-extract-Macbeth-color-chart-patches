Run the files in this order:
1. raw2tiff.bat convert the camera Raw images to .tiff without further processing.
2. filelist.bat writes the list of images names in a .txt file.
3. RuntheMethod calculates the illuminant colour from the ColoChecker placed in your image, and saves other data.

Note if you are a Linux user then you need to install the appropriate 
package to run windows batch files.

Outputs are:
* png images after demosaicing
* png images of the cropped and 'untransformed' selection of the chart 
* white_points contains: 
  a.RGB white points
  b.Normalised rgb white points 
  c.Average RGB of every patch 
* coordinates contains:
  a.Rectangle selection, 
  b.Coordinates in the selection 
  c.Coordinates in the whole image 
* The chart slections parameters in cc_struct files 