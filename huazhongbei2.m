c = 4200;  % 常数，题目假设为4200
lambda01 = 1529; % 初始状态1
lambda02 = 1540; % 初始状态2
lambda1 = [1529.808, 1529.807, 1529.813, 1529.812, 1529.814, 1529.809]; % 测试1数据
lambda2 = [1541.095, 1541.092, 1541.090, 1541.093, 1541.094, 1541.091]; % 测试2数据
s = [0, 0.6, 1.2, 1.8, 2.4, 3.0];  % 传感器间距分段的弧长
k1 = c * (lambda1 - lambda01) / lambda01; % 测试1得到的曲率 
k2 = c * (lambda2 - lambda02) / lambda02; % 测试2得到的曲率
pp1 = spline(s, k1);
pp2 = spline(s, k2); % 对应弧长与曲率的三次样条插值
x1 = 0;y1 = 0;
x2 = 0;y2 = 0;
angle1 = pi / 4; 
angle2 = pi / 4; % 初始角度为-45度或者45度 (弧度)
positions1 = zeros(100, 2);
positions2 = zeros(100, 2); % 分别存储两次测试数据的点
thinarclength = linspace(0, max(s), 100); % 创建更细的弧长分布
ds = thinarclength(2) - thinarclength(1); % 预计算弧长，即弧长微元
for i = 1:length(thinarclength)
    % 对于 k1
    angle_increment1 = ppval(pp1, thinarclength(i)) * ds; % 计算角度增量
    angle1 = angle1 + angle_increment1;  % 更新总角度
    x1 = x1 + cos(angle1) * ds;  % 更新x坐标
    y1 = y1 + sin(angle1) * ds;  % 更新y坐标
    positions1(i, :) = [x1, y1]; % 记录位置
    % 对于 k2
    angle_increment2 = ppval(pp2, thinarclength(i)) * ds; % 计算角度增量
    angle2 = angle2 + angle_increment2;  % 更新总角度
    x2 = x2 + cos(angle2) * ds; % 更新x坐标
    y2 = y2 + sin(angle2) * ds; % 更新y坐标
    positions2(i, :) = [x2, y2]; % 记录位置
end
% 图1是 题目x处曲率对应输出
x_target = [0.3, 0.4, 0.5, 0.6, 0.7];
fprintf('\n题目所求横坐标 x 对应的曲率 k1 和 k2：\n');
for ix = 1:length(x_target)
    fprintf('当x = %.1f时:\n', x_target(ix));
    % 寻找所有x坐标对应的弧长s并计算曲率
    idx1 = find(abs(positions1(:,1) - x_target(ix)) < 1e-2);
    idx2 = find(abs(positions2(:,1) - x_target(ix)) < 1e-2);
    if isempty(idx1)
        disp('该位置超出测试1曲线范围！');
    else
        k1_values = ppval(pp1, thinarclength(idx1));
        disp('测试1曲线的对应曲率为:');
        disp(k1_values);
    end
    if isempty(idx2)
        disp('该位置超出测试2曲线范围！');
    else
        k2_values = ppval(pp2, thinarclength(idx2));
        disp('测试2曲线的对应曲率为:');
        disp(k2_values);
    end
end
% 图2是 测试1和测试2得到的路径
figure;
plot(positions1(:, 1), positions1(:, 2), 'r-', 'LineWidth', 2); % 测试1的路径
hold on;
plot(positions2(:, 1), positions2(:, 2), 'b-', 'LineWidth', 2); % 测试2的路径
scatter(0, 0, 80, 'k', 'filled');  % 起始点标记为黑色实心点
title('测试1和测试2的重构曲线');
xlabel('x 轴');
ylabel('y 轴');
legend('测试1的重构曲线', '测试2的重构曲线');
axis equal; % 等比例轴
grid on; % 开启网格
% 图3是 测试1与测试2的曲率随弧长变化的图
figure;
plot(thinarclength, ppval(pp1, thinarclength), 'r-', 'LineWidth', 2); % 测试1的曲率k1随s的变化
hold on;
title('曲率随弧长变化图');
xlabel('弧长 s');
ylabel('曲率 k(s)');
legend('测试1的曲率 k1 变化');
grid on;
figure;
plot(thinarclength, ppval(pp2, thinarclength), 'b-', 'LineWidth', 2); % 测试2的曲率k2随s的变化
hold on;
title('曲率随弧长变化图');
xlabel('弧长 s');
ylabel('曲率 k(s)');
legend('测试2的曲率 k2 变化');
grid on;