# MER

## Entidades:
- f_incident
- d_time
- d_organization
- d_detector
- d_alert


## Descrição:

- f_incident(<u>SRK_incident</u>, SRK_time, SRK_org, SRK_det, SRK_alert, incident_title, incident_grade, entity_type, evidence_role, os_family, os_version, last_verdict, country_code, state, city, raw_event_id, created_at)
- d_time(<u>SRK_time</u>, event_timestamp, event_date, year, month, day, hour, weekday, created_at)
- d_organization(<u>SRK_org</u>, organization_external_id, organization_name, created_at)
- d_detector(<u>SRK_det</u>, detector_external_id, detector_name, created_at)
- d_alert(<u>SRK_alert</u>, alert_title, category, mitre_techniques, created_at)