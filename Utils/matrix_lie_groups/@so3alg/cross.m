function element_so3 = cross(phi)
%WEDGE The cross (expansion) operator for so3.  Another name for the wedge
%operator, specific to this group.  Just call wedge().
% From Section 5.1 of the DECAR IEKF doc. 
%
% PARAMETERS
% ----------
% phi : [3 x 1] double
%     The R^3 parameterization of an element of so3 (rotation matrix).
%
% RETURNS
% -------
% element_so3 : [3 x 3] double
%     An element of so3.
% -------------------------------------------------------------------------
    element_so3 = so3alg.wedge(phi);
end

