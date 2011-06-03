#include "ReadMedicalImagePipeline.h"

ReadMedicalImagePipeline::ReadMedicalImagePipeline(char* filepath):
  m_filepath(filepath)
{
  m_reader = ReaderType::New();
  m_reader->SetFileName(filepath);
  
  m_reader->UpdateOutputInformation() ;  
}

void ReadMedicalImagePipeline::CopyAndTranspose(double* image, double* origin, double* spacing)
{
  //m_roi_filter->Update();
  m_reader->Update() ;
  ImageType::Pointer itk_image = m_reader->GetOutput();
  ImageType::RegionType region = itk_image->GetLargestPossibleRegion();
  ImageType::SizeType size = region.GetSize();
  typedef itk::ImageRegionConstIterator<ImageType> ConstIteratorType;
  ConstIteratorType imageIt(itk_image, region);
  unsigned long int count = 0;
  for (imageIt.GoToBegin(); 
    !imageIt.IsAtEnd(); 
    ++imageIt, count++)
    {
       // Kayhan: I hate C to FORTRAN conversion (or otherway around) !
       unsigned long int deptIdx = count/(size[0]*size[1]) ;
       unsigned long int rowIdx  = (count % (size[0]*size[1]))/size[0] ;
       unsigned long int colIdx = (count % (size[0]*size[1])) % size[0] ;
    
       image[ rowIdx + colIdx*size[1] + deptIdx*(size[0]*size[1]) ] = imageIt.Value() ;
    }

  if (origin != 0)
    {
    ImageType::PointType itk_origin = itk_image->GetOrigin();
    origin[0] = static_cast<double>(itk_origin[1]);
    origin[1] = static_cast<double>(itk_origin[0]);
    origin[2] = static_cast<double>(itk_origin[2]);
    }

  if (spacing != 0)
    {
    ImageType::SpacingType itk_spacing = itk_image->GetSpacing();
    spacing[0] = static_cast<double>(itk_spacing[1]);
    spacing[1] = static_cast<double>(itk_spacing[0]);
    spacing[2] = static_cast<double>(itk_spacing[2]);
    }
}


void ReadMedicalImagePipeline::GetSize(size_t& m, size_t& n, size_t& s)
{
  m_reader->UpdateOutputInformation();
  ImageType::SizeType size = m_reader->GetOutput()->GetLargestPossibleRegion().GetSize();
  m = size[1];
  n = size[0];
  s = size[2];
}
