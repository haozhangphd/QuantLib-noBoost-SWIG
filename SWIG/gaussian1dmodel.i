
/*
 Copyright (C) 2014 Matthias Groncki
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

#ifndef quantlib_gaussian1dmodel_i
#define quantlib_gaussian1dmodel_i

%include stochasticprocess.i
%include date.i
%include options.i
%include indexes.i
%include optimizers.i
%include calibrationhelpers.i

%{
using QuantLib::Gaussian1dModel;

%}

%ignore Gaussian1dModel;
class Gaussian1dModel {
    public:
        const StochasticProcess1DPtr stateProcess() const;

        const Real numeraire(const Time t, const Real y = 0.0,
                             const Handle<YieldTermStructure> &yts =
                                 Handle<YieldTermStructure>()) const;

        const Real zerobond(const Time T, const Time t = 0.0,
                            const Real y = 0.0,
                            const Handle<YieldTermStructure> &yts =
                                Handle<YieldTermStructure>());

        const Real numeraire(const Date &referenceDate, const Real y = 0.0,
                             const Handle<YieldTermStructure> &yts =
                                 Handle<YieldTermStructure>()) const;

        const Real zerobond(const Date &maturity,
                            const Date &referenceDate = Null<Date>(),
                            const Real y = 0.0,
                            const Handle<YieldTermStructure> &yts =
                                Handle<YieldTermStructure>()) const;

        const Real zerobondOption(
            const Option::Type &type, const Date &expiry, const Date &valueDate,
            const Date &maturity, const Rate strike,
            const Date &referenceDate = Null<Date>(), const Real y = 0.0,
            const Handle<YieldTermStructure> &yts =
                Handle<YieldTermStructure>(),
            const Real yStdDevs = 7.0, const Size yGridPoints = 64,
            const bool extrapolatePayoff = true,
            const bool flatPayoffExtrapolation = false) const;

        const Real forwardRate(const Date &fixing,
                               const Date &referenceDate = Null<Date>(),
                               const Real y = 0.0,
                               std::shared_ptr<IborIndex> iborIdx =
                                   std::shared_ptr<IborIndex>()) const;

        const Real swapRate(const Date &fixing, const Period &tenor,
                            const Date &referenceDate = Null<Date>(),
                            const Real y = 0.0,
                            std::shared_ptr<SwapIndex> swapIdx =
                                std::shared_ptr<SwapIndex>()) const;

        const Real swapAnnuity(const Date &fixing, const Period &tenor,
                               const Date &referenceDate = Null<Date>(),
                               const Real y = 0.0,
                               std::shared_ptr<SwapIndex> swapIdx =
                                   std::shared_ptr<SwapIndex>()) const;
};

%template(Gaussian1dModel) std::shared_ptr<Gaussian1dModel>;

%{
using QuantLib::Gsr;
using QuantLib::MarkovFunctional;

typedef std::shared_ptr<Gaussian1dModel> GsrPtr;
typedef std::shared_ptr<Gaussian1dModel> MarkovFunctionalPtr;
%}


%rename(Gsr) GsrPtr;
class GsrPtr : public std::shared_ptr<Gaussian1dModel> {
  public:
    %extend {

        GsrPtr(const Handle<YieldTermStructure> &termStructure,
               const std::vector<Date> &volstepdates,
               const std::vector<Handle<Quote> > &volatilities,
               const std::vector<Handle<Quote> > &reversions, const Real T = 60.0) {
            return new GsrPtr(new Gsr(termStructure, volstepdates,
                                      volatilities, reversions, T));
        }
        
        void calibrateVolatilitiesIterative(
                const std::vector<std::shared_ptr<CalibrationHelper> > &helpers,
                OptimizationMethod &method, const EndCriteria &endCriteria,
                const Constraint &constraint = Constraint(),
                const std::vector<Real> &weights = std::vector<Real>()) {
            std::dynamic_pointer_cast<Gsr>(*self)
                ->calibrateVolatilitiesIterative(helpers, method, endCriteria,
                                                 constraint, weights);
        }
        
        void calibrate(
            const std::vector<std::shared_ptr<CalibrationHelper> >& helpers,
            OptimizationMethod& method, const EndCriteria & endCriteria,
            const Constraint& constraint = Constraint(),
            const std::vector<Real>& weights = std::vector<Real>(),
            const std::vector<bool> & fixParameters = std::vector<bool>()){
            std::dynamic_pointer_cast<Gsr>(*self)
                ->calibrate(helpers, method, endCriteria,
                            constraint, weights, fixParameters);
        }
        
        Array params() const{
            return std::dynamic_pointer_cast<Gsr>(*self)->params();
        }
        Real value(const Array& params,
                   const std::vector<std::shared_ptr<CalibrationHelper> >& helpers){
            return std::dynamic_pointer_cast<Gsr>(*self)->value(params, helpers);
        }
        EndCriteria::Type endCriteria() const{
            return std::dynamic_pointer_cast<Gsr>(*self)->endCriteria();
        }
        void setParams(const Array& params){
            std::dynamic_pointer_cast<Gsr>(*self)->setParams(params);
        }
        Integer functionEvaluation() const{
            return std::dynamic_pointer_cast<Gsr>(*self)->functionEvaluation();
        }
        const Array &reversion() const {
            return std::dynamic_pointer_cast<Gsr>(*self)->reversion();
        }

        const Array &volatility() const {
            return std::dynamic_pointer_cast<Gsr>(*self)->volatility();
        }

    }
};


#if defined(SWIGJAVA) || defined(SWIGCSHARP)
%rename(_MarkovFunctional) MarkovFunctional;
#else
%ignore MarkovFunctional;
#endif
%rename (MarkovFunctionalSettings) MarkovFunctional::ModelSettings;
%feature ("flatnested") ModelSettings;
class MarkovFunctional {
  public:
    struct ModelSettings {
       enum Adjustments {
            AdjustNone = 0,
            AdjustDigitals = 1 << 0,
            AdjustYts = 1 << 1,
            ExtrapolatePayoffFlat = 1 << 2,
            NoPayoffExtrapolation = 1 << 3,
            KahaleSmile = 1 << 4,
            SmileExponentialExtrapolation = 1 << 5,
            KahaleInterpolation = 1 << 6,
            SmileDeleteArbitragePoints = 1 << 7,
            SabrSmile = 1 << 8
        };
    };
#if defined(SWIGJAVA) || defined(SWIGCSHARP)
  private:
    MarkovFunctional();
#endif
};


%rename(MarkovFunctional) MarkovFunctionalPtr;
class MarkovFunctionalPtr : public std::shared_ptr<Gaussian1dModel> {
  public:
    %extend {
        static const MarkovFunctional::ModelSettings::Adjustments AdjustNone
            = MarkovFunctional::ModelSettings::AdjustNone;
        static const MarkovFunctional::ModelSettings::Adjustments AdjustDigitals
            = MarkovFunctional::ModelSettings::AdjustDigitals;
        static const MarkovFunctional::ModelSettings::Adjustments AdjustYts
            = MarkovFunctional::ModelSettings::AdjustYts;
        static const MarkovFunctional::ModelSettings::Adjustments ExtrapolatePayoffFlat
            = MarkovFunctional::ModelSettings::ExtrapolatePayoffFlat;
        static const MarkovFunctional::ModelSettings::Adjustments NoPayoffExtrapolation
            = MarkovFunctional::ModelSettings::NoPayoffExtrapolation;
        static const MarkovFunctional::ModelSettings::Adjustments KahaleSmile
            = MarkovFunctional::ModelSettings::KahaleSmile;
        static const MarkovFunctional::ModelSettings::Adjustments SmileExponentialExtrapolation
            = MarkovFunctional::ModelSettings::SmileExponentialExtrapolation;
        static const MarkovFunctional::ModelSettings::Adjustments KahaleInterpolation
            = MarkovFunctional::ModelSettings::KahaleInterpolation;
        static const MarkovFunctional::ModelSettings::Adjustments SmileDeleteArbitragePoints
            = MarkovFunctional::ModelSettings::SmileDeleteArbitragePoints;
        static const MarkovFunctional::ModelSettings::Adjustments SabrSmile
            = MarkovFunctional::ModelSettings::SabrSmile;

        MarkovFunctionalPtr(
            const Handle<YieldTermStructure> &termStructure,
            const Real reversion,
            const std::vector<Date> &volstepdates,
            const std::vector<Real> &volatilities,
            const Handle<SwaptionVolatilityStructure> &swaptionVol,
            const std::vector<Date> &swaptionExpiries,
            const std::vector<Period> &swaptionTenors,
            const SwapIndexPtr& swapIndexBase,
            const Size yGridPoints = 64,
            const Real yStdDevs = 7.0,
            const Size gaussHermitePoints = 32,
            const Real digitalGap = 1E-5,
            const Real marketRateAccuracy = 1E-7,
            const Real lowerRateBound = 0.0,
            const Real upperRateBound = 2.0,
            const int adjustments =
                MarkovFunctional::ModelSettings::KahaleSmile | MarkovFunctional::ModelSettings::SmileExponentialExtrapolation,
            const std::vector<Real>& smileMoneyCheckpoints = std::vector<Real>()) {
            const std::shared_ptr<SwapIndex> swapIndex =
                std::dynamic_pointer_cast<SwapIndex>(swapIndexBase);
            MarkovFunctional::ModelSettings modelSettings =
                MarkovFunctional::ModelSettings(yGridPoints, yStdDevs,
                                                gaussHermitePoints, digitalGap,
                                                marketRateAccuracy,
                                                lowerRateBound,
                                                upperRateBound,
                                                adjustments,
                                                smileMoneyCheckpoints);
            return new MarkovFunctionalPtr(
                new MarkovFunctional(termStructure, reversion,
                                     volstepdates, volatilities,
                                     swaptionVol, swaptionExpiries,
                                     swaptionTenors, swapIndex,
                                     modelSettings));
        }

        void calibrate(
              const std::vector<std::shared_ptr<CalibrationHelper> > &helper,
              OptimizationMethod &method, const EndCriteria &endCriteria,
              const Constraint &constraint = Constraint(),
              const std::vector<Real> &weights = std::vector<Real>(),
              const std::vector<bool> &fixParameters = std::vector<bool>()) {
            std::dynamic_pointer_cast<MarkovFunctional>(*self)->calibrate(helper, method, 
                                                                            endCriteria, constraint, weights, fixParameters);
        }

        const Array& volatility() const {
            return std::dynamic_pointer_cast<MarkovFunctional>(*self)
                ->volatility();
        }

    }
};

// Pricing Engines

%{
using QuantLib::Gaussian1dSwaptionEngine;
using QuantLib::Gaussian1dJamshidianSwaptionEngine;
using QuantLib::Gaussian1dNonstandardSwaptionEngine;
using QuantLib::Gaussian1dFloatFloatSwaptionEngine;
 
typedef std::shared_ptr<PricingEngine> Gaussian1dSwaptionEnginePtr;
typedef std::shared_ptr<PricingEngine> Gaussian1dJamshidianSwaptionEnginePtr;
typedef std::shared_ptr<PricingEngine> Gaussian1dNonstandardSwaptionEnginePtr;
typedef std::shared_ptr<PricingEngine> Gaussian1dFloatFloatSwaptionEnginePtr;
%}

%rename(Gaussian1dSwaptionEngine) Gaussian1dSwaptionEnginePtr;
class Gaussian1dSwaptionEnginePtr : public std::shared_ptr<PricingEngine> {
  public:
    %extend {

    Gaussian1dSwaptionEnginePtr(const std::shared_ptr<Gaussian1dModel> &model,
            const int integrationPoints = 64, const Real stddevs = 7.0,
            const bool extrapolatePayoff = true,
            const bool flatPayoffExtrapolation = false,
            const Handle<YieldTermStructure> &discountCurve =
                Handle<YieldTermStructure>()) {
            return new Gaussian1dSwaptionEnginePtr(new Gaussian1dSwaptionEngine(model, integrationPoints, 
                    stddevs, extrapolatePayoff, flatPayoffExtrapolation, discountCurve));
        }
    
    }
};

%rename(Gaussian1dJamshidianSwaptionEngine) Gaussian1dJamshidianSwaptionEnginePtr;
class Gaussian1dJamshidianSwaptionEnginePtr : public std::shared_ptr<PricingEngine> {
  public:
    %extend {

    Gaussian1dJamshidianSwaptionEnginePtr(const std::shared_ptr<Gaussian1dModel> &model) {
            return new Gaussian1dJamshidianSwaptionEnginePtr(new Gaussian1dJamshidianSwaptionEngine(model));
        }
    
    }
};

%rename(Gaussian1dNonstandardSwaptionEngine) Gaussian1dNonstandardSwaptionEnginePtr;
class Gaussian1dNonstandardSwaptionEnginePtr : public std::shared_ptr<PricingEngine> {
  public:
    %extend {

    Gaussian1dNonstandardSwaptionEnginePtr(
            const std::shared_ptr<Gaussian1dModel> &model,
            const int integrationPoints = 64, const Real stddevs = 7.0,
            const bool extrapolatePayoff = true,
            const bool flatPayoffExtrapolation = false,
            const Handle<Quote> &oas = Handle<Quote>(), // continuously
                                                        // compounded w.r.t. yts
                                                        // daycounter
            const Handle<YieldTermStructure> &discountCurve =
                Handle<YieldTermStructure>()) {
            return new Gaussian1dNonstandardSwaptionEnginePtr(new Gaussian1dNonstandardSwaptionEngine(model, integrationPoints, 
                    stddevs, extrapolatePayoff, flatPayoffExtrapolation, oas, discountCurve));
        }
    
    }

};

#if defined(SWIGJAVA) || defined(SWIGCSHARP)
%rename(_Gaussian1dFloatFloatSwaptionEngine) Gaussian1dFloatFloatSwaptionEngine;
#else
%ignore Gaussian1dFloatFloatSwaptionEngine;
#endif
class Gaussian1dFloatFloatSwaptionEngine {
  public:
    enum Probabilities {  None,
                          Naive,
                          Digital };
#if defined(SWIGJAVA) || defined(SWIGCSHARP)
  private:
    Gaussian1dFloatFloatSwaptionEngine();
#endif
};

%rename(Gaussian1dFloatFloatSwaptionEngine) Gaussian1dFloatFloatSwaptionEnginePtr;
class Gaussian1dFloatFloatSwaptionEnginePtr : public std::shared_ptr<PricingEngine> {
  public:
    %extend {

        static const Gaussian1dFloatFloatSwaptionEngine::Probabilities None
            = Gaussian1dFloatFloatSwaptionEngine::None;
        static const Gaussian1dFloatFloatSwaptionEngine::Probabilities Naive
            = Gaussian1dFloatFloatSwaptionEngine::Naive;
        static const Gaussian1dFloatFloatSwaptionEngine::Probabilities Digital
            = Gaussian1dFloatFloatSwaptionEngine::Digital;

        Gaussian1dFloatFloatSwaptionEnginePtr(
                const std::shared_ptr<Gaussian1dModel> &model,
                const int integrationPoints = 64, const Real stddevs = 7.0,
                const bool extrapolatePayoff = true,
                const bool flatPayoffExtrapolation = false,
                const Handle<Quote> &oas = Handle<Quote>(),
                const Handle<YieldTermStructure> &discountCurve =
                                                 Handle<YieldTermStructure>(),
                const bool includeTodaysExercise = false,
                const Gaussian1dFloatFloatSwaptionEngine::Probabilities probabilities = Gaussian1dFloatFloatSwaptionEngine::None) {
            return new Gaussian1dFloatFloatSwaptionEnginePtr(
                new Gaussian1dFloatFloatSwaptionEngine(model,
                                                       integrationPoints,
                                                       stddevs,
                                                       extrapolatePayoff,
                                                       flatPayoffExtrapolation,
                                                       oas,
                                                       discountCurve,
                                                       includeTodaysExercise,
                                                       probabilities));
        }

    }

};

#endif
