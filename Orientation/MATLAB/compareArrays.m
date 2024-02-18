function outputArray = compareArrays(arr1, arr2)
if all(size(arr1) == size(arr2))
    outputArray = (arr1 == arr2);
else
    outputArray = [];
    error("Input Arrays must have the same dimensions.")
end
end
