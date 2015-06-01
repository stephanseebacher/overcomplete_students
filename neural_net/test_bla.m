function extracted_data = test_bla( compressed_data,number_bits,quanitization_bits)

extracted_data=[];
j=1;
i=0;
%actual bits read for next decoded value
bits_read=[];
while (i<number_bits)
    %read next int from compressed_data
    current_c=compressed_data(j);
    j=j+1;
    if (j==20)
        dir;
    end
    %read next bits
    for y=1:8
        bits_read= [ bits_read (bitget(current_c,y))];
        if(length(bits_read)==quanitization_bits)
            %get decoding value
            extracted_data=[extracted_data bits_read];
            bits_read=[];
        end
        i=i+1;
        if (i==number_bits)
            break
        end
    end



end



end

