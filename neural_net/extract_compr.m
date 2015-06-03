function [ extracted_data ] = extract_compr( compressed_data,number_bits,quanitization_bits)
%EXTRACT_COMPR Summary of this function goes here
% %decode quantized data

extracted_data=[];
j=1;
i=0;
%actual bits read for next decoded value
bits_read='';
while (i<number_bits)
    %read next int from compressed_data
    current_c=compressed_data(j);
    j=j+1;
    %read next bits
    for y=1:8
        bits_read= [ bits_read num2str(bitget(current_c,y))];
        if(length(bits_read)==quanitization_bits)
            %get decoding value
            extracted_data(end+1)=double(get_bit_decoding(bits_read,quanitization_bits));
            bits_read='';
        end
        i=i+1;
        if (i>number_bits)
            break
        end
    end
    
    
end


end

