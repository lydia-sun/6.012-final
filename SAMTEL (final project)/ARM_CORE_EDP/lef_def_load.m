function [def,lef_by_component] = lef_def_load
% function [def,lef_by_component] = lef_def_load


%%

% fdne_def = 'CORTEXM0DS.def';
% 
% fdne_macro_lef = fullfilec({;
%     getenv('NDK');
%     'pdk';
%     'N07_mint_tuck';
%     'ndk';
%     'lef';
%     'N07_mint_tuck.macro.lef';
%     });
% 
% myArgs = {;
%     'doplot'            ;   false;
%     'do_GATE_PAIR'      ;   false;
%     'fdne_macro_lef'    ;   fdne_macro_lef;
%     'do_remap_ROW_NDK'  ;   true;
%     };
% 
% def = CORTEXM0DS_def_load(fdne_def,myArgs{:});

%%

% clear;
% close all;

%%
if 0
    save('lef.mat','-struct','lef');
    lef = load('lef.mat');
end

if 0
    save('def.mat','-struct','def');
    def = load('def.mat');
end

%%

if 0
fdne_macro_lef = fullfilec({;
    getenv('NDK');
    'pdk';
    'N07_mint_tuck';
    'ndk';
    'lef';
    'N07_mint_tuck.macro.lef';
    });


if exist(fdne_macro_lef,'file') == 0
    error('.macro.lef file does not exist!\n%s',fdne_macro_lef);
end
myArgs_lef = {;
    'doplot'    ;   false;
    'quiet'     ;   true;
    };
    
%lef = lef_load(p_fdne_macro_lef,myArgs_lef{:});
lef = lef_load(fdne_macro_lef,myArgs_lef{:});
else
   
    lef = load('lef.mat');
    
end
    

if 0
    % find .def file in fd_pnr
    %fdne_def = fullfile(fd_pnr,[top_module,'.def']);
    fdne_def = 'CORTEXM0DS.def';
    if exist(fdne_def,'file') == 0
        error('def file does not exist');
    end
    
    % load def file
    myArgs_def = {;
        'doplot'            ;   false;
        'do_GATE_PAIR'      ;   true;%false;%true;
        'fdne_macro_lef'    ;   fdne_macro_lef;
%         'fdne_macro_lef'    ;   p_fdne_macro_lef;
        'do_remap_ROW_NDK'  ;   true;
        };
    def = def_load(fdne_def,myArgs_def{:});
else
%    def = load('def.mat'); 
   def = load('def.adj.mat'); 
end
    
    %%
    
%     % for each component, find which row its in    
% %     row_id = [def.ROW.id];
%     row_ymin = [def.ROW.ymin];
%     def_num_ROW = length(row_ymin);
%     def_num_COMPONENT = length(def.COMPONENTS);
%     
%     % reassign row_id for NDK
%     [~,pos_ymin] = sort(row_ymin);
%     [~,pos_descramble] = sort(pos_ymin);
%     row_id_ndk_scrambled = 0:(def_num_ROW-1);
%     row_id_ndk = row_id_ndk_scrambled(pos_descramble);
%     row_id_ndk_str = cell(def_num_ROW,1);
%     for j=1:def_num_ROW
%        row_id_ndk_str{j} = sprintf('STD_ROW_NDK_%d',row_id_ndk(j)); 
%     end
%     for j=1:def_num_ROW
%         def.ROW(j).id_ndk_str = row_id_ndk_str{j};
%         def.ROW(j).id_ndk = row_id_ndk(j);
%     end    
%     row_id_ndk = [def.ROW.id_ndk];
%     
% %     num_row = length(row_id);
%     component_y = [def.COMPONENTS.y];    
%     row_id_ndk_by_component = nan(length(def.COMPONENTS),1);
%     for j=1:def_num_ROW
%         row_id_ndk_tmp = row_id_ndk(j);
%         row_ymin_tmp = row_ymin(j);
%         
%         idx = row_ymin_tmp == component_y;
%         row_id_ndk_by_component(idx) = row_id_ndk_tmp;
%     end
%     if any(isnan(row_id_ndk_by_component))
%         error('at least one component not mapped to row');
%     end
%     for j=1:length(def.COMPONENTS)
%         def.COMPONENTS(j).row_id_ndk = row_id_ndk_by_component(j);
%     end
    
    % regions
    regions_per_cell = 6; % TODO: get from somewhere
    num_local_N = regions_per_cell;
%     num_local_M = regions_per_cell;
%     num_local_var = num_local_N + num_local_M;
%     def_num_rows = length(def.ROW);

