n = 0;

state = true;
while state
    while true
        n = n+1;
        if n ==2
            break
        end
        if n==3
            state = false;
            break
        end
    end
    disp('hallo')
end