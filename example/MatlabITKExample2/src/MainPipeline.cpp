#include "MainPipeline.h"

MainPipeline::MainPipeline(char* filepath, unsigned int slice):
  m_filepath(filepath),
  m_slice(slice)
{
  m_reader = ReaderType::New();
  m_reader->SetFileName(filepath);
  
  m_roi_filter = ROIType::New();
  m_reader->UpdateOutputInformation();
  m_roi_filter->SetInput(m_reader->GetOutput());
  ImageType::RegionType in_region = m_reader->GetOutput()->GetLargestPossibleRegion();
  ImageType::SizeType size = in_region.GetSize();
  ImageType::IndexType index = in_region.GetIndex();
  // we only extract one slice because Matlab has memory consumption issues
  size[2] = 1;
  index[2] = slice - 1;
  ImageType::RegionType desired_region;
  desired_region.SetSize(size);
  desired_region.SetIndex(index);
  m_roi_filter->SetRegionOfInterest(desired_region);
}

void MainPipeline::CopyAndTranspose(double* image, double* origin, double* spacing)
{
  m_roi_filter->Update();
  ImageType::Pointer itk_image = m_roi_filter->GetOutput();
  ImageType::RegionType region = itk_image->GetLargestPossibleRegion();
  ImageType::SizeType size = region.GetSize();
  typedef itk::ImageRegionConstIterator<ImageType> ConstIteratorType;
  ConstIteratorType imageIt(itk_image, region);
  unsigned int count = 0;
  for (imageIt.GoToBegin(); 
    !imageIt.IsAtEnd(); 
    ++imageIt, count++)
    {
    image[(count % size[0])*size[1] + count/size[0]] = imageIt.Value();
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


void MainPipeline::GetSize(size_t& m, size_t& n, size_t& s)
{
  m_reader->UpdateOutputInformation();
  ImageType::SizeType size = m_reader->GetOutput()->GetLargestPossibleRegion().GetSize();
  m = size[1];
  n = size[0];
  s = size[2];
}
