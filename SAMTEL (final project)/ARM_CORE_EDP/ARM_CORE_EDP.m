function varargout = ARM_CORE_EDP(varargin)
% ARM_CORE_EDP MATLAB code for ARM_CORE_EDP.fig
%      ARM_CORE_EDP, by itself, creates a new ARM_CORE_EDP or raises the existing
%      singleton*.
%
%      H = ARM_CORE_EDP returns the handle to a new ARM_CORE_EDP or the handle to
%      the existing singleton*.
%
%      ARM_CORE_EDP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARM_CORE_EDP.M with the given input arguments.
%
%      ARM_CORE_EDP('Property','Value',...) creates a new ARM_CORE_EDP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ARM_CORE_EDP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ARM_CORE_EDP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% ==================================================
% ==================================================
% ==================================================
% ARM_CORE_EDP written for NOVELS group at MIT under Prof. Max Shulaker,
% do not distribute
% ==================================================
% ==================================================
% ==================================================

% Edit the above text to modify the response to help ARM_CORE_EDP

% Last Modified by GUIDE v2.5 26-Apr-2017 06:44:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ARM_CORE_EDP_OpeningFcn, ...
                   'gui_OutputFcn',  @ARM_CORE_EDP_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ARM_CORE_EDP is made visible.
function ARM_CORE_EDP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ARM_CORE_EDP (see VARARGIN)

set(handles.figure1,'toolbar','figure');

% set checkboxes
set(handles.checkboxInvBuf,'value',1);
set(handles.checkboxComb  ,'value',1);
set(handles.checkboxDFF   ,'value',1);

% default values
fet_params = [];
fet_params.VDD__V = 1.8;
fet_params.Cgs__norm = 1;
fet_params.Ion__uA_per_um = 600;
fet_params.Ioff__nA_per_um = 400;
% bounds
fet_params.bounds_VDD__V = [0.1,5];
fet_params.bounds_Cgs__norm = [0.01,100];
fet_params.bounds_Ion__uA_per_um = [1,10e3];
fet_params.bounds_Ioff__nA_per_um = [10e-3,10e3]; % 10 pA to 10 uA
FETParams2GUI(fet_params,handles);

% load ARM core
pushbuttonLoadARMCore_Callback(handles.pushbuttonLoadARMCore, eventdata, handles)

% calculate EDP & refresh axes
UpdateEDP(hObject,eventdata,handles);

% Choose default command line output for ARM_CORE_EDP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ARM_CORE_EDP wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function FETParams2GUI(fet_params,handles)
% function FETParams2GUI(fet_params,handles)

if isempty(fet_params)
   error('empty fet_params'); 
end

set(handles.editVDD,'string',sprintf('%g',fet_params.VDD__V));
set(handles.editIon,'string',sprintf('%g',fet_params.Ion__uA_per_um));
set(handles.editIoff,'string',sprintf('%g',fet_params.Ioff__nA_per_um));
set(handles.editCgs,'string',sprintf('%g',fet_params.Cgs__norm));

set(handles.uipanelFETparameters,'userdata',fet_params);

function fet_params = GUI2FETParams(handles)
% function fet_params = GUI2FETParams(handles)

fet_params = get(handles.uipanelFETparameters,'userdata');


% --- Outputs from this function are returned to the command line.
function varargout = ARM_CORE_EDP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonLoadARMCore.
function pushbuttonLoadARMCore_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoadARMCore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
1;

UpdateStatus('loading ARM core physical design data (takes a few seconds)...',handles);

%[def,lef_by_component] = class_project;
[def,lef_by_component] = lef_def_load;

UpdateStatus('loading ARM core physical design data... complete!',handles);



%%
% % % % % fdne_nets_csv = 'CORTEXM0DS.nets.csv';
% % % % % data_nets = StepStructRead(fdne_nets_csv,'headerExists',false);
% % % % % 
% % % % % fdne_port_csv = 'CORTEXM0DS.port.csv';
% % % % % data_port = StepStructRead(fdne_port_csv);%,'headerExists',false);
% % % % % 
% % % % % %%
% % % % % UpdateStatus('converting nets data...',handles);
% % % % % 
% % % % % p_net_name_csv = {data_nets.net_name}';
% % % % % 
% % % % % num_NETS_def = length(def.NETS);
% % % % % 
% % % % % def.NETS(1).data_csv = [];
% % % % % 
% % % % % for i=1:num_NETS_def
% % % % %     net_name_DEF_tmp = def.NETS(i).name;
% % % % %     
% % % % %     idx = strcmpi(p_net_name_csv,net_name_DEF_tmp);
% % % % %     
% % % % %     if nnz(idx) > 1
% % % % %         error('too many nets found!');
% % % % %     elseif nnz(idx) == 0
% % % % %         fprintf('warning: net ''%s'' not found\n',net_name_DEF_tmp);        
% % % % %         def.NETS(i).data_csv = [];
% % % % %     else
% % % % %         def.NETS(i).data_csv = data_nets(idx);
% % % % %     end
% % % % %     
% % % % % end
% % % % % 
% % % % % UpdateStatus('converting nets data... complete!',handles);
% % % % % 
% % % % % %% add ports
% % % % % 
% % % % % % def.NETS(1).data_port = []
% % % % % 
% % % % % % p_port_name_csv = {data_port.port};
% % % % % num_port_csv = length(data_port);
% % % % % 
% % % % % p_NET_name = {def.NETS.name}';
% % % % % 
% % % % % def.data_port = data_port;
% % % % % 
% % % % % for i=1:length(def.NETS)
% % % % %     def.NETS(i).is_port = false;
% % % % %     def.NETS(i).is_port_in = false;
% % % % %     def.NETS(i).is_port_out = false;
% % % % %     def.NETS(i).port_dir = '';
% % % % %     def.NETS(i).port_x = nan;
% % % % %     def.NETS(i).port_y = nan;
% % % % % end
% % % % % 
% % % % % for i=1:num_port_csv
% % % % %     port_name_tmp = data_port(i).port;
% % % % %     
% % % % %     idx_DEF = strcmp(port_name_tmp,p_NET_name);
% % % % %     
% % % % %     if nnz(idx_DEF) == 0
% % % % %         fprintf('port not found in DEF, for ''%s''\n',port_name_tmp);
% % % % %     elseif nnz(idx_DEF) > 1
% % % % %         error('multiple port matches');
% % % % %     else
% % % % %         def.NETS(idx_DEF).is_port = true;
% % % % %         if strcmpi(data_port(i).dir,'in')
% % % % %             def.NETS(idx_DEF).is_port_in = true;
% % % % %         elseif strcmpi(data_port(i).dir,'out')
% % % % %             def.NETS(idx_DEF).is_port_out = true;
% % % % %         else
% % % % %             error('unrecognized port dir: ''%s''',data_port(i).dir);
% % % % %         end
% % % % %         
% % % % %     end
% % % % %     
% % % % %     
% % % % % end

%% save it
% saveVars = {;
%     'def';
%     'lef_by_component';
%     };
% fdne_save = 'ARM_core_physical_design_data.mat';
% save(fdne_save,saveVars{:},'-v7.3');
    
if 0
    save('def.adj.mat','-struct','def');
end

% if 0
%     save('lef.adj.mat','lef_by_component');
% end

%%
userdata = [];
userdata.def = def;
userdata.lef_by_component = lef_by_component;

set(handles.pushbuttonLoadARMCore,'userdata',userdata);

pushbuttonRefreshDisplay_Callback(handles.pushbuttonRefreshDisplay,[],handles);



