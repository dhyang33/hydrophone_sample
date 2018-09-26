function same()
buf_size = 10;
%PARSE_HYDROPHONES Parse hydrophone data stored in .log files
file = fopen("hydrolog1.txt");

%Create variables to return
data=[];
data1=[]

for i=1:buf_size*4
    nib = fread(file,1,'*char');
    switch nib
        case 0
            data0(mod((i-1),buf_size)+1) = fread(file,1,'ubit12',0,'b');
        case 1
            data1(mod((i-1),buf_size)+1) = fread(file,1,'ubit12',0,'b');
    end
end