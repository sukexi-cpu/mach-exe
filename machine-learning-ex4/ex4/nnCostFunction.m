function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...          %��ǩ�ĸ�������������Ҫ
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%----------------------------PART 1----------------------------------
c = 1:num_labels;
yt = zeros(m,num_labels);  %ע��y�Ķ�ά��С
for i=1:m
    yt(i,:) =(c==y(i));
end

a1 = [ones(m,1) X];    % 5000 x 401
z2 = a1*Theta1';       % 5000 x 25
a2 = sigmoid(z2);      % 5000 x 25
a2 = [ones(m,1) a2];   % 5000 x 26
z3 = a2*Theta2';       % 5000 x 26
a3 = sigmoid(z3);      % 5000 x 10
hx = a3;   % 5000 *10

t1_temp=Theta1(:,2:end);
t2_temp=Theta2(:,2:end);

J = -1/m *sum(sum(yt.*log(hx)+(1-yt).*log(1-hx)));

regularize = lambda/(2*m)*(sum(sum(t1_temp.^2)) + sum(sum(t2_temp.^2)));

J = J + regularize;

%----------------------------PART 2----------------------------------
delta3 = zeros(m,num_labels);
delta2 = zeros(m,size(Theta2,2));

D2 = zeros(size(Theta2));            %10 x 26
D1 = zeros(size(Theta1));            %25 x 401


delta3 = a3 - yt;                                              % 5000 x 10
%delta2 = delta3 * Theta2.* sigmoidGradient(a2);
%%����Ǵ���ģ���������������
delta2 = delta3 * Theta2 .*(a2 .* (1 - a2));                   % 5000 x 26
delta2 = delta2(:,2:end);                                      % 5000 x 25

D2 = delta3' * a2;                        %10 x 26
D1 = delta2' * a1;                        %25 x 401

Theta2_grad = 1/m *D2;
Theta1_grad = 1/m *D1;

%----------------------------PART 3----------------------------------

% %regularize
temp1 = Theta1;
temp2 = Theta2;
temp1(:,1) = 0;
temp2(:,1) = 0;
Theta1_grad = Theta1_grad + lambda/m *temp1;              
Theta2_grad = Theta2_grad + lambda/m *temp2;















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
