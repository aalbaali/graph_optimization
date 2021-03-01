% Got answer from
% https://www.mathworks.com/matlabcentral/answers/240447-using-java-uuid-in-matlab#answer_191523
function uuid = generateUUID()
    %GENERATEUUID generates a universal unique identifier.
    uuid = java.util.UUID.randomUUID;
end