# !/usr/bin/env python
# -*- coding:utf-8 -*-
# see `%pylab?` from ipython for help (ipython --pylab)
# `pylab` 's original purpose was to mimic a MATLAB-like way of working

import re
import os
import sys
import time
import string

import torch
import torchdata
import torchinfo
import torchvision

import numpy as np
import scipy as sp
import pandas as pd
import datetime as dt
import networkx as nx
# import statsmodels.api as sm
import numpy.fft as npfft
import numpy.random as nprand
import numpy.linalg as nplina  # linear alg.
import numpy.ma as npmask

import flet as flt
import sklearn as skl
import itertools as itr
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.pyplot import *  # !!! its imporant to plot instantly!!
# from matplotlib import cbook, mlab

# to import or not import?:: TODO: do cleaning
from matplotlib.cbook import flatten, silent_list
from matplotlib.mlab import detrend, detrend_linear, detrend_mean, detrend_none, window_hanning, window_none
from matplotlib.dates import date2num, num2date, datestr2num, drange, DateFormatter, DateLocator
#  (RRuleLocator, rrule, relativedelta, MultipleLocator, # epoch2num, num2epoch,
#   YearLocator, MonthLocator, WeekdayLocator, DayLocator, HourLocator, MinuteLocator, SecondLocator,
#   YEARLY, MONTHLY, WEEKLY, DAILY, HOURLY, MINUTELY, SECONDLY, MO, TU, WE, TH, FR, SA, SU)

from torch import nn, optim
from torch.nn import functional as F
# from torch.utils.data import Dataset, DataLoader
# from torchvision import datasets, models, transforms

'''
import sklearn.preprocessing as prep

from sklearn.feature_selection import SelectFromModel, SelectKBest, SelectPercentile
from sklearn.feature_selection import f_classif, chi2, RFE
from sklearn import model_selection
from sklearn.model_selection import train_test_split, GridSearchCV, KFold
from sklearn.cross_validation import StratifiedKFold, cross_val_score
from sklearn.metrics import accuracy_score, roc_auc_score, classification_report, precision_score, recall_score, f1_score
from sklearn.ensemble import GradientBoostingClassifier, GradientBoostingRegressor, VotingClassifier, RandomForestClassifier, ExtraTreesClassifier, AdaBoostClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.utils import resample  # np.random.choice

from xgboost import XGBClassifier, XGBRegressor
'''

pd.options.display.max_columns = 100
pd.options.display.max_rows = 100

plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号
# mpl.rc("font", family="Noto Sans", weight="regular")
# mpl.use("Agg")  # uncomment when running on server!!!
#
# See http://matplotlib.sourceforge.net/api/figure_api.html#matplotlib.figure.Figure
plt.style.use('ggplot')
plt.rc('figure', figsize=(16, 12), dpi=300)    # figure size in inches


def dt_str(): return time.strftime("%Y-%m-%d %H:%M:%S %A")  #%w
def todo(s=''): print(dt_str()[:20], ': ', s, ' : ', 'TODO!')
def done(s=''): print(dt_str()[:20], ': ', s, ' : ', 'Done!')


def execfile(filename, globals=None, locals=None):
    'Noam@stackoverflow[436198]an-alternative-to-execfile-in-python-3'
    print(dt_str())
    if globals is None: globals = sys._getframe(1).f_globals
    if locals is None: locals = sys._getframe(1).f_locals
    code = compile(open(filename, 'rb').read(), filename, 'exec')
    exec(code, globals, locals)
    print(dt_str())


def live_days():
    today = dt_str()
    d1 = dt.datetime(          1979,               4,               25)
    d2 = dt.datetime(int(today[:4]), int(today[5:7]), int(today[8:10]))
    interval = d2 - d1
    return interval.days


def xuan_cal(tdy=[], ref=[1, 12, 22]):
    """
    玄历
      - 西元前1年冬至为开始计历的元日 (纪念太玄经; 玄0年~=西1年);
      - 冬至为每年的第零天 (冬至=新年; 元旦: 西1.1, 春节: 夏1.1);
      - 每月30天(0~29), 每年重置(每月编号0..11., 第12月只有几天).
    """

    from time import localtime
    from datetime import datetime
    cur = localtime()

    yF, mF, dF = ref
    yC, mC, dC = cur.tm_year, cur.tm_mon, cur.tm_mday
    if len(tdy) == 3: yC, mC, dC = tdy
    dF = datetime(yF, mF, dF)
    dC = datetime(yC, mC, dC)

    yeardays = (dC - dF).days
    print(f'xuan: {yeardays}')
    year, days = np.divmod(yeardays, 365.242199)
    mnth, days = np.divmod(days, 30)
    return round(year)+1, round(mnth), round(np.floor(days))


