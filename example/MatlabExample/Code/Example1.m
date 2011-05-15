function main (what, expnum, MatSize)
%
% SYNTAX:
% main (what, expnum, MatSize)
%
% what     - 'learn' or 'show' or 'FeatureExtr' 
% expnum   - experiment number code 
% MatSize  - define a size for a matrix
% 
% NOTE: this file is intended to be run in the stand alone manner

if (nargin < 3)
  usage() ;
  exit(1) ;
elseif (nargin == 3)  % show            
  fprintf('expnum is : %d',expnum);
  if isdeployed()
    MatSize = str2num(MatSize);
  end
  func (MatSize);
end

end % function main ()

% ****************************************************************************
function usage ()
    fprintf(' SYNTAX:\n');
    fprintf('main ( what, expnum, MatSize); \n');
    fprintf(' \n');
    fprintf(' what                  - "learn" or "show" or "FeatureExtr" \n') ;
    fprintf(' expnum                - experiment number code  \n') ;
    fprintf(' MatSize               - Matrix size \n') ;
    fprintf('\n') ;
    fprintf(' NOTE: this file is intended to be run in the stand alone manner \n') ;
end % function usage ()

