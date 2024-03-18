% CSCK505 Robotics 
% Author, Steve Dutton
% Kuka youBot Control Assignemnt

%Event enum to provide measningful callback codes to the onMove event 

classdef DirectionEnum < uint32
    enumeration
        Forward (1)
        Back (2)
        Left (4)
        Right (8)
        CrabRight (16)
        CrabLeft (32)
    end
end

