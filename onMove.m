% CSCK505 Robotics 
% Author, Steve Dutton
% Kuka youBot Control Assignemnt

% control callback for weheels

function onMove(app, direction)


    velocity = 4
    turnVelocity = 0.3
    velocityStop = 0

    % tranform matricies for the rotation and direction of the wheels
    transformF =  [1,1]
    transformR =  [1,-1]
    transformL =  [-1,1]
    transformB =  [-1,-1]

    sim = app.Simulator;
    cid = app.ClientId
    handles = app.Handles.Wheels

    switch direction
        case DirectionEnum.Forward
            SetDirection(sim,cid,handles,velocity,transformF);
            pause(2)
        case DirectionEnum.Back
            SetDirection(sim,cid,handles,velocity,transformB);
            pause(2)
        case DirectionEnum.Left
            SetDirection(sim,cid,handles,turnVelocity,transformL);
            pause(0.5)
        case DirectionEnum.Right
            SetDirection(sim,cid,handles,turnVelocity,transformR);
            pause(0.5)
    end
    
    SetDirection(sim,cid,handles,velocityStop,transformF);
end

% matricies mutiplied by velicity here
function SetDirection(sim,clientId, handles, velocity, transform)
    tVec = velocity * transform
    onSetJointTargetVelocity(sim,clientId,handles(1),tVec(1,1))
    onSetJointTargetVelocity(sim,clientId,handles(2),tVec(1,2))
end

% set the api calls
function onSetJointTargetVelocity(sim, clientId,handle,velocity)
   sim.simxSetJointTargetVelocity(clientId,handle,velocity,sim.simx_opmode_oneshot);
end
