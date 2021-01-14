DROP TABLE if exists indexed_docs ;

CREATE TABLE indexed_docs (
	doc_id UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
    document_title TEXT NOT NULL,
    document_body TEXT NOT NULL,
    document_tokens TSVECTOR 
);

INSERT INTO indexed_docs ( document_title, document_body ) values
	( 'On Tyrany', 'A book about how to stop tyrants and how to deal with the devaluation of democracy.' ),
	( 'How Democracies Die', 'A look at how other democracies around the world have failed.' )
;
