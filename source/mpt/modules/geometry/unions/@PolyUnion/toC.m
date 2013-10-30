function toC(obj, function_name, file_name)
% Exports the polyunion to a C-code that uses a sequential search to
% solve a point location problem
%
%   U.toC('function', 'output')
%

global MPTOPTIONS

error(nargchk(3, 3, nargin));
error(obj.rejectArray());

if nargin<2,
    file_name = 'mpt_getInput';
else
    if isempty(file_name)
        file_name = 'mpt_getInput';
    end
    % get the short name if the full path is provided
    [~,short_name] = fileparts(file_name);
    if ~isempty(regexp(short_name,'[^a-zA-Z0-9_]', 'once'))
        error('The file name must contain only alphanumerical characters including underscore "_".');
    end
end

% is the request function present?
if ~obj.hasFunction(function_name)
    error('No such function "%s" in the object.', function_name);
end
% we only support affine functions for now
if ~isa(obj.Set(1).Functions(function_name), 'AffFunction')
    error('Only affine functions are supported in this version.');
end

U = obj.getFunction(function_name);

% extract polyhedra with control law
Pn = U.Set;
nr = U.Num;

% extract hyperplane representation
Hn = cell(nr,1);
Kn = cell(nr,1);
[Hn{:}]=deal(Pn.A);
[Kn{:}]=deal(Pn.b);
if ~iscell(Hn),
    Hn = {Hn};
    Kn = {Kn};
end

% count number of constraints
nctotal = 0;
for ii=1:nr,
    nctotal = nctotal + size(Pn(ii).H,1);
end


% extract dimensions
nx = U.Dim; % domain
nu = U.Set(1).Functions(function_name).R; % range

% extract PWA function
Fi = cell(nr,1);
Gi = Fi;
for i=1:nr
    Fi{i}=Pn(i).Functions(function_name).F;
    Gi{i}=Pn(i).Functions(function_name).g;
end


%% write mpt_getInput.c

fid = fopen([file_name,'.c'], 'w');
if fid<0,
    error('Cannot open file for writing!');
end

fprintf(fid,'/* The function for evaluation of a piecewise affine control law associated\n');
fprintf(fid,'   to a given state X using sequential search.\n\n');
fprintf(fid,'  Usage:\n    region = %s(*X, *U)\n\n',short_name);

