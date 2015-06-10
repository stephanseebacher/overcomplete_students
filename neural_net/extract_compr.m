function [ extracted_data ] = extract_compr( compressed_data,number_bits_encoded,quanitization_bits)
% decode quanitized data into an array of double corresponding to decoded
% unquanitized data.

% preallocate extracted_data
extracted_data=zeros(number_bits_encoded/quanitization_bits,1);
%counter for int var in compressed_data
j=1;
%nunmber of bits read so far
i=0;
%actual bits read for next decoded value
bits_read=char(zeros(1,quanitization_bits));
%counter for next positon in bits_read
b=1;
%counter for extracted data
counter_extracted_data=1;
while (i<number_bits_encoded)
    %read next int from compressed_data
    current_c=compressed_data(j);
    j=j+1;
    %read next bits
    for y=1:8
        bits_read(b)= num2str(bitget(current_c,y));
        if(b==quanitization_bits)
            %get decoding value
            extracted_data(counter_extracted_data)=double(get_bit_decoding(bits_read,quanitization_bits));
            counter_extracted_data=counter_extracted_data+1;
            % reinitialize current bits_read
            bits_read=char(zeros(1,quanitization_bits));
            b=0;
        end
        b=b+1;
        i=i+1;
        % if number_bits_encoded are read then done!
        if (i==number_bits_encoded)
            break
        end
    end
    
    
end


end