%     A_map_global_N_to_local_N = sparse(...
%         num_local_N*def_num_COMPONENT,...
%         num_local_N*def_num_ROW);
    
    % lib_cells from components
    p_lib_cell = {def.COMPONENTS.lib_cell}';
    num_components = length(def.COMPONENTS);
    pos_component_in_lef = nan(num_components,1);
    for j=1:length(lef.MACRO)
        lef_macro_name_tmp = lef.MACRO(j).name;
        idx = strcmpi(p_lib_cell,lef_macro_name_tmp);
        pos_component_in_lef(idx) = j;
    end
    if any(isnan(pos_component_in_lef))
        error('at least one component in def not found in lef');
    end
    lef_by_component = lef.MACRO(pos_component_in_lef);
    
    
    
    if 1
    % add x & y, and flip
    fields_x = {;
        'rect_boundary_plot_x';
        'PIN_PORT_rect_mat_plot_x';
        };
    fields_y = {;
        'rect_boundary_plot_y';
        'PIN_PORT_rect_mat_plot_y';
        };
    for j=1:num_components
        switch def.COMPONENTS(j).orientation
            case 'N'
                sc_x = 1;
                sc_y = 1;
                add_size_x = 0;
                add_size_y = 0;
                
                % no flip
                Asub_map_global_N_to_local_N = sparse(eye(num_local_N));
                
            case 'S'
                sc_x = 1;
                sc_y = -1;
                add_size_x = 0;
                add_size_y = 1;
                
                % flip
                %Asub_map_global_N_to_local_N = sparse(circshift(fliplr(eye(num_local_N)),[0,num_local_N/2]));
                Asub_map_global_N_to_local_N = sparse(fliplr(eye(num_local_N)));
                
            case 'FN'
                sc_x = -1;
                sc_y = 1;
                add_size_x = 1;
                add_size_y = 0;
                
                % no flip
                Asub_map_global_N_to_local_N = sparse(eye(num_local_N));
                
            case 'FS'
                sc_x = -1;
                sc_y = -1;
                add_size_x = 1;
                add_size_y = 1;
                
                % flip
                %Asub_map_global_N_to_local_N = sparse(circshift(fliplr(eye(num_local_N)),[0,num_local_N/2]));
                Asub_map_global_N_to_local_N = sparse(fliplr(eye(num_local_N)));
                
            otherwise
                error('unrecognized orientation: ''%s''',def.COMPONENTS(j).orientation);
        end
        
        
        for k=1:length(fields_x)
            lef_by_component(j).(fields_x{k}) = ...
                def.COMPONENTS(j).x + ...
                lef_by_component(j).origin_x + ...
                add_size_x * lef_by_component(j).size_x + ...
                sc_x * lef_by_component(j).(fields_x{k});
        end
        for k=1:length(fields_y)
            lef_by_component(j).(fields_y{k}) = ...
                def.COMPONENTS(j).y + ...
                lef_by_component(j).origin_y + ...
                add_size_y * lef_by_component(j).size_y + ...
                sc_y * lef_by_component(j).(fields_y{k});
        end
        
        % add region data
        def.COMPONENTS(j).Asub_map_global_N_to_local_N = Asub_map_global_N_to_local_N;
        
%         A_offset_r = num_local_N * (j-1);
        A_offset_c_0_based = num_local_N * def.COMPONENTS(j).row_id_ndk;
        A_pos_vec_c_1_based = A_offset_c_0_based + (1:num_local_N);
        
        def.COMPONENTS(j).A_offset_c_0_based = A_offset_c_0_based;
        def.COMPONENTS(j).A_pos_vec_c_1_based = A_pos_vec_c_1_based;
        
%         A_map_global_N_to_local_N(...
%             A_offset_r + (1:num_local_N),...
%             A_offset_c + (1:num_local_N)) = Asub_map_global_N_to_local_N;
    end
    
    
    
    end % if 1
    
%%



return;

%%

