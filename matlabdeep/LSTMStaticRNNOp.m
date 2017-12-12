% This combines LSTM Basic and Static RNN just to start
%
% Documentation:
% https://www.tensorflow.org/api_docs/python/tf/contrib/rnn/BasicLSTMCell
% https://www.tensorflow.org/api_docs/python/tf/nn/static_rnn
% https://www.tensorflow.org/api_guides/python/contrib.rnn#Recurrent_Neural_Networks
% using http://arxiv.org/abs/1409.2329.
%
% http://www.wildml.com/2015/10/recurrent-neural-network-tutorial-part-4-implementing-a-grulstm-rnn-with-python-and-theano/
classdef LSTMStaticRNNOp < UnaryOp
      
    properties
        num_units
        forget_base
        activation
        state
        stat_size
        
        Wxi
        Whi
        Wxf
        Whf
        Wxo
        Who
        Wxc
        Whc
        bi
        bf
        bo
        bcin
        
        htpre
        ctpre
        htpost
        ctpost
        
    end
    methods
        % inputs: 2-D tensor with shape [batch_size x input_size]
        function obj = LSTMStaticRNNOp(x,input_size, num_units,forget_bias,activation)
            obj = obj@UnaryOp(x);
            obj.num_units = num_units;
            obj.forget_bias = forget_bias;
            obj.activation= @tanh;
               
            a = obj.activation;
            dt = single(0);
            
            gru= 0;
            if gru 
                obj.Wxi = Variable('Wxi',mzeros([inputsize,1],dt));
                obj.Whi = Variable('Whi',mzeros([inputsize,1],dt));
                obj.Wxf = Variable('Wxf',mzeros([inputsize,1],dt));
                obj.Whf = Variable('Whf',mzeros([inputsize,1],dt));
                obj.bi = Variable('bi',mzeros([inputsize,1],dt));
                obj.bf = Variable('bf',mzeros([inputsize,1],dt));
                obj.Wxc = Variable('Wxc',mzeros([inputsize,1],dt));
                obj.Whc = Variable('Whc',mzeros([inputsize,1],dt));
    
                % http://www.wildml.com/2015/10/recurrent-neural-network-tutorial-part-4-implementing-a-grulstm-rnn-with-python-and-theano/
                pit = g(obj.Wxi*x+obj.Whi*obj.htpre+obj.bi);
                pft = g(obj.Wxf*x+obj.Whf*obj.htpre+obj.bf);
                obj.bcin = Variable('bcin',mzeros([inputsize,1],dt));
                %obj.ht1 = ...
                ct = a(obj.Wxc*x + obj.Whc*obj.ht1+obj.bcin);
                obj.ctpost = obj.Wc*obj.st1 + obj.bc;
                
                obj.state = {obj.ctpre,obj.htpre};
                obj.outputs = { obj.ctpost, obj.htpost};
           
            else
                obj.Wxi = Variable('Wxi',mzeros([inputsize,1],dt));
                obj.Whi = Variable('Whi',mzeros([inputsize,1],dt));
                obj.Wxf = Variable('Wxf',mzeros([inputsize,1],dt));
                obj.Whf = Variable('Whf',mzeros([inputsize,1],dt));
                obj.Wxo = Variable('Wxo',mzeros([inputsize,1],dt));
                obj.Who = Variable('Who',mzeros([inputsize,1],dt));
                obj.Wxc = Variable('Wxc',mzeros([inputsize,1],dt));
                obj.Whc = Variable('Whc',mzeros([inputsize,1],dt));

                obj.bi = Variable('bi',mzeros([inputsize,1],dt));
                obj.bf = Variable('bf',mzeros([inputsize,1],dt));
                obj.bo = Variable('bo',mzeros([inputsize,1],dt));
                obj.bcin = Variable('bcin',mzeros([inputsize,1],dt));
                obj.ht1 = [];

                % Alternative formulation: stich (it,ft,ot,cint)
                pit = g(obj.Wxi*x+obj.Whi*obj.htpre+obj.bi);
                pft = g(obj.Wxf*x+obj.Whf*obj.htpre+obj.bf);
                pot = g(obj.Wxo*x+obj.Who*obj.htpre+obj.bo);
                cint = a(obj.Wxc*x + obj.Whc*obj.ht1+obj.bcin);

                obj.ctpre = IdentityOp(); % ?
                obj.ctpost = IdentityOp(); % ? 

                obj.ctpost = pft * obj.ctpre + pit * cint; % the new state
                obj.htpost = pot * a(obj.ctpost); % the output

                % our system could support graph models
                obj.state = {obj.ctpre,obj.htpre};
                obj.outputs = { obj.ctpost, obj.htpost};
                
            end
        end

        % TD: state: if self.state_size is an integer, this should be a 2-D Tensor with shape [batch_size x self.state_size]. Otherwise, if self.state_size is a tuple of integers, this should be a tuple with shapes [batch_size x s] for s in self.state_size.
        function r = eval(obj)
            % evaluate nested
        end

        function grad(obj,up)
            % evaluate nested
        end

    end
    
end

