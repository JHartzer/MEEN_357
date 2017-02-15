function [FSAE_Race_Car] = car_2014()
    FSAE_Race_Car = struct(...
        'team','Texas A&M',...
        'year',2014,...
        'top_speed',62,...
        't2top_speed',t2top_speed(3.4,62),...
        'pilot',driver_harry(),...
        'chassis',chassis_2014(),...
        'power_plant',power_plant_2014(),...
        'suspension_front',suspension_front_2014(),...
        'suspension_rear',suspension_rear_2014(),...
        'wheel_front',wheel_front_2014(),...
        'wheel_rear',wheel_rear_2014());

    
    