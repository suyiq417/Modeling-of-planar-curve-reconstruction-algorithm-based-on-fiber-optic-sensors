c = 4200;  % 常数，题目假设为4200
lambda01 = 1529; % 初始状态1
lambda02 = 1540; % 初始状态2
lambda1 = [1529.808, 1529.807, 1529.813, 1529.812, 1529.814, 1529.809]; % 测试1数据
lambda2 = [1541.095, 1541.092, 1541.090, 1541.093, 1541.094, 1541.091]; % 测试2数据
s = [0, 0.6, 1.2, 1.8, 2.4, 3.0];  % 传感器间距分段的弧长
k1 = c * (lambda1 - lambda01) / lambda01; % 测试1得到的曲率 
k2 = c * (lambda2 - lambda02) / lambda02; % 测试2得到的曲率
disp('测试1的传感器所在点曲率数据：');
disp(k1);
disp('测试2的传感器所在点曲率数据：');
disp(k2);
pp1 = spline(s, k1);
pp2 = spline(s, k2); % 对应弧长与曲率的三次样条插值
x_target = [0.3, 0.4, 0.5, 0.6, 0.7];
k1_values=ppval(pp1,x_target);
k2_values=ppval(pp2,x_target);
disp('横坐标x相应位置处的曲率k1:');
disp(k1_values);
disp('横坐标x相应位置处的曲率k2:');
disp(k2_values);