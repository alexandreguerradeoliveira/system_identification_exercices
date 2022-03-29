function [R,h] = intcor(u,y)
    % find M 
    M =size(u,1);
    if(size(u,1)~=size(y,1))
        error("u and y do not have the same size");
    end
    
    % calculate h vector
    h = 0:M-1;

    % calculate R(h)
    R = zeros(size(h));
    for j = h
       y_shifted = [y(M-j+1:M);y(1:M-j)]; % we shift y by h: y(k-h)
       components = u.*y_shifted; % components to be summed over to get R(h): u(k)*y(k-h)
      
       R(j+1) = sum(components)/M;
    end
end