print()
print(dt_str())
print('live:', live_days(), end='; ')
print('xuan:', xuan_cal(), end='')
print()


def iterable(arg):
    # 判断arg是否是如list, string等iterable的对象
    # https://stackoverflow.com/questions/1835018/how-to-check-if-an-object-is-a-list-or-tuple-but-not-string
    return (not hasattr(arg, "strip") and hasattr(arg, "__getitem__") or hasattr(arg, "__iter__"))


def included_angle_vector(v1, v2):
    '''
    Returns the angle in radians between vectors 'v1' and 'v2'::
    in the region [0,pi)
        In [-]: included_angle_vector((1, 0, 0), (0, 1, 0))
        Out[-]: (1.5707963267948966, 90.0)
        In [-]: included_angle_vector((1, 0, 0), (1, 0, 0))
        Out[-]: (0.0, 0.0)
        In [-]: included_angle_vector((1, 0, 0), (-1, 0, 0))
        Out[-]: (3.1415926535897931, 180.0)
    '''
    v1_u = v1 / np.linalg.norm(v1)
    v2_u = v2 / np.linalg.norm(v2)
    angle = np.arccos(np.clip(np.dot(v1_u, v2_u), -1.0, 1.0))
    return angle, np.degrees(angle)


def included_angle_line(l1, l2):
    '''
    Returns the angle in radians between lines 'l1' and 'l2'::
    in the region [0,pi/2)
        In [-]: included_angle_line((1, 0, 0), (-1, 0, 0))
        Out[-]: (0.0, 0.0)
        In [-]: included_angle_line((1, 0, 0), (1, 0, 0))
        Out[-]: (0.0, 0.0)
        In [-]: included_angle_line((1, 0, 0), (0, 1, 0))
        Out[-]: (1.5707963267948966, 90.0)
    '''
    ang, deg = included_angle_vector(l1, l2)
    if ang > 0.5 * np.pi:
        ang = np.pi - ang
        deg = 180 - deg
    return ang, deg


def avg_degree(angles):
    # 计算角度平均值，注意0-360度情况
    # https://stackoverflow.com/questions/491738/how-do-you-calculate-the-average-of-a-set-of-circular-data
    # https://en.wikipedia.org/wiki/Mean_of_circular_quantities
    fz_list = [np.sin(x) for x in angles]
    fm_list = [np.cos(x) for x in angles]
    return np.arctan2(sum(fz_list), sum(fm_list))


def polygen_area(points):
    # points是n个点的(x,y)坐标.按照顺时针或逆时针排序. TODO: 转换为矩阵计算!
    #
    n = len(points)
    if n < 3: return 0
    area = 0
    #
    for i in range(n):
        j = (i+1) % n
        area += points[i][0] * points[j][1]
        area -= points[j][0] * points[i][1]
    #
    return abs(area) / 2


# logistic (sigmoid) function &
def logis(x): return 1 / (1 + np.exp(-x))

# logit is the reverse of logis
def logit(p): return np.log(p) - np.log(1-p)


def lifetime_sparseness(data):
    # forked from andrewgiessel/gist:5708977
    # http://wilson.med.harvard.edu/SupplementalMaterialBhandawat2007.pdf (page 12)
    # a measure of selectivity calculated separately for each single neuron across all patterns
    #
    assert type(data) in {np.ndarray, list}
    N = len(data)
    Z = np.power(np.mean(data), 2)
    M = np.mean(np.power(data, 2))
    return N * (1 - Z/M) / (N - 1)


def sets_divergence(A, B): # A and B are both sets
    '''
        The Jaccard distance measures dissimilarity between sample sets.
        It is obtained by dividing the difference of the sizes of
           the union and the intersection of two sets, by the size of the union.
        https://en.wikipedia.org/wiki/Jaccard_index
    '''
    if isinstance(A, list) or isinstance(A, np.ndarray): A = set(A)
    if isinstance(B, list) or isinstance(B, np.ndarray): B = set(B)
    return (len(A.union(B))-len(A.intersection(B))) / len(A.union(B))


