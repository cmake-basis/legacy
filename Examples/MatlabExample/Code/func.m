%  a function doing something
function func(n)
      D = rand(n) ;
      fprintf('this is a matrix : \n') ;
      D
      fprintf('and here is the SVD of the matrix: \n')
      [U,S,V] = svd(D) 
end


