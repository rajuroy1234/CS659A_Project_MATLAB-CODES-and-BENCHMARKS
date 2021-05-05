%% Defining the plant dynamics

k1=1;
k2=3;
m=1;
b=2;

A = [0 1 0 ;
     -(k1+k2)/m 0 k1/m ; 
     k1/b 0 -k1/b ];
Bu = [0; 1/m ; 0 ];
Bw=[0; 0; 0];

C = [0 0 1 ];
D=0;
Dw=0;

%%
% calling the main constructor 
Sys= STLC_lti(A,Bu,Bw,C,D,Dw); 


%%
% initial state:
Sys.x0= [1 ; 1 ; 1 ];

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
Sys.stl_list = {'ev_[0,1.] alw_[0,2] (abs(y1(t)-w1(t)) < 0.7)'}; % epsilon<0.7 shows Yalmip error, too bad a disturbance           

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
Sys.stl_list = {'alw (ev_[0,1.] alw_[0,0.5] ( abs(y1(t)-w1(t)) < 1.9))'}; % epsilon<0.7 shows Yalmip error, too bad a disturbance

controller = get_controller(Sys);

%%
% plot input and outputs, 

close;
Sys.plot_x =[]; % default was Sys.plot_x = [1 2]
run_deterministic(Sys, controller);