def PCA(data, nComp=3, if_keep_order=False, if_ret_all=False, svas=''):
    '''
    input dim is [x, y], where x is timebin number, and y is PN number
    data是用来处理的二维表(by 列), nComp是取几个特征, 后面指定是否保序/返回特征系统/存档
    注意: 返回的是由一维向量构成的列表
    '''
    # return mdp.pca(x) # see also
    # http://stackoverflow.com/questions/13224362/principal-component-analysis-pca-in-python
    # TODO: debug
    data = np.array(data).astype(np.float64)
    data -= data.mean(axis=0)
    R = np.cov(data, rowvar=False)
    if svas != '': np.savetxt(svas, R)
    #
    eVals, eVcts = np.linalg.eigh(R)
    idx = np.argsort(eVals)[::-1]
    eVcts = eVcts[:, idx] # 排序
    eVcts = eVcts[:, :nComp]
    # eVals = eVals[idx]
    # eVals = eVals[:nComp]  # 与特征向量相对应地, 取nComp个
    rtn = np.dot(data, eVcts)  # 投影到特征向量上
    #
    # 将结果处理成一维向量的列表, 并确保每个向量都保序
    new_rtn = []
    for i in range(nComp):
        rtn_i = rtn[:, i]
        if if_keep_order and eVcts[i][0] < 0: rtn_i *= -1
        new_rtn.append(np.ravel(rtn_i))
    #
    if if_ret_all:  # 返回之后可以看到eVct相应元素是否为负
        return new_rtn, eVals, eVcts
    else:
        return new_rtn


def get_rank(x, weights, rank_num=5):
    # 根据x在weights中的位置, 返回其档位
    # rank is 1..rank_num, minor x leads to minor rank.
    num, rng = np.histogramrg(weights, rank_num)
    rnglst = list(rng) + [x]
    idxlst = list(np.argsort(rnglst))
    rank = idxlst.index(rank_num + 1)
    if rank < 1: rank = 1
    if rank > rank_num: rank = rank_num
    return rank


# plot functions with Matplotlib
# fplot('y=x**3+2*x-4', [-10, 10, 100])
# https://stackoverflow.com/questions/14000595/graphing-an-equation-with-matplotlib
def fplot(formula, xmms=[-5, 5]): # mms is min, max [and steps]
    if len(xmms) > 2:
        x = np.linspace(xmms[0], xmms[1], xmms[2])
    else:
        x = np.linspace(xmms[0], xmms[1], abs(xmms[1]-xmms[0])*5)
    # ...
    t = formula.find('=')
    y = eval(formula[t+1:])
    return plt.plot(x, y)


def jittering(lls, randScale=0.01, sampleNum=3):  # a simple jittering function
    # http://matplotlib.1069221.n5.nabble.com/jitter-in-matplotlib-td12573.html
    return sp.stats.norm.rvs(loc=lls, scale=randScale, size=(sampleNum, len(lls)))

'''
xs, ys = np.random.random((2,5))
plt.scatter(xs, ys, c='b')
# create jittered data for x and y coords
xs_jit = jittering(xs)
ys_jit = jittering(ys)
plt.scatter(xs_jit, ys_jit, c='r')
plt.show()
'''


def lmap(fn, *lst): return [*map(fn, *lst)]  # 类似于map, 但返回list
def rlen(*x): return range(len(*x))  # as the title


# https://github.com/sciy/temFlow/blob/master/list_process.py
def out_flat(lst):
    '''only flat the outter level'''
    new_lst = []
    for x in lst:
        if isinstance(x, list):
            for y in x: new_lst.append(y)
        else:
            new_lst.append(x)
    return new_lst

# In [-]: a
# Out[-]: [[[1, 2, 3], [1, 2, 3]], [[4, 5, 6], [4, 5, 6]], [[7, 8, 9], [7, 8, 9]]]
# In [-]: shape(a)
# Out[-]: (3, 2, 3)
# In [-]: out_flat(a)
# Out[-]: [[1, 2, 3], [1, 2, 3], [4, 5, 6], [4, 5, 6], [7, 8, 9], [7, 8, 9]]
# In [-]: shape(out_flat(a))
# Out[-]: (6, 3)


