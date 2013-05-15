function exportToC(obj, fname, dirname)
%MPT_EXPORTST Exports a search tree to C code
%
% mpt_exportST(ctrl, fname)
%
% ---------------------------------------------------------------------------
% DESCRIPTION
% ---------------------------------------------------------------------------
% Creates a standalone C-file which contains definition of the search tree and
% code which identifies control action associated to a given state.
%
% ---------------------------------------------------------------------------
% INPUT
% ---------------------------------------------------------------------------
% ctrl   - MPT explicit controller
% fname  - Name of the header file to be generated ("searchtree.c" by default)
%
% ---------------------------------------------------------------------------
% OUTPUT                                                                                                    
% ---------------------------------------------------------------------------
%

% Copyright is with the following author(s):
%
% (C) 2006 Michal Kvasnica, Automatic Control Laboratory, ETH Zurich,
%          kvasnica@control.ee.ethz.ch
%     2012 Revised by Martin Herceg, Automatic Control Laboratory, ETH
%          Zurich, herceg@control.ee.ethz.ch

% ---------------------------------------------------------------------------
% Legal note:
%          This program is free software; you can redistribute it and/or
%          modify it under the terms of the GNU General Public
%          License as published by the Free Software Foundation; either
%          version 2.1 of the License, or (at your option) any later version.
%
%          This program is distributed in the hope that it will be useful,
%          but WITHOUT ANY WARRANTY; without even the implied warranty of
%          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%          General Public License for more details.
% 
%          You should have received a copy of the GNU General Public
%          License along with this library; if not, write to the 
%          Free Software Foundation, Inc., 
%          59 Temple Place, Suite 330, 
%          Boston, MA  02111-1307  USA
%
% ---------------------------------------------------------------------------


global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

if nargin<2,
    fname = 'mpt_searchTree';
else
    if isempty(fname)
        fname = 'mpt_searchTree';
    end
    fname = strtrim(fname);
    if ~isempty(regexp(fname,'\W', 'once'))
        error('The file name must contain only alphanumerical characters including underscore "_".');
    end
end

if nargin<3
    dirname = 'mpt_explicit_controller';
else
    if isempty(dirname)
        dirname = 'mpt_explicit_controller';
    end
    if ~isempty(regexp(dirname,'\W', 'once'))
        error('The file name must contain only alphanumerical characters including underscore "_".');
    end
end
% append the dirname to a current directory
dirname = [pwd, filesep, dirname];

% generate the files inside given directory
if ~mkdir(dirname)
    error('Could not create directory "%s".',dirname);
end
% add extension
fullfilename = [dirname, filesep, fname,'.h'];


% extract search tree
ST = obj.STdata.tree'; ST = ST(:);

% extract dimensions
nr = obj.feedback.Num;
nx = obj.nx;
nu = obj.nu;
ny = nx;
nref = 0;
nxt = nx;
Ts = obj.model.Ts;
if isempty(Ts)
    Ts = 1;
end


% extract control law
Pn = obj.feedback.Set;
Fi = cell(nr,1);
Gi = Fi;
for i=1:nr
    Fi{i}=Pn(i).getFunction('primal').F(1:nu,:);
    Gi{i}=Pn(i).getFunction('primal').g(1:nu);
end

% TO DO: TRACKING AND DELTA U FORMULATION
deltau = 0;
tracking = 0;
if tracking==1,
    nxt = obj.model.nx;
    if isfield(obj.model.y, 'reference'),
        nref = obj.model.ny;
    else
        nref = obj.model.nx;
    end
elseif deltau,
    nxt = nx - nu;
end


% prepare output to be written to a header file
out = '';

ctr = 0;
out = strvcat(out, 'static float MPT_ST[] = {');

o = '';
for ii = 1:length(ST),
    o = [o sprintf('%e,\t', ST(ii))];
    if mod(ii, 5)==0 | ii==length(ST),
        out = strvcat(out, o);
        o = '';
    end
    
end
out = strvcat(out, '};');

out = strvcat(out, 'static float MPT_F[] = {');
for ii = 1:nr,
    F = Fi{ii};
    for jj = 1:nu,
        f = F(jj, :);
        o = '';
        for kk = 1:length(f),
            o = [o sprintf('%e,\t', f(kk))];
        end
        out = strvcat(out, o);
    end
end
out = strvcat(out, '};');

out = strvcat(out, 'static float MPT_G[] = {');
for ii = 1:nr,
    F = Gi{ii};
    for jj = 1:nu,
        f = F(jj, :);
        o = '';
        for kk = 1:length(f),
            o = [o sprintf('%e,\t', f(kk))];
        end
        out = strvcat(out, o);
    end
end
out = strvcat(out, '};');

% convert the concatenated array into one string, add line breaks
out_nl = [];
for ii = 1:size(out, 1),
    out_nl = [out_nl sprintf('%s\n', deblank(out(ii, :)))];