f=figure;
        set(f,'units','normalized','position',[0.1,0.1,0.8,0.8]);
        hax = axes;
        set(hax,'nextplot','add');
        
        xr = [def.DIEAREA.xmin,def.DIEAREA.xmax,def.DIEAREA.xmax,def.DIEAREA.xmin,def.DIEAREA.xmin]';
        yr = [def.DIEAREA.ymin,def.DIEAREA.ymin,def.DIEAREA.ymax,def.DIEAREA.ymax,def.DIEAREA.ymin]';
        plot(xr,yr,'k--');
        
        if 0
        % plot x/y grid
        plot([def.ROW.x_vec],[def.ROW.y_vec],'k.');
        end
        
        if 0
        % plot component origins
        plot([def.COMPONENTS.x],[def.COMPONENTS.y],'bo');
        end
        
        % plot boundaries
        plot(...
            vec(cat(1,lef_by_component.rect_boundary_plot_x)'),...
            vec(cat(1,lef_by_component.rect_boundary_plot_y)'),...
            'b.-');
        
        rect_boundary_plot_x = cat(1,lef_by_component.rect_boundary_plot_x);
        rect_boundary_plot_y = cat(1,lef_by_component.rect_boundary_plot_y);
        
        idx_boundary_DFF = strcmp({lef_by_component.name},'DFCNQSTKND2D1_MOD3');
        

%         %%
        % plot power & ground in lef
        if 0
            % case-sensitive
            idx_POWER = strcmp(cat(1,lef_by_component.PIN_PORT_pin_use),'POWER');
            idx_GROUND = strcmp(cat(1,lef_by_component.PIN_PORT_pin_use),'GROUND');
            idx_SIGNAL = strcmp(cat(1,lef_by_component.PIN_PORT_pin_use),'SIGNAL');
        else
            % case insensitive
            idx_POWER = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'POWER');
            idx_GROUND = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'GROUND');
            
            idx_SIGNAL = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'SIGNAL') ...
                | strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'NDK_DEFAULT');
            
            idx_CLOCK = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'CLOCK');
        end
        
        % filter DFF: error with double height
        idx_DFCNQSTKD1 = strcmpi(cat(1,lef_by_component.PIN_PORT_macro_name_rep),'DFCNQSTKND2D1_MOD3');
        idx_POWER = idx_POWER & ~idx_DFCNQSTKD1;
        idx_GROUND = idx_GROUND & ~idx_DFCNQSTKD1;
        idx_SIGNAL = idx_SIGNAL & ~idx_DFCNQSTKD1;
        idx_CLOCK = idx_CLOCK & ~idx_DFCNQSTKD1;
        
        PIN_PORT_rect_mat_plot_x = cat(1,lef_by_component.PIN_PORT_rect_mat_plot_x);
        PIN_PORT_rect_mat_plot_y = cat(1,lef_by_component.PIN_PORT_rect_mat_plot_y);
        
        % class project
        PIN_PORT_rect_mat_plot_x = vec(cat(1,lef_by_component.PIN_PORT_rect_mat_plot_x)');
        PIN_PORT_rect_mat_plot_y = vec(cat(1,lef_by_component.PIN_PORT_rect_mat_plot_y)');
        
        
        if 1
           plot(...
               vec(rect_boundary_plot_x(idx_boundary_DFF,:)'),...
               vec(rect_boundary_plot_y(idx_boundary_DFF,:)'),...
               'r-');
        end
        
        
        if 0
        % plot ground
        plot(...
            vec(PIN_PORT_rect_mat_plot_x(idx_GROUND,:)'),...
            vec(PIN_PORT_rect_mat_plot_y(idx_GROUND,:)'),...
            'k-');
        
        % plot power
        plot(...
            vec(PIN_PORT_rect_mat_plot_x(idx_POWER,:)'),...
            vec(PIN_PORT_rect_mat_plot_y(idx_POWER,:)'),...
            'r-');
        
        % plot signal
        plot(...
            vec(PIN_PORT_rect_mat_plot_x(idx_SIGNAL,:)'),...
            vec(PIN_PORT_rect_mat_plot_y(idx_SIGNAL,:)'),...
            'g-');
        
        % plot clock
        plot(...
            vec(PIN_PORT_rect_mat_plot_x(idx_CLOCK,:)'),...
            vec(PIN_PORT_rect_mat_plot_y(idx_CLOCK,:)'),...
            'c-');
        end
        
        % make text
        for j=1:min([0,length(def.COMPONENTS)])
            str = sprintf('%s\n%s\n%s\nSTD\\_ROW\\_%d',...
                def.COMPONENTS(j).lib_cell,...
                def.COMPONENTS(j).instance,...
                def.COMPONENTS(j).orientation,...
                def.COMPONENTS(j).row_id);
           ht = text(def.COMPONENTS(j).x,def.COMPONENTS(j).y,str);
           set(ht,'horizontalalignment','left','verticalalignment','bottom');
        end
        
        axis image;
        
        set(gca,'xlim',1*[-1,1]+[def.DIEAREA.xmin,def.DIEAREA.xmax]);
        set(gca,'ylim',1*[-1,1]+[def.DIEAREA.ymin,def.DIEAREA.ymax]);
        
        set(gca,'xtick',[def.DIEAREA.xmin,def.DIEAREA.xmax]);
        set(gca,'ytick',[def.DIEAREA.ymin,def.DIEAREA.ymax]);
        
        [row_ymin,pos_descramble] = sort([def.ROW.ymin]);
        if 0
            row_id = [def.ROW(pos_descrabmel).id];
            row_id_str = cell(length(row_id),1);
        else
            row_id_str = {def.ROW(pos_descramble).id_str};
            row_orientation = {def.ROW(pos_descramble).orientation};
%             for j=1:length(row_id)
%                 row_id_str{j} = [SwapChar(row_id_str{j},'_','\_'),...
%                     ': ',row_orientation{j}];
%             end
            row_id_ndk = [def.ROW(pos_descramble).id_ndk];
            for j=1:length(row_id_ndk)
                row_id_str{j} = sprintf('NDK ROW %d: %s',row_id_ndk(j),row_orientation{j});
            end            
        end
        set(gca,'ytick',row_ymin,'yticklabel',row_id_str);
        
        xlabel(sprintf('x (%s)',def.UNITS.units));
        ylabel(sprintf('y (%s)',def.UNITS.units));
        title(sprintf('%s',def.DESIGN.design));
        
    