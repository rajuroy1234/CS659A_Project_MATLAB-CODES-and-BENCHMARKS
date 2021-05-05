%% Defining the plant dynamics 

R= 4.0; % Ohms
L= 0.8; % Henrys
Km = .03; % torque constant
Kb = .04; % emf constant
Kf = 0.5; % Nms
J= 0.03; % kg.m^2


A = [-R/L -Kb/L; Km/J -Kf/J];
Bu = [1/L; 0];
C = [0 1];
D = [0];

%%
% calling the main constructor 
Sys= STLC_lti(A,Bu,C,D); 

%%
% initial state:
Sys.x0= [1 ; 1 ];

%% Defining the controller
 
Sys.time = 0:.1:30; 
Sys.ts=.2;                                                                       % sampling time for controller
Sys.L=10;                                                                        % horizon is 2s in that case

%%
% lower and upper bounds:
Sys.u_ub = 10;  
Sys.u_lb = -10;

%%
                                                        % Then the following define a signal temporal logic formula to be satisfied
                                                        % by the system
Sys.stl_list = {'ev_[0,1.] alw_[0,2] (abs(y1(t)-w1(t)) < 0.1)'}; % epsilon less shows Yalmip error, too bad a disturbance           

%%
% Now we are ready to compile the controller for our problem. 
controller = get_controller(Sys);


run_open_loop(Sys, controller);

%%
% Adding noise
Sys.Wref = Sys.time*0.;
Sys.Wref(50:60) = 3.5; 
Sys.Wref(90:100) = -1.5; 
Sys.Wref(140:160) = 2; 


%%
% the STL specifications:
Sys.stl_list = {'alw (ev_[0,1.] alw_[0,0.5] ( abs(y1(t)-w1(t)) < 3.5))'}; % epsilon<3 shows Yalmip error, too bad a disturbance

controller = get_controller(Sys);

%%
% plot input and outputs, 

close;
Sys.plot_x =[]; % default was Sys.plot_x = [1 2]
run_deterministic(Sys, controller);