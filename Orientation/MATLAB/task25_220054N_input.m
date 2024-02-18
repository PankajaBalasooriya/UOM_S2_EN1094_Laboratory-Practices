q = input("Enter Array1:");
c = input("Enter Array2:");


try
    result = compareArrays(q, c)
catch ME
    fprintf('Error: %s\n', ME.message);
    result = NaN;
end