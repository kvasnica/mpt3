/*  isInside.c
  
    MEX version of isInside()
  
    Usage:
    [isin, inwhich, closest] = isInside(Pn, x0, Options)

    See "help Polyhedron/isInside" for a complete description.

*/


/* Revised by Martin Herceg in 2010 (Automatic Control Laboratory, ETH) 
   Copyright (C) 2006 by Michal Kvasnica (kvasnica@control.ee.ethz.ch) */

/*  This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/ 

#include "mex.h"
#include <string.h>
#define MAX(a,b) ((a)>(b)?(a):(b))


typedef struct options_s {
	double abs_tol;
	int fastbreak;
} options_t;

int isInside(const mxArray *mxH, const mxArray *mxHe, const double *th, const double abs_tol)
{
	size_t ic, ir, nr, nc, ne;
	double *H, *He, rowsum;
    
	/* get pointers to real data */
	H = mxGetPr(mxH);
	He = mxGetPr(mxHe);
	
	nr = mxGetM(mxH); /* number of inequalities */
	ne = mxGetM(mxHe); /* number of equality constraints */
	nc = mxGetN(mxH); /* number of columns or dimension */
	
    /* check equalities first */
	for (ir=0; ir<ne; ir++)
	{                
		rowsum = 0.0;
		/* compute He*th */
		for (ic=0; ic<nc; ic++) {            
			rowsum = rowsum + He[ir + ic*ne]*th[ic];
        }
        
        /* if th violates equality, exit immediately */
		if ( (rowsum  > abs_tol) || ( rowsum < -abs_tol) ) {
			return 0;
		}
	}
    
	/* check inequalities */
	for (ir=0; ir<nr; ir++)
	{
		rowsum = 0.0;
		/* compute H*x0 */
        for (ic=0; ic<nc; ic++) {
            rowsum = rowsum + H[ir + ic*nr]*th[ic];
        }
        
		/* if th violates a hyperplane, exit immediately */
		if ( rowsum > abs_tol) {
			return 0;
		}
	}

    
	/* all inequalities and equalities satisfied with absolute tolerance, we are inside */
	return 1;
}


