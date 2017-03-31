function [out]=bilinear_interpolate(x_len, x_array, y_len, y_array, f, x, y, delta)

% This function uses bilinear interpolation to estimate the value
% of a function f at point (x,y)
% f is assumed to be sampled on a regular grid, with the grid x
% values specified
% by x_array and the grid y values specified by y_array
% Reference: http://en.wikipedia.org/wiki/Bilinear_interpolation

i = binarysearch(x_len, x_array, x, delta);
j = binarysearch(y_len, y_array, y, delta);

x1 = x_array(i);
x2 = x_array(i+1);

y1 = y_array(j);
y2 = y_array(j+1);
        
denom = (x2 - x1)*(y2 - y1);

out = (f(i,j)*(x2-x)*(y2-y) + f(i+1,j)*(x-x1)*(y2-y) + ...
     f(i,j+1)*(x2-x)*(y-y1) + f(i+1, j+1)*(x-x1)*(y-y1))/denom;
