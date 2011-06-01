/** 
 * @file SliceCountPipeline.h
 * @brief Creates and executes the ITK pipeline
 * @author Matthew McCormick (thewtex)
 * @version 
 * @date 2009-07-01
 */

#ifndef _SLICECOUNTPIPELINE_H
#define _SLICECOUNTPIPELINE_H

#include "itkImageFileReader.h"

class SliceCountPipeline
{
public:
  SliceCountPipeline(char* filepath);

  void GetSlices(double* s);

  // main itk types
  typedef double PixelType;
  const static unsigned int Dimension = 3;
  typedef itk::Image<PixelType, Dimension> ImageType;

protected:
  // filter types
  typedef itk::ImageFileReader<ImageType> ReaderType;
  ReaderType::Pointer m_reader;

  char* m_filepath;
};

#endif // _SLICECOUNTPIPELINE_H