void mexFunction(int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[])
{
	const mxArray *MPTOPTIONS;
    const char *fname;
    char msg[100];
	mxArray *tmp, *H, *He;
	double *tmpr, *x0, *inwhichp, *outinwhichp, *th;
	int j, dimx0, dim, isin=0, nfields;
	size_t i, nPn, ninside = 0, cnt;
	options_t options;
    
	if ((nrhs < 2) || (nrhs > 3))
		mexErrMsgTxt("isInside: Wrong number of input arguments.");
    
	if (nlhs > 3)
		mexErrMsgTxt("isInside: Too many output arguments.");
    
	if ((nrhs == 3) && !mxIsStruct(prhs[2]))
		mexErrMsgTxt("isInside: Third input must be a structure.");

	/* check Polyhedron */
	if (strcmp(mxGetClassName(prhs[0]), "Polyhedron"))
		mexErrMsgTxt("isInside: First input must be a Polyhedron object.");
	if ( (mxGetM(prhs[0])*mxGetN(prhs[0]) > MAX(mxGetM(prhs[0]),mxGetN(prhs[0]))) )
		mexErrMsgTxt("isInside: Only arrays of polyhedra are supported.");   
    
	/* check x0 */
	if (!mxIsDouble(prhs[1]) || mxIsSparse(prhs[1]) || mxIsEmpty(prhs[1]) )
		mexErrMsgTxt("isInside: Initial condition x0 must be of type double, full and not empty.");
	if ( (mxGetN(prhs[1]) > 1) || (mxGetM(prhs[1])*mxGetN(prhs[1]) > MAX(mxGetM(prhs[1]),mxGetN(prhs[1]))) )
		mexErrMsgTxt("isInside: Initial condition x0 must be given as column vector.");

	/* set default options, read abs_tol from mptOptions.abs_tol */
	if (!(MPTOPTIONS = mexGetVariablePtr("global", "MPTOPTIONS")))
		mexErrMsgTxt("isInside: You must call mpt_init first.");

	if (!(tmp = mxGetProperty(MPTOPTIONS, 0, "abs_tol")))
		mexErrMsgTxt("isInside: You must call mpt_init first.");

	options.abs_tol = 1e-8;
	options.fastbreak = 0;
    
	/* read options */
	if (nrhs == 3) 
	{
        nfields = mxGetNumberOfFields(prhs[2]);
        for (j=0; j<nfields; j++) {
            fname = mxGetFieldNameByNumber(prhs[2], j);
            tmp = mxGetField(prhs[2], 0, fname);
            /* check for proper field names */
            if (!( (strcmp(fname, "abs_tol")==0) || (strcmp(fname, "fastbreak")==0) )) {
                strcpy(msg, "");
                strcat(msg, "isInside: The field '");
                strcat(msg, fname);
                strcat(msg, "' is not allowed in the options structure.");
                mexErrMsgTxt(msg);
            }
        }
		if ((tmp = mxGetField(prhs[2], 0, "abs_tol")))
		{
            /* check value of abs_tol */
            if (!mxIsDouble(tmp) || mxIsEmpty(tmp) || !mxIsFinite(mxGetScalar(tmp)) 
                || (mxGetM(tmp)*mxGetN(tmp))!=1 || (mxGetScalar(tmp)<0) || (mxGetScalar(tmp)>0.01) )
                mexErrMsgTxt("isInside: Absolute tolerance must be a scalar of type double, not empty, finite, less than 0 and bigger that 0.01.");
            tmpr = mxGetPr(tmp);
            options.abs_tol = tmpr[0];
		}
        
		if ((tmp = mxGetField(prhs[2], 0, "fastbreak")))
		{
            /* check value of fastbreak */
            if ( (!mxIsDouble(tmp) && !mxIsLogical(tmp)) || mxIsEmpty(tmp) || !mxIsFinite(mxGetScalar(tmp)) || (mxGetM(tmp)*mxGetN(tmp))!=1 )
                mexErrMsgTxt("isInside: The value in the 'fastbreak' field must be a scalar of type double or logical, not empty and finite.");
            tmpr = mxGetPr(tmp);

			if (mxIsLogical(tmp))
				tmpr = (double *)mxGetLogicals(tmp);
			else
				tmpr = mxGetPr(tmp);
			options.fastbreak = (int)tmpr[0];
		}
	}
    
	/* how many polyhedra are in the array */   
	nPn = mxGetNumberOfElements(prhs[0]);
     
	/* get pointers to real data of x0 */
	x0 = mxGetPr(prhs[1]); /* double */
       
	/* get dimension from x0 */
	dimx0 = (int)mxGetM(prhs[1]);
	
	/* check all polyhedra first */
	for (i=0; i<nPn; i++)
	{
		/* pick data from each polyhedron */
		dim = (int)mxGetScalar(mxGetProperty(prhs[0],i,"Dim"));
		/*check dimension */
		if (dim != dimx0) {
			mexErrMsgTxt("isInside: Not all Polyhedra are in the same dimension as x0.");
		}
		
		/* check if polyhedron is in H-rep */
		if ( (mxGetM(mxGetProperty(prhs[0],i,"H"))*mxGetN(mxGetProperty(prhs[0],i,"H"))==0) &&
		     (mxGetM(mxGetProperty(prhs[0],i,"He"))*mxGetN(mxGetProperty(prhs[0],i,"He"))==0) )
			mexErrMsgTxt("isInside: All polyhedra must be in H-representation!");
	}
	/*must check x0 before allocating th */
	for (i=0; i<dimx0; i++) {
		if (!mxIsFinite(x0[i]))
			mexErrMsgTxt("isInside: No Inf or NaN numbers allowed in x0.");
	}

	/* allocate parameter vector th=[x; -1] */
	th = (double *)mxCalloc(dimx0+1, sizeof(double));

	/* assign th */
	for (i=0;i<dimx0; i++) {
		th[i] = x0[i];
	}
	/* assing -1 at the end */
	th[dimx0] = -1.0;
        
	/* allocate output vector */
	/*inwhichp = mxGetPr(mxCreateDoubleMatrix(nPn, 1, mxREAL));*/
	inwhichp = (double *)mxCalloc(nPn, sizeof(double));
    
	/* we can always do fastbreak if the user doesn't ask for "inwhich" */
	if (nlhs < 2)
		options.fastbreak = 1;
    
	/* the main loop */
	for (i=0; i<nPn; i++)
	{

		/* pick data from each polyhedron */
		H = mxGetProperty(prhs[0],i,"H");
		He = mxGetProperty(prhs[0],i,"He");
                
		/* test if th is in P */
		if (isInside(H, He, th, options.abs_tol))
		{
			if (options.fastbreak)
			{
				/* at least one polyhedron found, exit quickly */
				plhs[0] = mxCreateLogicalScalar(1);
				if (nlhs>1)
                    plhs[1] = mxCreateDoubleScalar((double)i+1);
                if (nlhs>2)
                    plhs[2] = mxCreateDoubleMatrix(0, 0, mxREAL);

				/* free theta before leaving */
				mxFree(inwhichp);
                mxFree(th);
				return;
			}
			inwhichp[i] = 1;
			isin = 1;
			ninside++;
		}
	}
        
	plhs[0] = mxCreateLogicalScalar(isin);

	/* create the inwhich array which contains indices of polyhedrons
	   which contain x0 */
    if (nlhs>1) {
        plhs[1] = mxCreateDoubleMatrix(ninside, 1, mxREAL);
        if (ninside > 0)
        {
            outinwhichp = mxGetPr(plhs[1]);
            cnt = 0;
            for (i=0; i<nPn; i++)
                if (inwhichp[i])
                    outinwhichp[cnt++] = (double)i+1;
        }
    }    

   /* Calculate index of a region which is closest to x0.
    But only do that if the user requests such information (i.e. nlhs=3) */
   
    if (nlhs>2) {
        if (!isin) {
            if (nPn == 1) {
                plhs[2] = mxCreateDoubleScalar(1);
            } else {
                plhs[2] = mxCreateDoubleScalar(0);
                mexCallMATLAB(1, &plhs[2], 2, prhs, "closestRegion");
            }
        }
        else {
            plhs[2] = mxCreateDoubleMatrix(0, 0, mxREAL);
        }
	}
    
	/* free theta before leaving */
    mxFree(inwhichp);
	mxFree(th);
    
	return;
}
