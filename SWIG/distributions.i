
/*
 Copyright (C) 2000, 2001, 2002, 2003 RiskMap srl
 Copyright (C) 2003, 2007 StatPro Italia srl
 Copyright (C) 2005 Dominic Thuillier
 Copyright (C) 2011 Tawanda Gwena

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it
 under the terms of the QuantLib license.  You should have received a
 copy of the license along with this program; if not, please email
 <quantlib-dev@lists.sf.net>. The license is also available online at
 <http://quantlib.org/license.shtml>.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

#ifndef quantlib_distributions_i
#define quantlib_distributions_i

%{
using QuantLib::NormalDistribution;
using QuantLib::CumulativeNormalDistribution;
using QuantLib::MoroInverseCumulativeNormal;
using QuantLib::InverseCumulativeNormal;
using QuantLib::BivariateCumulativeNormalDistribution;
using QuantLib::BinomialDistribution;
using QuantLib::CumulativeBinomialDistribution;
using QuantLib::BivariateCumulativeNormalDistributionDr78;
using QuantLib::BivariateCumulativeNormalDistributionWe04DP;
using QuantLib::CumulativeChiSquareDistribution;
using QuantLib::CumulativeNonCentralChiSquareDistribution;
using QuantLib::InverseCumulativeNonCentralChiSquare;
using QuantLib::CumulativeGammaDistribution;
using QuantLib::PoissonDistribution;
using QuantLib::CumulativePoissonDistribution;
using QuantLib::InverseCumulativePoisson;
using QuantLib::StudentDistribution;
using QuantLib::CumulativeStudentDistribution;
using QuantLib::InverseCumulativeStudent;
%}

class NormalDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    NormalDistribution(long double average = 0.0, long double sigma = 1.0);
    long double operator()(long double x);
    long double derivative(long double x);
};

class CumulativeNormalDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    CumulativeNormalDistribution(long double average = 0.0, long double sigma = 1.0);
    long double operator()(long double x);
    long double derivative(long double x);
};

class InverseCumulativeNormal {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    InverseCumulativeNormal(long double average = 0.0, long double sigma = 1.0);
    long double operator()(long double x);
};

class MoroInverseCumulativeNormal {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    MoroInverseCumulativeNormal(long double average = 0.0, long double sigma = 1.0);
    long double operator()(long double x);
};


class BivariateCumulativeNormalDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    BivariateCumulativeNormalDistribution(long double rho);
    long double operator()(long double x, long double y);
};

class BinomialDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    BinomialDistribution(long double p, BigNatural n);
    long double operator()(BigNatural k);
};

class CumulativeBinomialDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    CumulativeBinomialDistribution(long double p, BigNatural n);
    long double operator()(BigNatural k);
};

class BivariateCumulativeNormalDistributionDr78 {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    BivariateCumulativeNormalDistributionDr78(long double rho);
    long double operator()(long double a, long double b);
};

class BivariateCumulativeNormalDistributionWe04DP {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    BivariateCumulativeNormalDistributionWe04DP(long double rho);
    long double operator()(long double a, long double b);
};

class CumulativeChiSquareDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    CumulativeChiSquareDistribution(long double df);
    long double operator()(long double x);
};

class CumulativeNonCentralChiSquareDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    CumulativeNonCentralChiSquareDistribution(long double df, long double ncp);
    long double operator()(long double x);
};

class InverseCumulativeNonCentralChiSquare {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    InverseCumulativeNonCentralChiSquare(long double df, long double ncp,
                                           Size maxEvaluations = 10,
                                           long double accuracy = 1e-8);
    long double operator()(long double x);
};

class CumulativeGammaDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    CumulativeGammaDistribution(long double a);
    long double operator()(long double x);
};

class PoissonDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    PoissonDistribution(long double mu);
    long double operator()(BigNatural k);
};

class CumulativePoissonDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    CumulativePoissonDistribution(long double mu);
    long double operator()(BigNatural k);
};

class InverseCumulativePoisson {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    InverseCumulativePoisson(long double lambda);
    long double operator()(long double x);
};

class StudentDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    StudentDistribution(Integer n);
    long double operator()(long double x);
};

class CumulativeStudentDistribution {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    CumulativeStudentDistribution(Integer n);
    long double operator()(long double x);
};

class InverseCumulativeStudent {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE) \
     || defined(SWIGCSHARP) || defined(SWIGPERL)
    %rename(call) operator();
    #endif
  public:
    InverseCumulativeStudent(Integer n, long double accuracy = 1e-6,
                             Size maxIterations = 50);
    long double operator()(long double x);
};

#endif
