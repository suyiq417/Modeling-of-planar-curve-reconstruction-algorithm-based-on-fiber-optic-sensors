syms x;
y = x^3 + x;  % 原始曲线方程
dy = diff(y, x);   % y的一阶导数
d2y = diff(dy, x);  % y的二阶导数
arclength = sqrt(1 + dy^2);     % 弧长的积分表达式
arclength_fun = matlabFunction(arclength);   % 转换成函数
totalarclength = integral(arclength_fun,0,1);    % 计算总弧长
n = input('请输入划分弧段的数量：');
eachLength = totalarclength / n;    % 平均分成若干段的每段弧长 
length_x = zeros(1, n);     % 存储等弧长点的x值
arc_lengths = zeros(1, n);    % 存储从0到每个x的弧长
for i = 1:n     % 寻找每个等弧长点
    eqn = int(arclength_fun,0,x)==i*eachLength;
    length_x(i) = vpasolve(eqn, x);
    arc_lengths(i) = i * eachLength;  % 存储实际弧长
end
curvatures = zeros(1, n);   % 初始化曲率数组
for i = 1:n    % 计算每个等弧长点的曲率
    curvatures(i) = abs(subs(d2y, x, length_x(i)))/(1 + subs(dy^2, x, length_x(i)))^(3/2);
end
pp = spline(arc_lengths, curvatures);   % 对应弧长与曲率的三次样条插值
x_pos = 0;
y_pos = 0;   % 初始点为原点
angle = atan(double(subs(dy,x,0)));   % 初始角度由一阶导得出
positions = zeros(100, 2);  % 存储曲线上点的数组
thinarclength = linspace(0, totalarclength, 100);  % 创建更细的弧长分布，用于绘图和计算
ds = thinarclength(2) - thinarclength(1);   % 预计算第一段弧长
for i = 1:length(thinarclength)  % 沿路径计算新的位置
    if i > 1
        ds = thinarclength(i) - thinarclength(i-1);  % 计算每一小段的弧长
    end
    angle_increment = ppval(pp, thinarclength(i)) * ds;  % 计算角度增量即dθ
    angle = angle + angle_increment;   % 更新总角度
    x_pos = x_pos + cos(angle) * ds;   % 更新x坐标
    y_pos = y_pos + sin(angle) * ds;   % 更新y坐标
    positions(i, :) = [x_pos, y_pos];   % 记录位置
end
% 图1是 重构路径和原始路径对比图
figure;
fplot(y, [0 1], 'k-', 'LineWidth', 1.5);   % 原始曲线
hold on;
plot(positions(:, 1), positions(:, 2), 'r--', 'LineWidth', 2);  % 重构曲线图
scatter(0, 0, 80, 'k', 'filled');  % 起点标记
title('比较重构曲线与原始曲线两者差距');
xlabel('x 轴');
ylabel('y 轴');
legend('原始曲线', '重构曲线', '起始点');
axis equal;
grid on;
ori_y = matlabFunction(y); % 原始曲线 y = x^3 + x 的函数句柄
rec_y = interp1(positions(:,1), positions(:,2), linspace(0,1,100), 'spline'); 
ori_y_values = arrayfun(ori_y, linspace(0,1,100)); 
msey= mean((rec_y - ori_y_values).^2);
fprintf('重构曲线与原始曲线的均方误差为：%f\n', msey);  % 计算曲率的均方误差(MSE)
length_xo = zeros(1, length(thinarclength));     % 存储等弧长点的x值
arc_lengthso = zeros(1, length(thinarclength));    % 存储从0到每个x的弧长
for i = 1:length(thinarclength)     % 寻找每个等弧长点
    eqn = int(arclength_fun,0,x)==thinarclength(i);
    length_xo(i) = vpasolve(eqn, x);
    arc_lengthso(i) = thinarclength(i);  % 存储实际弧长
end
ori_k = zeros(1, length(thinarclength));   % 初始化曲率数组
for i = 1:length(thinarclength)   % 计算每个等弧长点的曲率
    ori_k(i) = abs(subs(d2y, x, length_xo(i)))/(1 + subs(dy^2, x, length_xo(i)))^(3/2);
end
ori_k = double(ori_k);  % 符号表达式转为数值
rec_k = ppval(pp, thinarclength);
msek = mean((rec_k - ori_k).^2);
fprintf('重构曲率与原始曲率的均方误差为：%f\n', msek); % 同上
% 图2是 原始曲率与重构曲率的比较图
figure; 
plot(thinarclength, ori_k, 'r-', 'LineWidth', 2); 
hold on; 
plot(thinarclength, rec_k, 'b--', 'LineWidth', 2); 
title('弧长与曲率变化图'); 
xlabel('弧长 (s)'); 
ylabel('曲率 (κ)'); 
legend('原始曲率变化', '重构曲率变化'); 
grid on;