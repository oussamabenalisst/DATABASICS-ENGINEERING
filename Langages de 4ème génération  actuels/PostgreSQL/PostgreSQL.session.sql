CREATE OR REPLACE PROCEDURE maj_note(
        p_id INTEGER,
        p_code VARCHAR,
        p_note NUMERIC
    ) LANGUAGE plpgsql AS $$
DECLARE v_old NUMERIC;
BEGIN
SELECT note INTO STRICT v_old
FROM note
WHERE id_etudiant = p_id
    AND code_module = p_code;
UPDATE note
SET note = p_note
WHERE id_etudiant = p_id
    AND code_module = p_code;
RAISE NOTICE 'Ancienne note : % -> %',
COALESCE(v_old, 0),
p_note;
-- pas de COMMIT : interdit dans un bloc ayant une clause EXCEPTION
EXCEPTION
WHEN no_data_found THEN RAISE EXCEPTION 'Note introuvable' USING ERRCODE = 'P0002';
END;