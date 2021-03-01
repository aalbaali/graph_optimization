function phi = decompose(element_so3)
%DECOMPOSE Break element of so3 up into its constituent parts. 
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% element_so3 : [3 x 3] double
%     An element of so3.
%
% RETURNS
% -------
% phi : [3 x 1] double
%     Rotation vector.
% -------------------------------------------------------------------------
    if so3alg.isValidElement(element_so3)
        phi = [element_so3(3, 2), element_so3(1, 3), element_so3(2, 1)].';
    end
end

