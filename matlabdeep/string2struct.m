function outputform = string2struct(outputmode)

outputform = [];
for I=1:length(outputmode)
    outputform.(outputmode(I)) = I;
end
