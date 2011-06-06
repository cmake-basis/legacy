/** 
 * @file WriteMedicalImage_gateway.cpp
 * @brief Matlab mex gateway function
 * @author Kayhan Batmanghelich
 * @version 
 * @date 2011-06-02
 */

#include <memory>
using std::auto_ptr;

#include "mex.h" 

#include "WriteMedicalImagePipeline.h"

//    @MATLAB_FUNCTION_NAME@('filename',image,origin,spacing,'typename')
void mexFunction(int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
  // input argument check
  if ( (nrhs != 5) || 
      !mxIsChar(prhs[0]) ||
      !mxIsChar(prhs[4]))
    mexErrMsgTxt("Incorrect arguments, see 'help @MATLAB_FUNCTION_NAME@'");

  // prhs[0] : filename
  char* filepath = mxArrayToString(prhs[0]);
  
  //prhs[1] : image
  if (mxGetNumberOfDimensions(prhs[1]) != 3 )
  {
      mexErrMsgTxt("This function only supports 3-dimensional image !") ;
  }
  double dims[3] ;
  dims[0] = (double)(mxGetDimensions(prhs[1]))[0];
  dims[1] = (double)(mxGetDimensions(prhs[1]))[1];
  dims[2] = (double)(mxGetDimensions(prhs[1]))[2];

  const double *image = (const double *)(mxGetData(prhs[1])) ;

  //prhs[2] : origin
  if  (mxGetNumberOfElements(prhs[2]) != 3 )
  {
      mexErrMsgTxt("origin should be either 3-dimensional row or column vector !") ;
  }
  const double  *origin = (const double *)(mxGetData(prhs[2])) ; 

  //prhs[3] : spacing
  if (mxGetNumberOfElements(prhs[3]) != 3 )
  {
      mexErrMsgTxt("spacing should be either 3-dimensional row or column vector !") ;
  }
  const double  *spacing = (const double *)(mxGetData(prhs[3])) ; 

  //prhs[4] : typename
  char* pixelType = mxArrayToString(prhs[4]) ;
  if  ( (strcmp(pixelType,"uint8") != 0 ) &&
         (strcmp(pixelType,"uint16") != 0 ) &&
         (strcmp(pixelType,"float") != 0 )  &&
         (strcmp(pixelType,"double") != 0) )
  {
     mexErrMsgTxt("Incorrect argument for pixel Type !") ;
  } 

  try
    {
      if (strcmp(pixelType,"uint8")==0)
      {
        auto_ptr< WriteMedicalImagePipeline<unsigned char> > pipeline(new WriteMedicalImagePipeline<unsigned char>(filepath));
        pipeline->CopyAndTranspose(image,dims,origin,spacing);
      }
      else if (strcmp(pixelType,"uint16")==0)
      {
        auto_ptr< WriteMedicalImagePipeline<unsigned int> > pipeline(new WriteMedicalImagePipeline<unsigned int>(filepath));
        pipeline->CopyAndTranspose(image,dims,origin,spacing);
      }
      else if (strcmp(pixelType,"float")==0)
      {
        auto_ptr< WriteMedicalImagePipeline<float> > pipeline(new WriteMedicalImagePipeline<float>(filepath));
        pipeline->CopyAndTranspose(image,dims,origin,spacing);
      }
      else if (strcmp(pixelType,"double")==0)
      {
        auto_ptr< WriteMedicalImagePipeline<double> > pipeline(new WriteMedicalImagePipeline<double>(filepath));
        pipeline->CopyAndTranspose(image,dims,origin,spacing);
      }
      else
      {
         mexErrMsgTxt("Incorrect argument for pixel Type !") ;
      }
    }
  catch (std::exception& e)
    {
    mexErrMsgTxt(e.what());
    return;
    }
} 


