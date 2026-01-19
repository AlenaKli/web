DROP TABLE IF EXISTS claims_import_lines;
CREATE TABLE claims_import_lines (
  id serial PRIMARY KEY,
  source_file text NOT NULL,
  line_no int NOT NULL,
  raw_line text NOT NULL,
  received_at timestamptz default now(),
  note text
);

INSERT INTO claims_import_lines (source_file, line_no, raw_line, note) VALUES
('clinic_A_2025_11.csv', 1, 'Claim#C1001; Patient: Ivan Petrov <ivan.petrov@example.com>; +7 (900) 123-45-67; Policy: POL-12345', 'claim row'),
('clinic_A_2025_11.csv', 2, 'Claim#C1002; Patient: Olga S; olga.s@mail.co; 8-900-1234567; Policy: POL67890', 'claim row'),
('clinic_A_2025_11.csv', 3, 'Claim#C1003; Patient: Oops <bad@-domain.com>; 09001234567; Policy: BAD@@POL', 'broken email/policy'),
('billing_feed.csv', 10, 'proc: CPT-99213; amount: "1,200.00" USD; provider: Clinic A', 'billing row'),
('billing_feed.csv', 11, 'code: ICD10-A41.9; charge: "2 500,00" EUR; note: urgent', 'billing row'),
('diagnosis_tags.csv', 1, 'tags: urgent, inpatient, cardio', 'tags row'),
('diagnosis_tags.csv', 2, 'tags: outpatient, , followup', 'tags with empty'),
('patients_dirty.csv', 5, '"Ivanov, Ivan","123 Med St, Bldg 2","claim: C2001","1,500.00"', 'dirty csv'),
('patients_dirty.csv', 6, '"Brown, Sarah","Ward 7, Room 12","notes: needs translator","2 000,00"', 'dirty csv'),
('ingest_claims_log.txt', 400, 'INFO: started claims ingest', 'log'),
('ingest_claims_log.txt', 401, 'warning: missing policy for claim C1003', 'log'),
('ingest_claims_log.txt', 402, 'error: failed to parse patients_dirty.csv line 6', 'log'),
('ingest_claims_log.txt', 403, 'Error: amount format invalid for claim C1002', 'log'),
('clinic_A_2025_11.csv', 20, 'Patient: bad@@example..com; phone: +7 900 ABC-45-67; Policy: POL-12-!!', 'trap-bad-email-phone-policy'),
('patients_dirty.csv', 7, '"O''Neil, Patrick","100 Main St, Suite 5","claim: C2002",""', 'dirty csv with apostrophe and empty amount');

SELECT id, source_file, line_no, raw_line
FROM claims_import_lines
WHERE raw_line ~ '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';

SELECT id, source_file, line_no, raw_line
FROM claims_import_lines
WHERE raw_line !~ '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';

SELECT id, source_file, line_no, (regexp_match(raw_line, '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'))[1] AS email
FROM claims_import_lines
WHERE raw_line ~ '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';

SELECT id, source_file, line_no, (regexp_match(raw_line, '(POL-\d+|POL\d+|C\d+)'))[1] AS policy_id
FROM claims_import_lines
WHERE raw_line ~ '(POL-\d+|POL\d+|C\d+)';

SELECT id, source_file, line_no, (regexp_matches(raw_line, '(CPT-\d+|ICD10-[A-Z]\d+\.\d+)', 'g')) AS procedure_codes
FROM claims_import_lines
WHERE raw_line ~ '(CPT-\d+|ICD10-[A-Z]\d+\.\d+)';

SELECT id, source_file, line_no, 
    regexp_replace(
        regexp_replace(
            (regexp_match(raw_line, '"([\d\s,\.]+)"'))[1],
            '[,\s]', '', 'g'
        ),
        ',', '.'
    )::NUMERIC AS normalized_amount
FROM claims_import_lines
WHERE raw_line ~ '"[\d\s,\.]+"';

SELECT id, source_file, line_no, 
    regexp_replace(
        (regexp_match(raw_line, '[\d\s\(\)\-\+]+'))[1],
        '[^\d]', '', 'g'
    ) AS normalized_phone
FROM claims_import_lines
WHERE raw_line ~ '[\d\s\(\)\-\+]+';

SELECT id, source_file, line_no, 
    regexp_split_to_array(
        (regexp_match(raw_line, 'tags:\s*(.*)'))[1],
        ',\s*'
    ) AS tags_array
FROM claims_import_lines
WHERE source_file = 'diagnosis_tags.csv';

SELECT id, source_file, line_no, 
    regexp_split_to_table(
        regexp_replace(raw_line, '^"|"$', '', 'g'),
        '","'
    ) AS field
FROM claims_import_lines
WHERE source_file = 'patients_dirty.csv';

SELECT id, source_file, line_no, 
    regexp_replace(raw_line, 'error', 'ERROR', 'gi') AS normalized_log
FROM claims_import_lines
WHERE source_file = 'ingest_claims_log.txt' AND raw_line ~* 'error';