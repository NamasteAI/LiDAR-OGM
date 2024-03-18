function onConnect(app,callBack)
    %Bind remote API
    app.Simulator=remApi('remoteApi');
    app.Simulator.simxFinish(-1);
    app.ClientId =app.Simulator.simxStart(app.IP,app.Port,true,true,3000,5);
    
    function [hArray] = getHandles(local_sim,cid,names)
        handleArray = []
        for i=1:numel(names)
            joint = char(names(i));
            [~,handleArray(i)] = local_sim.simxGetObjectHandle(cid ,joint, local_sim.simx_opmode_blocking);
        end
        hArray = handleArray
    end

    if(app.ClientId >-1 )
        rollingJointNames=["leftWheel","rightWheel"]
        lidarSensors =["./ptCloud"]
        app.Handles.Wheels = getHandles(app.Simulator, app.ClientId, rollingJointNames);
        app.Handles.PointCloud = getHandles(app.Simulator, app.ClientId, lidarSensors);
        app.CurrentStatus.Connected=true;
        fireCallback(callBack, app)
    else
        app.CurrentStatus.Connected=false;
        fireCallback(callBack, app)
    end
end



