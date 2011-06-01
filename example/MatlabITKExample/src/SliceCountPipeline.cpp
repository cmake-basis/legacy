#include "SliceCountPipeline.h"

SliceCountPipeline::SliceCountPipeline(char* filepath):
  m_filepath(filepath)
{
  m_reader = ReaderType::New();
  m_reader->SetFileName(filepath);
}

void SliceCountPipeline::GetSlices(double* s)
{
  m_reader->UpdateOutputInformation();
  ImageType::SizeType size = m_reader->GetOutput()->GetLargestPossibleRegion().GetSize();
  *s = static_cast<double>(size[2]);
}
