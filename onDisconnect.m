function onDisconnect(app,callBack)
    app.Simulator.delete();
    app.ClientId = -1;
    app.CurrentStatus.Connected = false;
    disp("All connections closed");
    app.Simulator.delete();
    if(~isempty(callBack))
          callBack(app,[])  
    end
end
