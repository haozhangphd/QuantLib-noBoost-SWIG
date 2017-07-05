
/*
 Copyright (C) 2000, 2001, 2002, 2003 RiskMap srl

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

#ifndef quantlib_instruments_i
#define quantlib_instruments_i

%include common.i
%include types.i
%include marketelements.i
%include observer.i
%include stl.i

// pricing engine

%{
using QuantLib::PricingEngine;
%}

%template(PricingEngine) std::shared_ptr<PricingEngine>;

// instrument

%{
using QuantLib::Instrument;
%}

%ignore Instrument;
class Instrument {
    #if defined(SWIGRUBY)
    %rename("isExpired?")     isExpired;
    %rename("pricingEngine=") setPricingEngine;
    %rename("recalculate!")   recalculate;
    %rename("freeze!")        freeze;
    %rename("unfreeze!")      unfreeze;
    #elif defined(SWIGMZSCHEME) || defined(SWIGGUILE)
    %rename("error-estimate")      errorEstimate;
    %rename("expired?")            isExpired;
    %rename("pricing-engine-set!") setPricingEngine;
    %rename("recalculate!")        recalculate;
    %rename("freeze!")             freeze;
    %rename("unfreeze!")           unfreeze;
    #endif
  public:
    Real NPV() const;
    Real errorEstimate() const;
    bool isExpired() const;
    void setPricingEngine(const std::shared_ptr<PricingEngine>&);
    void recalculate();
    void freeze();
    void unfreeze();
};

#if defined(SWIGR)
%Rruntime %{
setMethod("summary", "_p_std__shared_ptrTInstrument_t",
function(object) c(value=object$NPV()))

setMethod("print", "_p_std__shared_ptrTInstrument_t",
function(x) print(summary(x)))
%}
#endif

%template(Instrument) std::shared_ptr<Instrument>;
IsObservable(std::shared_ptr<Instrument>);

#if defined(SWIGCSHARP)
SWIG_STD_VECTOR_ENHANCED( std::shared_ptr<Instrument> )
#endif
namespace std {
    %template(InstrumentVector) vector<std::shared_ptr<Instrument> >;
}

// actual instruments

%{
using QuantLib::Stock;
typedef std::shared_ptr<Instrument> StockPtr;
%}

%rename(Stock) StockPtr;
class StockPtr : public std::shared_ptr<Instrument> {
  public:
    %extend {
        StockPtr(const Handle<Quote>& quote) {
            return new StockPtr(new Stock(quote));
        }
    }
};


%{
using QuantLib::CompositeInstrument;
typedef std::shared_ptr<Instrument> CompositeInstrumentPtr;
%}

%rename(CompositeInstrument) CompositeInstrumentPtr;
class CompositeInstrumentPtr : public std::shared_ptr<Instrument> {
  public:
    %extend {
        CompositeInstrumentPtr() {
            return new CompositeInstrumentPtr(new CompositeInstrument);
        }
        void add(const std::shared_ptr<Instrument>& instrument,
                 Real multiplier = 1.0) {
            std::dynamic_pointer_cast<CompositeInstrument>(*self)
                ->add(instrument, multiplier);
        }
        void subtract(const std::shared_ptr<Instrument>& instrument,
                      Real multiplier = 1.0) {
            std::dynamic_pointer_cast<CompositeInstrument>(*self)
                ->subtract(instrument, multiplier);
        }
    }
};


#endif
