function onLidar(app,callback)

    function addScanToSlam(cart)
        if(~isempty(cart))
            if(numel(app.LidarScans) < app.LidarScansMax)
                scan = lidarScan(cart);
                app.LidarScans{end + 1} = scan;
                app.LidarScansCount = app.LidarScansCount + 1;
            end
        end
    end

    function LidarScanAndPosition(~,~)
        [~,dataPacket] = app.Simulator.simxReadStringStream(app.ClientId,'DATA_PACKET', app.Simulator.simx_opmode_streaming);
        app.Simulator.simxClearStringSignal(app.ClientId,'DATA_PACKET',app.Simulator.simx_opmode_oneshot);

        points = app.Simulator.simxUnpackFloats(dataPacket);
        points = reshape(points,3,size(points,2)/3);
        
        points = [points(1,:) ; (points(2,:) .* -1); (points(3,:))]; %flip points around the y axis
        xCoords = [points(1,:)];
        yCoords = [(points(2,:) .* -1)];
        cart = [xCoords(1:10:end)', yCoords(1:10:end)'];

        addScanToSlam(cart);
        app.MappingPoints = points;
        if(~isempty(app.MappingPoints))
            fireCallback(callback,app);
        end
    end
    
    if(isempty(app.LidarTimer))
        app.LidarTimer  = timer;
        app.LidarTimer.TimerFcn = @LidarScanAndPosition;
        app.LidarTimer.Period = 1;
        app.LidarTimer.ExecutionMode = 'fixedRate';
    end

     if(isempty(app.IsLidarRunning))
        app.IsLidarRunning = false;
    end
    
    app.IsLidarRunning = ~app.IsLidarRunning;

    if(app.IsLidarRunning)
        start(app.LidarTimer)
    else
        stop(app.LidarTimer)
        fireCallback(callback,app);
    end

    if(isempty(app.LidarSlam))
        app.LidarSlam = lidarSLAM(app.LidarResolution, app.LidarRange);
        app.LidarSlam.LoopClosureThreshold = 15;  % Adjust based on your requirements
        app.LidarSlam.LoopClosureSearchRadius = 8; % Adjust based on your requirements
        
    end
end







