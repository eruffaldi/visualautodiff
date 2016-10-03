function autosizeme(x,asked)


%asked = max(1,get_param(gcb,'Inputs'));

bcon = [x '/Matrix Concatenate'];
actual = str2num(get_param(bcon,'NumInputs'));

if asked == actual
    return
end

bconL = bcon(length(gcs)+2:end);

if asked > actual
    set_param(bcon,'NumInputs',num2str(asked));
    bin1 = ([x '/In1']);
    bsh1 = ([x '/Reshape1']);
    bin1L = bin1(length(x)+2:end);
    bsh1L = bsh1(length(x)+2:end);
    for I=actual+1:asked
        bin = sprintf([x '/In%d'],I);
        bsh = sprintf([x '/Reshape%d'],I);
        binL = bin(length(x)+2:end);
        bshL = bsh(length(x)+2:end);
        % clone In and Reshape
        add_block(bin1,bin);
        add_block(bsh1,bsh);
        add_line(gcs,[binL '/1'],[bshL '/1']);
        add_line(gcs,[bshL '/1'],[bconL sprintf('/%d',I)]);
    end
else
    % remove
    for I=actual:-1:asked+1
        bin = sprintf([x '/In%d'],I);
        bsh = sprintf([x '/Reshape%d'],I);
        binL = bin(length(x)+2:end);
        bshL = bsh(length(x)+2:end);
        
        try
        delete_line(gcs,[binL '/1'],[bshL '/1']);
        catch me
        end
        try
        delete_line(gcs,[bshL '/1'],[bconL sprintf('/%d',I)]);        
        catch me
        end
        try
        delete_block(bin);
        catch me
        end
        try
        delete_block(bsh);
        catch me
        end
    end
    set_param(bcon,'NumInputs',num2str(asked));
end

