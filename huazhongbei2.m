c = 4200;  % ��������Ŀ����Ϊ4200
lambda01 = 1529; % ��ʼ״̬1
lambda02 = 1540; % ��ʼ״̬2
lambda1 = [1529.808, 1529.807, 1529.813, 1529.812, 1529.814, 1529.809]; % ����1����
lambda2 = [1541.095, 1541.092, 1541.090, 1541.093, 1541.094, 1541.091]; % ����2����
s = [0, 0.6, 1.2, 1.8, 2.4, 3.0];  % ���������ֶεĻ���
k1 = c * (lambda1 - lambda01) / lambda01; % ����1�õ������� 
k2 = c * (lambda2 - lambda02) / lambda02; % ����2�õ�������
pp1 = spline(s, k1);
pp2 = spline(s, k2); % ��Ӧ���������ʵ�����������ֵ
x1 = 0;y1 = 0;
x2 = 0;y2 = 0;
angle1 = pi / 4; 
angle2 = pi / 4; % ��ʼ�Ƕ�Ϊ-45�Ȼ���45�� (����)
positions1 = zeros(100, 2);
positions2 = zeros(100, 2); % �ֱ�洢���β������ݵĵ�
thinarclength = linspace(0, max(s), 100); % ������ϸ�Ļ����ֲ�
ds = thinarclength(2) - thinarclength(1); % Ԥ���㻡����������΢Ԫ
for i = 1:length(thinarclength)
    % ���� k1
    angle_increment1 = ppval(pp1, thinarclength(i)) * ds; % ����Ƕ�����
    angle1 = angle1 + angle_increment1;  % �����ܽǶ�
    x1 = x1 + cos(angle1) * ds;  % ����x����
    y1 = y1 + sin(angle1) * ds;  % ����y����
    positions1(i, :) = [x1, y1]; % ��¼λ��
    % ���� k2
    angle_increment2 = ppval(pp2, thinarclength(i)) * ds; % ����Ƕ�����
    angle2 = angle2 + angle_increment2;  % �����ܽǶ�
    x2 = x2 + cos(angle2) * ds; % ����x����
    y2 = y2 + sin(angle2) * ds; % ����y����
    positions2(i, :) = [x2, y2]; % ��¼λ��
end
% ͼ1�� ��Ŀx�����ʶ�Ӧ���
x_target = [0.3, 0.4, 0.5, 0.6, 0.7];
fprintf('\n��Ŀ��������� x ��Ӧ������ k1 �� k2��\n');
for ix = 1:length(x_target)
    fprintf('��x = %.1fʱ:\n', x_target(ix));
    % Ѱ������x�����Ӧ�Ļ���s����������
    idx1 = find(abs(positions1(:,1) - x_target(ix)) < 1e-2);
    idx2 = find(abs(positions2(:,1) - x_target(ix)) < 1e-2);
    if isempty(idx1)
        disp('��λ�ó�������1���߷�Χ��');
    else
        k1_values = ppval(pp1, thinarclength(idx1));
        disp('����1���ߵĶ�Ӧ����Ϊ:');
        disp(k1_values);
    end
    if isempty(idx2)
        disp('��λ�ó�������2���߷�Χ��');
    else
        k2_values = ppval(pp2, thinarclength(idx2));
        disp('����2���ߵĶ�Ӧ����Ϊ:');
        disp(k2_values);
    end
end
% ͼ2�� ����1�Ͳ���2�õ���·��
figure;
plot(positions1(:, 1), positions1(:, 2), 'r-', 'LineWidth', 2); % ����1��·��
hold on;
plot(positions2(:, 1), positions2(:, 2), 'b-', 'LineWidth', 2); % ����2��·��
scatter(0, 0, 80, 'k', 'filled');  % ��ʼ����Ϊ��ɫʵ�ĵ�
title('����1�Ͳ���2���ع�����');
xlabel('x ��');
ylabel('y ��');
legend('����1���ع�����', '����2���ع�����');
axis equal; % �ȱ�����
grid on; % ��������
% ͼ3�� ����1�����2�������满���仯��ͼ
figure;
plot(thinarclength, ppval(pp1, thinarclength), 'r-', 'LineWidth', 2); % ����1������k1��s�ı仯
hold on;
title('�����满���仯ͼ');
xlabel('���� s');
ylabel('���� k(s)');
legend('����1������ k1 �仯');
grid on;
figure;
plot(thinarclength, ppval(pp2, thinarclength), 'b-', 'LineWidth', 2); % ����2������k2��s�ı仯
hold on;
title('�����满���仯ͼ');
xlabel('���� s');
ylabel('���� k(s)');
legend('����2������ k2 �仯');
grid on;