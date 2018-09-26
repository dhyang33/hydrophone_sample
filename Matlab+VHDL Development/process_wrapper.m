function process_wrapper()
    for x = 0:10000000 
        x1 =randi([0,4095]);
        x2 =randi([0,4095]);
        x3 =randi([0,4095]);
        x4 =randi([0,4095]);
        [a b c] = hydrophones(x1,x2,x3,x4);
    end
end
