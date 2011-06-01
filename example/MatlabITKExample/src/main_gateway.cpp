/** 
 * @file main_gateway.cpp
 * @brief Matlab mex gateway function
 * @author Matthew McCormick (thewtex)
 * @version 
 * @date 2009-07-01
 */

#include <memory>
using std::auto_ptr;

#include "mex.h" 

#include "MainPipeline.h"


void mexFunction(int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{
  // input argument check
  if (nrhs < 1 || 
    nrhs > 2 ||
    !mxIsChar(prhs[0]) ||
    (nrhs == 2 && !mxIsNumeric(prhs[1])) )
    mexErrMsgTxt("Incorrect arguments, see 'help @MATLAB_FUNCTION_NAME@'");

  char* filepath = mxArrayToString(prhs[0]);
  // we will use Matlab counting, i.e. start from 1 instead of 0
  unsigned int slice = 1;
  if (nrhs > 1)
    slice = static_cast<unsigned int>(*mxGetPr(prhs[1]));

  try
    {
    auto_ptr<MainPipeline> pipeline(new MainPipeline(filepath, slice));
    size_t m, n, s;
    pipeline->GetSize(m, n, s);
    if(slice > s || slice < 1)
      mexErrMsgTxt("Invalid slice specified.");

    plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
    double* image = mxGetPr(plhs[0]);
    double* origin=0, *spacing=0;
    switch(nlhs)
      {
    case 1:
      pipeline->CopyAndTranspose(image);
      break;
    case 2:
      plhs[1] = mxCreateDoubleMatrix(3, 1, mxREAL);
      origin = static_cast<double*>(mxGetPr(plhs[1]));
      pipeline->CopyAndTranspose(image, origin);
      break;
    case 3:
      plhs[1] = mxCreateDoubleMatrix(3, 1, mxREAL);
      origin = static_cast<double*>(mxGetPr(plhs[1]));
      plhs[2] = mxCreateDoubleMatrix(3, 1, mxREAL);
      spacing = static_cast<double*>(mxGetPr(plhs[2]));
      pipeline->CopyAndTranspose(image, origin, spacing);
      break;
    default:
      mexErrMsgTxt("Incorrect output arguments.  See 'help @MATLAB_FUNCTION_NAME@'.");
      }
    }
  catch (std::exception& e)
    {
    mexErrMsgTxt(e.what());
    return;
    }
} 

