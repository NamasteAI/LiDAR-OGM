function onTrackOccupancy(app,callback)

    if(isempty(app.OccupancyGrid))
        app.OccupancyGrid = zeros(10 * app.OccupancyMagFactor,10 * app.OccupancyMagFactor);
        
    end

    function setGridColour(x,y, confidence)

        if(app.OccupancyGrid(x,y) >= 0.8)
            app.OccupancyGrid(x,y) = 0.8;
            return
        end
        app.OccupancyGrid(x,y) = confidence;

    end

    function setGrid(locX,locY)
        
        setGridColour(locX,locY,0.8);

        if( locX > 1 && locX < 10 && ...
            locY > 1 && locY < 10)

            setGridColour(locX,locY-1,0.32);
            setGridColour(locX-1,locY,0.32)
            setGridColour(locX-1,locY-1,0.32);

            setGridColour(locX,locY+1,0.32);
            setGridColour(locX+1,locY,0.32);
            setGridColour(locX+1,locY+1,0.32);
            
            setGridColour(locX-1,locY+1,0.32);
            setGridColour(locX+1,locY-1,0.32);

        end
    end

    
    function CheckCurrentLocation(timer,~)
        if(app.IsOccupancyRunning)
            [~,dst_1_1] = app.Simulator.simxGetFloatSignal(app.ClientId,'DISTANCE_1_1', app.Simulator.simx_opmode_streaming);
            [~,dst_5_5] = app.Simulator.simxGetFloatSignal(app.ClientId,'DISTANCE_5_5', app.Simulator.simx_opmode_streaming);
            [~,dst_1_10] = app.Simulator.simxGetFloatSignal(app.ClientId,'DISTANCE_1_10', app.Simulator.simx_opmode_streaming);
    
            if(dst_1_1 > 0)
                
                loc = onLocate(dst_1_1,dst_5_5,dst_1_10,app.CurrentLocation);
                app.CurrentLocation = loc
                
                % solver employed to resolve x,y
                locX = abs(app.OccupancyMagFactor * int32(loc(1)));
                locY = abs(app.OccupancyMagFactor * int32(loc(2)));
                                
                % Protect the index array base of 1
                locX  = int32((locX >= 1)) * locX + int32(~(locX >= 1)) * 1;
                locY  = int32((locY >= 1)) * locY + int32(~(locY >= 1)) * 1;
                setGrid(locX,locY);
            end
            fireCallback(callback,app);
        end
    end

    if(isempty(app.OccupancyTimer))
        app.OccupancyTimer  = timer;
        app.OccupancyTimer.TimerFcn = @CheckCurrentLocation;
        app.OccupancyTimer.Period = 0.25;
        app.OccupancyTimer.ExecutionMode = 'fixedRate';
    end

    app.IsOccupancyRunning = ~app.IsOccupancyRunning;

    if(app.IsOccupancyRunning)
        start(app.OccupancyTimer)
    else
        stop(app.OccupancyTimer)
        fireCallback(callback,app);
    end
end
