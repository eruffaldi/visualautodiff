function r = mallindex(shape)

if length(shape) == 2
    r = zeros(shape);
    for I=1:shape(1)
        for J=1:shape(2)
            r(I,J) = I*10+J;
        end
    end
elseif length(shape) == 4
    r = zeros(shape);
    for I=1:shape(1)
        for J=1:shape(2)
            for I2=1:shape(3)
                for J2=1:shape(4)
                    r(I,J,I2,J2) = 1000*I+J*100+I2*10+J2;
                end
            end
        end
    end
elseif length(shape) == 3
    r = zeros(shape);
    for I=1:shape(1)
        for J=1:shape(2)
            for I2=1:shape(3)
                    r(I,J,I2) = 100*I+J*10+I2;
            end
        end
    end
else
    error('unsupported size');
end