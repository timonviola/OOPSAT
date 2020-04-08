function fm_abcd(obj)
% FM_ABCD sets up matrices A, B, C and D for linear analysis
%         The matrices are stored in the structure obj.LA.
%
% Synthax:
%
% FM_ABCD
%
%Author:    Federico Milano
%Date:      29-Mar-2008
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

% Check for dynamic components
if ~obj.DAE.n
  obj.fm_disp('No dynamic component is loaded.')
  obj.fm_disp('Computation of linear dynamic matrices aborted.')
  return
end

obj.fm_disp('Computation of input/output matrices A,B,C,D:')
obj.fm_disp
obj.fm_disp('[Delta dx/dt] = [A] [Delta x] + [B] [Delta u]')
obj.fm_disp('    [Delta y] = [C] [Delta x] + [D] [Delta u]')
obj.fm_disp
obj.fm_disp('These matrices are stored in structure obj.LA.')

n = obj.DAE.n+obj.DAE.m;

% -------------------------------------------------------------------
% B & D matrices
% -------------------------------------------------------------------

obj.LA.d_y = 0;

bdmatrix(obj.Exc,obj);      % define obj.LA.b_avr       obj.LA.d_avr    AVclass
bdmatrix(obj.Tg,obj);       % define obj.LA.b_tg        obj.LA.d_tg     TGclass
bdmatrix(obj.Svc,obj);      % define obj.LA.b_svc       obj.LA.d_svc    SVclass
bdmatrix(obj.Tcsc,obj);     % define obj.LA.b_tcsc      obj.LA.d_tcsc   TCclass
bdmatrix(obj.Statcom,obj);  % define obj.LA.b_statcom   obj.LA.d_statcom STclass
bdmatrix(obj.Sssc,obj);     % define obj.LA.b_sssc      obj.LA.d_sssc    SSclass
bdmatrix(obj.Upfc,obj);     % define obj.LA.b_upfc      obj.LA.d_upfc    UPclass
bdmatrix(obj.Hvdc,obj);     % define obj.LA.b_hvdc      obj.LA.d_hvdc    HVclass

% -------------------------------------------------------------------
% C matrices
% -------------------------------------------------------------------

obj.LA.c_y = -full(obj.DAE.Gy\obj.DAE.Gx); % define obj.LA.c_y (algebraic variables as output)

% -------------------------------------------------------------------
% H matrices
% -------------------------------------------------------------------

hmatrix(obj.Line,obj); % define obj.LA.h_ps obj.LA.h_qs obj.LA.h_is
               %        obj.LA.h_pr obj.LA.h_qr obj.LA.h_ir

% -------------------------------------------------------------------
% A matrix
% -------------------------------------------------------------------

obj.LA.a = full(obj.DAE.Fx + obj.DAE.Fy*obj.LA.c_y);

obj.fm_disp('Computation of input/output matrices completed.')
