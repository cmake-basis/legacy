/** 
 * @file MainPipeline.h
 * @brief Creates and executes the ITK pipeline
 * @author Matthew McCormick (thewtex)
 * @version 
 * @date 2009-07-01
 */

#ifndef _MAINPIPELINE_H
#define _MAINPIPELINE_H

#include "itkImageFileReader.h"
#include "itkRegionOfInterestImageFilter.h"

class MainPipeline
{
public:
  MainPipeline(char* filepath, unsigned int slice=0);


  /** 
   * @brief Creates and copies the resulting image and its location information to the given
   * double pointers.  Transpose to address C/Fortran column/row memory
   * ordering.
   * 
   * @param image
   * @param origin
   * @param spacing
   */
  void CopyAndTranspose(double* image, double* origin=0, double* spacing=0);

  /** 
   * @brief get the size of the transposed output image
   * 
   * @param m rows 
   * @param n columns 
   */
  void GetSize(size_t& m, size_t& n, size_t& s);

  // main itk types
  typedef double PixelType;
  const static unsigned int Dimension = 3;
  typedef itk::Image<PixelType, Dimension> ImageType;

protected:
  // filter types
  typedef itk::ImageFileReader<ImageType> ReaderType;
  ReaderType::Pointer m_reader;
  typedef itk::RegionOfInterestImageFilter<ImageType, ImageType> ROIType;
  ROIType::Pointer m_roi_filter;

  char* m_filepath;
  unsigned int m_slice;

};

#endif // _MAINPIPELINE_H
