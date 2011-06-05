/** 
 * @file MainPipeline.h
 * @brief Creates and executes the ITK pipeline
 * @author Matthew McCormick (thewtex)
 * @version 
 * @date 2009-07-01
 */

#ifndef _WRITEMEDICALIMAGEPIPELINE_H
#define _WRITEMEDICALIMAGEPIPELINE_H

#include "itkImageFileWriter.h"
#include "itkImage.h"

#include <iostream>

template <typename PixelType>
class WriteMedicalImagePipeline
{
public:
  WriteMedicalImagePipeline(char* filepath);


  /** 
   * @brief Creates and copies the resulting image and its location information to the given
   * double pointers.  Transpose to address C/Fortran column/row memory
   * ordering.
   * 
   * @param image
   * @param origin
   * @param spacing
   */
  void CopyAndTranspose(const double* image, double* dims, const double *origin, const double *spacing);

  /** 
   * @brief get the size of the transposed output image
   * 
   * @param m rows 
   * @param n columns 
   */

  // main itk types
  //typedef double PixelType;
  const static unsigned int Dimension = 3;
  typedef typename itk::Image<PixelType, Dimension> ImageType;

protected:
  // filter types
  typedef typename itk::ImageFileWriter<ImageType> WriterType;
  typename WriterType::Pointer m_writer;

  char* m_filepath;
  double m_spacing[3] ;
  double m_origin[3] ;

};

#endif // _WRITEMEDICALIMAGEPIPELINE_H
