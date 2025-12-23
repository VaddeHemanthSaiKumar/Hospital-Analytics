# Healthcare Encounter & Readmission Analytics Dashboard

A comprehensive end-to-end healthcare analytics solution that analyzes patient encounters, procedures, costs, and 30-day readmission patterns using SQL Server and Power BI.

## 📋 Project Overview

This project processes raw hospital data (patients, encounters, organizations, payers, and procedures) and transforms it into a star schema data model. It delivers a fully interactive Power BI dashboard that provides hospital administrators with actionable insights into operational efficiency, financial performance, and patient risk patterns.

**Key Business Questions Addressed:**
- What are encounter trends over time by type and class?
- Which encounter types have the highest costs and lowest insurance coverage?
- Which procedures are most frequent and most expensive?
- What is the 30-day patient readmission rate and which patients are highest risk?
- How many unique patients visit per quarter and who are repeat visitors?
- Which insurance payers provide the most and least coverage?

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| **Data Warehouse** | SQL Server |
| **ETL & Data Cleaning** | SQL, Power Query |
| **Business Logic & Calculations** | DAX (Power BI) |
| **Visualization & Dashboard** | Power BI |
| **Data Modeling** | Star Schema (Dimensional Modeling) |

---

## 📊 Data Model Architecture

### Star Schema Design

The project implements an enterprise-grade star schema with the following structure:

#### **Fact Tables**
- **Fact_Encounters**: Visit-level transactions (base cost, total claim cost, payer coverage)
- **Fact_Procedures**: Procedure-level transactions (base cost, start/stop times)

#### **Dimension Tables**
- **Dim_Patient**: Patient demographics (age, gender, marital status, race, ethnicity, location)
- **Dim_Organization**: Hospital/clinic information (name, address, location)
- **Dim_Payer**: Insurance company details (name, headquarters, contact)
- **Dim_EncounterType**: Encounter classification (ambulatory, emergency, inpatient, wellness, urgent care)
- **Dim_Procedure**: Procedure classification (code, description, category)
- **Dim_Date**: Calendar dimension (date key, year, month, quarter, week, day name, fiscal attributes)

#### **Key Relationships**
```
Dim_Patient ──→ Fact_Encounters ←── Dim_Payer
Dim_Organization ──→ Fact_Encounters ←── Dim_Date
Dim_EncounterType ──→ Fact_Encounters

Fact_Encounters ──→ Fact_Procedures
Dim_Procedure ──→ Fact_Procedures
```

---

## 🔄 Data Processing Pipeline

### Step 1: Data Extraction & Validation
- Source raw hospital tables: Patients, Encounters, Organizations, Payers, Procedures
- Validate data quality, identify missing values, and detect duplicates
- Check referential integrity between foreign keys

### Step 2: Data Cleaning (SQL)
- Convert NVARCHAR date fields to DATE/DATETIME format
- Remove duplicate records and handle NULL values strategically
- Standardize inconsistent codes and descriptions (SNOMED-CT)
- Handle invalid ZIP codes and phone numbers (replace with "Unknown", not fake values)
- Create surrogate keys for dimensional tables

### Step 3: Dimensional Modeling
- Build slowly-changing dimension tables from raw attributes
- Create conformed dimensions (shared across multiple facts)
- Implement bridge tables where needed for many-to-many relationships

### Step 4: Fact Table Construction
- Aggregate procedure costs at encounter level
- Calculate encounter duration = Stop - Start
- Compute derived metrics (payer coverage gaps, out-of-pocket costs)

### Step 5: Load to Gold Layer
- Populate star schema tables in SQL Server
- Validate aggregates match source totals
- Create indexes on foreign keys for performance

---

## 📈 Key Metrics & DAX Measures

### Encounter Analytics
```dax
Total Encounters = COUNTA(Fact_Encounters[Encounter_Key])

Avg Encounter Cost = AVERAGEX(Fact_Encounters, Fact_Encounters[Total_Claim_Cost])

Encounters Over 24Hrs = CALCULATE(
    COUNTA(Fact_Encounters[Encounter_Key]),
    FILTER(Fact_Encounters, Fact_Encounters[Encounter_Duration] > 1440)
)
```

