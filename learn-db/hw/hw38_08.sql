UPDATE indexed_docs d1  
	SET document_tokens = to_tsvector(d1.document_title)  
	FROM indexed_docs d2
;  
