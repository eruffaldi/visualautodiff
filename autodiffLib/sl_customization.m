function sl_customization(cm)

% Copyright 2007-2014 The MathWorks, Inc.
% 
% 

cm.registerTargetInfo(@locCrlRegFcn);

end % End of SL_CUSTOMIZATION


% Local function(s)
function thisCrl = locCrlRegFcn
thisidx=1;


% Register a Code Replacement Library for use with model: rtwdemo_crlblas.mdl
thisCrl(thisidx) = RTW.TflRegistry;
thisCrl(thisidx).Name = 'AD Simulink Customization'; 
thisCrl(thisidx).Description = 'Includes BLAS Calls';
thisCrl(thisidx).TableList = {'crl_table_ad'};
thisCrl(thisidx).TargetHWDeviceType = {'*'};
thisidx=thisidx+1;


end % End of LOCCRLREGFCN


% EOF
