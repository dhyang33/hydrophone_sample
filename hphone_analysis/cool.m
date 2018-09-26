function cool()
    N = 10000000;
    file = fopen('dolphinpool.txt','r');

    %Create variables to return
    data0=[];
    data1=[];
    total = fread(file,'*char');
    total = total(1:N);
    k0 = 0;
    k1 = 0;
    x = 0;
    for i = 1:N
        switch total(i)
            case " "
                data0 = [data0 x];
        end
        x = x*10 + str2double(total(i));
    end
    fft(data0);
    fft(data1);
    Fs = 100000;
    T=1/Fs;
    t0 = (0:k0-1)*T;
    Y = fft(data0);
    P2 = abs(Y/k0);
    P1 = P2(1:k0/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(k0/2))/k0;
    data0 = data0(70000:90000);
    fclose(file);
    plot(data0); 
end
