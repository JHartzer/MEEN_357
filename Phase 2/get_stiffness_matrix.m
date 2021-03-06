function [ K ] = get_stiffness_matrix(vibration_model,FSAE_Race_Car)
    % get_stiffness_matrix - A function for producing the stiffness 
    %   matrix for a given car. Takes into account the calculated 
    %   leverage ratio and average across all car sections. 
    %
    %   USAGE
    % [ K ] = get_stiffness_matrix(vibration_model,FSAE_Race_Car)
    %
    %   INPUT
    % vibration_model    a char defining which type of model is being
    %                   used. Can be either "quarter_car_1_DOF",
    %                   "quarter_car_2_DOF", "half_car_2_DOF",
    %                   or "half_car_4_DOF".
    % FSAE_Race_Car      a struct defining which car to do analysis on
    %
    %   OUTPUT
    % K                  The stiffness matrix for the given   and
    %                   vibration model type
    
    if ischar(vibration_model) == 0 
        error(['Error: Input type.',...
            '\n\tvibration_model must be a char, not a %s'],class(vibration_model));        
    
    elseif isstruct(FSAE_Race_Car) == 0
        error(['Error: Input type.',...
            '\n\tFSAE_Race_Car must be a struct, not a %s'],class(FSAE_Race_Car));
    
    elseif strcmp(vibration_model,'quarter_car_1_DOF') == 0 && strcmp(vibration_model,'quarter_car_2_DOF') == 0 && strcmp(vibration_model,'half_car_2_DOF') == 0 && strcmp(vibration_model,'half_car_4_DOF') == 0
        error('Error: invalid vibration model. Acceptable formats are:\n"quarter_car_1_DOF"\n"quarter_car_2_DOF"\n"half_car_2_DOF"\n"half_car_4_DOF"');
    end
    
    
    kf = FSAE_Race_Car.wheel_front.k * 12;
    kr = FSAE_Race_Car.wheel_rear.k * 12;   
    k1 = FSAE_Race_Car.suspension_front.k * 12 * get_leverage_ratio('front', FSAE_Race_Car);
    k2 = FSAE_Race_Car.suspension_rear.k * 12 * get_leverage_ratio('rear', FSAE_Race_Car);
    lf = get_cg(FSAE_Race_Car);
    lr = (FSAE_Race_Car.chassis.wheelbase / 12) - lf;
    
    Ks = (k1 + k2) / 2;
       
    
    if strcmp(vibration_model, 'quarter_car_1_DOF') == 1
        K = Ks;
        
    elseif strcmp(vibration_model, 'quarter_car_2_DOF') == 1
        K = [Ks, -Ks;...
            -Ks, Ks + (kf + kr)/2];
        
    elseif strcmp(vibration_model, 'half_car_2_DOF') == 1
        K = [k1 + k2, ((k2 * lr) - (k1 * lf));...
            ((k2 * lr) - (k1 * lf)), ((k1 * (lf^2)) + (k2 * (lr^2)))];
        
    elseif strcmp(vibration_model, 'half_car_4_DOF') == 1
        K = [Ks*2, ((k2 * lr) - (k1 * lf)), -(k1), -(k2);...
            ((k2 * lr) - (k1 * lf)), ((k1 * (lf^2)) + (k2 * (lr^2))), (k1 * lf), -(k2 * lr);...
            -(k1), (k1 * lf), (k1 + kf), 0;...
            -(k2), -(k2 * lr), 0, (k2 + kr)];
        
    end
end

    