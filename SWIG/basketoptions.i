
/*
 Copyright (C) 2000, 2001, 2002, 2003 RiskMap srl
 Copyright (C) 2003, 2004, 2005, 2006, 2007, 2008 StatPro Italia srl
 Copyright (C) 2005 Dominic Thuillier
 Copyright (C) 2007 Joseph Wang

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

#ifndef quantlib_basket_options_i
#define quantlib_basket_options_i

%include date.i
%include options.i
%include payoffs.i
%{
using QuantLib::BasketOption;
using QuantLib::BasketPayoff;
using QuantLib::MinBasketPayoff;
using QuantLib::MaxBasketPayoff;
using QuantLib::AverageBasketPayoff;
typedef std::shared_ptr<Instrument> BasketOptionPtr;
typedef std::shared_ptr<Payoff> BasketPayoffPtr;
typedef std::shared_ptr<Payoff> MinBasketPayoffPtr;
typedef std::shared_ptr<Payoff> MaxBasketPayoffPtr;
typedef std::shared_ptr<Payoff> AverageBasketPayoffPtr;
%}

%rename(BasketPayoff) BasketPayoffPtr;
class BasketPayoffPtr : public std::shared_ptr<Payoff> {};

%rename(MinBasketPayoff) MinBasketPayoffPtr;
class MinBasketPayoffPtr : public BasketPayoffPtr  {
  public:
    %extend {
        MinBasketPayoffPtr(const std::shared_ptr<Payoff> p) {
            return new MinBasketPayoffPtr(new MinBasketPayoff(p));
        }
    }
};

%rename(MaxBasketPayoff) MaxBasketPayoffPtr;
class MaxBasketPayoffPtr : public BasketPayoffPtr  {
  public:
    %extend {
        MaxBasketPayoffPtr(const std::shared_ptr<Payoff> p) {
            return new MaxBasketPayoffPtr(new MaxBasketPayoff(p));
        }
    }
};

%rename(AverageBasketPayoff) AverageBasketPayoffPtr;
class AverageBasketPayoffPtr :
      public BasketPayoffPtr  {
  public:
    %extend {
        AverageBasketPayoffPtr(const std::shared_ptr<Payoff> p,
                               const Array &a) {
            return new AverageBasketPayoffPtr(new AverageBasketPayoff(p, a));
        }
        AverageBasketPayoffPtr(const std::shared_ptr<Payoff> p,
                               Size n) {
            return new AverageBasketPayoffPtr(new AverageBasketPayoff(p, n));
        }
    }
};


%rename(BasketOption) BasketOptionPtr;
class BasketOptionPtr : public MultiAssetOptionPtr {
  public:
    %extend {
        BasketOptionPtr(
                const std::shared_ptr<Payoff>& payoff,
                const std::shared_ptr<Exercise>& exercise) {
            std::shared_ptr<BasketPayoff> stPayoff =
                 std::dynamic_pointer_cast<BasketPayoff>(payoff);
            QL_REQUIRE(stPayoff, "wrong payoff given");
            return new BasketOptionPtr(new BasketOption(stPayoff,exercise));
        }
    }
};


%{
using QuantLib::MCEuropeanBasketEngine;
typedef std::shared_ptr<PricingEngine> MCEuropeanBasketEnginePtr;
%}

%rename(MCEuropeanBasketEngine) MCEuropeanBasketEnginePtr;
class MCEuropeanBasketEnginePtr : public std::shared_ptr<PricingEngine> {
    #if !defined(SWIGJAVA) && !defined(SWIGCSHARP)
    %feature("kwargs") MCEuropeanBasketEnginePtr;
    #endif
  public:
    %extend {
        MCEuropeanBasketEnginePtr(const StochasticProcessArrayPtr& process,
                                  const std::string& traits,
                                  Size timeSteps = Null<Size>(),
                                  Size timeStepsPerYear = Null<Size>(),
                                  bool brownianBridge = false,
                                  bool antitheticVariate = false,
                                  intOrNull requiredSamples = Null<Size>(),
                                  doubleOrNull requiredTolerance = Null<Real>(),
                                  intOrNull maxSamples = Null<Size>(),
                                  BigInteger seed = 0) {
            std::shared_ptr<StochasticProcessArray> processes =
                 std::dynamic_pointer_cast<StochasticProcessArray>(process);
            QL_REQUIRE(processes, "stochastic-process array required");
            std::string s = to_lower_copy(traits);
            if (s == "pseudorandom" || s == "pr")
                return new MCEuropeanBasketEnginePtr(
                   new MCEuropeanBasketEngine<PseudoRandom>(processes,
                                                            timeSteps,
                                                            timeStepsPerYear,
                                                            brownianBridge,
                                                            antitheticVariate,
                                                            requiredSamples,
                                                            requiredTolerance,
                                                            maxSamples,
                                                            seed));
            else if (s == "lowdiscrepancy" || s == "ld")
                return new MCEuropeanBasketEnginePtr(
                   new MCEuropeanBasketEngine<LowDiscrepancy>(processes,
                                                              timeSteps,
                                                              timeStepsPerYear,
                                                              brownianBridge,
                                                              antitheticVariate,
                                                              requiredSamples,
                                                              requiredTolerance,
                                                              maxSamples,
                                                              seed));
            else
                QL_FAIL("unknown Monte Carlo engine type: "+s);
        }
    }
};

%{
using QuantLib::MCAmericanBasketEngine;
typedef std::shared_ptr<PricingEngine> MCAmericanBasketEnginePtr;
%}

%rename(MCAmericanBasketEngine) MCAmericanBasketEnginePtr;
class MCAmericanBasketEnginePtr : public std::shared_ptr<PricingEngine> {
    #if !defined(SWIGJAVA) && !defined(SWIGCSHARP)
    %feature("kwargs") MCAmericanBasketEnginePtr;
    #endif
  public:
    %extend {
        MCAmericanBasketEnginePtr(const StochasticProcessArrayPtr& process,
                                  const std::string& traits,
                                  Size timeSteps = Null<Size>(),
                                  Size timeStepsPerYear = Null<Size>(),
                                  bool brownianBridge = false,
                                  bool antitheticVariate = false,
                                  intOrNull requiredSamples = Null<Size>(),
                                  doubleOrNull requiredTolerance = Null<Real>(),
                                  intOrNull maxSamples = Null<Size>(),
                                  BigInteger seed = 0) {
            std::shared_ptr<StochasticProcessArray> processes =
                 std::dynamic_pointer_cast<StochasticProcessArray>(process);
            QL_REQUIRE(processes, "stochastic-process array required");
            std::string s = to_lower_copy(traits);
            if (s == "pseudorandom" || s == "pr")
                  return new MCAmericanBasketEnginePtr(
                  new MCAmericanBasketEngine<PseudoRandom>(processes,
                                                           timeSteps,
                                                           timeStepsPerYear,
                                                           brownianBridge,
                                                           antitheticVariate,
                                                           requiredSamples,
                                                           requiredTolerance,
                                                           maxSamples,
                                                           seed));
            else if (s == "lowdiscrepancy" || s == "ld")
                return new MCAmericanBasketEnginePtr(
                new MCAmericanBasketEngine<LowDiscrepancy>(processes,
                                                           timeSteps,
                                                           timeStepsPerYear,
                                                           brownianBridge,
                                                           antitheticVariate,
                                                           requiredSamples,
                                                           requiredTolerance,
                                                           maxSamples,
                                                           seed));
            else
                QL_FAIL("unknown Monte Carlo engine type: "+s);
        }
    }
};


%{
using QuantLib::StulzEngine;
typedef std::shared_ptr<PricingEngine> StulzEnginePtr;
%}

%rename(StulzEngine) StulzEnginePtr;
class StulzEnginePtr
    : public std::shared_ptr<PricingEngine> {
  public:
    %extend {
        StulzEnginePtr(const GeneralizedBlackScholesProcessPtr& process1,
                       const GeneralizedBlackScholesProcessPtr& process2,
                       Real correlation) {
            std::shared_ptr<GeneralizedBlackScholesProcess> bsProcess1 =
                 std::dynamic_pointer_cast<GeneralizedBlackScholesProcess>(
                                                                    process1);
            QL_REQUIRE(bsProcess1, "Black-Scholes process required");
            std::shared_ptr<GeneralizedBlackScholesProcess> bsProcess2 =
                 std::dynamic_pointer_cast<GeneralizedBlackScholesProcess>(
                                                                    process2);
            QL_REQUIRE(bsProcess2, "Black-Scholes process required");
            return new StulzEnginePtr(
                          new StulzEngine(bsProcess1,bsProcess2,correlation));
        }
    }
};


%{
using QuantLib::EverestOption;
typedef std::shared_ptr<Instrument> EverestOptionPtr;
using QuantLib::MCEverestEngine;
typedef std::shared_ptr<PricingEngine> MCEverestEnginePtr;
%}

%rename(EverestOption) EverestOptionPtr;
class EverestOptionPtr : public MultiAssetOptionPtr {
  public:
    %extend {
        EverestOptionPtr(Real notional,
                         Rate guarantee,
                         const std::shared_ptr<Exercise>& exercise) {
            return new EverestOptionPtr(new EverestOption(notional,guarantee,
                                                          exercise));
        }
    }
};

%rename(MCEverestEngine) MCEverestEnginePtr;
class MCEverestEnginePtr : public std::shared_ptr<PricingEngine> {
    #if !defined(SWIGJAVA) && !defined(SWIGCSHARP)
    %feature("kwargs") MCEverestEnginePtr;
    #endif
  public:
    %extend {
        MCEverestEnginePtr(const StochasticProcessArrayPtr& process,
                           const std::string& traits,
                           Size timeSteps = Null<Size>(),
                           Size timeStepsPerYear = Null<Size>(),
                           bool brownianBridge = false,
                           bool antitheticVariate = false,
                           intOrNull requiredSamples = Null<Size>(),
                           doubleOrNull requiredTolerance = Null<Real>(),
                           intOrNull maxSamples = Null<Size>(),
                           BigInteger seed = 0) {
            std::shared_ptr<StochasticProcessArray> processes =
                 std::dynamic_pointer_cast<StochasticProcessArray>(process);
            QL_REQUIRE(processes, "stochastic-process array required");
            std::string s = to_lower_copy(traits);
            if (s == "pseudorandom" || s == "pr")
                return new MCEverestEnginePtr(
                        new MCEverestEngine<PseudoRandom>(processes,
                                                          timeSteps,
                                                          timeStepsPerYear,
                                                          brownianBridge,
                                                          antitheticVariate,
                                                          requiredSamples,
                                                          requiredTolerance,
                                                          maxSamples,
                                                          seed));
            else if (s == "lowdiscrepancy" || s == "ld")
                return new MCEverestEnginePtr(
                      new MCEverestEngine<LowDiscrepancy>(processes,
                                                          timeSteps,
                                                          timeStepsPerYear,
                                                          brownianBridge,
                                                          antitheticVariate,
                                                          requiredSamples,
                                                          requiredTolerance,
                                                          maxSamples,
                                                          seed));
            else
                QL_FAIL("unknown Monte Carlo engine type: "+s);
        }
    }
};


%{
using QuantLib::HimalayaOption;
typedef std::shared_ptr<Instrument> HimalayaOptionPtr;
using QuantLib::MCHimalayaEngine;
typedef std::shared_ptr<PricingEngine> MCHimalayaEnginePtr;
%}

%rename(HimalayaOption) HimalayaOptionPtr;
class HimalayaOptionPtr : public MultiAssetOptionPtr {
  public:
    %extend {
        HimalayaOptionPtr(const std::vector<Date>& fixingDates,
                          Real strike) {
            return new HimalayaOptionPtr(new HimalayaOption(fixingDates,
                                                            strike));
        }
    }
};

%rename(MCHimalayaEngine) MCHimalayaEnginePtr;
class MCHimalayaEnginePtr : public std::shared_ptr<PricingEngine> {
    #if !defined(SWIGJAVA) && !defined(SWIGCSHARP)
    %feature("kwargs") MCHimalayaEnginePtr;
    #endif
  public:
    %extend {
        MCHimalayaEnginePtr(const StochasticProcessArrayPtr& process,
                            const std::string& traits,
                            bool brownianBridge = false,
                            bool antitheticVariate = false,
                            intOrNull requiredSamples = Null<Size>(),
                            doubleOrNull requiredTolerance = Null<Real>(),
                            intOrNull maxSamples = Null<Size>(),
                            BigInteger seed = 0) {
            std::shared_ptr<StochasticProcessArray> processes =
                 std::dynamic_pointer_cast<StochasticProcessArray>(process);
            QL_REQUIRE(processes, "stochastic-process array required");
            std::string s = to_lower_copy(traits);
            if (s == "pseudorandom" || s == "pr")
                return new MCHimalayaEnginePtr(
                       new MCHimalayaEngine<PseudoRandom>(processes,
                                                          brownianBridge,
                                                          antitheticVariate,
                                                          requiredSamples,
                                                          requiredTolerance,
                                                          maxSamples,
                                                          seed));
            else if (s == "lowdiscrepancy" || s == "ld")
                return new MCHimalayaEnginePtr(
                     new MCHimalayaEngine<LowDiscrepancy>(processes,
                                                          brownianBridge,
                                                          antitheticVariate,
                                                          requiredSamples,
                                                          requiredTolerance,
                                                          maxSamples,
                                                          seed));
            else
                QL_FAIL("unknown Monte Carlo engine type: "+s);
        }
    }
};

#endif
