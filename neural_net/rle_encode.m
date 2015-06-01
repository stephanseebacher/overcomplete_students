
function rle_code = rle_encode(a)

n = 1;
for k=1:length(a)-1 
    if a(k)~=a(k+1) 
        n=n+1; 
    end 
end

rle_code=ones(1,n+1);
rle_code(1)=a(1); 
m=2; 
for i=1:k 
    if a(i)==a(i+1) 
        rle_code(m)= rle_code(m)+1; 
    else
        m=m+1;
    end 
end 