%%

function UpdateStatus(str,handles)
% function UpdateStatus(str,handles)

set(handles.editStatus,'string',str);
fprintf('ARM_CORE_EDP.m: %s\n',str);
drawnow;



function editStatus_Callback(hObject, eventdata, handles)
% hObject    handle to editStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStatus as text
%        str2double(get(hObject,'String')) returns contents of editStatus as a double


% --- Executes during object creation, after setting all properties.
function editStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in pushbuttonRefreshDisplay.
function pushbuttonRefreshDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRefreshDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
userdata_lefdef = get(handles.pushbuttonLoadARMCore,'userdata');

if isempty(userdata_lefdef)
    UpdateStatus('ARM core not loaded! unable to refresh display',handles);
    return;
end

def = userdata_lefdef.def;
lef_by_component = userdata_lefdef.lef_by_component;

% get checkboxes
cb_InvBuf = get(handles.checkboxInvBuf,'value');
cb_Comb = get(handles.checkboxComb,'value');
cb_DFF = get(handles.checkboxDFF,'value');

color_InvBuf = [0,0,1];
color_Comb = [0,0.9,0];
color_DFF = [1,0,0];

ud = get(handles.axesLayout,'userdata');
if isempty(ud)
    set(handles.axesLayout,'nextplot','replace');
    ud.hp_area = plot(handles.axesLayout,nan,nan,'k--');
    set(handles.axesLayout,'nextplot','add');
    ud.hp_InvBuf = plot(handles.axesLayout,nan,nan,'-','color',color_InvBuf);
    ud.hp_Comb = plot(handles.axesLayout,nan,nan,'-','color',color_Comb);
    ud.hp_DFF = plot(handles.axesLayout,nan,nan,'-','color',color_DFF);
    
    set(handles.axesLayout,'userdata',ud);
end


%%
% ====================
% ====================
% ====================

