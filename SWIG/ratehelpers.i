
/*
 Copyright (C) 2005, 2006, 2007, 2008 StatPro Italia srl
 Copyright (C) 2009 Joseph Malicki

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

#ifndef quantlib_rate_helpers_i
#define quantlib_rate_helpers_i

%include bonds.i
%include date.i
%include calendars.i
%include daycounters.i
%include futures.i
%include marketelements.i
%include types.i
%include vectors.i
%include swap.i

%{
using QuantLib::Pillar;
using QuantLib::RateHelper;
using QuantLib::DepositRateHelper;
using QuantLib::FraRateHelper;
using QuantLib::FuturesRateHelper;
using QuantLib::SwapRateHelper;
using QuantLib::BondHelper;
using QuantLib::FixedRateBondHelper;
using QuantLib::OISRateHelper;
using QuantLib::DatedOISRateHelper;
typedef std::shared_ptr<RateHelper> DepositRateHelperPtr;
typedef std::shared_ptr<RateHelper> FraRateHelperPtr;
typedef std::shared_ptr<RateHelper> FuturesRateHelperPtr;
typedef std::shared_ptr<RateHelper> SwapRateHelperPtr;
typedef std::shared_ptr<RateHelper> BondHelperPtr;
typedef std::shared_ptr<RateHelper> FixedRateBondHelperPtr;
typedef std::shared_ptr<RateHelper> OISRateHelperPtr;
typedef std::shared_ptr<RateHelper> DatedOISRateHelperPtr;
%}

struct Pillar {
    enum Choice { MaturityDate, LastRelevantDate, CustomDate};
};

%ignore RateHelper;
class RateHelper {
    #if defined(SWIGMZSCHEME) || defined(SWIGGUILE)
    %rename("latest-date") latestDate;
    #endif
  public:
    Handle<Quote> quote() const;
    Date latestDate() const;
};

// rate helpers for curve bootstrapping
%template(RateHelper) std::shared_ptr<RateHelper>;

%rename(DepositRateHelper) DepositRateHelperPtr;
class DepositRateHelperPtr : public std::shared_ptr<RateHelper> {
  public:
    %extend {
        DepositRateHelperPtr(
                const Handle<Quote>& rate,
                const Period& tenor,
                Natural fixingDays,
                const Calendar& calendar,
                BusinessDayConvention convention,
                bool endOfMonth,
                const DayCounter& dayCounter) {
            return new DepositRateHelperPtr(
                new DepositRateHelper(rate,tenor,fixingDays,
                                      calendar,convention,
                                      endOfMonth, dayCounter));
        }
        DepositRateHelperPtr(
                Rate rate,
                const Period& tenor,
                Natural fixingDays,
                const Calendar& calendar,
                BusinessDayConvention convention,
                bool endOfMonth,
                const DayCounter& dayCounter) {
            return new DepositRateHelperPtr(
                new DepositRateHelper(rate, tenor, fixingDays,
                                      calendar, convention,
                                      endOfMonth, dayCounter));
        }
        DepositRateHelperPtr(const Handle<Quote>& rate,
                             const IborIndexPtr& index) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new DepositRateHelperPtr(
                new DepositRateHelper(rate, libor));
        }
        DepositRateHelperPtr(Rate rate,
                             const IborIndexPtr& index) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new DepositRateHelperPtr(
                new DepositRateHelper(rate, libor));
        }
    }
};

%rename(FraRateHelper) FraRateHelperPtr;
class FraRateHelperPtr : public std::shared_ptr<RateHelper> {
  public:
    %extend {
        FraRateHelperPtr(
                const Handle<Quote>& rate,
                Natural monthsToStart,
                Natural monthsToEnd,
                Natural fixingDays,
                const Calendar& calendar,
                BusinessDayConvention convention,
                bool endOfMonth,
                const DayCounter& dayCounter) {
            return new FraRateHelperPtr(
                new FraRateHelper(rate,monthsToStart,monthsToEnd,
                                  fixingDays,calendar,convention,
                                  endOfMonth,dayCounter));
        }
        FraRateHelperPtr(
                Rate rate,
                Natural monthsToStart,
                Natural monthsToEnd,
                Natural fixingDays,
                const Calendar& calendar,
                BusinessDayConvention convention,
                bool endOfMonth,
                const DayCounter& dayCounter) {
            return new FraRateHelperPtr(
                new FraRateHelper(rate,monthsToStart,monthsToEnd,
                                  fixingDays,calendar,convention,
                                  endOfMonth,dayCounter));
        }
        FraRateHelperPtr(const Handle<Quote>& rate,
                         Natural monthsToStart,
                         const IborIndexPtr& index) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new FraRateHelperPtr(
                new FraRateHelper(rate,monthsToStart,libor));
        }
        FraRateHelperPtr(Rate rate,
                         Natural monthsToStart,
                         const IborIndexPtr& index) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new FraRateHelperPtr(
                new FraRateHelper(rate,monthsToStart,libor));
        }
    }
};

%rename(FuturesRateHelper) FuturesRateHelperPtr;
class FuturesRateHelperPtr : public std::shared_ptr<RateHelper> {
  public:
    %extend {
        FuturesRateHelperPtr(
                const Handle<Quote>& price,
                const Date& iborStartDate,
                Natural nMonths,
                const Calendar& calendar,
                BusinessDayConvention convention,
                bool endOfMonth,
                const DayCounter& dayCounter,
                const Handle<Quote>& convexityAdjustment,
                Futures::Type type = Futures::IMM) {
            return new FuturesRateHelperPtr(
                new FuturesRateHelper(price,iborStartDate,nMonths,
                                      calendar,convention,endOfMonth,
                                      dayCounter,convexityAdjustment,type));
        }
        FuturesRateHelperPtr(
                Real price,
                const Date& iborStartDate,
                Natural nMonths,
                const Calendar& calendar,
                BusinessDayConvention convention,
                bool endOfMonth,
                const DayCounter& dayCounter,
                Rate convexityAdjustment = 0.0,
                Futures::Type type = Futures::IMM) {
            return new FuturesRateHelperPtr(
                new FuturesRateHelper(price,iborStartDate,nMonths,
                                      calendar,convention,endOfMonth,
                                      dayCounter,convexityAdjustment,type));
        }
        FuturesRateHelperPtr(
                const Handle<Quote>& price,
                const Date& iborStartDate,
                const Date& iborEndDate,
                const DayCounter& dayCounter,
                const Handle<Quote>& convexityAdjustment,
                Futures::Type type = Futures::IMM) {
            return new FuturesRateHelperPtr(
                new FuturesRateHelper(price,iborStartDate,iborEndDate,
                                      dayCounter,convexityAdjustment,type));
        }
        FuturesRateHelperPtr(
                Real price,
                const Date& iborStartDate,
                const Date& iborEndDate,
                const DayCounter& dayCounter,
                Rate convexityAdjustment = 0.0,
                Futures::Type type = Futures::IMM) {
            return new FuturesRateHelperPtr(
                new FuturesRateHelper(price,iborStartDate,iborEndDate,
                                      dayCounter,convexityAdjustment,type));
        }
        FuturesRateHelperPtr(
                const Handle<Quote>& price,
                const Date& iborStartDate,
                const IborIndexPtr& index,
                const Handle<Quote>& convexityAdjustment,
                Futures::Type type = Futures::IMM) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new FuturesRateHelperPtr(
                new FuturesRateHelper(price,iborStartDate,libor,
                                      convexityAdjustment,type));
        }
        FuturesRateHelperPtr(
                Real price,
                const Date& iborStartDate,
                const IborIndexPtr& index,
                Real convexityAdjustment = 0.0,
                Futures::Type type = Futures::IMM) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new FuturesRateHelperPtr(
                new FuturesRateHelper(price,iborStartDate,libor,
                                      convexityAdjustment,type));
        }
    }
};

%rename(SwapRateHelper) SwapRateHelperPtr;
class SwapRateHelperPtr : public std::shared_ptr<RateHelper> {
  public:
    %extend {
        SwapRateHelperPtr(
                const Handle<Quote>& rate,
                const Period& tenor,
                const Calendar& calendar,
                Frequency fixedFrequency,
                BusinessDayConvention fixedConvention,
                const DayCounter& fixedDayCount,
                const IborIndexPtr& index,
                const Handle<Quote>& spread = Handle<Quote>(),
                const Period& fwdStart = 0*Days,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>(),
                Natural settlementDays = Null<Natural>(),
                Pillar::Choice pillar = Pillar::LastRelevantDate,
                Date customPillarDate = Date()) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new SwapRateHelperPtr(
                new SwapRateHelper(rate, tenor, calendar,
                                   fixedFrequency, fixedConvention,
                                   fixedDayCount, libor,
                                   spread, fwdStart,
                                   discountingCurve, settlementDays,
                                   pillar, customPillarDate));
        }
        SwapRateHelperPtr(
                Rate rate,
                const Period& tenor,
                const Calendar& calendar,
                Frequency fixedFrequency,
                BusinessDayConvention fixedConvention,
                const DayCounter& fixedDayCount,
                const IborIndexPtr& index,
                const Handle<Quote>& spread = Handle<Quote>(),
                const Period& fwdStart = 0*Days,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>(),
                Natural settlementDays = Null<Natural>(),
                Pillar::Choice pillar = Pillar::LastRelevantDate,
                Date customPillarDate = Date()) {
            std::shared_ptr<IborIndex> libor =
                std::dynamic_pointer_cast<IborIndex>(index);
            return new SwapRateHelperPtr(
                new SwapRateHelper(rate, tenor, calendar,
                                   fixedFrequency, fixedConvention,
                                   fixedDayCount, libor,
                                   spread, fwdStart,
                                   discountingCurve, settlementDays,
                                   pillar, customPillarDate));
        }
        SwapRateHelperPtr(
                const Handle<Quote>& rate,
                const SwapIndexPtr& index,
                const Handle<Quote>& spread = Handle<Quote>(),
                const Period& fwdStart = 0*Days,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>(),
                Pillar::Choice pillar = Pillar::LastRelevantDate,
                Date customPillarDate = Date()) {
            std::shared_ptr<SwapIndex> swapIndex =
                std::dynamic_pointer_cast<SwapIndex>(index);
            return new SwapRateHelperPtr(
                new SwapRateHelper(rate, swapIndex,
                                   spread, fwdStart,
                                   discountingCurve,
                                   pillar, customPillarDate));
        }
        SwapRateHelperPtr(
                Rate rate,
                const SwapIndexPtr& index,
                const Handle<Quote>& spread = Handle<Quote>(),
                const Period& fwdStart = 0*Days,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>(),
                Pillar::Choice pillar = Pillar::LastRelevantDate,
                Date customPillarDate = Date()) {
            std::shared_ptr<SwapIndex> swapIndex =
                std::dynamic_pointer_cast<SwapIndex>(index);
            return new SwapRateHelperPtr(
                new SwapRateHelper(rate, swapIndex,
                                   spread, fwdStart,
                                   discountingCurve,
                                   pillar, customPillarDate));
        }
        VanillaSwapPtr swap() {
            return std::dynamic_pointer_cast<SwapRateHelper>(*self)->swap();
        }
    }
};

%rename(BondHelper) BondHelperPtr;
class BondHelperPtr : public std::shared_ptr<RateHelper> {
  public:
    %extend {
        BondHelperPtr(const Handle<Quote>& cleanPrice,
                      const BondPtr& bond,
                      bool useCleanPrice = true) {
            std::shared_ptr<Bond> b = std::dynamic_pointer_cast<Bond>(bond);
            return new BondHelperPtr(
                new BondHelper(cleanPrice, b, useCleanPrice));
        }

        BondPtr bond() {
            return BondPtr(std::dynamic_pointer_cast<BondHelper>(*self)->bond());
        }
    }
};

%rename(FixedRateBondHelper) FixedRateBondHelperPtr;
class FixedRateBondHelperPtr : public BondHelperPtr {
  public:
    %extend {
        FixedRateBondHelperPtr(
                      const Handle<Quote>& cleanPrice,
                      Size settlementDays,
                      Real faceAmount,
                      const Schedule& schedule,
                      const std::vector<Rate>& coupons,
                      const DayCounter& paymentDayCounter,
                      BusinessDayConvention paymentConvention = Following,
                      Real redemption = 100.0,
                      const Date& issueDate = Date(),
                      const Calendar& paymentCalendar = Calendar(),
                      const Period& exCouponPeriod = Period(),
                      const Calendar& exCouponCalendar = Calendar(),
                      BusinessDayConvention exCouponConvention = Unadjusted,
                      bool exCouponEndOfMonth = false,
                      bool useCleanPrice = true) {
            return new FixedRateBondHelperPtr(
                new FixedRateBondHelper(cleanPrice, settlementDays, faceAmount,
                                        schedule, coupons, paymentDayCounter,
                                        paymentConvention, redemption,
                                        issueDate, paymentCalendar,
                                        exCouponPeriod, exCouponCalendar,
                                        exCouponConvention, exCouponEndOfMonth,
                                        useCleanPrice));
        }

        FixedRateBondPtr bond() {
            return FixedRateBondPtr(std::dynamic_pointer_cast<FixedRateBondHelper>(*self)->bond());
        }
    }
};


%rename(OISRateHelper) OISRateHelperPtr;
class OISRateHelperPtr : public std::shared_ptr<RateHelper> {
  public:
    %extend {
        OISRateHelperPtr(
                Natural settlementDays,
                const Period& tenor,
                const Handle<Quote>& rate,
                const OvernightIndexPtr& index,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>()) {
            std::shared_ptr<OvernightIndex> overnight =
                std::dynamic_pointer_cast<OvernightIndex>(index);
            return new OISRateHelperPtr(
                new OISRateHelper(settlementDays,tenor,rate,
                                  overnight,discountingCurve));
        }
    }
};

%rename(DatedOISRateHelper) DatedOISRateHelperPtr;
class DatedOISRateHelperPtr : public std::shared_ptr<RateHelper> {
  public:
    %extend {
        DatedOISRateHelperPtr(
                const Date& startDate,
                const Date& endDate,
                const Handle<Quote>& rate,
                const OvernightIndexPtr& index,
                const Handle<YieldTermStructure>& discountingCurve
                                            = Handle<YieldTermStructure>()) {
            std::shared_ptr<OvernightIndex> overnight =
                std::dynamic_pointer_cast<OvernightIndex>(index);
            return new DatedOISRateHelperPtr(
                new DatedOISRateHelper(startDate,endDate,rate,
                                       overnight,discountingCurve));
        }
    }
};


// allow use of RateHelper vectors
#if defined(SWIGCSHARP)
SWIG_STD_VECTOR_ENHANCED( std::shared_ptr<RateHelper> )
#endif
namespace std {
    %template(RateHelperVector) vector<std::shared_ptr<RateHelper> >;
}


#endif
