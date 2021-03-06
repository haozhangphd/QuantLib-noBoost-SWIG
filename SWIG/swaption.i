
/*
 Copyright (C) 2000, 2001, 2002, 2003 RiskMap srl
 Copyright (C) 2016 Peter Caspers
 Copyright (C) 2017 Matthias Lungwitz

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

#ifndef quantlib_swaption_i
#define quantlib_swaption_i

%include options.i
%include marketelements.i
%include termstructures.i
%include volatilities.i
%include swap.i
%include old_volatility.i
%include daycounters.i

%{
using QuantLib::Actual365Fixed;
using QuantLib::Swaption;
using QuantLib::NonstandardSwaption;
using QuantLib::Settlement;
using QuantLib::FloatFloatSwaption;
typedef std::shared_ptr<Instrument> SwaptionPtr;
typedef std::shared_ptr<Instrument> NonstandardSwaptionPtr;
typedef std::shared_ptr<Instrument> FloatFloatSwaptionPtr;
%}

struct Settlement {
   enum Type { Physical, Cash };
};

%rename(Swaption) SwaptionPtr;
class SwaptionPtr : public std::shared_ptr<Instrument> {
  public:
    %extend {
        SwaptionPtr(const VanillaSwapPtr& simpleSwap,
                    const std::shared_ptr<Exercise>& exercise,
                    Settlement::Type type = Settlement::Physical) {
            std::shared_ptr<VanillaSwap> swap =
                 std::dynamic_pointer_cast<VanillaSwap>(simpleSwap);
            QL_REQUIRE(swap, "simple swap required");
            return new SwaptionPtr(new Swaption(swap,exercise,type));
        }
    }
};

%{
using QuantLib::BasketGeneratingEngine;
%}

%rename(NonstandardSwaption) NonstandardSwaptionPtr;
class NonstandardSwaptionPtr : public std::shared_ptr<Instrument> {
  public:
    %extend {
        NonstandardSwaptionPtr(const NonstandardSwapPtr& nonstandardSwap,
                    const std::shared_ptr<Exercise>& exercise,
                    Settlement::Type type = Settlement::Physical) {
            std::shared_ptr<NonstandardSwap> swap =
                 std::dynamic_pointer_cast<NonstandardSwap>(nonstandardSwap);
            QL_REQUIRE(swap, "nonstandard swap required");
            return new NonstandardSwaptionPtr(new NonstandardSwaption(swap,exercise,type));
        }

        std::vector<std::shared_ptr<CalibrationHelper> > calibrationBasket(
            std::shared_ptr<Index> standardSwapBase,
            std::shared_ptr<SwaptionVolatilityStructure> swaptionVolatility,
            std::string typeStr) {

            BasketGeneratingEngine::CalibrationBasketType type;
            if(typeStr == "Naive")
                type = BasketGeneratingEngine::Naive;
            else if(typeStr == "MaturityStrikeByDeltaGamma")
                type = BasketGeneratingEngine::MaturityStrikeByDeltaGamma;
            else
                QL_FAIL("type " << typeStr << "unknown.");
            std::shared_ptr<SwapIndex> swapIndex =
                std::dynamic_pointer_cast<SwapIndex>(standardSwapBase);
            return std::dynamic_pointer_cast<NonstandardSwaption>(*self)->
                calibrationBasket(swapIndex, swaptionVolatility, type);
        }
    }
};

%rename(FloatFloatSwaption) FloatFloatSwaptionPtr;
class FloatFloatSwaptionPtr : public std::shared_ptr<Instrument> {
  public:
    %extend {
        FloatFloatSwaptionPtr(const FloatFloatSwapPtr& simpleSwap,
                    const std::shared_ptr<Exercise>& exercise) {
            std::shared_ptr<FloatFloatSwap> swap =
                 std::dynamic_pointer_cast<FloatFloatSwap>(simpleSwap);
            QL_REQUIRE(swap, "floatfloat swap required");
            return new FloatFloatSwaptionPtr(new FloatFloatSwaption(swap,exercise));
        }

        std::vector<std::shared_ptr<CalibrationHelper> > calibrationBasket(
            std::shared_ptr<Index> standardSwapBase,
            std::shared_ptr<SwaptionVolatilityStructure> swaptionVolatility,
            std::string typeStr) {

            BasketGeneratingEngine::CalibrationBasketType type;
            if(typeStr == "Naive")
                type = BasketGeneratingEngine::Naive;
            else if(typeStr == "MaturityStrikeByDeltaGamma")
                type = BasketGeneratingEngine::MaturityStrikeByDeltaGamma;
            else
                QL_FAIL("type " << typeStr << "unknown.");
            std::shared_ptr<SwapIndex> swapIndex =
                std::dynamic_pointer_cast<SwapIndex>(standardSwapBase);
            return std::dynamic_pointer_cast<FloatFloatSwaption>(*self)->
                calibrationBasket(swapIndex, swaptionVolatility, type);
        }

        Real underlyingValue() {
            return std::dynamic_pointer_cast<FloatFloatSwaption>(*self)->result<Real>("underlyingValue");
        }
    }
};

// pricing engines

%{
using QuantLib::BlackSwaptionEngine;
using QuantLib::BachelierSwaptionEngine;
typedef std::shared_ptr<PricingEngine> BlackSwaptionEnginePtr;
typedef std::shared_ptr<PricingEngine> BachelierSwaptionEnginePtr;
%}

%rename(BlackSwaptionEngine) BlackSwaptionEnginePtr;
class BlackSwaptionEnginePtr : public std::shared_ptr<PricingEngine> {
  public:
    %extend {
        BlackSwaptionEnginePtr(
                           const Handle<YieldTermStructure> & discountCurve,
                           const Handle<Quote>& vol,
                           const DayCounter& dc = Actual365Fixed(),
                           Real displacement = 0.0) {
            return new BlackSwaptionEnginePtr(
                          new BlackSwaptionEngine(discountCurve, vol, dc, displacement));
        }
        BlackSwaptionEnginePtr(
                           const Handle<YieldTermStructure> & discountCurve,
                           const Handle<SwaptionVolatilityStructure>& v) {
            return new BlackSwaptionEnginePtr(
                                   new BlackSwaptionEngine(discountCurve, v));
        }

    Real vega() {
                return std::dynamic_pointer_cast<Swaption>(*self)->result<Real>("vega");
        }

    }
};

%rename(BachelierSwaptionEngine) BachelierSwaptionEnginePtr;
class BachelierSwaptionEnginePtr : public std::shared_ptr<PricingEngine> {
  public:
    %extend {
        BachelierSwaptionEnginePtr(
                           const Handle<YieldTermStructure> & discountCurve,
                           const Handle<Quote>& vol,
                           const DayCounter& dc = Actual365Fixed()) {
            return new BlackSwaptionEnginePtr(
                          new BachelierSwaptionEngine(discountCurve, vol, dc));
        }
        BachelierSwaptionEnginePtr(
                           const Handle<YieldTermStructure> & discountCurve,
                           const Handle<SwaptionVolatilityStructure>& v) {
            return new BlackSwaptionEnginePtr(
                                   new BachelierSwaptionEngine(discountCurve, v));
        }
    }
};

#endif