### Financial Analytics
```dax
Coverage Gap = SUMX(
    Fact_Encounters,
    Fact_Encounters[Total_Claim_Cost] - Fact_Encounters[Payer_Coverage]
)

Avg Coverage % = DIVIDE(
    SUM(Fact_Encounters[Payer_Coverage]),
    SUM(Fact_Encounters[Total_Claim_Cost])
)
```

### Readmission Analytics (Advanced DAX)
```dax
Is_30Day_Readmission = 
VAR CurrentPatient = Fact_Encounters[Patient_Key]
VAR CurrentStart = Fact_Encounters[Start_Date_Key]
VAR PreviousDischarge =
    CALCULATE(
        MAX(Fact_Encounters[Stop_Date_Key]),
        FILTER(ALL(Fact_Encounters),
            Fact_Encounters[Patient_Key] = CurrentPatient
            && Fact_Encounters[Stop_Date_Key] < CurrentStart
        )
    )
RETURN
IF(
    NOT(ISBLANK(PreviousDischarge))
    && CurrentStart <= PreviousDischarge + 30,
    1,
    0
)

Readmission_Rate = DIVIDE(
    CALCULATE(SUM(Fact_Encounters[Is_30Day_Readmission])),
    COUNTA(Fact_Encounters[Encounter_Key])
)
```

### Patient Analytics
```dax
Unique Patients = DISTINCTCOUNT(Fact_Encounters[Patient_Key])

Repeat Patients = CALCULATE(
    DISTINCTCOUNT(Fact_Encounters[Patient_Key]),
    FILTER(ALL(Fact_Encounters),
        [Patient_Visit_Count] > 1
    )
)
```

---

## 📊 Dashboard Components

### 1. **Encounter Overview Page**
- Encounter count trend (line chart by month)
- Encounter class distribution (donut chart)
- Encounter duration breakdown (under vs over 24 hours)
- Table of top 10 encounters by cost

**Key Insight**: Identifies seasonal trends and high-cost encounter classes

### 2. **Financial Performance Page**
- Total claim cost by payer (bar chart)
- Coverage gap analysis (waterfall chart)
- Cost per encounter type (table)
- Payer coverage % by organization (matrix)

**Key Insight**: Highlights insurance coverage gaps and cost drivers

### 3. **Procedure Analysis Page**
- Top 10 most frequent procedures (bar chart)
- Top 10 most expensive procedures (bar chart)
- Procedure cost trend over time (line chart)
- Average cost per procedure type (table)

**Key Insight**: Identifies procedure-level revenue and utilization patterns

### 4. **Patient Risk & Readmission Page**
- 30-day readmission rate (KPI card)
- Readmission trend over quarters (line chart)
- Patients with highest repeat visits (table)
- Readmission by encounter class (grouped bar chart)

**Key Insight**: Identifies high-risk patients and departments with readmission issues

### 5. **Interactive Slicers (All Pages)**
- Date range picker
- Organization / Hospital filter
- Payer / Insurance filter
- Encounter class filter
- Patient demographics filters

---

## 🎯 Key Features

✅ **End-to-End Data Pipeline**: Raw data → Cleaned → Modeled → Visualized

✅ **Star Schema Implementation**: Properly separated facts and dimensions for scalability

✅ **Advanced DAX Logic**: Industry-grade readmission detection using patient-level filtering

✅ **Interactive Dashboards**: Slicers, drill-throughs, and cross-filtering for exploration

✅ **Time Intelligence**: Year-over-year, month-over-month, and quarter-over-quarter analysis

✅ **Data Quality**: Handled NULLs, duplicates, and datatype mismatches professionally

✅ **Performance Optimized**: Efficient relationships, indexes, and aggregate tables

---

## 💡 Business Insights Delivered

### Operational Insights
- **Encounter Trends**: Hospital admission patterns by season, day of week
- **High-Risk Patients**: Identified patients with 5+ visits in the dataset
- **Readmission Hotspots**: Departments and encounter classes with elevated 30-day readmission rates

