<h1 align="center"> Key Findings from Built Environment Data Tool </h1>

The [Built Environment Indicators and Health Interactive Map Tool](https://github.com/mattgerken/dc-built-environment-map-tool) originated as an October 2023 Data Science @ DC Hacktoberfest project. The tool sheds light on the relationship between the built environment and public health outcomes in the District of Columbia; it incorporates 41 data measures categorized into the following 9 Drivers utilizing 48 datasets on Open Data DC: 

* Education
* Employment
* Financial Institutions
* Housing
* Transportation
* Food Environment
* Medical Care
* Outdoor Environment
* Community Safety

My analysis below summarizes key findings from the tool.

# Overall Findings

Key takeaways:

* Most neighborhoods have high access to **education, transportation, and financial institution** built environment features, with lower access to playgrounds, modernized schools, and short walks to bus stops
* Proximity to vacant or blighted homes, levels of affordable housing, and housing stock quality **varies significantly** across neighborhoods
* Access to **food environment** features (grocery stores, farmers markets, and short walks to resturants) and **medical care** (mental health and healthcare facilities) is generally high with lower levels of access in Wards 7 and 8
* Although access varies across neighborhoods, **parks, bike trails, and nature trails** are scattered across Wards
* Most neighborhoods are not located near **vacant lots** or **high-injury roadways**, but access to **fire stations, police stations, and well-lit sidewalks** is more mixed

Reflections:

* The data tool is an exploration of leveraging public data - primarily through **Open Data DC** - to make statements about DC's physical environment
* Although the "perfect" dataset did not always exist for a given data measure, the team strategized to **best utilize the datasets that do exist**
* The tool **does not imply** that built environment features are the main factor influencing health outcomes in the District
* The tool serves as a starting point for further investigation into **potential connections with health outcomes**, rather than establishing definitive causal relationships 

# Education

* Most neighborhoods in D.C. are in close proximity to schools, wireless hotspots, recreation centers, and libraries, with more mixed access to playgrounds and to schools that have had full modernizations in the last five years
* Neighborhoods generally have low levels of access to school crossing guards and to “Safe Passage areas”—specific areas of the city with attention on improving student safety as they travel to and from school
* Neighborhoods whose built environments allow for greatest access to education-related features are concentrated in Wards 1 and 6

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline1.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/education.png?raw=true" width="60%">
</p>

# Employment

* Wards 2 and 3 have the greatest share of residents whose travel time to work is less than 45 minutes

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline2.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/employment.png?raw=true" width="60%">
</p>

# Financial Institutions

* Most D.C. neighborhoods are in close proximity to banking institutions—banks, non-depository banks, ATMs, and credit unions
* Check cashing places—which correlate with worse health outcomes—are common in the District—few neighborhoods are not within a 15-minute walk of one
* Neighborhoods whose built environments allow for greater access to financial institutions are concentrated in Wards 3 and 7

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline3.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/financialinstitutions.png?raw=true" width="60%">
</p>

# Housing

* Proximity to vacant or blighted homes varies significantly across D.C. neighborhoods
* Most neighborhoods generally have lower levels of affordable housing, newer homes, and homes of very good housing quality
* Neighborhoods whose built environments allow for greater access to housing-related features are concentrated in Wards 2, 6, and 8

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline4.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/housing.png?raw=true" width="60%">
</p>

# Transportation

* Most D.C. neighborhoods are in close proximity to Capital Bikeshare and Metro stations, and most do not devote significant land area to alleys or parking lots
* Access to buses and bike lanes is more mixed across neighborhoods
* Neighborhoods whose built environments allow for greater access to transportation-related features are concentrated in Wards 1, 2, and 6

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline5.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/transportation.png?raw=true" width="60%">
</p>

# Food Environment

* While many neighborhoods in D.C. are in close proximity to grocery stores and farmers markets, access is lower in Wards 7 and 8
* Access to restaurants is more mixed across the District
* Neighborhoods whose built environments allow for greater access to food environment features are concentrated in Wards 1, 2, and 6

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline6.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/foodenvironment.png?raw=true" width="60%">
</p>

# Medical Care

* Most neighborhoods are in close proximity to health care facilities, with more mixed access to mental health facilities
* Neighborhoods whole built environments allow for greater access to medical care facilities are scattered across the District, with greater concentrations in Wards 1, 2, 4, 6, and 8, compared to Wards 3, 5, and 7

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline7.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/medicalcare.png?raw=true" width="60%">
</p>

# Outdoor Environment

* Most neighborhoods are not located within a flood plain and most have “positive” land uses—defined here as land use that is not industrial or vacant
* Access to parks, trails, and urban tree canopy is more mixed, as is access to a mix of land uses within a neighborhood
* Neighborhoods whose built environments allow for greater access to outdoor environment-related features are concentrated in Wards 2, 3, and 7

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline8.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/outdoor.png?raw=true" width="60%">
</p>

# Community Safety

* Most neighborhoods are not located in close proximity to vacant lots or, to a lesser extent, High Injury Network Corridors—roadways in D.C. with the highest rates of injuries and fatalities
* Access to fire stations, police departments, and sidewalks covered by streetlights is more mixed
* Neighborhoods whose built environments allow for greater access to community safety-related features are concentrated in Wards 1, 2, and 6

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/ridgeline9.png?raw=true" width="60%">
</p>

<p align="center">
  <img src="https://github.com/mattgerken/built-environment-summary/blob/main/communitysafety.png?raw=true" width="60%">
</p>
