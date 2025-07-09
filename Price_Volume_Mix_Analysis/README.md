# Price, Volume, and Mix Analysis SQL Script

This repository contains a SQL script that performs a comprehensive **Price, Volume, and Mix (PVM) Analysis** for all clients. The script is designed for use in a data warehouse or business intelligence environment

## Overview

The script extracts, transforms, and loads (ETL) sales data to compute year-over-year (YoY) changes in sales, broken down into:
- **Price Impact**
- **Volume Impact**
- **Mix Impact**
- **New Product Sales**
- **Discontinued Product Sales**

## Features

- Uses **Common Table Expressions (CTEs)** for modular and readable SQL logic.
- Performs **full outer joins** to compare current and previous year data.
- Aggregates data by client, product, category, and month.
- Outputs results into a new table: `tbl_Sales_Impact`.

## Data Sources

- `Sales_Data`: Contains transactional sales records.
- `Derived_Variables`: Provides fiscal year and date parameters.
- `Client_Master`: Contains client metadata (name, region, manager, etc.).

## Key Variables

- `@CurrYear`: Current fiscal year.
- `@PrevYear`: Previous fiscal year.
- `@PrevYearMaxDate`: Cutoff date for previous year data.

## Output Table

The final output is stored in `dbo.tbl_Sales_Impact` and includes:
- Client and product identifiers
- Sales metrics for current and previous years
- Calculated impacts (Price, Volume, Mix)
- New and discontinued product sales

## Usage

1. Update the database context (`USE TempDB`) if needed.
2. Ensure the source tables (`Sales_Data`, `Derived_Variables`, `Client_Master`) are populated.
3. Run the script in a SQL Server environment.

## Disclaimer

All table and field names have been anonymized for public distribution. Replace them with actual names as per your database schema.
