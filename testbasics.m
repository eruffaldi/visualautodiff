h = new_system;
name = get_param(h,'Name');
open_system(name)
b = add_block('autodiff/Softmax AD CC',[name '/op']);
b1 = add_block('autodiff/One',[name '/one']);
bi = add_block('autodiff/Input',[name '/input']);
bo = add_block('autodiff/Output',[name '/output']);
h = add_line(name,blockconn1(name,'one'),blockrconn(name,'op',1));
h = add_line(name,blockconn1(name,'input'),blocklconn(name,'op',1));

% TODO:
% - setup inputs (input or workspace)
% - setup discrete test