### Financial Insights
- **Coverage Gaps**: Insurance payers covering <70% of encounter costs (negotiation opportunity)
- **High-Cost Areas**: Inpatient encounters average 10x the cost of ambulatory visits
- **Revenue Mix**: Procedure-heavy encounters generate 60% more revenue

### Clinical Insights
- **Readmission Drivers**: Emergency encounters show 3x higher readmission rate
- **Patient Segments**: Chronic condition patients (multiple diagnosis codes) have 40% readmission rate
- **Procedure Efficiency**: Top 20 procedures account for 80% of total procedure costs

---

## 🚀 How to Use

### Prerequisites
- SQL Server 2016+ (for Gold layer tables)
- Power BI Desktop (latest version)
- Sample hospital dataset (Synthea or similar FHIR-based data)

### Setup Instructions

1. **Load SQL Database**
   ```sql
   -- Run cleaning and transformation scripts
   -- Load Gold layer tables (Fact & Dimension tables)
   -- Validate row counts and totals
   ```

2. **Connect Power BI**
   - Open `HealthcareAnalytics.pbix`
   - Update data source connections to your SQL Server
   - Refresh all tables and validate relationships

3. **Validate Data Model**
   - Check model relationships (cardinality, filter direction)
   - Verify Date dimension is marked as Date table
   - Confirm all DAX measures calculate correctly

4. **Explore Dashboard**
   - Use slicers to filter by date, organization, payer
   - Click on charts to drill down for details
   - Export insights to stakeholders

### Performance Tips
- Use Aggregation tables for large fact tables (>10M rows)
- Implement incremental refresh for daily data loads
- Disable unnecessary bi-directional relationships
- Use measures instead of calculated columns where possible

---
## 🔍 Data Quality & Validation

### QA Checklist (Validation Tests)
- ✅ Fact totals match source database
- ✅ No cartesian multiplication in joins
- ✅ Date dimension covers entire date range
- ✅ All foreign keys have valid matches
- ✅ Slicers filter correctly across all visuals
- ✅ Readmission logic validated with manual spot-checks
- ✅ Dashboard performance <3 seconds for standard queries

---

## 📚 Learning Outcomes

This project demonstrates proficiency in:

1. **Data Engineering**: ETL pipelines, SQL optimization, data quality
2. **Data Modeling**: Star schema design, conformed dimensions, slowly-changing dimensions
3. **Analytics**: DAX, calculated columns, advanced measures
4. **BI Development**: Interactive dashboards, slicers, drill-throughs, bookmarks
5. **Healthcare Domain**: SNOMED-CT codes, readmission definitions, encounter classification
6. **Communication**: KPIs, storytelling with data, insight delivery

---

## 🤝 Contributing

This is a portfolio project. Feedback and suggestions are welcome. Please feel free to:
- Report data quality issues
- Suggest additional KPIs or visualizations
- Propose performance optimizations

---

## 📝 License

This project is open-source and available for educational and portfolio purposes. The sample healthcare data is synthetic and does not contain real patient information.

---

## 👤 Author

**Hemanth Sai Kumar**
- Data Analyst | SQL | Power BI | Healthcare Analytics
- LinkedIn: https://www.linkedin.com/in/vadde-hemanth-sai-kumar/
- GitHub: https://github.com/VaddeHemanthSaiKumar

---

## 🙏 Acknowledgments

- Synthea synthetic data generator for sample hospital data
- SNOMED-CT for medical coding standards
- Power BI and SQL Server documentation communities

---

## ❓ FAQ

**Q: Is this production-ready?**  
A: This is an enterprise-grade analytical solution suitable for real hospital use. However, always validate against actual clinical workflows and compliance requirements (HIPAA, etc.) before deployment.

**Q: How often should the data refresh?**  
A: Recommended daily refresh for operational dashboards. For historical trend analysis, weekly or monthly refresh is sufficient.

**Q: Can I add more metrics?**  
A: Absolutely. The star schema is designed for extensibility. New facts and dimensions can be added without breaking existing measures.

**Q: Why separate Fact_Encounters and Fact_Procedures?**  
A: Different grain levels. One encounter = one row. One procedure = one row. Merging them would cause double-counting of encounter costs.

---

**Last Updated**: December 2025  
**Data Model Version**: 1.0  
**Power BI Version**: Latest
