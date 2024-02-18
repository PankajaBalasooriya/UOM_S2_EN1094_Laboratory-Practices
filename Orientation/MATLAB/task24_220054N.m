randomArray = randi([50, 100],5 , 10);

tic;

sineVal_Vectorization = sin(randomArray);
Vectorization_Time = toc;


sineVal_loop = zeros([size(randomArray)]);

tic;
for j = 1:1:length(randomArray)
    for i = 1:1:size(randomArray)
        sineVal_loop(i, j) = sin(randomArray(i, j));
    end
end
loop_Time = toc;

sineVal_Vectorization
Vectorization_Time
sineVal_loop
loop_Time