header = {''    
'    if ''region'' is smaller 1 (region < 1), there is no control law associated to'
'    a given state.'
''
'   Please note that all code in this file is provided under the terms of the'
'   GNU General Public License, which implies that if you include it directly'
'   into your commercial application, you will need to comply with the license.'
'   If you feel this is not a good solution for you or your company, feel free '
'   to contact the author:'
'       michal.kvasnica@stuba.sk'
'    to re-license this specific piece of code to you free of charge.'
'*/'
''
'/* Copyright (C) 2005 by Michal Kvasnica (michal.kvasnica@stuba.sk) '
'   Revised in 2012-2013 by Martin Herceg (herceg@control.ee.ethz.ch)    '
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
    fprintf(fid,[header{i},'\n']);
end

fprintf(fid,'/* Generated on %s by MPT %s */ \n\n',datestr(now), MPTOPTIONS.version);

fprintf(fid, '#define MPT_NR %d\n', nr);
fprintf(fid, '#define MPT_DOMAIN %d\n', nx);
fprintf(fid, '#define MPT_RANGE %d\n', nu);
fprintf(fid, '#define MPT_ABSTOL %e\n', MPTOPTIONS.abs_tol);

ctr = 0;
fprintf(fid, '\nstatic float MPT_H[] = {\n');
for ii = 1:nr,
    Hi = Hn{ii};
    nc = size(Hi, 1);
    for jj = 1:nc,
        h = Hi(jj, :);
        for kk = 1:length(h),
            ctr = ctr + 1;
            if ctr<nctotal*nx,
                fprintf(fid, '%e,\t', h(kk));
            else
                fprintf(fid, '%e ', h(kk));
            end
            if mod(ctr, 5)==0,
                fprintf(fid, '\n');
            end
        end
    end
end
fprintf(fid, '};\n\n');

ctr = 0;
fprintf(fid, 'static float MPT_K[] = {\n');
for ii = 1:nr,
    Ki = Kn{ii};
    nc = size(Ki, 1);
    for jj = 1:nc,
        ctr = ctr + 1;
        if ctr<nctotal,
            fprintf(fid, '%e,\t', Ki(jj));
        else
            fprintf(fid, '%e ', Ki(jj));
        end
        if mod(ctr, 5)==0,
            fprintf(fid, '\n');
        end
    end
end
fprintf(fid, '};\n\n');

fprintf(fid, 'static int MPT_NC[] = {\n');
for ii = 1:nr,
    if ii < nr,
        fprintf(fid, '%d,\t', size(Pn(ii).H,1));
    else
        fprintf(fid, '%d ', size(Pn(ii).H,1));
    end
    if mod(ii, 5)==0,
        fprintf(fid, '\n');
    end
end
fprintf(fid, '};\n\n');

nctotal = nx*nu*nr;
ctr = 0;
fprintf(fid, 'static float MPT_F[] = {\n');
for ii = 1:nr,
    F = Fi{ii};
    for jj = 1:nu,
        f = F(jj, :);
        for kk = 1:nx,
            ctr = ctr + 1;
            if ctr<nctotal,
                fprintf(fid, '%e,\t', f(kk));
            else
                fprintf(fid, '%e ', f(kk));
            end
            if mod(ctr, 5)==0,
                fprintf(fid, '\n');
            end
        end
    end
end
fprintf(fid, '};\n\n');

ctr = 0;
fprintf(fid, 'static float MPT_G[] = {\n');
for ii = 1:nr,
    G = Gi{ii};
    for jj = 1:nu,
        ctr = ctr + 1;
        if ctr<nctotal,
            fprintf(fid, '%e,\t', G(jj));
        else
            fprintf(fid, '%e ', G(jj));
        end
        if mod(ctr, 5)==0,
            fprintf(fid, '\n');
        end
    end
end
fprintf(fid, '};\n');

fprintf(fid,'static float %s(float *X, float *U)\n',short_name);

core = {''
'{'
'    int ix, iu, ic, nc, isinside;'
'    unsigned long ireg, abspos;'
'    float hx, region;'
''    
'    abspos = 0;'
'    region = 0;'
''    
'    /* initialize U to zero*/'
'    for (iu=0; iu<MPT_RANGE; iu++) {'
'        U[iu] = 0;'
'    }'
''    
'    for (ireg=0; ireg<MPT_NR; ireg++) {'
''        
'        isinside = 1;'
'        nc = MPT_NC[ireg];'
'        for (ic=0; ic<nc; ic++) {'
'            hx = 0;'
'            for (ix=0; ix<MPT_DOMAIN; ix++) {'
'                hx = hx + MPT_H[abspos*MPT_DOMAIN+ic*MPT_DOMAIN+ix]*X[ix];'
'            }'
'            if ((hx - MPT_K[abspos+ic]) > MPT_ABSTOL) {'
'                /* constraint is violated, continue with next region */'
'                isinside = 0;'
'                break;'
'            } '
'        }'
'        if (isinside==1) {'
'            /* state belongs to this region, extract control law and exit */'
'            region = ireg + 1;'
'            for (iu=0; iu<MPT_RANGE; iu++) {'
'                for (ix=0; ix<MPT_DOMAIN; ix++) {'
'                    U[iu] = U[iu] + MPT_F[ireg*MPT_DOMAIN*MPT_RANGE + iu*MPT_DOMAIN + ix]*X[ix];'
'                }'
'                U[iu] = U[iu] + MPT_G[ireg*MPT_RANGE + iu];'
'            }'
'            return region;'
'        }'
'        abspos = abspos + MPT_NC[ireg];'
'    }'
'    return region;'
'}'
''
''};

% write the core
for i=1:numel(core)
    fprintf(fid,[core{i},'\n']);
end

fclose(fid);
fprintf('Output written to "%s".\n', [file_name,'.c']);


end