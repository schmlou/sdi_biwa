# SDI_IWS

Dashboard: https://schmlou.github.io/sdi_biwa/

## Mission Statement

This project is part of the Masters study program in "Applied Geoinformatics" and "Copernicus Master in Digital Earth" at the Z_GIS (Paris-Lodron University Salzburg). In the course "SDI Implementation" and the "GI/EO Project Management"-course support the planing and implementation of an SDI. The idea of creating an integrated warning system for the cross-border alpine region of "Berchtesgaden" and "Salzburger Land" was developed by the students.  

## Abstract

The Alpine Region, especially the transboundary area encompassing “Nationalpark Berchtesgaden” in Bavaria and the “Land Salzburg” in Austria, are high susceptible to natural hazards such as pluvial floods, landslides and avalanches. In topographically challenging regions, disaster risk management is frequently compromised by administrative differences, resulting in fragmented geospatial data, including incompatible coordinate reference systems, and different semantic definitions about hazard zones across national borders. This project aims to develop a transboundary SDI to harmonize, integrate and visualise critical disaster prevention and meteorological data. By using an open-source architecture to handle geometric harmonisation, including the grid shifts from the Austrian and German coordinate systems, and by adopting standards from the Open Geospatial Consortium (OGC) for publishing. This will make risk zones and topographic models, sourced from regional authorities such as SAGIS and LfU, publicly available. To elevate the system from a static map to a dynamic forecasting tool, SDI middleware (e.g. lightweight standards like OGC API Features) will incorporate high-resolution, real-time meteorological APIs provided by Deutscher Wetterdienst (DWD) and GeoSphere Austria (Austrian geological, geophysical, climatological and meteorological Service). The deliverable is an interactive, web-based decision support tool that combines cross-border data streams to provide a cross-border hazard map. By adhering to the FAIR principle, this will demonstrate an interoperable and scalable methodology for overcoming transboundary data fragmentation and enhance regional resilience against (climate-triggered) natural hazards.

### Keywords

Open-source, hazard map, harmonization

## Authors

Mary Muthee (MSc Copernicus Master in Digital Earth),
Louis Schmalisch (MSc Applied Geoinformatics),
Ullah Asad (MSc Applied Geoinformatics)

## Project plan

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title       Projektplan (Gantt Chart)
    axisFormat  %d.%m.%Y

    section 1 Project Management
    1.1 Topic & Abstract           :done,    pm1, 2026-03-03, 2026-03-18
    1.2 Define Objectives          :done,    pm2, 2026-03-03, 2026-03-10
    1.4 Define Targetgroup         :active,  pm4, 2026-03-18, 2026-04-04
    1.5 GitLab setup               :         pm5, 2026-04-14, 2026-04-21

    section 2 Data Acquisition
    2.1 Literature Review          :active,  pm3, 2026-03-18, 2026-04-04
    2.2 Data gathering             :active,  da1, 2026-04-21, 2026-04-24
    2.3 Evaluate data quality      :         da2, 2026-04-24, 2026-04-25
    2.4 Data into Database         :         da3, 2026-04-25, 7d

    section 3 Data Processing
    3.1.1 Harmonize cross border   :         dp1, 2026-05-01, 2026-05-05
    3.1.2 Identify hazard zones    :         dp2, 2026-05-06, 2026-05-15
    3.1.3 Historic data            :         dp3, 2026-05-06, 2026-05-15
    3.2.1 API integration          :         dp4, 2026-05-01, 2026-05-10
    3.2.2 Check Compatibility      :         dp5, 2026-05-10, 2026-05-15

    section 4 SDI Development
    4.1 Database Setup             :         sdi1, 2026-04-25, 7d
    4.2 User Interface design      :         sdi2, 2026-05-16, 2026-06-12
    4.3 First Prototype            :         sdi3, 2026-06-13, 2026-06-14

    section 5 Feedback
    5.1 Evaluate User feedback     :         fb1, 2026-06-15, 2026-06-20
    5.2 Apply feedback             :         fb2, 2026-06-21, 2026-06-22

    section 6 Final Presentation & Documentation
    6.1 SDI publication            :milestone, doc1, 2026-06-23, 0d
    6.2 Documentation              :milestone, doc2, 2026-06-23, 0d
    6.3 GitLab                     :milestone, doc3, 2026-06-23, 0d
    Launch                         :milestone, launch, 2026-06-23, 0d
```