CREATE OR REPLACE function indexed_docs_ins_upd()
RETURNS trigger AS $$
DECLARE
	l_lang text;
BEGIN
	l_lang = 'english';
	NEW.document_tokens = 
		setweight ( to_tsvector ( l_lang::regconfig, coalesce(NEW.document_title,'')), 'A' ) ||
		setweight ( to_tsvector ( l_lang::regconfig, coalesce(NEW.document_body,'')), 'B' )
	;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


DROP TRIGGER if exists  indexd_docs_trig_1 on indexed_docs;

CREATE TRIGGER indexd_docs_trig_1
	BEFORE insert or update ON indexed_docs
	FOR EACH ROW
	EXECUTE PROCEDURE indexed_docs_ins_upd()
;
