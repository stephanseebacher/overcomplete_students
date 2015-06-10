function [ quanitized_data ] = quanitize(x,quanitization_bits)
%quanitize input data using quanitization_bits bits

%first get encoding for each value in array x and stores it in a char
%array.
bit_array=char(zeros(length(x)*quanitization_bits,1));
j=1;
for i=1:length(x)
    bit_array(j:(j+quanitization_bits-1))=get_bit_encoding(x(i),quanitization_bits);
    j=j+quanitization_bits;
end

%now store the char array at the bit level continuously in int8 variables to maximize compression
quanitized_data=int8(zeros(1,ceil(length(x)*quanitization_bits/8))); %8 because int8 used!
i=1;
%counter for uint8 vars used
t=1;
while ( i<length(bit_array))
    %take new int8 number
    cur_int=int8(0);
    for j=1:8
        %if 1 set bit
        if(str2double(bit_array(i)))
            tmp=bitset(cur_int,j);
            cur_int=int8(tmp);
        end
        i=i+1;
        % stop if everyting encoded
        if (i>length(bit_array))
            break
        end
    end
    quanitized_data(t)=cur_int;
    t=t+1;
end

end

