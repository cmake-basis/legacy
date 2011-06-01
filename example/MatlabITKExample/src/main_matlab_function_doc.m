% Import any image format supported by ITK into Matlab.
%
% Usage:
%   [image, origin, spacing] = @MATLAB_FUNCTION_NAME@('filename', slice)
% or
%   [image, origin, spacing] = @MATLAB_FUNCTION_NAME@('filename')
%      grabs first slice/frame, (assumes slice=0)
% or 
%   image = @MATLAB_FUNCTION_NAME@('filename', slice)
%
% image is a 2D image out of a possibly 3D image 
% 'filename' is the path to an image readable by ITK
% 
% Matt McCormick (thewtex) <matt@mmmccormick.com>
