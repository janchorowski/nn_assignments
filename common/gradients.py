"""
Routines for numerical gradient evaluation.
"""

import numpy as np
from past.builtins import xrange # pip3 install future

def numerical_gradient(f, X, delta=1e-4):
    X = np.array(X) # force a copy
    R = np.zeros_like(X)
    XF = X.ravel() #get the views
    RF = R.ravel() 
    for i in xrange(XF.shape[0]):
        xold = XF[i]
        XF[i] = xold+delta
        fp, unused_grad = f(X)
        XF[i] = xold-delta
        fn, unused_grad = f(X)
        XF[i] = xold
        RF[i] = (fp-fn)/(2*delta)
    return R

def check_gradient(f, X, delta=1e-4, prec=1e-6):
    fval, fgrad = f(X)
    num_grad = numerical_gradient(f, X, delta=delta)
    diffnorm = np.sqrt(np.sum((fgrad-num_grad)**2))
    gradnorm = np.sqrt(np.sum(fgrad**2))
    if gradnorm>0:
        if not (diffnorm < prec or diffnorm/gradnorm < prec):
            raise Exception("Numerical and anaylical gradients differ: %s != %s!" %
                            (num_grad, fgrad))
    else:
        if not (diffnorm < prec):
            raise Exception("Numerical and anaylical gradients differ: %s != %s!" %
                            (num_grad, fgrad))
    return True

    
def encode_params(P):
    """
    Flatten and concatenate parameters into a single list.
    """
    flat = np.hstack([p.ravel() for p in P])
    shapes = [p.shape for p in P]
    return flat, shapes

    
def decode_params(P, shapes):
    """
    Decompress a single list of parameters into individual arrays
    """
    ret = []
    i = 0
    for s in shapes:
        e = i + np.prod(s)
        ret.append(P[i:e].reshape(s))
        i = e
    return ret