def part_by(lst, segment_len):
    '均分list, 多的元素被抛弃!'
    if len(lst) % segment_len != 0:
        lst = lst[:np.int(np.floor(len(lst) / segment_len * segment_len))]
    return [lst[i:i+segment_len] for i in range(0, len(lst), segment_len)]

# In [-]: a
# Out[-]: [1, 2, 3, 1, 2, 3, 4, 5, 6, 4, 5, 6, 7, 8, 9, 7, 8, 9]
# In [-]: a=part_by(a,3)
# Out[-]: [[1, 2, 3], [1, 2, 3], [4, 5, 6], [4, 5, 6], [7, 8, 9], [7, 8, 9]]
# In [-]: a=part_by(a,2)
# Out[-]: [[[1, 2, 3], [1, 2, 3]], [[4, 5, 6], [4, 5, 6]], [[7, 8, 9], [7, 8, 9]]]
# In [-]: shape(a)
# Out[-]: (3, 2, 3)


def gemean(iterable):
    'geometric mean'
    a = np.log(iterable)
    return np.exp(a.sum() / len(a))


def minN(a, n):
    if not isinstance(a, list) or not isinstance(a, np.ndarray): return False
    if n > len(a): n = len(a)
    b = a[:]
    for i in range(len(a)): b[i] = (b[i], i)
    b.sort(key = lambda x: x[0], reverse = False)
    return np.array([b[i][0] for i in range(n)]), np.array(map(int, [b[i][1] for i in range(n)]))


def maxN(a, n):
    if not isinstance(a, list) or not isinstance(a, np.ndarray): return False
    if n > len(a): n = len(a)
    b = a[:]
    for i in range(len(a)): b[i] = (b[i], i)
    b.sort(key = lambda x: x[0], reverse = True)
    return np.array([b[i][0] for i in range(n)]), np.array(map(int, [b[i][1] for i in range(n)]))

# In [-]: a=[13,4,23,9,111]
# In [-]: maxN(a, 3)
# Out[-]: ([111, 23, 13], [4, 2, 0])
#
# In [-]: minN(a, 3)
# Out[-]: ([4, 9, 13], [1, 3, 0])
#
# In [-]: minN(a, 33)
# Out[-]: ([4, 9, 13, 23, 111], [1, 3, 0, 2, 4])


# handy 2d fitting function
# http://stackoverflow.com/questions/7997152/python-3d-polynomial-surface-fit-order-dependent
def polyfit2d(x, y, z, deg):
    # deg : x and y maximum degrees: [x_deg, y_deg].
    x = np.asarray(x)
    y = np.asarray(y)
    z = np.asarray(z)
    deg = np.asarray(deg)
    vander = np.polynomial.polyvander2d(x, y, deg)
    vander = vander.reshape((-1, vander.shape[-1]))
    z = z.reshape((vander.shape[0], ))
    c = np.linalg.lstsq(vander, z)[0]
    return c.reshape(deg+1)


# get the fitting z results at given (x,y) points used for doing plots:
def polyval2d(x, y, m):
    ij = itr.product(range(np.shape(m)[0]), range(np.shape(m)[1]))
    z = np.zeros_like(x)
    for a, (i, j) in np.zip(np.flatten(m), ij): z = z + a * x**i * y**j
    return z

'''
a=array([ [i, j, i**2+(100-j)**2]  for i in range(100)  for j in range(100) ])
m = polyfit2d(a[:,0], a[:,1], a[:,2], [3,3]) # fits it!
m is :
array([[  1.00000033e+04,  -2.00000024e+02,   9.99998625e-01,  1.18931529e-08],
       [ -4.10125405e-05,  -1.30057323e-06,   5.62423528e-08, -3.80531578e-10],
       [  9.99998620e-01,   5.63967447e-08,  -6.96189863e-10,  3.22986082e-12],
       [  1.18394489e-08,  -3.79559266e-10,   3.20454774e-12, -2.84217094e-14]])

The above matrix m gives coefficients of (x, y)
(0, 0) (0, 1) (0, 2) (0, 3)
(1, 0) (1, 1) (1, 2) (1, 3)
(2, 0) (2, 1) (2, 2) (2, 3)
(3, 0) (3, 1) (3, 2) (3, 3)

tmp = polyval2d(a[:,0], a[:,1], m) # compute the fitting vals at each point
plot(abs(tmp-a[:,2])) # checherrors
'''
