function [ quantized_data ] = quantize(x,bit_number)
%quantize input data using bit_number bits

quantized_data=[];
for i=1:lenght(x)
    current_x=x(i);
    bit_encoding=get_bit_encoding(current_x);
    
end


quantized_data=x;
end

