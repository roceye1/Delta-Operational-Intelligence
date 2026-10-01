# Data Validation Report

> **Status:** Template. Results will be completed after raw data collection and cleaning.

## Validation Summary

| Check | Dataset | Expected Rule | Result | Status |
|---|---|---|---|---|
| Reporting period | Flights | 2025 only | Pending | Not run |
| Marketing carrier | Flights | Delta-marketed population per final filter | Pending | Not run |
| Duplicate records | Flights | No unexplained duplicate flight records | Pending | Not run |
| Airport codes | Flights | Standardized origin/destination codes | Pending | Not run |
| Cancellation flag | Flights | Valid expected values | Pending | Not run |
| Diversion flag | Flights | Valid expected values | Pending | Not run |
| Delay target | Flights | Correct 15+ minute logic for eligible completed flights | Pending | Not run |
| Financial years | Financials | 2021–2025 | Pending | Not run |
| Financial units | Financials | Consistent units across years | Pending | Not run |
| Fuel dates | Fuel prices | Monthly 2021–2025 | Pending | Not run |
| Fuel values | Fuel prices | Numeric USD/gallon | Pending | Not run |

## Planned Flight Checks
- Source row count
- Filtered row count
- Date minimum and maximum
- Carrier values
- Operating-carrier values
- Null counts for key fields
- Duplicate-key investigation
- Cancelled/diverted population counts
- Arrival-delay distribution
- Impossible or unexpected time/distance values
- Delay-cause field consistency
- Route and airport counts

## Planned Financial Checks
- Compare extracted values back to Delta/SEC source tables
- Confirm fiscal year and units
- Check consistency of metric definitions across years
- Recalculate operating margin where appropriate
- Flag any metric whose reporting definition changes

## Planned Fuel Checks
- Confirm monthly frequency
- Confirm units are dollars per gallon
- Confirm 2021–2025 date coverage
- Check missing months and duplicate months

## Final Sign-Off
The validation report will be considered complete only after all analysis datasets have documented checks, discrepancies are explained, and critical issues are resolved before SQL findings or dashboard metrics are published.
