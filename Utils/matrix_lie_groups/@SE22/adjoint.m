function adj_SE22 = adjoint(element_SE22)
%ADJOINT Return the adjoint representation of the SE22 element.
%
% PARAMETERS
% ----------
% element_SE22 : [4 x 4] double
%     An element of SE22.
%
% RETURNS
% -------
% adj_SE22 : [5 x 5] double
%     The adjoint representation of the SE22 element.
% -------------------------------------------------------------------------
    adj_SE22 = [];
    if SE22.isValidElement(element_SE22)
        [C, v, r] = SE22.decompose(element_SE22);
        omega = [0, -1; 1, 0];
        adj_SE22 = [ 1, zeros(1, 4)           ;
                    -omega * v, C, zeros(2)   ;
                    -omega * r, zeros(2), C  ];
    end
end

