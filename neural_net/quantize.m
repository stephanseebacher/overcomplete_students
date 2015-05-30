function [ quantized_data ] = quantize(x,bit_number)
%quantize input data using bit_number bits

bit_array=[];
for i=1:length(x)
    bit_array=[bit_array get_bit_encoding(x(i),bit_number)];
end

%now stores bit array in uint8 var
quantized_data=[];
i=1;
while ( i<=length(bit_array))
    %take new int8 number
    cur_int=int8(0);
    for j=1:8
        %if 1 set bit
        if(str2num(bit_array(i)))
            tmp=bitset(cur_int,j);
            cur_int=int8(tmp);
        end
        i=i+1;
        if (i>length(bit_array))
            break
        end
    end
    quantized_data=[quantized_data cur_int];
end

end

