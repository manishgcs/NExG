max_iter = 250;

iterations = zeros(1,max_iter);
robustness = zeros(1, max_iter);

idx = 1;
while idx <= max_iter

 %     clear

%     cd('../..')
%     cd('SystemModelsAndData')

    % disp(' ')
    % disp(' One run will be performed for a maximum of 1000 tests. ')
    % disp(' Press any key to continue ... ')

    % pause

    model = @(t,x) ...
        [ 1.4 * x(3) - 0.9 * x(1); ...
        2.5 * x(5) - 1.5 * x(2); ...
        0.6 * x(7) - 0.8 * x(2) * x(3); ...
        2.0 - 1.3 * x(3) * x(4); ...
        0.7 * x(1) - x(4) * x(5); ...
        0.3 * x(1) - 3.1 * x(6); ...    
        1.8 * x(6) - 1.5 * x(2) * x(7)];
    

    init_cond = [1.1 1.4; 1.0 1.3; 1.4 1.7; 2.2 2.5; 1.2 1.5; 0.0 0.3; 0.4 0.7];
    input_range = [];
    cp_array = [];


    phi = '!(<>_[0.70,0.90] eventual_req)';

    form_id = 1;
        
    u_x1_min = 1.45;
    u_x1_max = 1.50;
    u_x2_min = 1.40;
    u_x2_max = 1.45;
    u_x3_min = 0.70;
    u_x3_max = 0.75;
    u_x4_min = 1.70;
    u_x4_max = 1.75;
    u_x5_min = 0.75;
    u_x5_max = 0.80;
    u_x6_min = 0.10;
    u_x6_max = 0.15;
    u_x7_min = 0.15;
    u_x7_max = 0.20;
    ii = 1;
    preds(ii).str='eventual_req';
    preds(ii).A = [-1 0 0 0 0 0 0; 1 0 0 0 0 0 0; 0 -1 0 0 0 0 0; 0 1 0 0 0 0 0; 0 0 -1 0 0 0 0; 0 0 1 0 0 0 0; 0 0 0 -1 0 0 0; 0 0 0 1 0 0 0; 0 0 0 0 -1 0 0; 0 0 0 0 1 0 0; 0 0 0 0 0 -1 0; 0 0 0 0 0 1 0; 0 0 0 0 0 0 -1; 0 0 0 0 0 0 1];
    preds(ii).b = [-u_x1_min; u_x1_max; -u_x2_min; u_x2_max; -u_x3_min; u_x3_max; -u_x4_min; u_x4_max; -u_x5_min; u_x5_max; -u_x6_min; u_x6_max; -u_x7_min; u_x7_max];
    
    time = 3.0;

    opt = staliro_options();

    opt.runs = 1;

    % Since this a function pointer there is no output space.
    % Set the specification space to be X
    opt.spec_space = 'X';

    % This model needs a stiff solver
    opt.ode_solver = 'ode15s';

    % Set the max number of tests
    opt.optim_params.n_tests = 150;

    [results, history] = staliro(model,init_cond,input_range,cp_array,phi,preds,time,opt);
    
    if results.run.nTests > 1
        iterations(idx) = results.run.nTests;
        robustness(idx) = results.run.bestRob;
        idx = idx + 1;
        idx

%         % Get the falsifying trajectory
%         bestRun = results.optRobIndex;
%         [T1,XT1] = SimFunctionMdl(model,init_cond,input_range,cp_array,results.run(bestRun).bestSample,time,opt);
% 
%         figure(1)
%         clf
%         rectangle('Position',[u_x1_min,u_x2_min,u_x1_max-u_x1_min,u_x2_max-u_x2_min],'FaceColor','r')
%         hold on
%         if (init_cond(1,1)==init_cond(1,2)) || (init_cond(2,1)==init_cond(2,2))
%             plot(init_cond(1,:),init_cond(2,:),'g')
%         else
%             rectangle('Position',[init_cond(1,1),init_cond(2,1),init_cond(1,2)-init_cond(1,1),init_cond(2,2)-init_cond(2,1)],'FaceColor','g')
%         end
%         ntests = results.run(bestRun).nTests;
%         hist = history(bestRun).samples;
%         plot(hist(1:ntests,1),hist(1:ntests,2),'*')
%         plot(XT1(:,1),XT1(:,2))
%         xlabel('y_1')
%         ylabel('y_2')
    end
end

mean_iter = mean(iterations);
var_iter = var(iterations);
maximum_iterations = max(iterations);
mean_robust = mean(robustness);