end


%% write the header file in the given directory
fid = fopen(fullfilename, 'w');
if fid<0,
    error('Cannot open file for writing!');       
end

% write declarations
fprintf(fid, '#define mpt_getInput_h\n\n');
fprintf(fid, '#define MPT_NR %d\n', nr);
fprintf(fid, '#define MPT_NX %d\n', nx);
fprintf(fid, '#define MPT_NU %d\n', nu);
fprintf(fid, '#define MPT_NY %d\n', ny);
fprintf(fid, '#define MPT_NXT %d\n', nxt);
fprintf(fid, '#define MPT_NREF %d\n', nref);
fprintf(fid, '#define MPT_TS %f\n', Ts);
fprintf(fid, '#define MPT_DUMODE %d\n', deltau);
fprintf(fid, '#define MPT_TRACKING %d\n', tracking);
fprintf(fid, '#define MPT_ABSTOL %e\n', MPTOPTIONS.abs_tol);


% write the body
fprintf(fid, '%s', out_nl);

fclose(fid);

%% write mpt_getInput.c
f2 = fopen([dirname, filesep, 'mpt_getInput.c'], 'w');
if f2<0,
    error('Cannot open file for writing!');
end


% write the header
header = {''
'    /*  mpt_getInput.c'
''  
'  Identifies a control law associated to a given state X using a binary search tree.'
''
'  Usage:'
'    region = mpt_getInput(*X, *U)'
''    
'    if "region" is smaller 1 (region < 1), there is no control law associated to'
'    a given state.'
''
'   Please note that all code in this file is provided under the terms of the'
'   GNU General Public License, which implies that if you include it directly'
'   into your commercial application, you will need to comply with the license.'
'   If you feel this is not a good solution for you or your company, feel free '
'   to contact me at kvasnica@control.ee.ethz.ch, I can re-license this specific '
'   piece of code to you free of charge.'
'*/'
''
'/* Copyright (C) 2005 by Michal Kvasnica (michal.kvasnica@stuba.sk) '
'   Revised in 2012 by Martin Herceg (herceg@control.ee.ethz.ch)    '
'*/'
''
''
'/*  This program is free software; you can redistribute it and/or modify'
'    it under the terms of the GNU General Public License as published by'
'    the Free Software Foundation; either version 2 of the License, or'
'    (at your option) any later version.'
''
'    This program is distributed in the hope that it will be useful,'
'    but WITHOUT ANY WARRANTY; without even the implied warranty of'
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the'
'    GNU General Public License for more details.'
''
'    You should have received a copy of the GNU General Public License'
'    along with this program; if not, write to the Free Software'
'    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.'
'*/ '
''};

% write the header
for i=1:numel(header)
    fprintf(f2,[header{i},'\n']);
end


% insert the name of the file
fprintf(f2,'#ifndef mpt_getInput_h \n');
fprintf(f2,'#include "%s.h" \n',fname);
fprintf(f2,'#endif\n');


% footer
footer = {''
'  static float mpt_getInput(const float *X, float *U)'
'{'
'    int ix, iu;'
'    long node = 1, row;'
'    float hx, k;'
''    
'    /* initialize U to zero*/'
'    for (iu=0; iu<MPT_NU; iu++) {'
'        U[iu] = 0;'
'    }'
''    
'    /* find region which contains the state x0 */'
'    while (node > 0) {'
'        hx = 0;'
'        row = (node-1)*(MPT_NX+3);'
'        for (ix=0; ix<MPT_NX; ix++) {'
'            hx = hx + MPT_ST[row+ix]*X[ix];'
'        }'
'        k = MPT_ST[row+MPT_NX];'
''        
'        if ((hx - k) < 0) {'
'            /* x0 on plus-side of the hyperplane */'
'            node = (long)MPT_ST[row+MPT_NX+2];'
'        } else {'
'            /* x0 on minus-side of the hyperplane */'
'            node = (long)MPT_ST[row+MPT_NX+1];'
'        }'
'    }'
''    
'   node = -node;'
''    
'    /* compute control action associated to state x0 */'
'    for (iu=0; iu<MPT_NU; iu++) {'
'        for (ix=0; ix<MPT_NX; ix++) {'
'            U[iu] = U[iu] + MPT_F[(node-1)*MPT_NX*MPT_NU + iu*MPT_NX + ix]*X[ix];'
'        }'
'        U[iu] = U[iu] + MPT_G[(node-1)*MPT_NU + iu];'
'    }'
''    
'    return (float)node;'
'}'
''  
''
};

% write the footer
for i=1:numel(footer)
    fprintf(f2,[footer{i},'\n']);
end


fclose(f2);

%% copy remaining files

p = fileparts(which('EMPCController'));
copyfile([p,filesep,'mpt_getInput_sfunc.c'],dirname);