% f=figure;
%         set(f,'units','normalized','position',[0,0,1,1]);
%         hax = axes;
%         set(hax,'nextplot','add');
        
        xr = [def.DIEAREA.xmin,def.DIEAREA.xmax,def.DIEAREA.xmax,def.DIEAREA.xmin,def.DIEAREA.xmin]';
        yr = [def.DIEAREA.ymin,def.DIEAREA.ymin,def.DIEAREA.ymax,def.DIEAREA.ymax,def.DIEAREA.ymin]';
        %plot(xr,yr,'k--');
        set(ud.hp_area,'xdata',xr,'ydata',yr);
        
        %%
        
        if 0
        % plot x/y grid
        plot([def.ROW.x_vec],[def.ROW.y_vec],'k.');
        
        % plot component origins
        plot([def.COMPONENTS.x],[def.COMPONENTS.y],'bo');
        
        % plot boundaries
        plot(...
            vec(cat(1,lef_by_component.rect_boundary_plot_x)'),...
            vec(cat(1,lef_by_component.rect_boundary_plot_y)'),...
            'b.-');
        end
        
        % plot boundaries
        if 0
        plot(...
            vec(cat(1,lef_by_component.rect_boundary_plot_x)'),...
            vec(cat(1,lef_by_component.rect_boundary_plot_y)'),...
            'b.-');
        end
        
        rect_boundary_plot_x = cat(1,lef_by_component.rect_boundary_plot_x);
        rect_boundary_plot_y = cat(1,lef_by_component.rect_boundary_plot_y);
        
        p_cell_names = {lef_by_component.name}';
        names_unique = unique(p_cell_names);
        
        idx_boundary_DFF = strncmpi(p_cell_names,'DF',2);
        idx_boundary_INV = strncmpi(p_cell_names,'IN',2);
        idx_boundary_BUF = strncmpi(p_cell_names,'BU',2);
        idx_boundary_ND2 = strncmpi(p_cell_names,'ND',2);
        idx_boundary_NR2 = strncmpi(p_cell_names,'NR',2);
        
        idx_boundary_InvBuf = idx_boundary_INV | idx_boundary_BUF;
        idx_boundary_Comb = idx_boundary_ND2 | idx_boundary_NR2;
        
        nDFF = nnz(idx_boundary_DFF);
        nInvBuf = nnz(idx_boundary_InvBuf);
        nComb = nnz(idx_boundary_Comb);
        
        nAll = length(lef_by_component);
        
        if sum([nDFF,nInvBuf,nComb]) ~= nAll
            error('sanity check on total cells failed');
        end
        
        
        if cb_DFF
            set(ud.hp_DFF,...
                'xdata',vec(rect_boundary_plot_x(idx_boundary_DFF,:)'),...
                'ydata',vec(rect_boundary_plot_y(idx_boundary_DFF,:)'));
        else
            set(ud.hp_DFF,'xdata',nan,'ydata',nan);
        end
        
        if cb_InvBuf
            set(ud.hp_InvBuf,...
                'xdata',vec(rect_boundary_plot_x(idx_boundary_InvBuf,:)'),...
                'ydata',vec(rect_boundary_plot_y(idx_boundary_InvBuf,:)'));
        else
            set(ud.hp_InvBuf,'xdata',nan,'ydata',nan);
        end
        
        if cb_Comb
            set(ud.hp_Comb,...
                'xdata',vec(rect_boundary_plot_x(idx_boundary_Comb,:)'),...
                'ydata',vec(rect_boundary_plot_y(idx_boundary_Comb,:)'));
        else
            set(ud.hp_Comb,'xdata',nan,'ydata',nan);
        end
        
        
        
        axis(handles.axesLayout,'image');
        
        
        
        set(handles.axesLayout,'xlim',1*[-1,1]+[def.DIEAREA.xmin,def.DIEAREA.xmax]);
        set(handles.axesLayout,'ylim',1*[-1,1]+[def.DIEAREA.ymin,def.DIEAREA.ymax]);
        
        set(handles.axesLayout,'xtick',[def.DIEAREA.xmin,def.DIEAREA.xmax]);
        set(handles.axesLayout,'ytick',[def.DIEAREA.ymin,def.DIEAREA.ymax]);
        
        
        if 0
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
        end
        
        xlabel(handles.axesLayout,sprintf('x (%s)',def.UNITS.units));
        ylabel(handles.axesLayout,sprintf('y (%s)',def.UNITS.units));
        %title(handles.axesLayout,sprintf('%s',def.DESIGN.design));
        title(handles.axesLayout,'ARM core: physical layout');
        
        return;
        
        %%
            
% % % % % % %         
% % % % % % %         
% % % % % % %         
% % % % % % %         idx_boundary_DFF = strcmp({lef_by_component.name},'DFCNQSTKND2D1_MOD3');
% % % % % % %         
% % % % % % %         idx_boundary_DFF = strcmp({lef_by_component.name},'DFCNQSTKND2D1_MOD3');
% % % % % % %         
% % % % % % % 
% % % % % % %         % plot power & ground in lef
% % % % % % %         if 0
% % % % % % %             % case-sensitive
% % % % % % %             idx_POWER = strcmp(cat(1,lef_by_component.PIN_PORT_pin_use),'POWER');
% % % % % % %             idx_GROUND = strcmp(cat(1,lef_by_component.PIN_PORT_pin_use),'GROUND');
% % % % % % %             idx_SIGNAL = strcmp(cat(1,lef_by_component.PIN_PORT_pin_use),'SIGNAL');
% % % % % % %         else
% % % % % % %             % case insensitive
% % % % % % %             idx_POWER = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'POWER');
% % % % % % %             idx_GROUND = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'GROUND');
% % % % % % %             
% % % % % % %             idx_SIGNAL = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'SIGNAL') ...
% % % % % % %                 | strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'NDK_DEFAULT');
% % % % % % %             
% % % % % % %             idx_CLOCK = strcmpi(cat(1,lef_by_component.PIN_PORT_pin_use),'CLOCK');
% % % % % % %         end
% % % % % % %         
% % % % % % %         % filter DFF: error with double height
% % % % % % %         idx_DFCNQSTKD1 = strcmpi(cat(1,lef_by_component.PIN_PORT_macro_name_rep),'DFCNQSTKD1');
% % % % % % %         idx_POWER = idx_POWER & ~idx_DFCNQSTKD1;
% % % % % % %         idx_GROUND = idx_GROUND & ~idx_DFCNQSTKD1;
% % % % % % %         idx_SIGNAL = idx_SIGNAL & ~idx_DFCNQSTKD1;
% % % % % % %         idx_CLOCK = idx_CLOCK & ~idx_DFCNQSTKD1;
% % % % % % %         
% % % % % % %         PIN_PORT_rect_mat_plot_x = cat(1,lef_by_component.PIN_PORT_rect_mat_plot_x);
% % % % % % %         PIN_PORT_rect_mat_plot_y = cat(1,lef_by_component.PIN_PORT_rect_mat_plot_y);
% % % % % % %         
% % % % % % %         % class project
% % % % % % %         PIN_PORT_rect_mat_plot_x = vec(cat(1,lef_by_component.PIN_PORT_rect_mat_plot_x)');
% % % % % % %         PIN_PORT_rect_mat_plot_y = vec(cat(1,lef_by_component.PIN_PORT_rect_mat_plot_y)');
% % % % % % %         
% % % % % % %         
% % % % % % %         if 1
% % % % % % %            plot(...
% % % % % % %                vec(rect_boundary_plot_x(idx_boundary_DFF,:)'),...
% % % % % % %                vec(rect_boundary_plot_y(idx_boundary_DFF,:)'),...
% % % % % % %                'r-');
% % % % % % %         end
% % % % % % %         
% % % % % % %         
% % % % % % %         if 0
% % % % % % %             % plot ground
% % % % % % %             plot(...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_x(idx_GROUND,:)'),...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_y(idx_GROUND,:)'),...
% % % % % % %                 'k-');
% % % % % % %             
% % % % % % %             % plot power
% % % % % % %             plot(...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_x(idx_POWER,:)'),...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_y(idx_POWER,:)'),...
% % % % % % %                 'r-');
% % % % % % %             
% % % % % % %             % plot signal
% % % % % % %             plot(...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_x(idx_SIGNAL,:)'),...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_y(idx_SIGNAL,:)'),...
% % % % % % %                 'g-');
% % % % % % %             
% % % % % % %             % plot clock
% % % % % % %             plot(...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_x(idx_CLOCK,:)'),...
% % % % % % %                 vec(PIN_PORT_rect_mat_plot_y(idx_CLOCK,:)'),...
% % % % % % %                 'c-');
% % % % % % %         end
% % % % % % %         
% % % % % % %         % make text
% % % % % % %         for j=1:min([0,length(def.COMPONENTS)])
% % % % % % %             str = sprintf('%s\n%s\n%s\nSTD\\_ROW\\_%d',...
% % % % % % %                 def.COMPONENTS(j).lib_cell,...
% % % % % % %                 def.COMPONENTS(j).instance,...
% % % % % % %                 def.COMPONENTS(j).orientation,...
% % % % % % %                 def.COMPONENTS(j).row_id);
% % % % % % %            ht = text(def.COMPONENTS(j).x,def.COMPONENTS(j).y,str);
% % % % % % %            set(ht,'horizontalalignment','left','verticalalignment','bottom');
% % % % % % %         end
% % % % % % %         
% % % % % % %         axis image;
% % % % % % %         
% % % % % % %         set(gca,'xlim',1*[-1,1]+[def.DIEAREA.xmin,def.DIEAREA.xmax]);
% % % % % % %         set(gca,'ylim',1*[-1,1]+[def.DIEAREA.ymin,def.DIEAREA.ymax]);
% % % % % % %         
% % % % % % %         set(gca,'xtick',[def.DIEAREA.xmin,def.DIEAREA.xmax]);
% % % % % % %         set(gca,'ytick',[def.DIEAREA.ymin,def.DIEAREA.ymax]);
% % % % % % %         
% % % % % % %         [row_ymin,pos_descramble] = sort([def.ROW.ymin]);
% % % % % % %         if 0
% % % % % % %             row_id = [def.ROW(pos_descrabmel).id];
% % % % % % %             row_id_str = cell(length(row_id),1);
% % % % % % %         else
% % % % % % %             row_id_str = {def.ROW(pos_descramble).id_str};
% % % % % % %             row_orientation = {def.ROW(pos_descramble).orientation};
% % % % % % % %             for j=1:length(row_id)
% % % % % % % %                 row_id_str{j} = [SwapChar(row_id_str{j},'_','\_'),...
% % % % % % % %                     ': ',row_orientation{j}];
% % % % % % % %             end
% % % % % % %             row_id_ndk = [def.ROW(pos_descramble).id_ndk];
% % % % % % %             for j=1:length(row_id_ndk)
% % % % % % %                 row_id_str{j} = sprintf('NDK ROW %d: %s',row_id_ndk(j),row_orientation{j});
% % % % % % %             end            
% % % % % % %         end
% % % % % % %         set(gca,'ytick',row_ymin,'yticklabel',row_id_str);
% % % % % % %         
% % % % % % %         xlabel(sprintf('x (%s)',def.UNITS.units));
% % % % % % %         ylabel(sprintf('y (%s)',def.UNITS.units));
% % % % % % %         title(sprintf('%s',def.DESIGN.design));
% % % % % % %         




%%

% --- Executes on button press in checkboxInvBuf.
function checkboxInvBuf_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxInvBuf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxInvBuf

pushbuttonRefreshDisplay_Callback(handles.pushbuttonRefreshDisplay,[],handles);

% --- Executes on button press in checkboxComb.
function checkboxComb_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxComb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxComb

pushbuttonRefreshDisplay_Callback(handles.pushbuttonRefreshDisplay,[],handles);

% --- Executes on button press in checkboxDFF.
function checkboxDFF_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxDFF

pushbuttonRefreshDisplay_Callback(handles.pushbuttonRefreshDisplay,[],handles);

function editIon_Callback(hObject, eventdata, handles)
% hObject    handle to editIon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIon as text
%        str2double(get(hObject,'String')) returns contents of editIon as a double

fet_params = GUI2FETParams(handles);

val = str2double(get(hObject,'string'));
if isnan(val)
    UpdateStatus('unable to parse value for Ion',handles);
    FETParams2GUI(fet_params,handles);
    return;
end
if val < fet_params.bounds_Ion__uA_per_um(1)
    UpdateStatus('Ion too low, setting to lower bound',handles);
    val = fet_params.bounds_Ion__uA_per_um(1);
elseif val > fet_params.bounds_Ion__uA_per_um(2)
    UpdateStatus('Ion too high, setting to upper bound',handles);
    val = fet_params.bounds_Ion__uA_per_um(2);
else
    UpdateStatus(sprintf('updating Ion to %g',val),handles);
end

fet_params.Ion__uA_per_um = val;

FETParams2GUI(fet_params,handles);

% UpdateEDP(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function editIon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editIoff_Callback(hObject, eventdata, handles)
% hObject    handle to editIoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIoff as text
%        str2double(get(hObject,'String')) returns contents of editIoff as a double


fet_params = GUI2FETParams(handles);

val = str2double(get(hObject,'string'));
if isnan(val)
    UpdateStatus('unable to parse value for Ioff',handles);
    FETParams2GUI(fet_params,handles);
    return;
end
if val < fet_params.bounds_Ioff__nA_per_um(1)
    UpdateStatus('Ioff too low, setting to lower bound',handles);
    val = fet_params.bounds_Ioff__nA_per_um(1);
elseif val > fet_params.bounds_Ioff__nA_per_um(2)
    UpdateStatus('Ioff too high, setting to upper bound',handles);
    val = fet_params.bounds_Ioff__nA_per_um(2);
else
    UpdateStatus(sprintf('updating Ioff to %g',val),handles);
end

fet_params.Ioff__nA_per_um = val;

FETParams2GUI(fet_params,handles);

% UpdateEDP(hObject,eventdata,handles);



% --- Executes during object creation, after setting all properties.
function editIoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editVDD_Callback(hObject, eventdata, handles)
% hObject    handle to editVDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVDD as text
%        str2double(get(hObject,'String')) returns contents of editVDD as a double

fet_params = GUI2FETParams(handles);

val = str2double(get(hObject,'string'));
if isnan(val)
    UpdateStatus('unable to parse value for VDD',handles);
    FETParams2GUI(fet_params,handles);
    return;
end
if val < fet_params.bounds_VDD__V(1)
    UpdateStatus('VDD too low, setting to lower bound',handles);
    val = fet_params.bounds_VDD__V(1);
elseif val > fet_params.bounds_VDD__V(2)
    UpdateStatus('VDD too high, setting to upper bound',handles);
    val = fet_params.bounds_VDD__V(2);
else
    UpdateStatus(sprintf('updating VDD to %g',val),handles);
end

fet_params.VDD__V = val;

FETParams2GUI(fet_params,handles);

% UpdateEDP(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function editVDD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCgs_Callback(hObject, eventdata, handles)
% hObject    handle to editCgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCgs as text
%        str2double(get(hObject,'String')) returns contents of editCgs as a double


fet_params = GUI2FETParams(handles);

val = str2double(get(hObject,'string'));
if isnan(val)
    UpdateStatus('unable to parse value for Cgs',handles);
    FETParams2GUI(fet_params,handles);
    return;
end
if val < fet_params.bounds_Cgs__norm(1)
    UpdateStatus('Cgs too low, setting to lower bound',handles);
    val = fet_params.bounds_Cgs__norm(1);
elseif val > fet_params.bounds_Cgs__norm(2)
    UpdateStatus('Cgs too high, setting to upper bound',handles);
    val = fet_params.bounds_Cgs__norm(2);
else
    UpdateStatus(sprintf('updating Cgs to %g',val),handles);
end

fet_params.Cgs__norm = val;

FETParams2GUI(fet_params,handles);

% UpdateEDP(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function editCgs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UpdateEDP(hObject,eventdata,handles)
% function UpdateEDP(hObject,eventdata,handles)


%%
ud_core = get(handles.pushbuttonLoadARMCore,'userdata');

if isempty(ud_core)
   UpdateStatus('ARM core not loaded! unable to update EDP',handles);
   return;
end

UpdateStatus('Updating EDP...',handles);
do_dbg = false;

%%
def = ud_core.def;
lef_by_component = ud_core.lef_by_component;

fet_params = GUI2FETParams(handles);

%%

% unique cells:
lib_cell1 = unique({def.COMPONENTS.lib_cell}');
% lib_cell1 = 
%     'BUFFD1'
%     'BUFFD2'
%     'DFCNQSTKND2D1_MOD3'
%     'INVD0'
%     'INVD1'
%     'INVD2'
%     'INVD4'
%     'ND2D0'
%     'ND2D1'
%     'NR2ND2D0'

data_ref = [];
data_ref.VDD__V = 0.5;
data_ref.Ioff__nA_per_um = 100;
data_ref.W__nm = 72;
data_ref.CPP__nm = 42;


% rough approx for Cgs of each FET
eps0__F_per_m = 8.85e-12;
Hg   = 64e-9;
Lx   = 32e-9;
Lg   = 32e-9;
Lc   = 32e-9;
Xj   = 4e-9;
Tox  = 2e-9;
Kox  = 10.3;
Kspa = 5.5;
Ksi  = 11.7;

Cgc__F_per_m = Lg * Kox/Tox * eps0__F_per_m;
Cgs_par__F_per_m = Hg * Kspa/Lx * eps0__F_per_m;

Cgs__F_per_m = Cgc__F_per_m + Cgs_par__F_per_m;
% Cgs__F_per_um = 1e-6 * Cgs__F_per_m;
% Cgs__fF_per_um = 1e15 * Cgs__F_per_um;

Cj__F_per_m = Lc * Ksi/Xj * eps0__F_per_m;
% Cj__F_per_um = 1e-6 * Cj__F_per_m;
% Cj__fF_per_um = 1e15 * Cj__F_per_um;


Cgs__norm = fet_params.Cgs__norm;
Cgs__F_per_m = Cgs__norm * Cgs__F_per_m;
Cj__F_per_m = Cgs__norm * Cj__F_per_m;



% 7->10->14->22->32
% scale by sqrt(2)^5 = 5.6529
% 72 nm * 5.629 = 407.2935
% 64 * ceil(72 * 5.629 / 64)
W__nm = 448;
W__um = 1e-3 * W__nm;
W__m = 1e-9 * W__nm;


Ion__A_per_m = fet_params.Ion__uA_per_um;
VDD__V = fet_params.VDD__V;


data_lib_cell = [];
data_lib_cell.cell = '';
% data_lib_cell.VDD_ref__V = 0.5;
% data_lib_cell.Ioff_ref__nA_per_um = 100;
% data_lib_cell.W_ref__nm = 72; % D0 has 48 nm, D1 and above has 72 nm

data_lib_cell.Pleak_ref__nW = nan; % nW, not nA

% ==============================
% all cells

d_INVD0 = data_lib_cell;
d_INVD0.cell = 'INVD0';
d_INVD0.Pleak_ref__nW = 2.43185;
d_INVD0.Cin__F = 2 * (2/3) * Cgs__F_per_m * W__m; % 2 * (2/3) FETs on input
d_INVD0.Cpar__F = 2 * (2/3) * Cj__F_per_m * W__m; % 2 * (2/3) FETs on output
d_INVD0.Idr_r__A = Ion__A_per_m * W__m * (2/3); % 1 * (2/3) FETs full-drive pull-up
d_INVD0.Idr_f__A = Ion__A_per_m * W__m * (2/3); % 1 * (2/3) FETs half-drive pull-down
d_INVD0.dpar_r__s = log(2) * d_INVD0.Cpar__F * VDD__V / d_INVD0.Idr_r__A;
d_INVD0.dpar_f__s = log(2) * d_INVD0.Cpar__F * VDD__V / d_INVD0.Idr_f__A;
d_INVD0.Epar__J = 0.5 * d_INVD0.Cpar__F * VDD__V^2;
d_INVD0.Eint__J = 0;

d_INVD1 = data_lib_cell;
d_INVD1.cell = 'INVD1';
d_INVD1.Pleak_ref__nW = 3.60024;
d_INVD1.Cin__F = 2 * Cgs__F_per_m * W__m; % 2 FETs on input
d_INVD1.Cpar__F = 2 * Cj__F_per_m * W__m; % 2 FETs on output
d_INVD1.Idr_r__A = 1 * Ion__A_per_m * W__m; % 1 FET full-drive pull-up
d_INVD1.Idr_f__A = 1 * Ion__A_per_m * W__m; % 1 FET full-drive pull-down
d_INVD1.dpar_r__s = log(2) * d_INVD1.Cpar__F * VDD__V / d_INVD1.Idr_r__A;
d_INVD1.dpar_f__s = log(2) * d_INVD1.Cpar__F * VDD__V / d_INVD1.Idr_f__A;
d_INVD1.Epar__J = 0.5 * d_INVD1.Cpar__F * VDD__V^2;
d_INVD1.Eint__J = 0;

d_INVD2 = data_lib_cell;
d_INVD2.cell = 'INVD2';
d_INVD2.Pleak_ref__nW = 7.20049;
d_INVD2.Cin__F = 4 * Cgs__F_per_m * W__m; % 4 FETs on input
d_INVD2.Cpar__F = 4 * Cj__F_per_m * W__m; % 4 FETs on output
d_INVD2.Idr_r__A = 2 * Ion__A_per_m * W__m; % 2 FETs full-drive pull-up
d_INVD2.Idr_f__A = 2 * Ion__A_per_m * W__m; % 2 FETs full-drive pull-down
d_INVD2.dpar_r__s = log(2) * d_INVD2.Cpar__F * VDD__V / d_INVD2.Idr_r__A;
d_INVD2.dpar_f__s = log(2) * d_INVD2.Cpar__F * VDD__V / d_INVD2.Idr_f__A;
d_INVD2.Epar__J = 0.5 * d_INVD2.Cpar__F * VDD__V^2;
d_INVD2.Eint__J = 0;

d_INVD4 = data_lib_cell;
d_INVD4.cell = 'INVD4';
d_INVD4.Pleak_ref__nW = 14.4009;
d_INVD4.Cin__F = 8 * Cgs__F_per_m * W__m; % 8 FETs on input
d_INVD4.Cpar__F = 8 * Cj__F_per_m * W__m; % 8 FETs on output
d_INVD4.Idr_r__A = 4 * Ion__A_per_m * W__m; % 4 FETs full-drive pull-up
d_INVD4.Idr_f__A = 4 * Ion__A_per_m * W__m; % 4 FETs full-drive pull-down
d_INVD4.dpar_r__s = log(2) * d_INVD4.Cpar__F * VDD__V / d_INVD4.Idr_r__A;
d_INVD4.dpar_f__s = log(2) * d_INVD4.Cpar__F * VDD__V / d_INVD4.Idr_f__A;
d_INVD4.Epar__J = 0.5 * d_INVD4.Cpar__F * VDD__V^2;
d_INVD4.Eint__J = 0;

d_ND2D0 = data_lib_cell;
d_ND2D0.cell = 'ND2D0';
d_ND2D0.Pleak_ref__nW = 2.71848;
d_ND2D0.Cin__F = 2 * (2/3) * Cgs__F_per_m * W__m; % 2 * (2/3) FETs on input
d_ND2D0.Cpar__F = 3 * (2/3) * Cj__F_per_m * W__m; % 3 * (2/3) FETs on output
d_ND2D0.Idr_r__A = 1 * (2/3) * Ion__A_per_m * W__m; % 1 * (2/3) FET full drive on pull-up
d_ND2D0.Idr_f__A = 1 * (2/3) * 0.5 * Ion__A_per_m * W__m; % 1 * (2/3) FET half drive on pull-down
d_ND2D0.dpar_r__s = log(2) * d_ND2D0.Cpar__F * VDD__V / d_ND2D0.Idr_r__A;
d_ND2D0.dpar_f__s = log(2) * d_ND2D0.Cpar__F * VDD__V / d_ND2D0.Idr_f__A;
d_ND2D0.Epar__J = 0.5 * d_ND2D0.Cpar__F * VDD__V^2;
d_ND2D0.Eint__J = 0;

d_ND2D1 = data_lib_cell;
d_ND2D1.cell = 'ND2D1';
d_ND2D1.Pleak_ref__nW = 4.02458;
d_ND2D1.Cin__F = 2 * Cgs__F_per_m * W__m; % 2 FETs on input
d_ND2D1.Cpar__F = 3 * Cj__F_per_m * W__m; % 3 FETs on output
d_ND2D1.Idr_r__A = 1 * Ion__A_per_m * W__m; % 1 FET full drive on pull-up
d_ND2D1.Idr_f__A = 1 * 0.5 * Ion__A_per_m * W__m; % 1 FET half drive on pull-down
d_ND2D1.dpar_r__s = log(2) * d_ND2D1.Cpar__F * VDD__V / d_ND2D1.Idr_r__A;
d_ND2D1.dpar_f__s = log(2) * d_ND2D1.Cpar__F * VDD__V / d_ND2D1.Idr_f__A;
d_ND2D1.Epar__J = 0.5 * d_ND2D1.Cpar__F * VDD__V^2;
d_ND2D1.Eint__J = 0;

d_NR2ND2D0 = data_lib_cell;
d_NR2ND2D0.cell = 'NR2ND2D0';
d_NR2ND2D0.Pleak_ref__nW = 2.71848;
d_NR2ND2D0.Pleak_ref__nW = 4.02458;
d_NR2ND2D0.Cin__F = 2 * (2/3) * Cgs__F_per_m * W__m; % 2 * (2/3) FETs on input
d_NR2ND2D0.Cpar__F = 3 * (2/3) * Cj__F_per_m * W__m; % 3 * (2/3) FETs on output
d_NR2ND2D0.Idr_r__A = 1 * (2/3) * 0.5 * Ion__A_per_m * W__m; % 1 FET half drive on pull-up
d_NR2ND2D0.Idr_f__A = 1 * (2/3) * Ion__A_per_m * W__m; % 1 FET full drive on pull-down
d_NR2ND2D0.dpar_r__s = log(2) * d_NR2ND2D0.Cpar__F * VDD__V / d_NR2ND2D0.Idr_r__A;
d_NR2ND2D0.dpar_f__s = log(2) * d_NR2ND2D0.Cpar__F * VDD__V / d_NR2ND2D0.Idr_f__A;
d_NR2ND2D0.Epar__J = 0.5 * d_NR2ND2D0.Cpar__F * VDD__V^2;
d_NR2ND2D0.Eint__J = 0;

% BUFFD1 is INVD1 driving INVD1
d_BUFFD1 = data_lib_cell;
d_BUFFD1.cell = 'BUFFD1';
d_BUFFD1.Pleak_ref__nW = 7.20137;
d_BUFFD1.Cin__F = 2 * Cgs__F_per_m * W__m; % 2 FETs on input
d_BUFFD1.Cpar__F = 2 * Cj__F_per_m * W__m; % 2 FETs on output
d_BUFFD1.Idr_r__A = 1 * Ion__A_per_m * W__m; % 1 FET full-drive pull-up
d_BUFFD1.Idr_f__A = 1 * Ion__A_per_m * W__m; % 1 FET full-drive pull-down
d_BUFFD1.dpar_r__s = d_INVD1.dpar_f__s + ... % INVD1 parasitic fall delay
    log(2) * d_INVD1.Cin__F * VDD__V / d_INVD1.Idr_f__A + ... % INVD1 fall to drive INVD1
    log(2) * d_BUFFD1.Cpar__F * VDD__V / d_BUFFD1.Idr_r__A; % BUFFD1 rise
d_BUFFD1.dpar_f__s = d_INVD1.dpar_r__s + ... % INVD1 parasitic rise delay
    log(2) * d_INVD1.Cin__F * VDD__V / d_INVD1.Idr_r__A + ... % INVD1 rise to drive INVD1
    log(2) * d_BUFFD1.Cpar__F * VDD__V / d_BUFFD1.Idr_f__A; % BUFFD1 fall
d_BUFFD1.Epar__J = 0.5 * d_BUFFD1.Cpar__F * VDD__V^2;
d_BUFFD1.Eint__J = d_INVD1.Epar__J + ... % output of INVD1
    0.5 * d_INVD1.Cin__F * VDD__V^2; % input of INVD1

% BUFFD2 is INVD1 driving INVD2
d_BUFFD2 = data_lib_cell;
d_BUFFD2.cell = 'BUFFD2';
d_BUFFD2.Pleak_ref__nW = 14.4028;
d_BUFFD2.Cin__F = 2 * Cgs__F_per_m * W__m; % 2 FETs on input
d_BUFFD2.Cpar__F = 4 * Cj__F_per_m * W__m; % 4 FETs on output
d_BUFFD2.Idr_r__A = 2 * Ion__A_per_m * W__m; % 2 FET full-drive pull-up
d_BUFFD2.Idr_f__A = 2 * Ion__A_per_m * W__m; % 2 FET full-drive pull-down
d_BUFFD2.dpar_r__s = d_INVD1.dpar_f__s + ... % INVD1 parasitic fall delay
    log(2) * d_INVD2.Cin__F * VDD__V / d_INVD1.Idr_f__A + ... % INVD1 fall to drive INVD2
    log(2) * d_BUFFD2.Cpar__F * VDD__V / d_BUFFD2.Idr_r__A; % BUFFD1 rise
d_BUFFD2.dpar_f__s = d_INVD1.dpar_r__s + ... % INVD1 parasitic rise delay
    log(2) * d_INVD1.Cin__F * VDD__V / d_INVD1.Idr_r__A + ... % INVD1 rise to drive INVD1
    log(2) * d_BUFFD2.Cpar__F * VDD__V / d_BUFFD2.Idr_f__A; % BUFFD1 fall
d_BUFFD2.Epar__J = 0.5 * d_BUFFD1.Cpar__F * VDD__V^2;
d_BUFFD2.Eint__J = d_INVD1.Epar__J + ... % output of INVD1
    0.5 * d_INVD2.Cin__F * VDD__V^2; % input of INVD2

% assume DFF has same input/output as BUFFD1
% (approximate internal energy & setup/hold timing as 0)
d_DFCNQSTKND2D1_MOD3 = data_lib_cell;
d_DFCNQSTKND2D1_MOD3.cell = 'DFCNQSTKND2D1_MOD3';
d_DFCNQSTKND2D1_MOD3.Pleak_ref__nW = 26.7588;
d_DFCNQSTKND2D1_MOD3.Cin__F = d_BUFFD2.Cin__F;
d_DFCNQSTKND2D1_MOD3.Cpar__F = d_BUFFD2.Cpar__F;
d_DFCNQSTKND2D1_MOD3.Idr_r__A = d_BUFFD2.Idr_r__A;
d_DFCNQSTKND2D1_MOD3.Idr_f__A = d_BUFFD2.Idr_f__A;
d_DFCNQSTKND2D1_MOD3.dpar_r__s = d_BUFFD2.dpar_r__s;
d_DFCNQSTKND2D1_MOD3.dpar_f__s = d_BUFFD2.dpar_r__s;
d_DFCNQSTKND2D1_MOD3.Epar__J = d_BUFFD2.Epar__J;
d_DFCNQSTKND2D1_MOD3.Eint__J = 9 * d_ND2D0.Epar__J + ... % 9 NAND outputs
    4 * d_INVD0.Epar__J + ... % 4 INV outputs
    0.5 * 9 * 2 * d_ND2D0.Cin__F * VDD__V^2 + ... % 9 NAND inputs (*2 inputs each)
    0.5 * 4 * d_ND2D0.Cin__F * VDD__V^2; % 4 INV inputs

% concatenate
dataAll_lib_cell = [;
    d_BUFFD1;
    d_BUFFD2;
    d_DFCNQSTKND2D1_MOD3;
    d_INVD0;
    d_INVD1;
    d_INVD2;
    d_INVD4;
    d_ND2D0;
    d_ND2D1;
    d_NR2ND2D0;
    ];

lib_cell_name = {dataAll_lib_cell.cell}';


%%



% compute leakage
Pleak_ref_total__nW = 0;
num_COMPONENTS = length(def.COMPONENTS);

for i=1:num_COMPONENTS
   idx_lib_cell = strcmp(def.COMPONENTS(i).lib_cell,lib_cell_name);
   if nnz(idx_lib_cell) == 0
       error('lib_cell not found: ''%s''',def.COMPONENTS(i).lib_cell);
   elseif nnz(idx_lib_cell) > 1
       error('multiple lib_cell found: ''%s''',def.COMPONENTS(i).lib_cell);
   end
      
   Pleak_ref_total__nW = Pleak_ref_total__nW + dataAll_lib_cell(idx_lib_cell).Pleak_ref__nW;
end

% Pleak_ref_total__nW

Pleak_total__W = 1e-9 * Pleak_ref_total__nW ...
    * (fet_params.VDD__V / data_ref.VDD__V) ... % scale by voltage
    * (fet_params.Ioff__nA_per_um / data_ref.Ioff__nA_per_um) ...
    * (W__nm / data_ref.W__nm); % scale by width
    
% UpdateStatus(sprintf('leakage power: %g W',Pleak_total__W),handles)





%% compute dynamic energy

Edynamic_total__J = 0;

Ewire_total__J = 0;
Epar_total__J = 0;
Ein_total__J = 0;

Cw__fF_per_um = 0.15;
Cw__fF_per_m = 1e6 * Cw__fF_per_um;
Cw__F_per_m = 1e-15 * Cw__fF_per_m;

num_NETS = length(def.NETS);

% Lg + Lc + 2*Lx, all 32 nm
CPP__nm = 4 * 32;

% scale wires in y dimension by the relative height of the standard cells
scale_y = W__nm / data_ref.W__nm;
% scale wires in x dimension by the relative contacted gate pitch
scale_x = CPP__nm / data_ref.CPP__nm;



% logic switching activity factor
activity_factor = 0.1;

% add delay to NETS data
def.NETS(1).dpar_r__s = 0;
def.NETS(1).dpar_f__s = 0;

def.NETS(1).d_rwire_cwire_r__s = 0;
def.NETS(1).d_rwire_cwire_f__s = 0;

def.NETS(1).d_rdrive_cwire_r__s = 0;
def.NETS(1).d_rdrive_cwire_f__s = 0;

def.NETS(1).d_rwire_cin_r__s = 0;
def.NETS(1).d_rwire_cin_f__s = 0;

def.NETS(1).d_rdrive_cin_r__s = 0;
def.NETS(1).d_rdrive_cin_f__s = 0;

def.NETS(1).d_r__s = 0;
def.NETS(1).d_f__s = 0;



% resistivity of copper, ohm.m
rho_wire__Ohm_m = 1.68e-8;

Ww__m = 32e-9; % wire width
Hw__m = 2*Ww__m; % wire height

Rw__Ohm_per_m = rho_wire__Ohm_m / (Ww__m * Hw__m);
Rw__Ohm_per_um = 1e-6 * Rw__Ohm_per_m;




for i=1:num_NETS
    data_csv = def.NETS(i).data_csv;
    
    if isempty(data_csv)
        len_m = 0;
        if do_dbg
        fprintf('WARNING: no .csv data found for net ''%s''\n',def.NETS(i).name);
        end
    else
        % wire len
        x_len_m = def.NETS(i).data_csv.x_len_m * scale_x;
        y_len_m = def.NETS(i).data_csv.y_len_m * scale_y;
        len_m = x_len_m + y_len_m; % manhattan distance
    end
    
    % wire cap
    Cwire_tmp__F = Cw__F_per_m * len_m;
    
    % wire energy
    Ewire_tmp__J = 0.5 * Cwire_tmp__F * VDD__V^2;
    
    % add to total wire energy
    Ewire_total__J = Ewire_total__J + Ewire_tmp__J;
    
    % wire res
    Rwire_tmp__Ohm = Rw__Ohm_per_m * len_m;
    
    
    
    % ----------------------
    % get energy to drive input of fanout gates (multiple per net)
    p_lib_cell_load = def.NETS(i).p_GATE_PAIR_lib_cell_load;
    
    Ein_tmp__J = 0; % 0 for both cases (need to accumulate)
    Cin_tmp__F = 0; % accumulate capacitance to compute load
    
    for j=1:length(p_lib_cell_load)
        lib_cell_load_tmp = p_lib_cell_load{j};
        
        idx_lib_cell_name = strcmpi(lib_cell_load_tmp,lib_cell_name);
        if nnz(idx_lib_cell_name) == 0
            error('lib cell not found ''%s''',lib_cell_load_tmp);
        elseif nnz(idx_lib_cell_name) > 1
            error('multiple lib cell matches');
        end
        
        lib_cell_tmp = dataAll_lib_cell(idx_lib_cell_name);
       
        Cin_tmp_tmp__F = lib_cell_tmp.Cin__F;
        Ein_tmp_tmp__J = 0.5 * lib_cell_tmp.Cin__F * VDD__V^2;
        
        % accumulate Ein for fanout
        Ein_tmp__J = Ein_tmp__J + Ein_tmp_tmp__J;
        % accumulate Cin for delay
        Cin_tmp__F = Cin_tmp__F + Cin_tmp_tmp__F;
    end
    
    %Cload_tmp__F = Cin_tmp__F + Cwire_tmp__F;
    
    % add to total energy for driving logic gate inputs
    Ein_total__J = Ein_total__J + Ein_tmp__J;    
    
    
    % ----------------------
    % get parasitic energy of output
    % also compute delay of driving logic gate
    p_lib_cell_drive_tmp = unique(def.NETS(i).p_GATE_PAIR_lib_cell_drive);
    
    if isempty(p_lib_cell_drive_tmp)
        Epar_tmp__J = 0;
        
% def.NETS(1).dpar_r__s = 0;
% def.NETS(1).dpar_f__s = 0;
% 
% def.NETS(1).d_rwire_cwire_r__s = 0;
% def.NETS(1).d_rwire_cwire_f__s = 0;
% 
% def.NETS(1).d_rdrive_cwire_r__s = 0;
% def.NETS(1).d_rdrive_cwire_f__s = 0;
% 
% def.NETS(1).d_rwire_cin_r__s = 0;
% def.NETS(1).d_rwire_cin_f__s = 0;
% 
% def.NETS(1).d_rdrive_cin_r__s = 0;
% def.NETS(1).d_rdrive_cin_f__s = 0;
% 
% def.NETS(1).d_r__s = 0;
% def.NETS(1).d_f__s = 0;        
        
        dpar_r__s = nan;
        dpar_f__s = nan;
        d_rwire_cwire_r__s = nan;
        d_rwire_cwire_f__s = nan;
        d_rdrive_cwire_r__s = nan;
        d_rdrive_cwire_f__s = nan;
        d_rwire_cin_r__s = nan;
        d_rwire_cin_f__s = nan;
        d_rdrive_cin_r__s = nan;
        d_rdrive_cin_f__s = nan;
       
    else
        % assume only one cell is driving this net (no wired or)
        if length(p_lib_cell_drive_tmp) > 1
            error('unexpected multiple cells driving same net');
        end
        
        lib_cell_drive_tmp = p_lib_cell_drive_tmp{1};
        
        % parasitic output energy
        %     lib_cell_name = {dataAll_lib_cell.cell}';
        idx_lib_cell_name = strcmpi(lib_cell_drive_tmp,lib_cell_name);
        if nnz(idx_lib_cell_name) == 0
            error('lib cell not found: ''%s''',lib_cell_drive_tmp);
        elseif nnz(idx_lib_cell_name) > 1
            error('multiple lib cell matches');
        end
        
        lib_cell_tmp = dataAll_lib_cell(idx_lib_cell_name);
        
        Epar_tmp__J = lib_cell_tmp.Epar__J;
        
        
        % delay
        dpar_r__s = lib_cell_tmp.dpar_r__s;
        dpar_f__s = lib_cell_tmp.dpar_f__s;
        d_rwire_cwire_r__s = log(2) * Rwire_tmp__Ohm * (Cwire_tmp__F/2);
        d_rwire_cwire_f__s = log(2) * Rwire_tmp__Ohm * (Cwire_tmp__F/2);
        d_rdrive_cwire_r__s = log(2) * (2*Cwire_tmp__F/2) * VDD__V / lib_cell_tmp.Idr_r__A; % on both sides of pi model
        d_rdrive_cwire_f__s = log(2) * (2*Cwire_tmp__F/2) * VDD__V / lib_cell_tmp.Idr_f__A; % on both sides of pi model
        d_rwire_cin_r__s = log(2) * Rwire_tmp__Ohm * Cin_tmp__F;
        d_rwire_cin_f__s = log(2) * Rwire_tmp__Ohm * Cin_tmp__F;
        d_rdrive_cin_r__s = log(2) * Cin_tmp__F * VDD__V / lib_cell_tmp.Idr_r__A;
        d_rdrive_cin_f__s = log(2) * Cin_tmp__F * VDD__V / lib_cell_tmp.Idr_f__A;

    end
    
    d_r__s = sum([dpar_r__s, d_rwire_cwire_r__s, d_rdrive_cwire_r__s, d_rwire_cin_r__s, d_rdrive_cin_r__s]);
    d_f__s = sum([dpar_f__s, d_rwire_cwire_f__s, d_rdrive_cwire_f__s, d_rwire_cin_f__s, d_rdrive_cin_f__s]);
    
    % add to total parasitic output energy
    Epar_total__J = Epar_total__J + Epar_tmp__J;
    
    % store delay
    def.NETS(i).dpar_r__s = dpar_r__s;
    def.NETS(i).dpar_f__s = dpar_f__s;
    
    def.NETS(i).d_rwire_cwire_r__s = d_rwire_cwire_r__s;
    def.NETS(i).d_rwire_cwire_f__s = d_rwire_cwire_f__s;
    
    def.NETS(i).d_rdrive_cwire_r__s = d_rdrive_cwire_r__s;
    def.NETS(i).d_rdrive_cwire_f__s = d_rdrive_cwire_f__s;
    
    def.NETS(i).d_rwire_cin_r__s = d_rwire_cin_r__s;
    def.NETS(i).d_rwire_cin_f__s = d_rwire_cin_f__s;
    
    def.NETS(i).d_rdrive_cin_r__s = d_rdrive_cin_r__s;
    def.NETS(i).d_rdrive_cin_f__s = d_rdrive_cin_f__s;
    
    def.NETS(i).d_r__s = d_r__s;
    def.NETS(i).d_f__s = d_f__s;

    
end
    

Epar_total__J = activity_factor * Epar_total__J;
Ewire_total__J = activity_factor * Ewire_total__J;
Ein_total__J = activity_factor * Ein_total__J;


d_r_all__s = [def.NETS.d_r__s]';
d_f_all__s = [def.NETS.d_f__s]';

idx_filt = isnan(d_r_all__s) | isnan(d_f_all__s);

d_r_all_filt__s = d_r_all__s(~idx_filt);
d_f_all_filt__s = d_f_all__s(~idx_filt);


d_r_avg__s = mean(d_r_all_filt__s);
d_f_avg__s = mean(d_f_all_filt__s);

d_avg__s = mean([d_r_avg__s,d_f_avg__s]);
d_avg__ps = 1e12 * d_avg__s;


logic_depth_ARM_core = 179;

% --------------------
% compute delay of critical path

%Tcrit__ps = 1e3; % test
Tcrit__ps = logic_depth_ARM_core * d_avg__ps;

% 
freq__GHz = 1e3 / Tcrit__ps;
freq__Hz = 1e9 * freq__GHz;

% ----------------------
% %% total leakage energy

Eleak_total__J = Pleak_total__W / freq__Hz;

if do_dbg
Epar_total__J
Ewire_total__J
Ein_total__J
Eleak_total__J
end

Edynamic_total__J = Epar_total__J + Ewire_total__J + Ein_total__J;

if do_dbg
Edynamic_total__J
end

%% total energy

Etotal__J = Eleak_total__J + Edynamic_total__J;

%% total EDP

EDPtotal__J_s = Etotal__J / freq__Hz;

EDPtotal__pJ_ps = 1e12 * 1e12 * EDPtotal__J_s;

%% update userdata

myVars = {;
    'Pleak_total__W';
    'Eleak_total__J';
    'Epar_total__J';
    'Ein_total__J';
    'Ewire_total__J';
    'Edynamic_total__J';
    'freq__Hz';
    'Etotal__J';
    'EDPtotal__J_s';
    'fet_params';
    };

core_metrics = [];
for i=1:length(myVars)
    evalStr = sprintf('core_metrics.%s = %s;',myVars{i},myVars{i});
    eval(evalStr);
end

set(handles.uitableEDP,'userdata',core_metrics);

UpdateStatus('Updating EDP... complete!',handles);



%% refresh axes

RefreshAxesEDP(hObject,eventdata,handles);



% --- Executes on button press in pushbuttonClear.
function pushbuttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RefreshAxesEDP(hObject,eventdata,handles)


%%
function RefreshAxesEDP(hObject,eventdata,handles)
% function RefreshAxesEDP(hObject,eventdata,handles)

%%
ud_edp = get(handles.axesEDP,'userdata');

color_all = [0,0,0];
color_last2 = [0,0,1]; % same color but smaller
color_last1 = [1,0,0];

ms_all = 10;
ms_last2 = 20;
ms_last1 = 30;

if isempty(ud_edp) ...
        || hObject == handles.pushbuttonClear % called from pushbuttonClear_Callback
    set(handles.axesEDP,'nextplot','replace');
    ud_edp.hp_all   = plot(nan,nan,'.-','color',color_all  ,'markersize',ms_all);
    set(handles.axesEDP,'nextplot','add');
    ud_edp.hp_last2 = plot(nan,nan,'.','color',color_last2,'markersize',ms_last2);
    ud_edp.hp_last1 = plot(nan,nan,'.','color',color_last1,'markersize',ms_last1);
end

core_metrics = get(handles.uitableEDP,'userdata');
if isempty(core_metrics)
    UpdateStatus('core metrics not calculated! returning',handles);
   return; 
end

freq__GHz = 1e-9 * core_metrics.freq__Hz;
Etotal__J = core_metrics.Etotal__J;
Etotal__pJ = 1e12 * Etotal__J;

x_all = [get(ud_edp.hp_all,'xdata'),freq__GHz];
%y_all = [get(ud_edp.hp_all,'ydata'),Etotal__J];
y_all = [get(ud_edp.hp_all,'ydata'),Etotal__pJ];

x_last2 = x_all(end-1);
y_last2 = y_all(end-1);

x_last1 = x_all(end);
y_last1 = y_all(end);

set(ud_edp.hp_all  ,'xdata',x_all  ,'ydata',y_all);
set(ud_edp.hp_last2,'xdata',x_last2,'ydata',y_last2);
set(ud_edp.hp_last1,'xdata',x_last1,'ydata',y_last1);

set(handles.axesEDP,'xscale','log');
set(handles.axesEDP,'yscale','log');

% rd_xlim = get(handles.axesEDP,'xlim')

bounds_x = [min(x_all),max(x_all)];
bounds_y = [min(y_all),max(y_all)];

myxlim = 10.^[floor(log10(bounds_x(1))),ceil(log10(bounds_x(2)))];
myylim = 10.^[floor(log10(bounds_y(1))),ceil(log10(bounds_y(2)))];

if myxlim(1) == myxlim(2)
    myxlim = myxlim .* [0.1,10];
end
if myylim(1) == myylim(2)
    myylim = myylim .* [0.1,10];
end

legStr = {;
    'all designs';
    '2nd most-recent design';
    'most recent design';
    };
legend(legStr,'location','eastoutside');

set(handles.axesEDP,'xlim',myxlim);
set(handles.axesEDP,'ylim',myylim);


xlabel(handles.axesEDP,'clock frequency (GHz)');
ylabel(handles.axesEDP,'energy per clock cycle (pJ)');
title(handles.axesEDP,'ARM core: energy vs. frequency');

grid(handles.axesEDP,'on');

set(handles.axesEDP,'userdata',ud_edp);

%% update table
%get(handles.uitableEDP,'string')
% cell_data = {;
%     'one'   ,   'two';
%     'three' ,   'four';
%     };
% my_fields = fields(core_metrics
% cell_data = cell(

%fmt = '%.3f';
fmt = '%.4g';

fet_params = core_metrics.fet_params;

cell_data = {;
    '--- FET parameters ---'  ,   '';
    'on-current (uA/um)'      ,   sprintf(fmt,fet_params.Ion__uA_per_um);
    'off-current (nA/um)'     ,   sprintf(fmt,fet_params.Ioff__nA_per_um);
    'supply voltage (V)'      ,   sprintf(fmt,fet_params.VDD__V);
    'Cgs (normalized)'        ,   sprintf(fmt,fet_params.Cgs__norm);
%     'leakage power (W)'     ,   core_metrics.Pleak_total__W;
    '--- ARM core metrics ---',   '';
    'leakage energy (pJ)'     ,   sprintf(fmt,1e12*core_metrics.Eleak_total__J);
    'dynamic energy (pJ)'     ,   sprintf(fmt,1e12*core_metrics.Edynamic_total__J);
    'TOTAL energy (pJ)'       ,   sprintf(fmt,1e12*core_metrics.Etotal__J);
    'clock frequency (GHz)'   ,   sprintf(fmt,1e-9 * core_metrics.freq__Hz);
    'EDP (ns*pJ)'             ,   sprintf(fmt,1e9 * 1e12 * core_metrics.EDPtotal__J_s);
    };

set(handles.uitableEDP,'RowName',cell_data(:,1));
set(handles.uitableEDP,'ColumnName',{'value'});

set(handles.uitableEDP,'data',cell_data(:,2));
1;


% --- Executes on button press in pushbuttonAnalyze.
function pushbuttonAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UpdateEDP(hObject,eventdata,handles);
